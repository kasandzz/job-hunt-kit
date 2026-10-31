# write-guard.ps1 - PreToolUse on Write / Edit / MultiEdit / NotebookEdit. Fails closed.
# Windows paths ignore case, so deny globs in settings.json can be dodged (_Templates, .Obsidian, ..\ tricks).
# This hook resolves the real target (full path, .., links and junctions) and, ignoring case, allows only:
# notes and data of a few known types inside the notebook, never .obsidian, never .claude (bar helper notes), never
# the tools, hooks, .git or any template an add-on reads, never outside the notebook. Anything it cannot check blocks.
# The deny rules in settings.json stay as a second layer. ASCII only.
$ErrorActionPreference = 'Stop'
$script:Msg = 'Blocked: that file is part of how the notebook runs safely, so it is never written by Claude. Do not try another way or another path. Tell the person in plain words what you wanted to change, and carry on without it.'
function Block($why) { [Console]::Error.WriteLine("$script:Msg ($why)"); exit 2 }

# One full path with every link and junction on the way replaced by its target.
function Resolve-Real([string]$p, [int]$depth) {
  if ($depth -gt 16) { throw 'too many links' }
  $full = [IO.Path]::GetFullPath($p).TrimEnd([char]92)
  if ($full.Length -lt 3) { return $full }
  $parts = $full.Substring(3).Split([char]92)
  $cur = $full.Substring(0, 3)
  for ($i = 0; $i -lt $parts.Count; $i++) {
    if ($parts[$i] -eq '') { continue }
    $next = Join-Path $cur $parts[$i]
    if (-not (Test-Path -LiteralPath $next)) {
      $rest = ($parts[$i..($parts.Count - 1)] -join [string][char]92)
      return (Join-Path $cur $rest)
    }
    $item = Get-Item -LiteralPath $next -Force
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
      $t = @($item.Target) | Where-Object { $_ } | Select-Object -First 1
      if (-not $t) { throw 'unreadable link' }
      if (-not [IO.Path]::IsPathRooted($t)) { $t = Join-Path $cur $t }
      $next = Resolve-Real $t ($depth + 1)
    } else { $next = $item.FullName }
    $cur = $next
  }
  return $cur.TrimEnd([char]92)
}

function Norm-Rel([string]$x) {
  $x = "$x".Replace([char]47, [char]92).Trim().Trim([char]92)
  return $x.ToLowerInvariant()
}

# Every template or script an add-on can read, from every Obsidian settings file, read fresh each time.
# Any value under a key with "template", "script" or "hotkey" in its name counts (Templater folders, pairs and
# hotkeys, Periodic Notes, core Templates and Daily notes, folder and file templates). Both the folder of the
# value and the value itself as a file (with and without .md) are protected. Unreadable settings block.
function Add-TemplateValues($node, [bool]$named, [string]$key, [int]$depth, [System.Collections.ArrayList]$acc) {
  if ($depth -gt 12 -or $null -eq $node) { return }
  if ($node -is [string]) { if ($named -and $node.Trim()) { [void]$acc.Add(@($node, $key)) }; return }
  if ($node -is [System.Collections.IEnumerable]) { foreach ($x in $node) { Add-TemplateValues $x $named $key ($depth + 1) $acc }; return }
  if ($node -is [psobject]) {
    foreach ($p in $node.PSObject.Properties) {
      if ($p.MemberType -ne 'NoteProperty') { continue }
      Add-TemplateValues $p.Value ($named -or ($p.Name -match '(?i)templat|script|hotkey')) $p.Name ($depth + 1) $acc
    }
  }
}
function Get-TemplateSpots([string]$root) {
  $acc = New-Object System.Collections.ArrayList
  [void]$acc.Add(@('_templates', 'folder')); [void]$acc.Add(@('playbook\templates', 'folder'))
  $od = Join-Path $root '.obsidian'
  $files = @()
  if (Test-Path -LiteralPath $od) {
    $files += @(Get-ChildItem -LiteralPath $od -Filter '*.json' -File -Force -ErrorAction Stop)
    $pl = Join-Path $od 'plugins'
    if (Test-Path -LiteralPath $pl) { $files += @(Get-ChildItem -LiteralPath $pl -Directory -Force -ErrorAction Stop | ForEach-Object { Get-ChildItem -LiteralPath $_.FullName -Filter 'data.json' -File -Force -ErrorAction Stop }) }
  }
  foreach ($f in $files) {
    try { $j = [IO.File]::ReadAllText($f.FullName) | ConvertFrom-Json } catch { Block "add-on settings unreadable: $($f.Name)" }
    Add-TemplateValues $j ($f.Name -match '(?i)templat') '' 0 $acc
  }
  $folders = @(); $filesOut = @()
  $rootC = [IO.Path]::GetFullPath($root).TrimEnd([char]92)
  foreach ($pair in $acc) {
    # Canonicalise each setting exactly like a target: joined to the notebook, full path, relative, lower case.
    # A setting that names the notebook itself, or anything outside it, blocks every write.
    $raw = "$($pair[0])".Trim()
    if ($raw -eq '' -or $raw -match '[<>|"?*]') { continue }
    try {
      $abs = if ([IO.Path]::IsPathRooted($raw)) { $raw } else { Join-Path $rootC $raw }
      $full = [IO.Path]::GetFullPath($abs).TrimEnd([char]92)
    } catch { Block 'an add-on template setting cannot be read' }
    if ($full -ieq $rootC) { Block 'an add-on template setting names the whole notebook' }
    if (-not $full.StartsWith($rootC + [char]92, [StringComparison]::OrdinalIgnoreCase)) { Block 'an add-on template setting points outside the notebook' }
    $n = Norm-Rel $full.Substring($rootC.Length + 1)
    if ($n -eq '') { continue }
    $folders += $n
    $filesOut += $n; if (-not $n.EndsWith('.md')) { $filesOut += ($n + '.md') }
    # A template FILE: its whole folder holds templates too. A FOLDER setting (or a value that is a folder) stops there,
    # so the playbook templates folder never protects all of playbook.
    $isFolder = ($pair[1] -match '(?i)folder|dir') -or (Test-Path -LiteralPath (Join-Path $root $n) -PathType Container)
    $parent = Split-Path -Parent $n
    if ($parent -and -not $isFolder) { $folders += $parent }
  }
  # The jobs folder of every kit language (the "jobs" row of playbook/profiles/language-*.md).
  $jobs = @()
  $pd = Join-Path $root 'playbook\profiles'
  if (Test-Path -LiteralPath $pd) {
    foreach ($lf in @(Get-ChildItem -LiteralPath $pd -Filter 'language-*.md' -File -ErrorAction Stop)) {
      $m = [regex]::Match([IO.File]::ReadAllText($lf.FullName), '(?m)^\|\s*jobs\s*\|\s*([A-Za-z0-9-]{1,40})\s*\|')
      if ($m.Success) { $jobs += $m.Groups[1].Value.ToLowerInvariant() }
    }
  }
  return @{ Folders = @($folders | Select-Object -Unique); Files = @($filesOut | Select-Object -Unique); Jobs = @($jobs | Select-Object -Unique) }
}

# Allowlist. $rel: lower case, backslashes, relative to the notebook. Returns why it may not be written, or $null.
function Get-Protected([string]$rel, $spots) {
  $segs = $rel.Split([char]92)
  $first = $segs[0]
  foreach ($s in $segs) { if ($s -eq '.git') { return '.git' } }
  if ($first -eq '.obsidian') { return '.obsidian' }
  if ($first -eq '.claude') {
    if ($segs.Count -eq 4 -and $segs[1] -eq 'skills' -and $segs[3] -eq 'skill.md') { return $null }
    return '.claude'
  }
  foreach ($d in @('playbook\tools', 'playbook\hooks') + $spots.Folders) {
    if ($rel -eq $d -or $rel.StartsWith($d + [char]92)) { return "folder $d" }
  }
  if ($spots.Files -contains $rel) { return 'a file an add-on reads as a template' }
  $leaf = $segs[-1]
  $ext = [IO.Path]::GetExtension($leaf)
  $dir = if ($segs.Count -gt 1) { ($segs[0..($segs.Count - 2)] -join [string][char]92) } else { '' }
  if ($leaf.StartsWith('.')) { return 'a hidden settings file' }
  if (@('.md', '.canvas', '.csv', '.txt', '.png', '.jpg', '.jpeg', '.gif', '.webp', '.pdf') -contains $ext) { return $null }
  # Data files only where the kit keeps them.
  if ($ext -eq '.json' -and @('playbook\state', '.planning') -contains $dir) { return $null }
  if ($ext -eq '.done' -and $dir -eq 'playbook\state' -and $leaf -match '^stage-[0-9]+\.done$') { return $null }
  # Word copies of a CV, to attach on job sites: only in the jobs folder of a kit language.
  if ($ext -eq '.docx' -and @($spots.Jobs) -contains $first -and $segs.Count -ge 2) { return $null }
  if ($ext -eq '') { return 'a file with no type' }
  return "file type $ext"
}

# More than one name for the same file (a hard link) could hide a protected file behind a note name.
function Test-HardLinked([string]$path) {
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { return $false }
  $out = & fsutil.exe hardlink list $path 2>$null
  if ($LASTEXITCODE -ne 0) { return $true }
  return (@($out | Where-Object { "$_".Trim() }).Count -gt 1)
}

# Characters that can end a line for some readers but not for this check. A helper note may hold none of them.
function Test-OddChars([string]$text) {
  for ($i = 0; $i -lt $text.Length; $i++) {
    $c = [int]$text[$i]
    if ($c -eq 9 -or $c -eq 10) { continue }
    if ($c -eq 13) { if ($i + 1 -lt $text.Length -and [int]$text[$i + 1] -eq 10) { continue }; return 'a lone carriage return' }
    if ($c -lt 32 -or $c -eq 127) { return "control character $c" }
    if ($c -eq 0x85 -or $c -eq 0x2028 -or $c -eq 0x2029) { return "line separator $c" }
    if ($c -eq 0xFEFF -and $i -gt 0) { return 'a byte-order mark inside the file' }
  }
  return $null
}

# One edit, the way the Edit tool does it: old text must be there (once, unless replace_all). Any doubt blocks.
function Apply-Edit([string]$text, $e, [bool]$exists) {
  # The Edit tool works on LF text, so compare the same way.
  $old = "$($e.old_string)".Replace("`r`n", "`n"); $new = "$($e.new_string)".Replace("`r`n", "`n")
  if ($old -eq '') {
    if (-not $exists -and $text -eq '') { return $new }
    Block 'helper edit with no old text'
  }
  $n = 0; $at = 0
  while (($at = $text.IndexOf($old, $at, [StringComparison]::Ordinal)) -ge 0) { $n++; $at += $old.Length }
  if ($n -eq 0) { Block 'helper edit text not found' }
  if ($e.replace_all -eq $true) { return $text.Replace($old, $new) }
  if ($n -gt 1) { Block 'helper edit text found more than once' }
  $i = $text.IndexOf($old, [StringComparison]::Ordinal)
  return $text.Substring(0, $i) + $new + $text.Substring($i + $old.Length)
}

# The whole file as it would be after this Write, Edit or MultiEdit.
function Get-FinalContent([string]$tool, $ti, [string]$path) {
  if ($tool -eq 'Write') { return "$($ti.content)" }
  $exists = Test-Path -LiteralPath $path -PathType Leaf
  $text = ''
  if ($exists) { $text = [IO.File]::ReadAllText($path, (New-Object Text.UTF8Encoding $false)).Replace("`r`n", "`n") }
  if ($tool -eq 'Edit') { return (Apply-Edit $text $ti $exists) }
  $edits = @($ti.edits)
  if ($edits.Count -eq 0) { Block 'helper edit with no edits' }
  foreach ($e in $edits) {
    if ($null -eq $e) { Block 'helper edit unreadable' }
    $text = Apply-Edit $text $e $exists
    $exists = $true
  }
  return $text
}

# A helper header may only hold name and description, each a plain line or a | / > block. Returns why not, or $null.
function Test-HelperHeader([string]$text) {
  $t = $text.TrimStart([char]0xFEFF)
  $lines = $t -split "`r?`n"
  $first = 0
  while ($first -lt $lines.Count -and $lines[$first].Trim() -eq '') { $first++ }
  if ($first -ge $lines.Count) { return $null }
  if ($lines[$first].TrimEnd() -ne '---') {
    if ($lines[$first].TrimStart().StartsWith('---')) { return 'odd first line' }
    if ($first -gt 0 -and $lines[$first].Trim().StartsWith('{')) { return 'flow header' }
    return $null
  }
  $block = $false
  for ($i = $first + 1; $i -lt $lines.Count; $i++) {
    $l = $lines[$i]
    if ($l.TrimEnd() -eq '---') { return $null }
    if ($l.Trim() -eq '...') { return 'document end mark' }
    if ($l.Trim() -eq '' -or $l.TrimStart().StartsWith('#')) { continue }
    if ($l -match '^[ \t]') {
      if ($block) { continue }
      return 'indented line'
    }
    $m = [regex]::Match($l, '^(["'']?)([A-Za-z_-]+)\1[ \t]*:(?:[ \t]+(.*))?$')
    if (-not $m.Success) { return 'not a plain key' }
    $key = $m.Groups[2].Value.ToLowerInvariant()
    if (@('name', 'description') -notcontains $key) { return "key $key" }
    $val = $m.Groups[3].Value.Trim()
    if ($val -eq '') { return "empty $key" }
    if ($val -match '^[\{\[&\*!%@`]') { return "odd value for $key" }
    $block = ($val -match '^[|>][+-]?[0-9]?[ \t]*(#.*)?$')
  }
  return 'header never closed'
}

try {
  $in = [Console]::In.ReadToEnd() | ConvertFrom-Json
  if ($null -eq $in) { throw 'empty' }
  $tool = "$($in.tool_name)"
  if ($tool -notmatch '^(Write|Edit|MultiEdit|NotebookEdit)$') { exit 0 }
  $ti = $in.tool_input
  $target = "$($ti.file_path)"
  if (-not $target.Trim()) { $target = "$($ti.notebook_path)" }
  if (-not $target.Trim()) { Block 'no file named' }
  $root = "$env:CLAUDE_PROJECT_DIR"
  if (-not $root.Trim()) { $root = "$($in.cwd)" }
  if (-not $root.Trim()) { $root = (Get-Location).Path }

  $raw = $target.Trim().Replace([char]47, [char]92)
  # Device, network and long-path forms, and alternate data streams (name.md:stream), are never needed here.
  if ($raw.StartsWith('\\')) { Block 'network or device path' }
  if ($raw.IndexOf(':', 2) -ge 0) { Block 'stream or odd path' }
  if ($raw -match '^[A-Za-z]:(?!\\)') { Block 'odd path' }
  # Short names (like JOHNSM~1) could hide a protected folder; only those already in the notebook's own path are fine.
  $rootSegs = @("$root".Replace([char]47, [char]92).Split([char]92))
  foreach ($s in $raw.Split([char]92)) { if ($s -match '~[0-9]' -and $rootSegs -notcontains $s) { Block 'short folder name' } }
  foreach ($s in $raw.Split([char]92)) { if ($s -ne $s.TrimEnd('.', ' ') -and $s -ne '.' -and $s -ne '..') { Block 'name ends in a dot or space' } }
  # Windows device names (CON, NUL, COM1.md ...) and letters that look like, or fold to, other letters.
  foreach ($s in $raw.Split([char]92)) { if (($s.Split('.')[0]) -match '^(?i)(con|prn|aux|nul|com[0-9]|lpt[0-9]|conin\$|conout\$)$') { Block 'a Windows device name' } }
  foreach ($ch in $raw.ToCharArray()) {
    $c = [int]$ch
    if ($c -lt 32 -or $c -eq 127 -or $c -eq 0x017F -or $c -eq 0x212A -or $c -eq 0x212B -or $c -eq 0x0130 -or $c -eq 0x0131 -or ($c -ge 0xFF01 -and $c -le 0xFF5E) -or
        [Globalization.CharUnicodeInfo]::GetUnicodeCategory($ch) -eq [Globalization.UnicodeCategory]::Format) { Block 'an odd letter in the name' }
  }
  if (-not [IO.Path]::IsPathRooted($raw)) { $raw = Join-Path $root $raw }

  $rootFull = [IO.Path]::GetFullPath($root).TrimEnd([char]92)
  $rootReal = Resolve-Real $rootFull 0
  $lex = [IO.Path]::GetFullPath($raw).TrimEnd([char]92)
  $real = Resolve-Real $lex 0
  $spots = Get-TemplateSpots $rootReal

  # Only inside the notebook: the path as written and the path it really leads to must both be in it.
  foreach ($pair in @(@($lex, $rootFull), @($real, $rootReal))) {
    $p = $pair[0]; $r = $pair[1]
    if ($p.Equals($r, [StringComparison]::OrdinalIgnoreCase)) { Block 'the notebook folder itself' }
    if (-not $p.StartsWith($r + [char]92, [StringComparison]::OrdinalIgnoreCase)) { Block 'outside the notebook' }
    $why = Get-Protected (Norm-Rel $p.Substring($r.Length)) $spots
    if ($why) { Block $why }
  }
  if (Test-HardLinked $real) { Block 'a file with more than one name' }

  # A helper note (any SKILL.md: .claude/skills, or the bundles and setups it is copied from) may be written,
  # but its header may only hold name and description. The check runs on the file as it would be AFTER the
  # change, so a key split across edits, quoted, or written as {hooks: ...} is still caught.
  if ([IO.Path]::GetFileName($lex) -ieq 'SKILL.md' -or [IO.Path]::GetFileName($real) -ieq 'SKILL.md') {
    if ($tool -eq 'NotebookEdit') { Block 'helper note' }
    $final = Get-FinalContent $tool $ti $real
    $odd = Test-OddChars $final
    if ($odd) { Block "helper note: $odd" }
    $why = Test-HelperHeader $final
    if ($why) { Block "helper header: $why" }
  }
  exit 0
} catch {
  [Console]::Error.WriteLine('Blocked: could not check where this file would go. Do not try another way; tell the person in plain words.')
  exit 2
}
