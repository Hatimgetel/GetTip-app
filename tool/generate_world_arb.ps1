$ErrorActionPreference = "Stop"

$templatePath = "lib/l10n/app_en.arb"
$worldLanguagesPath = "lib/l10n/world_languages.dart"

if (!(Test-Path $templatePath)) {
  throw "Template ARB not found: $templatePath"
}
if (!(Test-Path $worldLanguagesPath)) {
  throw "Language list file not found: $worldLanguagesPath"
}

$templateObject = Get-Content -Path $templatePath -Raw -Encoding UTF8 | ConvertFrom-Json
$template = @{}
foreach ($p in $templateObject.PSObject.Properties) {
  $template[$p.Name] = $p.Value
}
$worldLanguagesContent = Get-Content -Path $worldLanguagesPath -Raw -Encoding UTF8

$codes = [regex]::Matches($worldLanguagesContent, "AppLanguageOption\(code: '([a-z]{2})'")
$languageCodes = $codes | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique

# ASCII Record Separator — unlikely in UI copy; survives translation as one code unit.
$sep = [string][char]0x001E
$sepRegex = [regex]::Escape($sep)

function Should-Translate([string]$value) {
  if ([string]::IsNullOrWhiteSpace($value)) { return $false }
  if ($value -match "\{[^}]+\}") { return $false }
  return $true
}

function Translate-JoinedText([string]$joined, [string]$target) {
  $url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=$target&dt=t&q=$([uri]::EscapeDataString($joined))"
  $response = Invoke-RestMethod -Uri $url -Method Get -TimeoutSec 45
  $segments = @($response[0] | ForEach-Object { $_[0] })
  return ($segments -join "")
}

function Translate-OneText([string]$text, [string]$target) {
  $url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=$target&dt=t&q=$([uri]::EscapeDataString($text))"
  $response = Invoke-RestMethod -Uri $url -Method Get -TimeoutSec 45
  $segments = @($response[0] | ForEach-Object { $_[0] })
  return ($segments -join "")
}

function Translate-Chunk([string[]]$keys, [hashtable]$src, [string]$target) {
  $result = @{}
  if ($keys.Count -eq 0) { return $result }

  $joined = ($keys | ForEach-Object { [string]$src[$_] }) -join $sep
  $translated = $null
  for ($attempt = 1; $attempt -le 3; $attempt++) {
    try {
      $translated = Translate-JoinedText -joined $joined -target $target
      break
    } catch {
      if ($attempt -lt 3) { Start-Sleep -Milliseconds (300 * $attempt) }
    }
  }

  if ($translated) {
    $parts = @($translated -split $sepRegex)
    if ($parts.Count -eq $keys.Count) {
      for ($i = 0; $i -lt $keys.Count; $i++) {
        $result[$keys[$i]] = $parts[$i]
      }
      return $result
    }
  }

  foreach ($k in $keys) {
    $source = [string]$src[$k]
    $one = $null
    for ($attempt = 1; $attempt -le 2; $attempt++) {
      try {
        $one = Translate-OneText -text $source -target $target
        break
      } catch {
        if ($attempt -lt 2) { Start-Sleep -Milliseconds (200 * $attempt) }
      }
    }
    if (![string]::IsNullOrWhiteSpace($one)) {
      $result[$k] = $one
    }
  }
  return $result
}

$baseKeys = @($template.Keys)
$textKeys = [System.Collections.Generic.List[string]]::new()
foreach ($k in $baseKeys) {
  if ($k.StartsWith("@")) { continue }
  if ($template[$k] -isnot [string]) { continue }
  if (Should-Translate $template[$k]) {
    [void]$textKeys.Add($k)
  }
}

$chunkSize = 12
Write-Host "Generating ARB files for $($languageCodes.Count) languages ($($textKeys.Count) strings each, chunks of $chunkSize)..."

foreach ($code in $languageCodes) {
  if ($code -eq "en") { continue }

  $out = @{}
  foreach ($k in $baseKeys) {
    $out[$k] = $template[$k]
  }
  $out["@@locale"] = $code

  for ($start = 0; $start -lt $textKeys.Count; $start += $chunkSize) {
    $end = [Math]::Min($start + $chunkSize - 1, $textKeys.Count - 1)
    $chunk = $textKeys.GetRange($start, $end - $start + 1)
    $chunkMap = Translate-Chunk -keys $chunk -src $template -target $code
    foreach ($kv in $chunkMap.GetEnumerator()) {
      $out[$kv.Key] = $kv.Value
    }
    Start-Sleep -Milliseconds 120
  }

  $json = $out | ConvertTo-Json -Depth 20
  [System.IO.File]::WriteAllText("lib/l10n/app_$code.arb", $json, [System.Text.UTF8Encoding]::new($false))
  Write-Host "Wrote lib/l10n/app_$code.arb"
}

Write-Host "ARB generation complete."
