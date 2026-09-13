# Generate chunk split plan for the 9 ffmpeg docs.
# Safe split boundaries (all are sibling-level positions):
#   ^<a name=            section anchors
#   ^<dt                 definition-list items
#   ^  <li><a id="toc-   top-level table-of-contents entries (siblings inside the TOC <ul>)
# Target ~350 lines per chunk; if no boundary exists inside the window, extend forward.
$ErrorActionPreference = 'Stop'
$root = 'D:\Change\WorkspaceInDeepSeek\Translation'
$docs = @(
  'developer.html',
  'faq.html',
  'fate.html',
  'general.html',
  'git-howto.html',
  'platform.html'
)
$TARGET = 350
$MAXSCAN = 1450   # allow occasional larger chunks (e.g. straight after the TOC)
$out = @()
$summary = @()

foreach ($doc in $docs) {
    $path = Join-Path $root $doc
    $lines = [System.IO.File]::ReadAllLines($path)
    $n = $lines.Count

    $candSet = New-Object 'System.Collections.Generic.HashSet[int]'
    [void]$candSet.Add(1)
    for ($i = 0; $i -lt $n; $i++) {
        $l = $lines[$i]
        if ($l.StartsWith('<a name=') -or $l.StartsWith('<dt') -or $l.StartsWith('  <li><a id="toc-')) {
            [void]$candSet.Add($i + 1)
        }
    }
    $cands = @($candSet | Sort-Object)

    $starts = New-Object System.Collections.Generic.List[int]
    $starts.Add(1)
    $cur = 1
    while ($true) {
        $pick = 0
        # look for a boundary in the target window first, then extend up to MAXSCAN
        foreach ($win in @($TARGET, 500, 700, 950, $MAXSCAN)) {
            $limit = [Math]::Min($cur + $win - 1, $n)
            $next = $cands | Where-Object { $_ -gt $cur -and $_ -le $limit }
            if ($next) { $pick = ($next | Measure-Object -Maximum).Maximum; break }
        }
        if ($pick -eq 0) { break }   # no boundary at all ahead: remainder becomes one chunk
        $starts.Add($pick)
        $cur = $pick
    }

    $ranges = @()
    for ($k = 0; $k -lt $starts.Count; $k++) {
        $s = $starts[$k]
        $e = if ($k + 1 -lt $starts.Count) { $starts[$k + 1] - 1 } else { $n }
        $ranges += ,@($s, $e)
    }
    $sizes = $ranges | ForEach-Object { $_[1] - $_[0] + 1 }
    $summary += [pscustomobject]@{
        Doc    = $doc
        Lines  = $n
        Chunks = $ranges.Count
        MinSz  = ($sizes | Measure-Object -Minimum).Minimum
        MaxSz  = ($sizes | Measure-Object -Maximum).Maximum
    }
    $out += [pscustomobject]@{ doc = $doc; total = $n; chunks = $ranges }
}

$json = $out | ConvertTo-Json -Depth 6
[System.IO.File]::WriteAllText((Join-Path $root '_guide\split_plan.json'), $json, (New-Object System.Text.UTF8Encoding($false)))
$summary | Format-Table -AutoSize
"TOTAL CHUNKS: " + (($summary | Measure-Object Chunks -Sum).Sum)
