$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$publishScript = Join-Path $root "publish-github.ps1"
$checkScript = Join-Path $PSScriptRoot "check-live-site.ps1"

Write-Host "JavaScript kontrolu yapiliyor..."
node --check (Join-Path $root "script.js")

Write-Host "GitHub'a aktariliyor..."
& $publishScript

Write-Host "GitHub Pages hazirlanmasi bekleniyor..."
Start-Sleep -Seconds 30

Write-Host "Canli site kontrol ediliyor..."
& $checkScript
