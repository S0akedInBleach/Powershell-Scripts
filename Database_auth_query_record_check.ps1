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

# Open Edge and create a new window
$edgeProcess = Start-Process -FilePath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList ("-new-window")

# Wait for the Edge window to finish loading
Start-Sleep -Seconds 5

# Loop through the URLs and open each one as a new tab in the existing Edge window
foreach ($url in $urls) {
    # Create a new tab in the existing Edge window
    $tabProcess = Start-Process -FilePath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList ("-new-tab", $url)

    # Wait for the page to finish loading
    Start-Sleep -Seconds 5

    # Check if Record Count is greater than 0
    $page = New-Object -ComObject "InternetExplorer.Application"
    $page.Visible = $false
    $page.Navigate2($url)

    while ($page.Busy) {
        Start-Sleep -Milliseconds 100
    }

    $recordCount = $page.Document.getElementById("MainContent_lblRecordCount").InnerText -replace "Record Count: ", ""

    # Close the tab if Record Count is 0
    if ($recordCount -eq 0) {
        $tabProcess.CloseMainWindow()
    }

    $page.Quit()
}
