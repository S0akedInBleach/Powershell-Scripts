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

# Loop through the URLs and open them in Edge if the record count is greater than 0
foreach ($url in $urls) {
    # Make a web request to the URL and retrieve the content
    $content = Invoke-WebRequest -Uri "https://$url"

    # Select the element with the record count
    $recordCount = $content.ParsedHtml.getElementById("MainContent_lblRecordCount")

    # Check if the record count is greater than 0
    if ($recordCount -and $recordCount.innerText -gt 0) {
        # Open the URL in a new tab in Edge
        $ie = New-Object -ComObject InternetExplorer.Application
        $ie.Navigate2("https://$url", 0x1000)
        $ie.Visible = $true
    }
}
