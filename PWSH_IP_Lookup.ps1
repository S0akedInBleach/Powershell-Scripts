#function for windows.forms to collect $ip address from user via gui
function Get-InputBox {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Title,
        [Parameter(Mandatory=$true)]
        [string]$Prompt,
        [Parameter(Mandatory=$true)]
        [string]$DefaultResponse
    )
    Add-Type -AssemblyName System.Windows.Forms
    $form = New-Object System.Windows.Forms.Form
    $form.Text = $Title
    $form.Width = 500
    $form.Height = 150
    $form.TopMost = $true
    $form.FormBorderStyle = 'FixedDialog'
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.StartPosition = 'CenterScreen'
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $Prompt
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(10,10)
    $textbox = New-Object System.Windows.Forms.TextBox
    $textbox.Text = $DefaultResponse
    $textbox.Location = New-Object System.Drawing.Point(10,30)
    $textbox.Width = 470
    $textbox.SelectAll()
    $button = New-Object System.Windows.Forms.Button
    $button.Text = 'OK'
    $button.Location = New-Object System.Drawing.Point(10,60)
    $button.Width = 470
    $button.DialogResult = 'OK'
    $form.AcceptButton = $button
    $form.Controls.Add($label)
    $form.Controls.Add($textbox)
    $form.Controls.Add($button)
    $form.ShowDialog() | Out-Null
    $textbox.Text
}

$ip= Get-InputBox -Title "IP Lookup" -Prompt "Enter IP Address" -DefaultResponse "

#use $ip to build URLs for lookup




$urls = @(
    "https://www.abuseipdb.com/check/$ip"
    "https://www.virustotal.com/gui/ip-address/$ip/details"
    "https://exchange.xforce.ibmcloud.com/ip/$ip"
    "https://www.shodan.io/host/$ip"
    "https://otx.alienvault.com/indicator/ip/$ip"
    "https://www.threatcrowd.org/ip.php?ip=$ip"
    "https://www.threatminer.org/host.php?q=$ip"
    "https://www.talosintelligence.com/reputation_center/lookup?search=$ip"
    "https://www.malware-traffic-analysis.net/ip-address-lookup.php?ip=$ip"
    "https://viz.greynoise.io/query/?gnql=$ip"
    "https://www.malwaredomainlist.com/mdl.php?search=$ip"
    "https://www.malwarebytes.com/threat-center/ip/$ip"
    "https://www.criminalip.io/en/asset/report/$ip"
    "https://www.blocklist.de/en/view.html?ip=$ip"
    "https://www.google.com/search?q=ip:$ip"

)

#open each URL in microsoft edge as tabs in a new window, and pause slightly for each tab to open

$urls | % {
    Start-Process -FilePath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList "--new-window $_"
    Start-Sleep -Seconds 1
}

#end of script

#to run the script, save it as a .ps1 file, and then run it from powershell with the following command:
#ip_lookup.ps1
#or
#.\ip_lookup.ps1
#or
#powershell.exe -ExecutionPolicy Bypass -File ip_lookup.ps1
#or
#powershell.exe -ExecutionPolicy Bypass -File "C:\path\to\ip_lookup.ps1"
