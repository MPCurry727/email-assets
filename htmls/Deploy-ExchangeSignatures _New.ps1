# Requires ExchangeOnlineManagement
Install-Module ExchangeOnlineManagement -Scope CurrentUser

Import-Module ExchangeOnlineManagement -ErrorAction Stop
Connect-ExchangeOnline

# Local folder where the script is running
$LocalHtmlFolder = $PSScriptRoot

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
	"Hyundai-Subaru" = "Hyundai-Subaru.html"
    "Hyundai-Subaru-Toyota" = "Hyundai-Subaru-Toyota.html"
    "Sub K"        = "Subaru-Kingston.html"
    "MBDB"         = "MBDB.html"
    "MBWF"       = "MBWF.html"
	"TOYHYSUBHA" = "TOYHYSUBHA.html"
	#"HondaNY_Accounting" = "HondaNY_Accounting.html"
	"Nissan-HondaMA" = "Nissan-HondaMA.html"
	"MikeDMiele" = "MikeDMiele.html"
	"TOYHYSUBHA - PlatManager" = "TOYHYSUBHA - PlatManager.html"
	"HondaMA_BodyShop" = "HondaMA_BodyShop.html"
	"ServiceBDC" = "ServiceBDC.html"
	"Nissan - Comply" = "Nissan - Comply.html"
}

foreach ($rule in $SignatureMap.Keys) {

    $file = $SignatureMap[$rule]
    $path = Join-Path $LocalHtmlFolder $file

    Write-Host "🔄 Updating rule '$rule' from local file: $file"

    try {
        if (-not (Test-Path $path)) {
            throw "Local HTML file not found: $path"
        }

        $html = Get-Content -Path $path -Raw -ErrorAction Stop

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

Disconnect-ExchangeOnline -Confirm:$false
Pause