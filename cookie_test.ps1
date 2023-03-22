# Authenticate with the web page using Edge credentials
$ie = New-Object -ComObject 'InternetExplorer.Application'
$ie.Visible = $true
$ie.Navigate('https://example.com/login')

# Wait for the page to load
while ($ie.Busy -or $ie.ReadyState -ne 4) {
    Start-Sleep -Milliseconds 100
}

# Fill in the login form
$usernameField = $ie.Document.getElementById('username')
$usernameField.value = 'myusername'

$passwordField = $ie.Document.getElementById('password')
$passwordField.value = 'mypassword'

# Click the login button
$submitButton = $ie.Document.getElementsByTagName('input') | Where-Object { $_.type -eq 'submit' }
$submitButton.click()

# Wait for the page to load
while ($ie.Busy -or $ie.ReadyState -ne 4) {
    Start-Sleep -Milliseconds 100
}

# Get the authentication cookies
$cookies = $ie.Document.cookie -split '; ' | ForEach-Object { $_.Split('=')[1] }

# Use the cookies to authenticate with the web page using Invoke-WebRequest
$uri = 'https://example.com/my-page'
$headers = @{
    'Cookie' = $cookies -join '; '
}
$response = Invoke-WebRequest -Uri $uri -Headers $headers

# Interact with the page using PowerShell
$pageContent = $response.Content
$recordCount = $response.ParsedHtml.getElementById('MainContent_iblRecordCount')

# Close Edge
$ie.Quit()
