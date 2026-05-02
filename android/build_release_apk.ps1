# Release APK (Google Play can also accept AAB; see build_release_appbundle.ps1)
$ErrorActionPreference = "Stop"
Set-Location (Split-Path $PSScriptRoot -Parent)
flutter build apk --release
Write-Host ""
Write-Host "APK (if build succeeded): build\app\outputs\flutter-apk\app-release.apk"
