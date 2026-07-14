# Requires ExchangeOnlineManagement
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Write-Host "ExchangeOnlineManagement is not installed. Installing for the current user..." -ForegroundColor Yellow
    Install-Module ExchangeOnlineManagement -Scope CurrentUser -Force -AllowClobber
}

Import-Module ExchangeOnlineManagement -ErrorAction Stop
Connect-ExchangeOnline -UserPrincipalName mprescott@curryauto.com

# Base GitHub RAW path
$repoRawBase = "https://raw.githubusercontent.com/MPCurry727/email-assets/main/htmls"

# Exchange Rule Name  ->  HTML file
$SignatureMap = @{
    "Acura"                    = "Acura-Sig.html"
    "Chevy"                    = "Chevy-Sig.html"
    "Grenadier"                = "Grenadier.html"
    "HondaNY"                  = "HondaNY.html"
    "HondaMA"                  = "HondaMA.html"
    "Hyundai"                  = "Hyundai.html"
    "Nissan"                   = "Nissan.html"
    "Subaru"                   = "Subaru.html"
    "Toyota"                   = "Toyota.html"
    "Hyundai-Subaru"           = "Hyundai-Subaru.html"
    "Hyundai-Subaru-Toyota"    = "Hyundai-Subaru-Toyota.html"
    "Sub K"                    = "Subaru-Kingston.html"
    "MBDB"                     = "MBDB.html"
    "MBWF"                     = "MBWF.html"
    "TOYHYSUBHA"               = "TOYHYSUBHA.html"
    #"HondaNY_Accounting"      = "HondaNY_Accounting.html"
    "Nissan-HondaMA"           = "Nissan-HondaMA.html"
    "MikeDMiele"               = "MikeDMiele.html"
    "TOYHYSUBHA - PlatManager" = "TOYHYSUBHA - PlatManager.html"
    "HondaMA_BodyShop"         = "HondaMA_BodyShop.html"
    "ServiceBDC"               = "ServiceBDC.html"
    "Nissan - Comply"          = "Nissan - Comply.html"
}

foreach ($rule in $SignatureMap.Keys) {
    $file = $SignatureMap[$rule]
    $encodedFile = [System.Uri]::EscapeDataString($file).Replace('%2F', '/')
    $url = "$repoRawBase/$encodedFile"

    Write-Host "[Updating] Rule '$rule' from $file"

    try {
        $html = Invoke-RestMethod -Uri $url -ErrorAction Stop

        Set-TransportRule `
            -Identity $rule `
            -ApplyHtmlDisclaimerText $html `
            -ApplyHtmlDisclaimerLocation Append `
            -ErrorAction Stop

        Write-Host "[OK] $rule updated successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "[Failed] $rule failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Disconnect-ExchangeOnline
Pause
