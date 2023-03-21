$cred = Get-Credential
$codys_the_man = Read-Host "Enter a string"

$url = "https://codys.webpage.com/Dashboard.aspx?D=0&k=$codys_the_man"
$page = Invoke-WebRequest -Uri $url

# Check if Record Count is greater than 0
$recordCount = $page.ParsedHtml.getElementById("MainContent_iblRecordCount")
if ($recordCount -ne $null -and $recordCount.InnerText -match "Record Count: (\d+)") {
    $count = [int]$Matches[1]
    if ($count -gt 0) {
        Write-Host "Record Count: $count"
        $EdgePath = (Get-Item "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe").FullName
        Start-Process $EdgePath $url -Credential $cred
    }
    else {
        Write-Host "No results found"
    }
}
else {
    Write-Host "Error: Could not find Record Count"
}
