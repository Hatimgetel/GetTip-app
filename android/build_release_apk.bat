@echo off
REM Release APK — run from repo root or double-click (changes to repo root).
cd /d "%~dp0.."
flutter build apk --release
echo.
echo APK: build\app\outputs\flutter-apk\app-release.apk
