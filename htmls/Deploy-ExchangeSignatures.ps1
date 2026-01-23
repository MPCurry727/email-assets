# Requires ExchangeOnlineManagement
Install-Module ExchangeOnlineManagement -Scope CurrentUser

Import-Module ExchangeOnlineManagement -ErrorAction Stop
Connect-ExchangeOnline

# Base GitHub RAW path (confirmed)
$repoRawBase = "https://raw.githubusercontent.com/MPCurry727/email-assets/main/htmls"

# Exchange Rule Name  ->  HTML file
$SignatureMap = @{
    "Acura"        = "Acura-Sig.html"
    "Chevy"        = "Chevy-Sig.html"
    "Grenadier"    = "Grenadier.html"
    "HondaNY"      = "Honda-NY.html"
    "HondaMA"      = "Honda-MA.html"
    "Hyundai"      = "Hyundai.html"
    "Nissan"       = "Nissan.html"
    "Subaru"       = "Subaru.html"
    "Toyota"       = "Toyota.html"
    "Sub K"        = "Subaru-Kingston.html"
    "MBDB"         = "Mercedes-Benz-Danbury.html"
    "MBOFWF"       = "Mercedes-Benz-Wappingers-Falls.html"
    # "Acura Techs"  = "Acura-Techs.html"
    # "Acura NoNum"  = "Acura-No Number.html"
}

foreach ($rule in $SignatureMap.Keys) {

    $file = $SignatureMap[$rule]
    $url  = "$repoRawBase/$file"

    Write-Host "🔄 Updating rule '$rule' from $file"

    try {
        $html = Invoke-RestMethod -Uri $url -ErrorAction Stop

        Set-TransportRule `
            -Identity $rule `
            -ApplyHtmlDisclaimerText $html `
            -ApplyHtmlDisclaimerLocation Append `
            -ErrorAction Stop

        Write-Host "✅ $rule updated successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ $rule failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Disconnect-ExchangeOnline
