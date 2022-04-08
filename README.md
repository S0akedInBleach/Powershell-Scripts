# Powershell-Scripts
Random Projects that I have created, or updated, or found useful from others. If you find errors please let me know as I would like to maintain these to be viable in the field. 

**Situational awareness** is a script to be ran on hosts either as blue team to identify any potential weaknesses in domain/host/user configs or from a red team perspective to gain knowledge of the landscape and find oppurtunities to escelate or move laterally. This code is quite long and can be segmented for more targeted results.  - https://github.com/S0akedInBleach/Powershell-Scripts/blob/main/situational_awareness.ps1
1.	PowerShell Language Mode - determines which PowerShell elements can be used - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_language_modes?view=powershell-7.2#:~:text=The%20language%20mode%20determines%20the,mode%20of%20the%20session%20configuration.
2.	Current user details - Pulls current user details from the domain, RSAT is NOT needed https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/cc771865(v=ws.11)
3.	Current privileges - https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/whoami
4.	Domain and Forest functional levels - Consider documenting for risks that are presented for current version IE: 2008 vulnerable to credential gathering/mimikatz - https://www.linkedin.com/pulse/what-windows-domain-functional-level-dfl-why-should-i-e-d-williams
5.	AD user information - some additional information not provided by current user, RSAT NOT needed - https://docs.microsoft.com/en-us/powershell/module/activedirectory/get-aduser?view=windowsserver2022-ps
6.	AD computer information - self-explanatory - https://docs.microsoft.com/en-us/powershell/module/activedirectory/get-adcomputer?view=windowsserver2022-ps
7.	System information - determine architecture, patch level, system version, etc - https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/systeminfo
8.	Local user accounts - think get-wmi is used for some of these commands for computers that do not have PowerShell remote configs - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-wmiobject?view=powershell-5.1
9.	Local Administrators - shows groups and users with admin rights on local host - https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/cc725622(v=ws.11)
10.	Session information - displays information about active sessions and session capabilities -  https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/qwinsta
11.	Local user profiles - Displays local users and mode, need to research mode more - 
12.	Installed software - shows windows installed software with version - https://docs.microsoft.com/en-us/previous-versions/windows/desktop/legacy/aa394378(v=vs.85)
13.	Running security products, and windows defender - simple search to show if names for security products are present - would like to expand more - windows defender/antimalware check (think this can be overridden by hkey changes when dual installs like forticlient and defender are both "on") - https://docs.microsoft.com/en-us/powershell/module/defender/get-mpcomputerstatus?view=windowsserver2022-ps 
14.	Domain password policy - RSAT needed, tells password policy for domain to assist in cracking - https://docs.microsoft.com/en-us/powershell/module/activedirectory/get-addefaultdomainpasswordpolicy?view=windowsserver2022-ps
15.	Keepass databases - searches for .kdb, I think there is more to this type of opportunistic search, learning if the user has a pw manager could be a big win, 
16.	Password File Name Detection - searches for files named [***]pass[***] or [***]pw[***] in users   
17.	RunMRU (run command history)- searches window run commands from registry - 
18.	Powershell History - shows historical pwershell commands ran - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/get-history?view=powershell-7.2
19.	Networking 
20.	Network connections - netstat tcp - https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/netstat
21.	Proxy settings - user specific using hkey, netstat for hostwide 
22.	DNS cache - https://docs.microsoft.com/en-us/powershell/module/dnsclient/get-dnsclientcache?view=windowsserver2022-ps
23.	Shares - shows available shares 
24.	Scheduled tasks - shows all scheduled tasks 
25.	Domain Admins - unsure if needs RSAT -
26.	Windows Event Forwarding - Checks if event logging is on and stats about them, including event forwarding
27.	Windows Update settings - checks for wsus, latest updates, and registry key for location of update settings
28.	Running processes - shows all local running processes
29.	AppLocker settings - checks applocker policy, and determines if .exe files are able to be executed from C:\
30.	Outbound firewall rules - Shows status of local firewall rules


**Bitlocker Check** - Simple script to check bitlocker status of domain connected PCs. 
