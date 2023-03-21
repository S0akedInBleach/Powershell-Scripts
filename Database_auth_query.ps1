$codys_the_man = Read-Host "Enter a string"

$url = "https://codys.webpage.com/Dashboard.aspx?D=0&k=$codys_the_man"

# Check if Record Count is greater than 0
$page = Invoke-WebRequest -Uri $url -UseDefaultCredentials
$recordCount = $page.ParsedHtml.getElementById("MainContent_iblRecordCount")

if ($recordCount -ne $null -and $recordCount.InnerText -match "Record Count: (\d+)") {
    $count = [int]$Matches[1]
    if ($count -gt 0) {
        Write-Host "Record Count: $count"

        # Check for an existing browser session
        $browserProcesses = Get-Process -Name "iexplore", "msedge" -ErrorAction SilentlyContinue
        if ($browserProcesses.Count -eq 0) {
            # Launch the browser with the URL
            Start-Process $url
        }
    }
    else {
        Write-Host "No results found"
    }
}
else {
    Write-Host "Error: Could not find Record Count"
}
