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
    "HondaNY"      = "HondaNY.html"
    "HondaMA"      = "HondaMA.html"
    "Hyundai"      = "Hyundai.html"
    "Nissan"       = "Nissan.html"
    "Subaru"       = "Subaru.html"
    "Toyota"       = "Toyota.html"
    "Sub K"        = "Subaru-Kingston.html"
    "MBDB"         = "Mercedes-Benz-Danbury.html"
    "MBOFWF"       = "Mercedes-Benz-Wappingers-Falls.html"
    "Acura- Techs"  = "Acura- Techs.html"
    "Acura- No Number"  = "Acura- NoNumber.html"
    "Grenadier- NoNumber" = "Grenadier - NoNumber.html"
    "Grenadier- Techs" = "Grenadier - Techs.html"
    "HondaMA- Techs" = "HondaMA- Techs.html"
    "HondaMA- No Number" = "HondaMA- No Number.html"
    "HondaNY - No Number" = "HondaNY - No Number.html"
    "HondaNY- Techs" = "HondaNY- Techs.html"

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
