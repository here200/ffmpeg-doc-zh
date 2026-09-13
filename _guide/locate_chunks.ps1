# Ground-truth alignment: locate each filters chunk's actual source start line by
# matching its first line against the source (works for tag-only first lines).
$ErrorActionPreference = 'Stop'
$root = 'D:\Change\WorkspaceInDeepSeek\Translation'
$doc = 'ffmpeg-filters.html'
$plan = Get-Content -Raw -Encoding UTF8 (Join-Path $root '_guide\split_plan.json') | ConvertFrom-Json
$e = $plan | Where-Object { $_.doc -eq $doc }
$src = [System.IO.File]::ReadAllLines((Join-Path $root $doc))

# index of first line -> list of 1-based line numbers with identical text
$index = @{}
for ($i = 0; $i -lt $src.Count; $i++) {
    $t = $src[$i]
    if (-not $index.ContainsKey($t)) { $index[$t] = New-Object System.Collections.Generic.List[int] }
    $index[$t].Add($i + 1)
}

$rows = @()
for ($i = 1; $i -le $e.chunks.Count; $i++) {
    $p = Join-Path $root ('_parts\filters_c{0:D2}.html' -f $i)
    $lines = [System.IO.File]::ReadAllLines($p)
    $first = ''
    foreach ($l in $lines) { if ($l.Trim() -ne '') { $first = $l; break } }
    $actual = ''
    if ($index.ContainsKey($first)) {
        $cand = $index[$first]
        # prefer the candidate closest to the planned start (avoids far-away duplicate text)
        $planned = $e.chunks[$i-1][0]
        $best = $cand | Sort-Object { [Math]::Abs($_ - $planned) } | Select-Object -First 1
        $actual = $best
    } else { $actual = 'inline-text-start' }
    $rows += [pscustomobject]@{
        Chunk  = "c$('{0:D2}' -f $i)"
        Planned = $e.chunks[$i-1][0]
        Actual  = $actual
        Ok      = ($actual -eq $e.chunks[$i-1][0])
        Lines   = $lines.Count
    }
}
$bad = $rows | Where-Object { -not $_.Ok }
Write-Host "TOTAL=$($rows.Count)  MISALIGNED=$($bad.Count)"
$bad | Format-Table -AutoSize
