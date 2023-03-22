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

# Create a string of URLs
# Initialize an empty string to hold the URLs
[string]$urlString = ""

# Loop through the strings and concatenate the URLs to the string
foreach ($string in $strings) {
    $url = "codys.awesome.com/$string"
    $urlString += $url + ","
}

# Remove the trailing comma from the URL string
$urlString = $urlString.TrimEnd(",")

# Open a new Edge window with all URLs as tabs
Start-Process "msedge.exe" -ArgumentList ("-new-window", "-url", $urlString)
