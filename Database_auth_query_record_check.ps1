# Create an array of strings
# Initialize an empty array to hold the strings
[string[]]$strings = @()

# Read a string from user input and add it to the array
[string]$inputString = Read-Host "Enter a string to add to the array"
$strings += $inputString

# Define an array of the top 10 TLDs
[string[]]$tlds = @(".com", ".org", ".net", ".edu", ".gov", ".co", ".io", ".info", ".me", ".biz")

# Add each TLD to the end of the string and add the modified string to the array
foreach ($tld in $tlds) {
    # Add the TLD to the input string and add the resulting string to the array
    $modifiedString = "$inputString$tld"
    $strings += $modifiedString

    # Add the TLD to the input string with "www" prepended and add the resulting string to the array
    $modifiedString = "www.$inputString$tld"
    $strings += $modifiedString
}

# Create an array to hold the URLs
[string[]]$urls = @()

# Loop through the strings and add the URLs to the array
foreach ($string in $strings) {
    $url = "codys.awesome.com/$string"
    $urls += $url
}

# Open the URLs in Edge
$edge = Start-Process -FilePath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList ("-new-window", "-maximized", $urls) -PassThru

# Wait for Edge to finish loading the pages
Start-Sleep -Seconds 5

# Loop through the tabs and check the record count for each page
foreach ($tab in $edge.Windows[0].Tabs) {
    $page = $tab.WebView

    # Check if Record Count is greater than 0
    $recordCountElement = $page.Document.GetElementById("MainContent_lblRecordCount")
    $recordCountText = $recordCountElement.InnerText
    $recordCount = $recordCountText -replace "[^0-9]"
    if ($recordCount -gt 0) {
        Write-Host "Record Count for $($tab.Title) is greater than 0."
    }
    else {
        Write-Host "Record Count for $($tab.Title) is 0. Closing tab."
        $tab.Close()
    }
}
