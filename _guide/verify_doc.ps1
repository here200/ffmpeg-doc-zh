# Generic verifier for one ffmpeg doc translation.
# Usage: & verify_doc.ps1 -Doc ffmpeg-utils.html -Stem utils
# NOTE: ASCII-only source on purpose (PS 5.1 mis-decodes UTF-8 no-BOM scripts).
param(
    [Parameter(Mandatory=$true)][string]$Doc,
    [Parameter(Mandatory=$true)][string]$Stem
)
$ErrorActionPreference = 'Stop'
$root = 'D:\Change\WorkspaceInDeepSeek\Translation'
$plan = Get-Content -Raw -Encoding UTF8 (Join-Path $root '_guide\split_plan.json') | ConvertFrom-Json
$entry = $plan | Where-Object { $_.doc -eq $Doc }
if (-not $entry) { Write-Host "no plan entry for $Doc"; exit 1 }

$nchunks = $entry.chunks.Count
$parts = @()
for ($i = 1; $i -le $nchunks; $i++) { $parts += (Join-Path $root ('_parts\{0}_c{1:D2}.html' -f $Stem, $i)) }
$missing = $parts | Where-Object { -not (Test-Path $_) }
if ($missing) { Write-Host "MISSING PARTS:"; $missing | ForEach-Object { Write-Host "  $_" }; exit 1 }

$sb = New-Object System.Text.StringBuilder
foreach ($f in $parts) { [void]$sb.Append(([System.IO.File]::ReadAllText($f))) }
$joined = $sb.ToString()

# --- align every section heading with its TOC entry (TOC is the single source of truth
#     for the translated title; Texinfo guarantees both carry the same section name) ---
$tocMap = @{}
$tocRe = [regex]::new('(?s)<a id="toc-[^"]*" href="#([^"]+)">(.*?)</a>')
foreach ($m in $tocRe.Matches($joined)) { $tocMap[$m.Groups[1].Value] = $m.Groups[2].Value }

$headRe = [regex]::new('(?s)(<a name="([^"]+)"></a>\s*<h[2-5][^>]*>)(.*?)(<span class="pull-right">)')
$fixes = @()
foreach ($m in $headRe.Matches($joined)) {
    $anchor = $m.Groups[2].Value
    if ($tocMap.ContainsKey($anchor)) {
        $cur = $m.Groups[3].Value
        $want = $tocMap[$anchor]
        if ($want -ne $cur) { $fixes += ,@(($m.Groups[1].Value + $cur + $m.Groups[4].Value), ($m.Groups[1].Value + $want + $m.Groups[4].Value)) }
    }
}
foreach ($fx in $fixes) { $joined = $joined.Replace($fx[0], $fx[1]) }
$alignCount = $fixes.Count

$zhPath = Join-Path $root ($Stem + '-zh.html')
[System.IO.File]::WriteAllText($zhPath, $joined, (New-Object System.Text.UTF8Encoding($false)))
Write-Host "WROTE $zhPath ($($joined.Length) chars, $nchunks chunks)  headings aligned to TOC: $alignCount"

$orig = [System.IO.File]::ReadAllText((Join-Path $root $Doc))
$new  = [System.IO.File]::ReadAllText($zhPath)

$tagRe = [regex]::new('<[^>]*>')
$preRe = [regex]::new('(?s)<pre[^>]*>.*?</pre>')
$inlRe = [regex]::new('(?s)<(code|samp|var|kbd|tt|em)(?:\s[^>]*)?>(.*?)</\1>')

# 1 tag multiset
$tO = @($tagRe.Matches($orig) | ForEach-Object { $_.Value } | Sort-Object)
$tN = @($tagRe.Matches($new)  | ForEach-Object { $_.Value } | Sort-Object)
Write-Host "`n[1] TAG MULTISET orig=$($tO.Count) zh=$($tN.Count)"
$c1 = Compare-Object $tO $tN
if (-not $c1) { Write-Host "    OK identical" } else { Write-Host "    MISMATCH ($($c1.Count)):"; $c1 | Select-Object -First 25 | ForEach-Object { Write-Host "      $($_.SideIndicator) $($_.InputObject)" } }

# 2 inline code-like element content
$iO = @($inlRe.Matches($orig) | ForEach-Object { $_.Groups[1].Value + '|' + ($_.Groups[2].Value -replace '\s+',' ').Trim() } | Sort-Object)
$iN = @($inlRe.Matches($new)  | ForEach-Object { $_.Groups[1].Value + '|' + ($_.Groups[2].Value -replace '\s+',' ').Trim() } | Sort-Object)
Write-Host "`n[2] INLINE ELEMENTS orig=$($iO.Count) zh=$($iN.Count)"
$c2 = Compare-Object $iO $iN
if (-not $c2) { Write-Host "    OK identical" } else { Write-Host "    DIFFS=$($c2.Count):"; $c2 | Select-Object -First 25 | ForEach-Object { Write-Host "      $($_.SideIndicator) $($_.InputObject)" } }

# 3 pre blocks
$pO = @($preRe.Matches($orig) | ForEach-Object { ($_.Value -replace '\s+',' ').Trim() })
$pN = @($preRe.Matches($new)  | ForEach-Object { ($_.Value -replace '\s+',' ').Trim() })
Write-Host "`n[3] PRE BLOCKS orig=$($pO.Count) zh=$($pN.Count)"
$pd = 0
for ($i = 0; $i -lt [Math]::Max($pO.Count, $pN.Count); $i++) {
    $a = if ($i -lt $pO.Count) { $pO[$i] } else { '<MISSING>' }
    $b = if ($i -lt $pN.Count) { $pN[$i] } else { '<MISSING>' }
    if ($a -ne $b) { $pd++; if ($pd -le 5) { Write-Host "    PRE #$i MISMATCH"; Write-Host "      O: $($a.Substring(0,[Math]::Min(140,$a.Length)))"; Write-Host "      Z: $($b.Substring(0,[Math]::Min(140,$b.Length)))" } }
}
if ($pd -eq 0) { Write-Host "    OK all identical" } else { Write-Host "    total pre mismatches: $pd" }

# 4 leftover English in prose
$probe = $preRe.Replace($new, ' ')
$probe = [regex]::new('(?s)<(code|samp|var|kbd|tt|em|a)(?:\s[^>]*)?>.*?</\1>').Replace($probe, ' ')
$probe = $tagRe.Replace($probe, "`n")
$hits = @()
foreach ($l in ($probe -split "`n")) {
    $s = [System.Net.WebUtility]::HtmlDecode($l).Trim()
    if ($s -match '[A-Za-z]{2,}(\s+[A-Za-z][A-Za-z.,:;()/''-]*){1,}') { $hits += $s }
}
Write-Host "`n[4] ENGLISH LEFTOVER lines: $($hits.Count)"
$hits | Select-Object -First 30 | ForEach-Object { Write-Host "    | $_" }

# 5 links and anchors
$hO = @([regex]::new('<a\s[^>]*href="([^"]*)"').Matches($orig) | ForEach-Object { $_.Groups[1].Value })
$hN = @([regex]::new('<a\s[^>]*href="([^"]*)"').Matches($new)  | ForEach-Object { $_.Groups[1].Value })
Write-Host "`n[5a] href seq identical: $(-not (Compare-Object $hO $hN)) (n=$($hO.Count))"
$nO = @([regex]::new('(?:id|name)="([^"]*)"').Matches($orig) | ForEach-Object { $_.Groups[1].Value })
$nN = @([regex]::new('(?:id|name)="([^"]*)"').Matches($new)  | ForEach-Object { $_.Groups[1].Value })
Write-Host "[5b] id/name seq identical: $(-not (Compare-Object $nO $nN)) (n=$($nO.Count))"

# 6 heading count + untranslated headings
$hRe = [regex]::new('(?s)<h([2-5])[^>]*>\s*([^<]*?)\s*<span class="pull-right">')
$hdO = @($hRe.Matches($orig) | ForEach-Object { $_.Groups[2].Value })
$hdN = @($hRe.Matches($new)  | ForEach-Object { $_.Groups[2].Value })
Write-Host "`n[6] HEADINGS orig=$($hdO.Count) zh=$($hdN.Count)"
$untrans = 0
for ($i = 0; $i -lt [Math]::Min($hdO.Count, $hdN.Count); $i++) {
    $o = $hdO[$i]; $z = $hdN[$i]
    # only flag heads that still contain a multi-word English phrase (identifier-only
    # headings such as "2.1 aac_adtstoasc" are correctly left in English)
    $oNoNum = $o -replace '^[0-9][0-9.]*\s*', ''
    $isNameOnly = $oNoNum -notmatch '\s'
    if (-not $isNameOnly -and $o -match '[A-Za-z]' -and $z -notmatch '[\u4e00-\u9fff]') {
        $untrans++
        if ($untrans -le 15) { Write-Host "    NOT TRANSLATED: $o" }
    }
}
if ($untrans -eq 0) { Write-Host "    OK no untranslated headings" } else { Write-Host "    untranslated headings: $untrans" }

# 7 TOC vs heading consistency (reported only; fixing is a separate step)
$map = @{}
$hnRe = [regex]::new('(?s)<a name="([^"]+)"></a>\s*<h([2-5])[^>]*>\s*([^<]*?)\s*<span class="pull-right">')
foreach ($m in $hnRe.Matches($new)) { $map[$m.Groups[1].Value] = $m.Groups[3].Value }
$aRe = [regex]::new('(?s)<a id="toc-[^"]*" href="#([^"]+)">(.*?)</a>')
$mismatch = 0
foreach ($m in $aRe.Matches($new)) {
    $anchor = $m.Groups[1].Value; $txt = $m.Groups[2].Value
    if ($map.ContainsKey($anchor) -and $map[$anchor] -ne $txt) {
        $mismatch++
        if ($mismatch -le 10) { Write-Host "    TOC '$txt'  vs  HEADING '$($map[$anchor])'  (#$anchor)" }
    }
}
Write-Host "`n[7] TOC vs HEADING mismatches: $mismatch  (anchors mapped: $($map.Count))"

# 8b English prose left inside <samp>/<code> wrappers (upstream markup quirk)
$proseRe = [regex]::new('(?s)<(samp|code)(?:\s[^>]*)?>([^<]*)</\1>')
$proseHits = @()
foreach ($m in $proseRe.Matches($new)) {
    $t = $m.Groups[2].Value
    if ($t -match '[A-Za-z]{2,}\s+[A-Za-z]{2,}\s+[A-Za-z]{2,}' -and $t -notmatch '[\u4e00-\u9fff]') { $proseHits += $t }
}
Write-Host "`n[9] ENGLISH PROSE INSIDE samp/code: $($proseHits.Count)"
$proseHits | Select-Object -First 20 | ForEach-Object { Write-Host "    | $_" }

# 8 structure
Write-Host "`n[8] STRUCTURE"
Write-Host "    orig tail: $($orig.Substring($orig.Length-25) -replace "`r?`n", ' / ')"
Write-Host "    zh   tail: $($new.Substring($new.Length-25) -replace "`r?`n", ' / ')"
Write-Host "    bytes=$((Get-Item $zhPath).Length)  BOM=$(([System.IO.File]::ReadAllBytes($zhPath))[0] -eq 0xEF)"
