#use windows.forms to prompt user for IP address 

$ip = [System.Windows.Forms.InputBox]::Show("Enter IP Address", "IP Lookup", "
")

$ip = $ip.Trim()

if ($ip -eq $null) {
    Write-Host "No IP address entered"
    exit
}

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

foreach ($url in $urls) {
    Start-Process -FilePath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList "--new-window $url"
    Start-Sleep -Seconds 1
}

#close powershell script

exit
