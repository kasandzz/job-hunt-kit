# make-cv-files.ps1 - turns one CV note into a Word file (.docx) and a PDF next to it, so the person can attach
# their CV on a job site (Indeed, OCC, Computrabajo, CV.lt...). No new programs: the Word file is built here, and
# the PDF is printed by Microsoft Edge (on every Windows 10 and 11 PC) in hidden mode, or Chrome if Edge is missing.
# Usage (from the notebook folder): powershell -NoProfile -ExecutionPolicy Bypass -File playbook/tools/make-cv-files.ps1 -Note "05-Jobs/cv-base.md"
# Output lines: "docx: <path>" and "pdf: <path>" (or "pdf: none"). Exit 0 = both, 4 = Word file only, 2 = bad note.
# The note must be a .md file inside the notebook's jobs folder. ASCII only.
param([string]$Note)
$ErrorActionPreference = 'Stop'
$enc = New-Object Text.UTF8Encoding $false
$root = [IO.Path]::GetFullPath((Split-Path -Parent (Split-Path -Parent $PSScriptRoot))).TrimEnd([char]92)
function Fail($why) { [Console]::Error.WriteLine("make-cv-files: $why"); exit 2 }

# 1. The note: a .md file in a jobs folder of this notebook (the "jobs" row of a language profile).
if (-not $Note -or $Note -notmatch '(?i)\.md$') { Fail 'give -Note "<jobs folder>/<cv note>.md"' }
$full = [IO.Path]::GetFullPath((Join-Path $root $Note))
if (-not $full.StartsWith($root + [char]92, [StringComparison]::OrdinalIgnoreCase)) { Fail 'the note is outside the notebook' }
$rel = $full.Substring($root.Length + 1)
$jobs = @()
foreach ($lf in @(Get-ChildItem -LiteralPath (Join-Path $root 'playbook\profiles') -Filter 'language-*.md' -File -ErrorAction SilentlyContinue)) {
  $m = [regex]::Match([IO.File]::ReadAllText($lf.FullName), '(?m)^\|\s*jobs\s*\|\s*([A-Za-z0-9-]{1,40})\s*\|')
  if ($m.Success) { $jobs += $m.Groups[1].Value }
}
$first = $rel.Split([char]92)[0]
if (-not ($jobs | Where-Object { $_ -ieq $first })) { Fail 'the note is not in the jobs folder' }
if (-not (Test-Path -LiteralPath $full -PathType Leaf)) { Fail 'the note does not exist' }
$item = Get-Item -LiteralPath $full -Force
if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) { Fail 'the note is a link' }

# 2. Read it: drop the top block (between --- lines) and comments; keep headings, bullets and paragraphs.
$text = [IO.File]::ReadAllText($full, $enc).Replace("`r`n", "`n")
$text = $text.TrimStart([char]0xFEFF)   # never StartsWith here: it ignores U+FEFF and would cut the first letter
$text = [regex]::Replace($text, '\A---\n[\s\S]*?\n---\n', '')
$text = [regex]::Replace($text, '<!--[\s\S]*?-->', '')
function Clean([string]$s) {
  $s = [regex]::Replace($s, '\[\[([^\]|]+)\|([^\]]+)\]\]', '$2')
  $s = [regex]::Replace($s, '\[\[([^\]]+)\]\]', '$1')
  $s = [regex]::Replace($s, '!?\[([^\]]*)\]\(([^)]*)\)', '$1')
  return $s.Trim()
}
$blocks = New-Object System.Collections.ArrayList   # each: kind (h1 h2 h3 li p), text
$para = ''
foreach ($line in $text.Split("`n")) {
  $t = $line.TrimEnd()
  if ($t -match '^\s*$') { if ($para) { [void]$blocks.Add(@('p', $para)); $para = '' }; continue }
  if ($t -match '^(#{1,3})\s+(.*)$') { if ($para) { [void]$blocks.Add(@('p', $para)); $para = '' }; [void]$blocks.Add(@(('h' + $matches[1].Length), (Clean $matches[2]))); continue }
  if ($t -match '^#{4,6}\s+(.*)$') { if ($para) { [void]$blocks.Add(@('p', $para)); $para = '' }; [void]$blocks.Add(@('h3', (Clean $matches[1]))); continue }
  if ($t -match '^\s*[-*+]\s+(?:\[[ xX]\]\s+)?(.*)$') { if ($para) { [void]$blocks.Add(@('p', $para)); $para = '' }; [void]$blocks.Add(@('li', (Clean $matches[1]))); continue }
  if ($t -match '^\s*(?:---|\*\*\*|___)\s*$') { if ($para) { [void]$blocks.Add(@('p', $para)); $para = '' }; continue }
  if ($t -match '^\s*\|') { $t = (($t.Trim().Trim('|').Split('|') | ForEach-Object { $_.Trim() }) | Where-Object { $_ -and $_ -notmatch '^:?-{2,}:?$' }) -join '  -  '; if (-not $t) { continue } }
  $para = if ($para) { $para + ' ' + (Clean $t) } else { Clean $t }
}
if ($para) { [void]$blocks.Add(@('p', $para)) }
if ($blocks.Count -eq 0) { Fail 'the note is empty' }

# Inline **bold** and *italic*, split into runs: each run is @(text, bold, italic).
function Get-Runs([string]$s) {
  $runs = @()
  foreach ($m in [regex]::Matches($s, '\*\*(.+?)\*\*|__(.+?)__|\*(.+?)\*|([^*_]+|[*_])')) {
    if ($m.Groups[1].Success) { $runs += , @($m.Groups[1].Value, $true, $false) }
    elseif ($m.Groups[2].Success) { $runs += , @($m.Groups[2].Value, $true, $false) }
    elseif ($m.Groups[3].Success) { $runs += , @($m.Groups[3].Value, $false, $true) }
    else { $runs += , @($m.Groups[4].Value, $false, $false) }
  }
  return , $runs
}
function Enc-Xml([string]$s) { return [Security.SecurityElement]::Escape($s) }
function Enc-Html([string]$s) { return [Net.WebUtility]::HtmlEncode($s) }

# 3. The Word file: a plain .docx built by hand (a zip of a few XML files), Arial, A4, simple headings and bullets.
$body = New-Object Text.StringBuilder
foreach ($b in $blocks) {
  $kind = $b[0]; $size = switch ($kind) { 'h1' { 36 } 'h2' { 28 } 'h3' { 24 } default { 22 } }
  $ppr = switch ($kind) { 'h1' { '<w:pPr><w:spacing w:before="0" w:after="120"/></w:pPr>' } 'h2' { '<w:pPr><w:spacing w:before="240" w:after="80"/><w:pBdr><w:bottom w:val="single" w:sz="4" w:space="1" w:color="999999"/></w:pBdr></w:pPr>' } 'h3' { '<w:pPr><w:spacing w:before="160" w:after="40"/></w:pPr>' } 'li' { '<w:pPr><w:spacing w:after="40"/><w:ind w:left="360" w:hanging="220"/></w:pPr>' } default { '<w:pPr><w:spacing w:after="120"/></w:pPr>' } }
  [void]$body.Append('<w:p>' + $ppr)
  if ($kind -eq 'li') { [void]$body.Append('<w:r><w:rPr><w:sz w:val="22"/></w:rPr><w:t xml:space="preserve">' + [char]0x2022 + ' </w:t></w:r>') }
  foreach ($r in (Get-Runs $b[1])) {
    $rpr = '<w:rPr>' + $(if ($r[1] -or $kind -match '^h') { '<w:b/>' } else { '' }) + $(if ($r[2]) { '<w:i/>' } else { '' }) + '<w:sz w:val="' + $size + '"/></w:rPr>'
    [void]$body.Append('<w:r>' + $rpr + '<w:t xml:space="preserve">' + (Enc-Xml $r[0]) + '</w:t></w:r>')
  }
  [void]$body.Append('</w:p>')
}
$W = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'
$docXml = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><w:document xmlns:w="' + $W + '"><w:body>' + $body.ToString() +
  '<w:sectPr><w:pgSz w:w="11906" w:h="16838"/><w:pgMar w:top="1134" w:right="1134" w:bottom="1134" w:left="1134" w:header="708" w:footer="708" w:gutter="0"/></w:sectPr></w:body></w:document>'
$stylesXml = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><w:styles xmlns:w="' + $W + '"><w:docDefaults><w:rPrDefault><w:rPr><w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:eastAsia="Arial" w:cs="Arial"/><w:sz w:val="22"/></w:rPr></w:rPrDefault><w:pPrDefault><w:pPr><w:spacing w:after="80" w:line="264" w:lineRule="auto"/></w:pPr></w:pPrDefault></w:docDefaults><w:style w:type="paragraph" w:default="1" w:styleId="Normal"><w:name w:val="Normal"/></w:style></w:styles>'
$typesXml = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/><Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/><Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/></Types>'
$relsXml = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/></Relationships>'
$docRelsXml = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/></Relationships>'
$base = $full.Substring(0, $full.Length - 3)
$docx = $base + '.docx'; $pdf = $base + '.pdf'
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$tmpDocx = $docx + '.tmp'
if (Test-Path -LiteralPath $tmpDocx) { Remove-Item -LiteralPath $tmpDocx -Force }
$zip = [IO.Compression.ZipFile]::Open($tmpDocx, [IO.Compression.ZipArchiveMode]::Create)
try {
  foreach ($part in @(@('[Content_Types].xml', $typesXml), @('_rels/.rels', $relsXml), @('word/document.xml', $docXml), @('word/_rels/document.xml.rels', $docRelsXml), @('word/styles.xml', $stylesXml))) {
    $e = $zip.CreateEntry($part[0]); $s = $e.Open(); $bytes = $enc.GetBytes($part[1]); $s.Write($bytes, 0, $bytes.Length); $s.Close()
  }
} finally { $zip.Dispose() }
Move-Item -LiteralPath $tmpDocx -Destination $docx -Force
Write-Output ('docx: ' + $docx.Substring($root.Length + 1))

# 4. The PDF: the same CV as a simple web page, printed to PDF by Edge (or Chrome) with no window.
$html = New-Object Text.StringBuilder
[void]$html.Append('<!DOCTYPE html><html><head><meta charset="utf-8"><style>@page{size:A4;margin:20mm}body{font-family:Arial,Helvetica,sans-serif;font-size:11pt;line-height:1.35;color:#111}h1{font-size:18pt;margin:0 0 6pt}h2{font-size:14pt;margin:14pt 0 4pt;border-bottom:1px solid #999}h3{font-size:12pt;margin:10pt 0 2pt}p{margin:0 0 6pt}ul{margin:0 0 6pt;padding-left:16pt}li{margin:0 0 2pt}</style></head><body>')
$inList = $false
foreach ($b in $blocks) {
  if ($b[0] -eq 'li' -and -not $inList) { [void]$html.Append('<ul>'); $inList = $true }
  if ($b[0] -ne 'li' -and $inList) { [void]$html.Append('</ul>'); $inList = $false }
  $inner = ''
  foreach ($r in (Get-Runs $b[1])) { $t = Enc-Html $r[0]; if ($r[1]) { $t = '<b>' + $t + '</b>' }; if ($r[2]) { $t = '<i>' + $t + '</i>' }; $inner += $t }
  $tag = if ($b[0] -eq 'li') { 'li' } elseif ($b[0] -eq 'p') { 'p' } else { $b[0] }
  [void]$html.Append("<$tag>$inner</$tag>")
}
if ($inList) { [void]$html.Append('</ul>') }
[void]$html.Append('</body></html>')
$browser = @(
  (Join-Path ${env:ProgramFiles(x86)} 'Microsoft\Edge\Application\msedge.exe'),
  (Join-Path $env:ProgramFiles 'Microsoft\Edge\Application\msedge.exe'),
  (Join-Path $env:ProgramFiles 'Google\Chrome\Application\chrome.exe'),
  (Join-Path ${env:ProgramFiles(x86)} 'Google\Chrome\Application\chrome.exe'),
  (Join-Path $env:LOCALAPPDATA 'Google\Chrome\Application\chrome.exe')
) | Where-Object { $_ -and (Test-Path -LiteralPath $_) } | Select-Object -First 1
$ok = $false
if ($browser) {
  $wd = Join-Path ([IO.Path]::GetTempPath()) ('pol-cv-' + [guid]::NewGuid().ToString('N').Substring(0, 12))
  New-Item -ItemType Directory -Force $wd | Out-Null
  $page = Join-Path $wd 'cv.html'; [IO.File]::WriteAllText($page, $html.ToString(), $enc)
  $outPdf = Join-Path $wd 'cv.pdf'
  $argList = @('--headless=new', '--disable-gpu', '--no-first-run', '--no-default-browser-check', '--disable-extensions', ('--user-data-dir="' + (Join-Path $wd 'profile') + '"'),
    '--no-pdf-header-footer', ('--print-to-pdf="' + $outPdf + '"'), ('"' + ([Uri]$page).AbsoluteUri + '"'))
  try {
    $p = Start-Process -FilePath $browser -ArgumentList $argList -WindowStyle Hidden -PassThru
    if (-not $p.WaitForExit(90000)) { try { $p.Kill() } catch { } }
    for ($i = 0; $i -lt 20 -and -not (Test-Path -LiteralPath $outPdf); $i++) { Start-Sleep -Milliseconds 250 }
    if ((Test-Path -LiteralPath $outPdf) -and (Get-Item -LiteralPath $outPdf).Length -gt 800) {
      Copy-Item -LiteralPath $outPdf -Destination $pdf -Force; $ok = $true
    }
  } catch { $ok = $false }
  try { Remove-Item -LiteralPath $wd -Recurse -Force -ErrorAction SilentlyContinue } catch { }
}
if ($ok) { Write-Output ('pdf: ' + $pdf.Substring($root.Length + 1)); exit 0 }
Write-Output 'pdf: none'
exit 4
