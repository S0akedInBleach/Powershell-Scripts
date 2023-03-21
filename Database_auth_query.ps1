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

# Create an array of URLs
# Initialize an empty array to hold the URLs
[string[]]$urls = @()

# Loop through the strings and add the URLs to the array
foreach ($string in $strings) {
    $url = "codys.awesome.com/$string"
    $urls += $url
}

# Open Edge and create the first tab
$edgeProcess = Start-Process "msedge.exe" -PassThru
Start-Sleep -Seconds 1
$edgeTab = $edgeProcess | Select-Object -ExpandProperty MainWindowHandle
[System.Windows.Forms.SendKeys]::SendWait("^t")
Start-Sleep -Seconds 1

# Open each URL as a new tab in the existing Edge window
foreach ($url in $urls) {
    [System.Windows.Forms.SendKeys]::SendWait($url)
    [System.Windows.Forms.SendKeys]::SendWait("{Enter}")
    Start-Sleep -Seconds 1
    [System.Windows.Forms.SendKeys]::SendWait("^t")
    Start-Sleep -Seconds 1
}

# Activate the first tab
[System.Windows.Forms.SendKeys]::SendWait("^1")
Start-Sleep -Seconds 1
