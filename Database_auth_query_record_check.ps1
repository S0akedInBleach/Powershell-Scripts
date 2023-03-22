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

# Create an empty array to hold the tabs
$tabs = @()

# Start Edge and create a new window
$edgeProcess = Start-Process -FilePath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList ("-new-window", "-maximized")

# Loop through the URLs and open each one in a new tab
foreach ($url in $urls) {
    # Open the URL in a new tab
    $tab = $edgeProcess.MainWindow.Invoke({$edgeProcess.MainWindow.OpenNewTab()})
    $tab.Navigate2($url)
    
    # Add the tab to the array
    $tabs += $tab
}

# Loop through the tabs and check if the record count is greater than 0
foreach ($tab in $tabs) {
    $page = $tab.Document
    
    # Check if Record Count is greater than 0
    $recordCount = $page.ParsedHtml.getElementById("MainContent_lblRecordCount")
    if ($recordCount -and $recordCount.innerText -gt 0) {
        # Record Count is greater than 0, do nothing
    } else {
        # Record Count is 0 or not found, close the tab
        $tab.Close()
    }
}
