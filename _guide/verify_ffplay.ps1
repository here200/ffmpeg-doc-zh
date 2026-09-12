# ffplay 翻译校验：拼接 -> 标签多重集 -> 内联元素内容 -> <pre> 块 -> 残留英文 -> 标题
$ErrorActionPreference = 'Stop'
$root = 'D:\Change\WorkspaceInDeepSeek\Translation'
$origPath = Join-Path $root 'ffplay.html'
$partDir  = Join-Path $root '_parts'
$zhPath   = Join-Path $root 'ffplay-zh.html'

$files = 1..6 | ForEach-Object { Join-Path $partDir ('p{0:D2}.html' -f $_) }
$missing = $files | Where-Object { -not (Test-Path $_) }
if ($missing) { Write-Host "MISSING PARTS:"; $missing | ForEach-Object { Write-Host "  $_" }; exit 1 }

$sb = New-Object System.Text.StringBuilder
foreach ($f in $files) { [void]$sb.Append((Get-Content -Raw -Encoding UTF8 $f)) }
[System.IO.File]::WriteAllText($zhPath, $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))
Write-Host "WROTE $zhPath"

$orig = [System.IO.File]::ReadAllText($origPath)
$new  = [System.IO.File]::ReadAllText($zhPath)

$tagRe = [regex]::new('<[^>]*>')
$preRe = [regex]::new('(?s)<pre[^>]*>.*?</pre>')
$inlRe = [regex]::new('(?s)<(code|samp|var|kbd|tt|em)(?:\s[^>]*)?>(.*?)</\1>')

# ---- 1. 标签多重集 ----
$tO = @($tagRe.Matches($orig) | ForEach-Object { $_.Value } | Sort-Object)
$tN = @($tagRe.Matches($new)  | ForEach-Object { $_.Value } | Sort-Object)
Write-Host "`n[1] TAG MULTISET  orig=$($tO.Count) zh=$($tN.Count)"
$c1 = Compare-Object $tO $tN
if (-not $c1) { Write-Host "    OK identical" } else { Write-Host "    MISMATCH:"; $c1 | Select-Object -First 40 | ForEach-Object { Write-Host "      $($_.SideIndicator) $($_.InputObject)" } }

# ---- 2. 代码类内联元素内容 ----
$iO = @($inlRe.Matches($orig) | ForEach-Object { $_.Groups[1].Value + '|' + ($_.Groups[2].Value -replace '\s+',' ').Trim() } | Sort-Object)
$iN = @($inlRe.Matches($new)  | ForEach-Object { $_.Groups[1].Value + '|' + ($_.Groups[2].Value -replace '\s+',' ').Trim() } | Sort-Object)
Write-Host "`n[2] INLINE code/samp/var/kbd/em CONTENT  orig=$($iO.Count) zh=$($iN.Count)"
$c2 = Compare-Object $iO $iN
if (-not $c2) { Write-Host "    OK identical" } else { Write-Host "    DIFFS=$($c2.Count):"; $c2 | Select-Object -First 40 | ForEach-Object { Write-Host "      $($_.SideIndicator) $($_.InputObject)" } }

# ---- 3. <pre> 块 ----
$pO = @($preRe.Matches($orig) | ForEach-Object { ($_.Value -replace '\s+',' ').Trim() })
$pN = @($preRe.Matches($new)  | ForEach-Object { ($_.Value -replace '\s+',' ').Trim() })
Write-Host "`n[3] PRE BLOCKS  orig=$($pO.Count) zh=$($pN.Count)"
$pd = 0
for ($i = 0; $i -lt [Math]::Max($pO.Count, $pN.Count); $i++) {
    $a = if ($i -lt $pO.Count) { $pO[$i] } else { '<MISSING>' }
    $b = if ($i -lt $pN.Count) { $pN[$i] } else { '<MISSING>' }
    if ($a -ne $b) { $pd++; Write-Host "    PRE #$i MISMATCH"; Write-Host "      ORIG: $($a.Substring(0,[Math]::Min(150,$a.Length)))"; Write-Host "      ZH  : $($b.Substring(0,[Math]::Min(150,$b.Length)))" }
}
if ($pd -eq 0) { Write-Host "    OK all identical" }

# ---- 4. 残留英文（段落级） ----
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

# ---- 5. 链接/锚点/标题 ----
$hO = @([regex]::new('<a\s[^>]*href="([^"]*)"').Matches($orig) | ForEach-Object { $_.Groups[1].Value })
$hN = @([regex]::new('<a\s[^>]*href="([^"]*)"').Matches($new)  | ForEach-Object { $_.Groups[1].Value })
Write-Host "`n[5a] href sequence identical: $(-not (Compare-Object $hO $hN)) (orig=$($hO.Count))"
$nO = @([regex]::new('(?:id|name)="([^"]*)"').Matches($orig) | ForEach-Object { $_.Groups[1].Value })
$nN = @([regex]::new('(?:id|name)="([^"]*)"').Matches($new)  | ForEach-Object { $_.Groups[1].Value })
Write-Host "[5b] id/name sequence identical: $(-not (Compare-Object $nO $nN)) (orig=$($nO.Count))"

$hRe = [regex]::new('(?s)<h([1-4])[^>]*>\s*([^<]*?)\s*<span class="pull-right">')
$tO = @($hRe.Matches($orig) | ForEach-Object { $_.Groups[2].Value })
$tN = @($hRe.Matches($new)  | ForEach-Object { $_.Groups[2].Value })
Write-Host "`n[6] HEADINGS orig=$($tO.Count) zh=$($tN.Count)"
for ($i = 0; $i -lt $tO.Count; $i++) { Write-Host ("    {0,-40} => {1}" -f $tO[$i], $tN[$i]) }

# ---- 7. 结构 ----
Write-Host "`n[7] STRUCTURE"
Write-Host "    orig tail: $($orig.Substring($orig.Length-30) -replace "`r?`n", ' / ')"
Write-Host "    zh   tail: $($new.Substring($new.Length-30) -replace "`r?`n", ' / ')"
Write-Host "    orig head: $($orig.Substring(0,60) -replace "`r?`n", ' / ')"
Write-Host "    zh   head: $($new.Substring(0,60) -replace "`r?`n", ' / ')"
