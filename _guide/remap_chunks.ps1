# Robust re-location of every part file to its true source range.
# Signature = concatenated tag-skeletons of the first 3 non-empty lines.
# Tag skeletons survive translation, so this works even when the file starts with prose.
$ErrorActionPreference = 'Stop'
$root = 'D:\Change\WorkspaceInDeepSeek\Translation'
$tagRe = [regex]::new('<[^>]*>')
function Skeleton([string]$s) { return (($tagRe.Matches($s) | ForEach-Object { $_.Value }) -join '') }

function Sig([string[]]$lines, [int]$from) {
    $parts = @()
    for ($i = $from; $i -lt $lines.Count -and $parts.Count -lt 3; $i++) {
        if ($lines[$i].Trim() -eq '') { continue }
        $parts += (Skeleton $lines[$i])
    }
    return ($parts -join '||')
}

$jobs = @(
    @{ doc='ffmpeg-filters.html'; stem='filters' },
    @{ doc='ffmpeg-codecs.html'; stem='codecs' },
    @{ doc='ffmpeg-formats.html'; stem='formats' },
    @{ doc='ffmpeg-protocols.html'; stem='protocols' },
    @{ doc='ffmpeg-devices.html'; stem='devices' },
    @{ doc='ffmpeg-utils.html'; stem='utils' },
    @{ doc='ffmpeg-bitstream-filters.html'; stem='bitstream-filters' },
    @{ doc='ffmpeg-resampler.html'; stem='resampler' },
    @{ doc='ffmpeg-scaler.html'; stem='scaler' }
)
$plan = Get-Content -Raw -Encoding UTF8 (Join-Path $root '_guide\split_plan.json') | ConvertFrom-Json

foreach ($job in $jobs) {
    $e = $plan | Where-Object { $_.doc -eq $job.doc }
    $src = [System.IO.File]::ReadAllLines((Join-Path $root $job.doc))
    # map signature -> source line numbers
    $sigIndex = @{}
    for ($i = 0; $i -lt $src.Count; $i++) {
        $sg = Sig $src $i
        if ($sg -eq '' -or $sg -eq '||||') { continue }
        if (-not $sigIndex.ContainsKey($sg)) { $sigIndex[$sg] = New-Object System.Collections.Generic.List[int] }
        $sigIndex[$sg].Add($i + 1)
    }
    $map = @{}   # planned chunk start -> file index that truly covers it
    $stray = @()
    for ($c = 1; $c -le $e.chunks.Count; $c++) {
        $p = Join-Path $root ('_parts\{0}_c{1:D2}.html' -f $job.stem, $c)
        if (-not (Test-Path $p)) { continue }
        $lines = [System.IO.File]::ReadAllLines($p)
        $sg = Sig $lines 0
        if (-not $sigIndex.ContainsKey($sg)) { $stray += "c$c : signature not found"; continue }
        $cand = $sigIndex[$sg]
        $planned = $e.chunks[$c-1][0]
        $best = $cand | Sort-Object { [Math]::Abs($_ - $planned) } | Select-Object -First 1
        if ($best -eq $planned) { $map[$planned] = $c }
        else { $stray += "c$c : expected start $planned but content is $best" }
    }
    $missing = @()
    for ($c = 1; $c -le $e.chunks.Count; $c++) { if (-not $map.ContainsKey($e.chunks[$c-1][0])) { $missing += $c } }
    Write-Host "===== $($job.doc) : chunks=$($e.chunks.Count) aligned=$($map.Count) missing=$($missing.Count) stray=$($stray.Count)"
    if ($stray.Count)  { $stray  | ForEach-Object { Write-Host "   STRAY  $_" } }
    if ($missing.Count) {
        if ($missing.Count -le 25) { Write-Host "   MISSING chunk numbers: $($missing -join ',')" }
        else { Write-Host "   MISSING: $($missing.Count) chunks -> $($missing[0..24] -join ',') ..." }
    }
}
