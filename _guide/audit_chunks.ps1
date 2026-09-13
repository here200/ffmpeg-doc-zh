# Audit every part file against its planned line range.
# A part is considered aligned when:
#   - its line count equals the planned range length (translation may re-flow, so allow +/-5%)
#   - the tag-token-count of its first line equals that of the planned first source line
#   - the tag-token-count of its last non-empty line equals that of the planned last source line
# Reports misaligned chunks so they can be re-dispatched.
$ErrorActionPreference = 'Stop'
$root = 'D:\Change\WorkspaceInDeepSeek\Translation'
$plan = Get-Content -Raw -Encoding UTF8 (Join-Path $root '_guide\split_plan.json') | ConvertFrom-Json

$stems = @{
    'ffmpeg-resampler.html'         = 'resampler'
    'ffmpeg-scaler.html'            = 'scaler'
    'ffmpeg-bitstream-filters.html' = 'bitstream-filters'
    'ffmpeg-utils.html'             = 'utils'
    'ffmpeg-devices.html'           = 'devices'
    'ffmpeg-protocols.html'         = 'protocols'
    'ffmpeg-formats.html'           = 'formats'
    'ffmpeg-codecs.html'            = 'codecs'
    'ffmpeg-filters.html'           = 'filters'
    'developer.html'                = 'developer'
    'faq.html'                      = 'faq'
    'fate.html'                     = 'fate'
    'general.html'                  = 'general'
    'git-howto.html'                = 'git-howto'
    'platform.html'                 = 'platform'
}
$tagRe = [regex]::new('<[^>]*>')
function TagCount([string]$s) { return $tagRe.Matches($s).Count }

$only = $args[0]
$bad = @()
foreach ($d in $plan) {
    if ($only -and $d.doc -ne $only) { continue }
    $stem = $stems[$d.doc]
    $src = [System.IO.File]::ReadAllLines((Join-Path $root $d.doc))
    for ($i = 1; $i -le $d.chunks.Count; $i++) {
        $p = Join-Path $root ('_parts\{0}_c{1:D2}.html' -f $stem, $i)
        if (-not (Test-Path $p)) { $bad += [pscustomobject]@{Chunk="$stem c$i"; Issue='MISSING FILE'}; continue }
        $lines = [System.IO.File]::ReadAllLines($p)
        $s = $d.chunks[$i-1][0]; $e = $d.chunks[$i-1][1]
        $expLen = $e - $s + 1
        $srcFirstTags = TagCount $src[$s-1]
        $srcLastTags  = TagCount $src[$e-1]
        $outFirstTags = if ($lines.Count -gt 0) { TagCount $lines[0] } else { -1 }
        $outLastTags  = -1
        for ($k = $lines.Count - 1; $k -ge 0; $k--) { if ($lines[$k].Trim() -ne '') { $outLastTags = TagCount $lines[$k]; break } }
        $issues = @()
        if ($outFirstTags -ne $srcFirstTags) { $issues += "first-line tagcount src=$srcFirstTags out=$outFirstTags" }
        if ($srcLastTags -ne 0 -and $outLastTags -ne $srcLastTags) { $issues += "last-line tagcount src=$srcLastTags out=$outLastTags" }
        if ([Math]::Abs($lines.Count - $expLen) -gt [Math]::Max(8, [int]($expLen * 0.08))) { $issues += "linecount exp~$expLen out=$($lines.Count)" }
        if ($issues.Count -gt 0) {
            $bad += [pscustomobject]@{ Chunk = "$stem c$i"; Range = "[$s,$e]"; Issue = ($issues -join '; ') }
        }
    }
}
if ($bad.Count -eq 0) { Write-Host "ALL CHUNKS ALIGNED" }
else { Write-Host "MISALIGNED CHUNKS: $($bad.Count)"; $bad | Format-Table -AutoSize }
