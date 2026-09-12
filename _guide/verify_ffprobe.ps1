# ffprobe translation verification (ASCII-only source: PS 5.1 mis-decodes UTF-8 no-BOM scripts)
$ErrorActionPreference = 'Stop'
$root = 'D:\Change\WorkspaceInDeepSeek\Translation'
$origPath = Join-Path $root 'ffprobe.html'
$partDir  = Join-Path $root '_parts'
$zhPath   = Join-Path $root 'ffprobe-zh.html'

$files = 1..7 | ForEach-Object { Join-Path $partDir ('q{0:D2}.html' -f $_) }
$missing = $files | Where-Object { -not (Test-Path $_) }
if ($missing) { Write-Host "MISSING PARTS:"; $missing | ForEach-Object { Write-Host "  $_" }; exit 1 }

$sb = New-Object System.Text.StringBuilder
foreach ($f in $files) { [void]$sb.Append((Get-Content -Raw -Encoding UTF8 $f)) }
[System.IO.File]::WriteAllText($zhPath, $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))
Write-Host "WROTE $zhPath"

$orig = [System.IO.File]::ReadAllText($origPath)
$new  = [System.IO.File]::ReadAllText($zhPath)
if ($orig.Length -eq 0) { Write-Host "ERROR: empty source read"; exit 1 }

$tagRe = [regex]::new('<[^>]*>')
$preRe = [regex]::new('(?s)<pre[^>]*>.*?</pre>')
$inlRe = [regex]::new('(?s)<(code|samp|var|kbd|tt|em)(?:\s[^>]*)?>(.*?)</\1>')

# --- 1. tag multiset ---
$tO = @($tagRe.Matches($orig) | ForEach-Object { $_.Value } | Sort-Object)
$tN = @($tagRe.Matches($new)  | ForEach-Object { $_.Value } | Sort-Object)
Write-Host "`n[1] TAG MULTISET  orig=$($tO.Count) zh=$($tN.Count)"
$c1 = Compare-Object $tO $tN
if (-not $c1) { Write-Host "    OK identical" } else { Write-Host "    MISMATCH:"; $c1 | Select-Object -First 40 | ForEach-Object { Write-Host "      $($_.SideIndicator) $($_.InputObject)" } }

# --- 2. code-like inline element content ---
$iO = @($inlRe.Matches($orig) | ForEach-Object { $_.Groups[1].Value + '|' + ($_.Groups[2].Value -replace '\s+',' ').Trim() } | Sort-Object)
$iN = @($inlRe.Matches($new)  | ForEach-Object { $_.Groups[1].Value + '|' + ($_.Groups[2].Value -replace '\s+',' ').Trim() } | Sort-Object)
Write-Host "`n[2] INLINE code/samp/var/kbd/em CONTENT  orig=$($iO.Count) zh=$($iN.Count)"
$c2 = Compare-Object $iO $iN
if (-not $c2) { Write-Host "    OK identical" } else { Write-Host "    DIFFS=$($c2.Count):"; $c2 | Select-Object -First 40 | ForEach-Object { Write-Host "      $($_.SideIndicator) $($_.InputObject)" } }

# --- 3. pre blocks ---
$pO = @($preRe.Matches($orig) | ForEach-Object { ($_.Value -replace '\s+',' ').Trim() })
$pN = @($preRe.Matches($new)  | ForEach-Object { ($_.Value -replace '\s+',' ').Trim() })
Write-Host "`n[3] PRE BLOCKS  orig=$($pO.Count) zh=$($pN.Count)"
$pd = 0
for ($i = 0; $i -lt [Math]::Max($pO.Count, $pN.Count); $i++) {
    $a = if ($i -lt $pO.Count) { $pO[$i] } else { '<MISSING>' }
    $b = if ($i -lt $pN.Count) { $pN[$i] } else { '<MISSING>' }
    if ($a -ne $b) { $pd++; Write-Host "    PRE #$i MISMATCH"; Write-Host "      ORIG: $($a.Substring(0,[Math]::Min(160,$a.Length)))"; Write-Host "      ZH  : $($b.Substring(0,[Math]::Min(160,$b.Length)))" }
}
if ($pd -eq 0) { Write-Host "    OK all identical" }

# --- 4. leftover English in prose ---
$probe = $preRe.Replace($new, ' ')
$probe = [regex]::new('(?s)<(code|samp|var|kbd|tt|em|a)(?:\s[^>]*)?>.*?</\1>').Replace($probe, ' ')
$probe = $tagRe.Replace($probe, "`n")
$hits = @()
foreach ($l in ($probe -split "`n")) {
    $s = [System.Net.WebUtility]::HtmlDecode($l).Trim()
    if ($s -match '[A-Za-z]{2,}(\s+[A-Za-z][A-Za-z.,:;()/''-]*){1,}') { $hits += $s }
}
Write-Host "`n[4] ENGLISH LEFTOVER lines: $($hits.Count)"
$hits | ForEach-Object { Write-Host "    | $_" }

# --- 5. links and anchors ---
$hO = @([regex]::new('<a\s[^>]*href="([^"]*)"').Matches($orig) | ForEach-Object { $_.Groups[1].Value })
$hN = @([regex]::new('<a\s[^>]*href="([^"]*)"').Matches($new)  | ForEach-Object { $_.Groups[1].Value })
Write-Host "`n[5a] href sequence identical: $(-not (Compare-Object $hO $hN)) (orig=$($hO.Count))"
$nO = @([regex]::new('(?:id|name)="([^"]*)"').Matches($orig) | ForEach-Object { $_.Groups[1].Value })
$nN = @([regex]::new('(?:id|name)="([^"]*)"').Matches($new)  | ForEach-Object { $_.Groups[1].Value })
Write-Host "[5b] id/name sequence identical: $(-not (Compare-Object $nO $nN)) (orig=$($nO.Count))"

# --- 6. headings ---
$hRe = [regex]::new('(?s)<h([1-4])[^>]*>\s*([^<]*?)\s*<span class="pull-right">')
$tO = @($hRe.Matches($orig) | ForEach-Object { $_.Groups[2].Value })
$tN = @($hRe.Matches($new)  | ForEach-Object { $_.Groups[2].Value })
Write-Host "`n[6] HEADINGS orig=$($tO.Count) zh=$($tN.Count)"
for ($i = 0; $i -lt $tO.Count; $i++) { Write-Host ("    {0,-34} => {1}" -f $tO[$i], $tN[$i]) }

# --- 7. TOC entries ---
$aRe = [regex]::new('(?s)<a id="toc-[^"]*" href="[^"]*">(.*?)</a>')
$cO = @($aRe.Matches($orig) | ForEach-Object { $_.Groups[1].Value })
$cN = @($aRe.Matches($new)  | ForEach-Object { $_.Groups[1].Value })
Write-Host "`n[7] TOC ENTRIES orig=$($cO.Count) zh=$($cN.Count)"
for ($i = 0; $i -lt $cO.Count; $i++) { Write-Host ("    {0,-34} => {1}" -f $cO[$i], $cN[$i]) }

# --- 8. structure ---
Write-Host "`n[8] STRUCTURE"
Write-Host "    orig tail: $($orig.Substring($orig.Length-30) -replace "`r?`n", ' / ')"
Write-Host "    zh   tail: $($new.Substring($new.Length-30) -replace "`r?`n", ' / ')"
Write-Host "    orig title: $(([regex]::new('(?s)<title>\s*(.*?)\s*</title>').Match($orig)).Groups[1].Value)"
Write-Host "    zh   title: $(([regex]::new('(?s)<title>\s*(.*?)\s*</title>').Match($new)).Groups[1].Value)"
Write-Host "    zh bytes=$((Get-Item $zhPath).Length)  BOM=$(([System.IO.File]::ReadAllBytes($zhPath))[0] -eq 0xEF)"
