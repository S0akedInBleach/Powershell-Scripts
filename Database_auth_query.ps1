#capture string as a base search term for codys.webpage.com
$codys_the_man = Read-Host "Enter a string"

# List of top TLDs to check
$tlds = @(".com", ".net", ".org", ".edu", ".gov", ".io", ".ai", ".co", ".me", ".ly", ".us", ".uk", ".au", ".ca", ".cn", ".jp", ".de", ".fr", ".es", ".it", ".nl", ".ch", ".se", ".no")

foreach ($tld in $tlds) {
    $domain = $codys_the_man + $tld
    $wwwDomain = "www." + $domain
    $url = "https://codys.webpage.com/Dashboard.aspx?D=0&k=$domain"
    $wwwUrl = "https://codys.webpage.com/Dashboard.aspx?D=0&k=$wwwDomain"

    #check for the inital string given first using Microsoft Edge
    $page = Invoke-WebRequest -Uri $url -UseDefaultCredentials
    $recordCount = $page.ParsedHtml.getElementById("MainContent_iblRecordCount")

    if ($recordCount -ne $null -and $recordCount.InnerText -match "Record Count: (\d+)") {
        $count = [int]$Matches[1]
        Write-Host "Domain: $domain, Record Count: $count"
        if ($count -gt 0) {
            # Check for an existing browser session
            $browserProcesses = Get-Process -Name "msedge" -ErrorAction SilentlyContinue
            if ($browserProcesses.Count -eq 0) {
                # Launch the browser with the URL
                Start-Process $url
            }
            else {
                # Open the URL in the existing browser session
                Start-Process -FilePath "msedge" -ArgumentList "--new-window $url"
            }
        }
    }
    
    # Check if Record Count is greater than 0 for non-www domain using Microsoft Edge
    $page = Invoke-WebRequest -Uri $url -UseDefaultCredentials
    $recordCount = $page.ParsedHtml.getElementById("MainContent_iblRecordCount")

    if ($recordCount -ne $null -and $recordCount.InnerText -match "Record Count: (\d+)") {
        $count = [int]$Matches[1]
        Write-Host "Domain: $domain, Record Count: $count"
        if ($count -gt 0) {
            # Check for an existing browser session
            $browserProcesses = Get-Process -Name "msedge" -ErrorAction SilentlyContinue
            if ($browserProcesses.Count -eq 0) {
                # Launch the browser with the URL
                Start-Process $url
            }
            else {
                # Open the URL in the existing browser session
                Start-Process -FilePath "msedge" -ArgumentList "--new-window $url"
            }
        }
    }

    # Check if Record Count is greater than 0 for www domain using Microsoft Edge
    $page = Invoke-WebRequest -Uri $wwwUrl -UseDefaultCredentials
    $recordCount = $page.ParsedHtml.getElementById("MainContent_iblRecordCount")

    if ($recordCount -ne $null -and $recordCount.InnerText -match "Record Count: (\d+)") {
        $count = [int]$Matches[1]
        Write-Host "Domain: $wwwDomain, Record Count: $count"
        if ($count -gt 0) {
            # Check for an existing browser session
            $browserProcesses = Get-Process -Name "msedge" -ErrorAction SilentlyContinue
            if ($browserProcesses.Count -eq 0) {
                # Launch the browser with the URL
                Start-Process $wwwUrl
            }
            else {
                # Open the URL in the existing browser session
                Start-Process -FilePath "msedge" -ArgumentList "--new-window $wwwUrl"
            }
        }
    }
}











   
            
