# Normalize terminology in ffmpeg-zh.html. ASCII-only script; Chinese pairs come from
# term_pairs.json (read explicitly as UTF-8) so PS 5.1 cannot mis-decode literals here.
$ErrorActionPreference = 'Stop'
$root = 'D:\Change\WorkspaceInDeepSeek\Translation'
$p = Join-Path $root 'ffmpeg-zh.html'
$backup = Join-Path $root 'ffmpeg-zh.backup.html'
if (-not (Test-Path $backup)) { Copy-Item $p $backup }

$cfg = [System.IO.File]::ReadAllText((Join-Path $root '_guide\term_pairs.json'), [System.Text.Encoding]::UTF8) | ConvertFrom-Json
$t = [System.IO.File]::ReadAllText($p, [System.Text.Encoding]::UTF8)
$before = $t.Length
$log = @()

foreach ($pr in $cfg.termPairs) {
    $n = ([regex]::new([regex]::Escape($pr[0]))).Matches($t).Count
    if ($n -gt 0) { $t = $t.Replace($pr[0], $pr[1]); $log += ("{0} -> {1} : {2}" -f $pr[0], $pr[1], $n) }
}
foreach ($pr in $cfg.headingPairs) {
    $n = ([regex]::new([regex]::Escape($pr[0]))).Matches($t).Count
    if ($n -gt 0) { $t = $t.Replace($pr[0], $pr[1]); $log += ("{0} -> {1} : {2}" -f $pr[0], $pr[1], $n) }
}

[System.IO.File]::WriteAllText($p, $t, (New-Object System.Text.UTF8Encoding($false)))
Write-Host "REPLACEMENTS:"
$log | ForEach-Object { Write-Host "  $_" }
Write-Host "bytes $before -> $($t.Length)"

$resid = 0
foreach ($pr in $cfg.termPairs) {
    $c = ([regex]::new([regex]::Escape($pr[0]))).Matches($t).Count
    if ($c -gt 0) { Write-Host "  RESIDUAL $($pr[0]) : $c"; $resid++ }
}
if ($resid -eq 0) { Write-Host "  no residual variants" }
