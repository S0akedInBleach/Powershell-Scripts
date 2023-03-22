# Create an array of strings
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

# Create a new array to hold the URLs
[string[]]$urls = @()

# Loop through the strings and add the URLs to the array
foreach ($string in $strings) {
    $urls += "https://codys.awesome.com/$string"
}

# Open the URLs in Edge
Start-Process -FilePath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList ("-new-window", "-maximized")

# Wait for Edge to fully open
Start-Sleep -Seconds 2

# Loop through the URLs and check for the element with ID "MainContent_iblRecordCount"
foreach ($url in $urls) {
    # Navigate to the URL in the current tab
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.SendKeys]::SendWait("^t$url{ENTER}")

    # Wait for the page to fully load
    Start-Sleep -Seconds 5

    # Get the parsed HTML of the page
    $page = (New-Object -ComObject "HTMLFile").IHTMLDocument3
    $page.write((New-Object -ComObject "WinHttp.WinHttpRequest.5.1").Open('GET', $url, $false).ResponseBody)

    # Check if the element with ID "MainContent_iblRecordCount" exists and has a value greater than 0
    $recordCount = $page.getElementById("MainContent_iblRecordCount")
    if ($recordCount -eq $null -or [int]$recordCount.innerText -eq 0) {
        # If the element does not exist or has a value of 0, close the current tab
        [System.Windows.Forms.SendKeys]::SendWait("^w")
    }
}
