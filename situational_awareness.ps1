
<#

21May22 - CB -- Updated Domain Admins to show last logon, password last set, and if the password expires. I am 99% sure at this point that it needs RSAT. This portion of the script you may have to modify Identity, however in my experience it pulled all admin groups. Need someone to verify. 
7APR22 - CB -- Added notes for commands, removed/commented out the current session ID command, replaced "...Win32Reg_AddRemovePrograms...DisplayName" with "...Win32_Product...name", added AV names to running security products and expanded to check for windows defender, added [***]pass[***] or [***]pw[***] file search, finished runmru, added powershell command history, added netsh winhttp show proxy to proxy detection, fixed dns cache to display results       - want to expand on selecting what you want to choose to run and if output is possible - 

Script will enumerate:

    PowerShell Language Mode - determines which powershell elements can be used - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_language_modes?view=powershell-7.2#:~:text=The%20language%20mode%20determines%20the,mode%20of%20the%20session%20configuration.
    Current user details - Pulls current user details from the domain,  RSAT is NOT needed  https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/cc771865(v=ws.11)
    Current privileges - https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/whoami
    Domain and Forest functional levels - Consider documenting for risks that are presented for current version IE: 2008 vulnerable to credentail gathering/mimikatz - https://www.linkedin.com/pulse/what-windows-domain-functional-level-dfl-why-should-i-e-d-williams
    AD user information - some additional information not provided by current user, RSAT NOT needed - https://docs.microsoft.com/en-us/powershell/module/activedirectory/get-aduser?view=windowsserver2022-ps
    AD computer information - self explanitory - https://docs.microsoft.com/en-us/powershell/module/activedirectory/get-adcomputer?view=windowsserver2022-ps
    System information - determine architecture, patch level, system version, etc - https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/systeminfo
    Local user accounts - think get-wmi is used for some of these commands for computers that do not have powershell remote configs - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-wmiobject?view=powershell-5.1
    Local Administrators - shows groups and users with admin rights on local host - https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/cc725622(v=ws.11)
    Session information - displays information about active sessions and session capabilities -  https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/qwinsta
    Local user profiles - Displays local users and mode, need to research mode more - 
    Installed software - shows windows installed software with version - https://docs.microsoft.com/en-us/previous-versions/windows/desktop/legacy/aa394378(v=vs.85)
    Running security products, and windows defender - simple search to show if names for security products are present -  would like to expand more - windows defender/antimalware check (think this can be overridden by hkey changes when dual installs like forticlient and defender are both "on") - https://docs.microsoft.com/en-us/powershell/module/defender/get-mpcomputerstatus?view=windowsserver2022-ps 
    Domain password policy - RSAT needed, tells password policy for domain to assist in cracking - https://docs.microsoft.com/en-us/powershell/module/activedirectory/get-addefaultdomainpasswordpolicy?view=windowsserver2022-ps
    Keepass databases - searches for .kdb, I think there is more to this type of oppurtunistic search, learning if the user has a pw manager could be a big win, 
    Password File Name Detection - searches for files named [***]pass[***] or [***]pw[***] in users   
    RunMRU (run command history)- searches window run commands from registry - 
    Powershell History - shows historical pwershell commands ran - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/get-history?view=powershell-7.2
    Networking 
    Network connections - netstat tcp - https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/netstat
    Proxy settings - user specific using hkey, netstat for hostwide 
    DNS cache - https://docs.microsoft.com/en-us/powershell/module/dnsclient/get-dnsclientcache?view=windowsserver2022-ps
    Shares - shows available shares 
    Scheduled tasks - shows all scheduled tasks 
    Domain Admins - Still needs validation but think RSAT is needed -
    Windows Event Forwarding - Checks if event logging is on and stats about them, including event forwarding
    Windows Update settings - checks for wsus, latest updates, and registry key for location of update settings
    Running processes - shows all local running processes
    AppLocker settings - checks applocker policy, and determines if .exe files are able to be executed from C:\
    Outbound firewall rules - Shows status of local firewall rules

#>

$ErrorActionPreference = 'SilentlyContinue'


# PowerShell Language Mode

Write-Output "`n[[***]] Checking PowerShell Language Mode `r`n`r`nFull = default, permits all language elements in the session `r`nRestricted = allowed(cmdlets, functions, CIM commands, and workflows) blocked = (Script Blocks) `r`nNoLanguage = only API `r`nConstrained = UMCI on Win RT `r`n`r`nResults:"
$executioncontext.sessionstate.languagemode



# Current user details

Write-Output "`n[[***]] Checking user details`n"
net user $env:UserName /domain
net user $env:UserName


# Current privileges

Write-Output "`n[[***]] Checking privileges`n"
whoami /priv


# Domain and Forest functional levels

Write-Output "`n[[***]] Checking Forest functional level`n"
[System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
Get-WMIObject Win32_NTDomain
            
Write-Output "`n[[***]] Checking Domain functional level`n"
[System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()


# AD user information

Write-Output "`n[[***]] Checking AD user information`n"
$san = $env:UserName
$getad = (([adsisearcher]"(&(objectCategory=User)(samaccountname=$san))").findall()).properties
$getad


# AD computer information

Write-Output "`n[[***]] Checking AD computer information`n"
$pc = $env:COMPUTERNAME
$getad = (([adsisearcher]"(&(objectCategory=Computer)(name=$pc))").findall()).properties
$getad


# System information

Write-Output "`n[[***]] Getting systeminfo`n"
systeminfo


# Local user accounts

Write-Output "`n[[***]] Checking local user accounts"
Get-WmiObject -Class Win32_UserAccount -Filter  "LocalAccount='True'" | Select Caption, SID | ft -hidetableheaders


# Local Administrators

Write-Output "`n[[***]] Checking local administrators`n"

net localgroup administrators


# Current Session ID

Write-Output "[[***]] Checking current Session ID`n"
query session
<# commented out because I think the commnand qwinsta produces more clear results and tells session ID with carrot indicating which session you have
(Get-Process -PID $pid).SessionID#>


# Local sessions

Write-Output "`n`n[[***]] Checking user sessions`n"
qwinsta


# Local user profiles

Write-Output "`n`n[[***]] Checking user profiles"
$OS = Get-WMiobject -Class Win32_operatingsystem
dir ($OS.SystemDrive + "\Users\")


# Installed software

Write-Output "`n`n[[***]] Checking installed software"
Get-WmiObject -Class Win32_Products | fl Name, Version


# Running security products

Write-Output "[[***]] Checking for running security products"
dir HKLM:\SYSTEM\CurrentControlSet\services\ | findstr /C:McAfee /C:Qualys /C:Symantec /C:Sophos /C:Kaspersky /C:CrowdStrike /C:CarbonBlack /C:Cylance /C:Fortinet /C:Norton /C:Webroot /C:Malwarebytes /C:Eset /C:TrendMicro /C:Fsecure /C:Emsisoft /C:Gdata /C:TotalDefense

Write-Output "[[***]] Gets the status of antimalware software on the computer (Defender)"
Get-MpComputerStatus

# Domain password policy

Write-Output "`n[[***]] Checking Domain password policy"
Get-ADDefaultDomainPasswordPolicy


# Keepass databases

Write-Output "`n[[***]] Searching for Keepass databases"
Get-ChildItem -Path ($OS.SystemDrive + "\Users\") -Include @("[***].kdb[***]") -Recurse

#Password File Name Detection
Write-Output "`n[[***]] Searching for files with [***]pass[***] or [***]pw[***] on users drive"
Get-ChildItem -Path ($OS.SystemDrive + "\users") -Include @("*pass*") -Recurse
Get-ChildItem -Path ($OS.SystemDrive + "\users") -Include @("*pw*") -Recurse


# RunMRU (Run command history)

Write-Output "`n[[***]] Querying RunMRU"
$Items = Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU\
$Items.MRUList.ToCharArray().foreach{$Items.$_}

#Powershell Command History 

Write-Output "`n[[***]] Querying Powershell Command History"
Get-History | Format-List -Property [***]

# Network connections

Write-Output "`n[[***]] Checking network connections"
$c = netstat -aonp TCP | select-string "ESTABLISHED"; $c


# Proxy settings

Write-Output "`n[[***]] Checking proxy settings"

Get-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Internet Explorer\Control Panel" | Select Proxy
Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" | Select AutoConfigURL
Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" | Select AutoDetect
Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" | Select ProxyServer
netsh winhttp show proxy

# DNS cache

Write-Output "`n[[***]] Checking DNS cache"
Get-DnsClientCache 


# Shares

Write-Output "`n`n[[***]] Checking shares"
get-WmiObject -class Win32_Share 


# Scheduled tasks

Write-Output "[[***]] Checking scheduled tasks"
schtasks /Query


# Domain Admins This portion of the script you may have to modify Identity, however in my experience it pulled all admin groups. Need someone to verify. 

Write-Output "`n[[***]] Checking domain admin groups`n"
Get-ADGroupMember -Identity Administrators | Select-Object name, samaccountname, objectClass,distinguishedName
Write-Output "`n[[***]] Checking Domain Admins`n"
Get-ADGroupMember -Identity Administrators | get-adgroupmember | Select-Object name, samaccountname, objectClass,distinguishedName
Write-Output "`n[[***]] Checking Domain Admin last login, and password status`n"
Get-ADGroupMember -Identity Administrators | get-adgroupmember | Get-ADUser -properties passwordlastset, passwordneverexpires, lastlogondate | sort lastlogondate | ft -AutoSize Name, lastlogondate, passwordlastset, Passwordneverexpires
<#I cannot debug this at this time instead adding in aternative method below, unsure of why its not working. -cb 7apr22
Gwmi win32_groupuser |? {$_.groupcomponent like "[***]`"$('Domain Admins')`""} |%{

        $_.partcomponent match .+Domain\=(.+)\,Name\=(.+)$|Out-Null

        $matches[1].trim('"') + \ + $matches[2].trim('"')

    }#>


# Windows Event Forwarding

Write-Output "`n`n[[***]] Checking if Windows Event Forwarding is enabled`n"
Get-LogProperties -Name "Security"
Get-LogProperties -Name "Application"
Get-LogProperties -Name "Windows Powershell"
Get-LogProperties -Name "system"
Get-LogProperties -Name "forwarded events"


# Windows Update settings

Write-Output "`n[[***]] Checking Windows Update settings"

Write-Output "`nUses WSUS server (1 if true) blank if null:"
reg query HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU /v UseWUServer

Write-Output "`nWSUS url blank if null:"
reg query HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate /v WUServer

Write-Output "`Latest KBs"
get-wmiobject -class win32_quickfixengineering

Write-Output "`nUpdate Registry Key"
REG QUERY "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate"




<# Domain Information - added Get-WMIObject Win32_NTDomain to other domain forest enumeration script

Write-Output "`n[[***]] Enumerating Domain Information`n"
[System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
Get-WMIObject Win32_NTDomain #>


# Running processes

Write-Output "`n`n[[***]] Checking running processes"
tasklist /v

Start-Sleep -s 3


# AppLocker settings

Write-Output "`n[[***]] Checking AppLocker settings"
Get-AppLockerPolicy -Effective 

Write-Output "`n[[***]] Testing Applocker Policy for .exe files in C:\ Drive"
Get-AppLockerPolicy -Effective | Test-AppLockerPolicy -Path C:\Windows\System32\[***].exe -User Everyone 

# Outbound firewall rules

Write-Output "`n[[***]] Checking outbound Firewall rules`n"
Get-NetFirewallRule -PolicyStore ActiveStore |Select Profile, Direction, Action, DisplayName | Sort-Object -Property Action
