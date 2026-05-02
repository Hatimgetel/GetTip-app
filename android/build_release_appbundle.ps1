# Release App Bundle (preferred format for Google Play Console)
$ErrorActionPreference = "Stop"
Set-Location (Split-Path $PSScriptRoot -Parent)
flutter build appbundle --release
Write-Host ""
Write-Host "AAB (if build succeeded): build\app\outputs\bundle\release\app-release.aab"
