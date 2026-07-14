# Requires ExchangeOnlineManagement
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Write-Host "ExchangeOnlineManagement is not installed. Installing for the current user..." -ForegroundColor Yellow
    Install-Module ExchangeOnlineManagement -Scope CurrentUser -Force -AllowClobber
}

Import-Module ExchangeOnlineManagement -ErrorAction Stop
Connect-ExchangeOnline -UserPrincipalName mprescott@curryauto.com

# HTML files live in the same folder as this script
$scriptFolder = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }

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
    $localPath = Join-Path -Path $scriptFolder -ChildPath $file

    Write-Host "[Updating] Rule '$rule' from $file"

    try {
        if (-not (Test-Path -LiteralPath $localPath)) {
            throw "HTML file was not found: $localPath"
        }

        $html = Get-Content -LiteralPath $localPath -Raw -Encoding UTF8

        Set-TransportRule `
            -Identity $rule `
            -ApplyHtmlDisclaimerText $html `
            -ApplyHtmlDisclaimerLocation Append `
            -ErrorAction Stop

        $updatedRule = Get-TransportRule -Identity $rule -ErrorAction Stop
        if ($updatedRule.ApplyHtmlDisclaimerText -eq $html) {
            Write-Host "[Verified] $rule updated from local file" -ForegroundColor Green
        }
        else {
            Write-Host "[Warning] $rule command ran, but Exchange does not show the expected HTML yet" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "[Failed] $rule failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Disconnect-ExchangeOnline
Pause
