$username = Read-Host "Enter your SSO username"
$password = Read-Host "Enter your SSO password" -AsSecureString
$codys_the_man = Read-Host "Enter a string"

$SSOUrl = "https://sso.webpage.com"
$SSOCookie = New-Object System.Net.CookieContainer

# Authenticate with SSO
$loginPage = Invoke-WebRequest -Uri $SSOUrl -UseDefaultCredentials -SessionVariable SSOsession -WebSession $SSOCookie -Method GET
$form = $loginPage.Forms[0]
$form.Fields["Username"] = $username
$form.Fields["Password"] = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
$response = Invoke-WebRequest -Uri ($SSOUrl + $form.Action) -WebSession $SSOCookie -Method POST -Body $form.Fields
if ($response.StatusCode -ne 200) {
    Write-Host "SSO authentication failed"
    return
}

# Query the webpage with the entered string as the value of the "k" parameter
$url = "https://codys.webpage.com/Dashboard.aspx?D=0&k=$codys_the_man"
$page = Invoke-WebRequest -Uri $url -WebSession $SSOCookie

# Check if Record Count is greater than 0
$recordCount = $page.ParsedHtml.getElementById("MainContent_iblRecordCount")
if ($recordCount -ne $null -and $recordCount.InnerText -match "Record Count: (\d+)") {
    $count = [int]$Matches[1]
    if ($count -gt 0) {
        Write-Host "Record Count: $count"
        Start-Process $url
    }
    else {
        Write-Host "No results found"
    }
}
else {
    Write-Host "Error: Could not find Record Count"
}
