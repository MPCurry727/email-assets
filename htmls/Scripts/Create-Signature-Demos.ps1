# Creates demo copies of all production email signature HTML files in the current folder.
# It replaces Exchange placeholders with fake user information.
# Production files are NOT changed.

$Folder = $PSScriptRoot

$FakeFirstName = "Ella"
$FakeLastName  = "Vader"
$FakeFullName  = "$FakeFirstName $FakeLastName"
$FakeTitle     = "Product Specialist"
$FakePhone     = "(914) 555-1234"

# Get all HTML files, but skip files that are already demo files
$HtmlFiles = Get-ChildItem -Path $Folder -Filter "*.html" |
    Where-Object { $_.Name -notlike "*-DEMO.html" }

if ($HtmlFiles.Count -eq 0) {
    Write-Host "No production HTML files found in $Folder" -ForegroundColor Yellow
    return
}

foreach ($File in $HtmlFiles) {

    Write-Host "Creating demo for $($File.Name)..." -ForegroundColor Cyan

    $Html = Get-Content $File.FullName -Raw

    # Try to guess the dealership/domain from the existing Email or Website area
    # If no domain is found, fallback to example.com
    $Domain = "example.com"

    if ($Html -match "www\.([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})") {
        $Domain = $Matches[1]
    }
    elseif ($Html -match "https://www\.([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})") {
        $Domain = $Matches[1]
    }

    $FakeEmail = "evader@$Domain"

    # Replace common Exchange disclaimer placeholders
    $Html = $Html.Replace("%%FirstName%% %%LastName%%", $FakeFullName)
    $Html = $Html.Replace("%%FirstName%%", $FakeFirstName)
    $Html = $Html.Replace("%%LastName%%", $FakeLastName)
    $Html = $Html.Replace("%%Title%%", $FakeTitle)
    $Html = $Html.Replace("%%PhoneNumber%%", $FakePhone)
    $Html = $Html.Replace("%%Email%%", $FakeEmail)

    # Safety: catches the common typo if it exists in any template
    $Html = $Html.Replace("%%PhonenNumber%%", $FakePhone)

    # Optional demo banner at the very top so nobody thinks this is a real user
    $DemoBanner = @"
<div style="font-family: Arial, sans-serif; font-size: 10pt; color: #b00020; font-weight: bold; padding-bottom: 10px;">
  DEMO PREVIEW ONLY - Fake employee information used for screenshot purposes
</div>

"@

    $Html = $DemoBanner + $Html

    $OutputName = [System.IO.Path]::GetFileNameWithoutExtension($File.Name) + "-DEMO.html"
    $OutputPath = Join-Path $Folder $OutputName

    $Html | Set-Content -Path $OutputPath -Encoding UTF8

    Write-Host "Created: $OutputName" -ForegroundColor Green
}

Write-Host ""
Write-Host "Done. Demo files were created in:" -ForegroundColor Green
Write-Host $Folder
Start-Process $Folder