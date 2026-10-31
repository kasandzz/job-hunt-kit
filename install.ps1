param([switch]$DryRun, [switch]$SkipApps, [string]$DocumentsDir = [Environment]::GetFolderPath('MyDocuments'),
      [ValidateSet('','en-GB','es-MX','lt-LT')][string]$Language = '')
$ErrorActionPreference = 'Continue'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$log = Join-Path $here 'install-log.txt'
$logMarker = '# personal-os-lite install log'
$script:Failed = $false

# The log never holds profile values (name, email). Verbs, fixed words and paths only. ASCII only.
function Write-Log($text) {
  if ($DryRun) { return }
  if (-not (Test-Path -LiteralPath $log)) { Set-Content -LiteralPath $log -Value $logMarker -Encoding ASCII }
  Add-Content -LiteralPath $log -Value $text -Encoding ASCII
}
function Act($verb, $detail, [scriptblock]$do, [switch]$App) {
  $line = "ACTION $verb $detail"
  if ($DryRun) { Write-Output $line; return }
  Write-Log $line
  if ($App -and $SkipApps) { Write-Log "SKIPPED $verb (SkipApps)"; return }
  $ErrorActionPreference = 'Stop'   # local: non-terminating errors become catchable
  try { & $do } catch { $script:Failed = $true; Write-Log ("ERROR " + $_.Exception.Message) }
}
function Get-GitExe {
  if (Test-Path 'C:\Program Files\Git\cmd\git.exe') { return 'C:\Program Files\Git\cmd\git.exe' }
  return 'git.exe'
}
function Show-Box($msg, $title) {
  Add-Type -AssemblyName PresentationFramework
  [System.Windows.MessageBox]::Show($msg, $title, 'OK', 'Information', 'OK', 'DefaultDesktopOnly') | Out-Null
}

# A broken kit stops here: no guessing the language. Fixed log words only, never exception text.
$profPath = Join-Path $here 'vault-seed\playbook\state\profile.json'
$prof = $null
$profProblem = $null
if (-not (Test-Path -LiteralPath $profPath)) { $profProblem = 'profile-missing' }
else {
  try { $prof = Get-Content -LiteralPath $profPath -Raw | ConvertFrom-Json } catch { $prof = $null }
  if (-not $prof -or -not $prof.language) { $profProblem = 'profile-unreadable' }
}
if ($profProblem) {
  if ($DryRun) { Write-Output "ACTION stop $profProblem"; exit 1 }
  Write-Log "ERROR $profProblem"
  if (-not $SkipApps) { Show-Box "Setup file missing, please ask Kas`r`nFalta el archivo de configuracion, pide ayuda a Kas" 'Personal OS' }
  exit 1
}
# J-05: a generic pack is one zip for anybody; the language is picked here (the paste-in text passes it).
if ($Language) { $prof.language = $Language }
$es = $prof.language -eq 'es-MX'
$lt = $prof.language -eq 'lt-LT'
# Lithuanian letters for the boxes, kept out of this ASCII-only file: ~a=a-ogonek ~c=c-caron ~e=e-dot ~i=i-ogonek ~s=s-caron ~u=u-macron ~y=u-ogonek ~z=z-caron
function LtText([string]$s) {
  $map = @{ '~a' = 0x105; '~c' = 0x10D; '~e' = 0x117; '~i' = 0x12F; '~s' = 0x161; '~u' = 0x16B; '~y' = 0x173; '~z' = 0x17E }
  foreach ($k in $map.Keys) { $s = $s.Replace($k, [string][char]$map[$k]) }
  $s
}

if (-not $DryRun) {
  $od = "$env:OneDrive"
  $onOd = ($od -ne '') -and $DocumentsDir.StartsWith($od, [StringComparison]::OrdinalIgnoreCase)
  Write-Log ("NOTE documents-onedrive " + $(if ($onOd) { 'yes' } else { 'no' }))
}

# A fresh random folder under the per-user TEMP (never a fixed shared path another account could plant first).
# The 8.3 short form keeps installers working when the user name has a space.
Act 'set-temp' 'per-user-random' {
  $userTemp = [IO.Path]::GetTempPath().TrimEnd([char]92)
  try { $userTemp = (New-Object -ComObject Scripting.FileSystemObject).GetFolder($userTemp).ShortPath } catch { }
  $instTemp = Join-Path $userTemp ('pol-inst-' + [guid]::NewGuid().ToString('N').Substring(0, 16))
  New-Item -ItemType Directory -Path $instTemp -ErrorAction Stop | Out-Null
  if (-not (Test-Path -LiteralPath $instTemp)) { throw 'set-temp folder missing' }
  $env:TEMP = $instTemp; $env:TMP = $instTemp
}
$apps = 'Git.Git','Obsidian.Obsidian','yt-dlp.yt-dlp','GitHub.cli','OpenJS.NodeJS.LTS','Anthropic.Claude'
foreach ($id in $apps) {
  Act 'winget' $id -App {
    winget list --id $id --exact --accept-source-agreements --disable-interactivity | Out-Null
    if ($LASTEXITCODE -ne 0) {
      winget install --id $id --exact --silent --accept-package-agreements --accept-source-agreements --disable-interactivity | Out-Null
      if ($LASTEXITCODE -ne 0) { throw "winget install $id exit $LASTEXITCODE" }
    }
  }
}
$vaultName = if ($es) { 'Mi-Vida' } elseif ($lt) { 'Mano-Gyvenimas' } else { 'My-Life' }
$vault = Join-Path $DocumentsDir $vaultName
$seed = Join-Path $here 'vault-seed'

# Never overwrite anything that already exists in the notebook (safe to double-click again).
Act 'copy-seed' $vault {
  if (-not (Test-Path -LiteralPath $vault)) { New-Item -ItemType Directory -Force $vault | Out-Null }
  $seedFull = (Get-Item -LiteralPath $seed).FullName.TrimEnd('\')
  Get-ChildItem -LiteralPath $seedFull -Recurse -Force -File | ForEach-Object {
    if (-not $_.FullName.StartsWith($seedFull, [StringComparison]::OrdinalIgnoreCase)) { throw 'seed path mismatch' }
    $rel = $_.FullName.Substring($seedFull.Length).TrimStart('\')
    $dest = Join-Path $vault $rel
    if (-not (Test-Path -LiteralPath $dest)) {
      # One locked or unreadable file must not stop the rest; a re-run fills the gap safely.
      try {
        $destDir = Split-Path -Parent $dest
        if (-not (Test-Path -LiteralPath $destDir)) { New-Item -ItemType Directory -Force $destDir | Out-Null }
        Copy-Item -LiteralPath $_.FullName -Destination $dest
      } catch { $script:Failed = $true; Write-Log ("ERROR copy-seed-file " + $rel) }
    }
  }
}
# The picked language goes into the notebook's own profile, only when -Language was given.
if ($Language) {
  Act 'set-language' $Language {
    $vp = Join-Path $vault 'playbook\state\profile.json'
    $vj = [IO.File]::ReadAllText($vp) | ConvertFrom-Json
    $vj.language = $Language
    $enc8 = New-Object Text.UTF8Encoding $false
    [IO.File]::WriteAllText($vp, ($vj | ConvertTo-Json), $enc8)
    # Point the daily-notes add-on at this language's daily folder, as build-kit does for a named pack.
    $lf = Join-Path $vault "playbook\profiles\language-$Language.md"
    $row = [regex]::Match([IO.File]::ReadAllText($lf, $enc8), '(?m)^\|\s*daily\s*\|\s*([^|\r\n]+?)\s*\|')
    $pnf = Join-Path $vault '.obsidian\plugins\periodic-notes\data.json'
    if ($row.Success -and (Test-Path -LiteralPath $pnf)) {
      $df = $row.Groups[1].Value.Trim().Trim([char]96)
      if ($df -cmatch '^[A-Za-z0-9][A-Za-z0-9-]{0,40}$') {
        $pn = [IO.File]::ReadAllText($pnf, $enc8) | ConvertFrom-Json
        $pn.daily.folder = $df; $pn.weekly.folder = $df
        [IO.File]::WriteAllText($pnf, ($pn | ConvertTo-Json -Depth 5), $enc8)
      }
    }
  }
}
# Place the helpers for this mode's bundles. Claude cannot write into .claude/ without a permission
# prompt, so the installer does it; stage 5 then finds each helper already in place and skips it.
# Never overwrites an existing helper.
# Note templates are placed here, not by Claude: the vault settings block Claude from writing _templates/ (Templater can run code from it).
Act 'copy-templates' (Join-Path $vault '_templates') {
  $tdst = Join-Path $vault '_templates'
  if (-not (Test-Path -LiteralPath $tdst)) { New-Item -ItemType Directory -Force $tdst | Out-Null }
  Get-ChildItem -LiteralPath (Join-Path $vault 'playbook\templates') -Filter '*.md' -File | Where-Object { $_.Name -ne 'rules-CLAUDE.md' } | ForEach-Object {
    $t = Join-Path $tdst $_.Name
    if (-not (Test-Path -LiteralPath $t)) { Copy-Item -LiteralPath $_.FullName -Destination $t }
  }
}
# The add-on list is written here, not by Claude: the vault settings block Claude from writing .obsidian/community-plugins.json.
Act 'enable-addons' (Join-Path $vault '.obsidian\community-plugins.json') {
  $cp = Join-Path $vault '.obsidian\community-plugins.json'
  $have = @()
  if (Test-Path -LiteralPath $cp) { try { $parsed = ConvertFrom-Json ([IO.File]::ReadAllText($cp)); foreach ($x in $parsed) { $have += $x } } catch { $have = @() } }
  $want = @($have | Where-Object { $_ -is [string] -and $_ -match '^[A-Za-z0-9._-]+$' })
  foreach ($p in 'dataview','templater-obsidian','periodic-notes') { if ($want -notcontains $p) { $want += $p } }
  $json = '[' + (($want | ForEach-Object { '"' + ($_ -replace '[^A-Za-z0-9._-]', '') + '"' }) -join ',') + ']'
  if (-not (Test-Path -LiteralPath (Split-Path -Parent $cp))) { New-Item -ItemType Directory -Force (Split-Path -Parent $cp) | Out-Null }
  [IO.File]::WriteAllText($cp, $json, (New-Object Text.UTF8Encoding($false)))
}
# The three Obsidian settings stage 4 used to write. Claude can never write anything in .obsidian (Windows ignores
# case, and Obsidian runs add-on code and template code from there), so the installer merges them: every other
# setting already in a file is kept. One template folder (_templates) for every add-on; built-in Daily notes off.
Act 'obsidian-settings' (Join-Path $vault '.obsidian') {
  $enc8 = New-Object Text.UTF8Encoding $false
  $od = Join-Path $vault '.obsidian'
  if (-not (Test-Path -LiteralPath $od)) { New-Item -ItemType Directory -Force $od | Out-Null }
  $vj = [IO.File]::ReadAllText((Join-Path $vault 'playbook\state\profile.json')) | ConvertFrom-Json
  $lang = "$($vj.language)"; if ($lang -notmatch '^[a-z]{2}-[A-Z]{2}$') { throw 'language unreadable' }
  $row = [regex]::Match([IO.File]::ReadAllText((Join-Path $vault "playbook\profiles\language-$lang.md"), $enc8), '(?m)^\|\s*daily\s*\|\s*([^|\r\n]+?)\s*\|')
  $df = if ($row.Success) { $row.Groups[1].Value.Trim().Trim([char]96) } else { '' }
  if ($df -cnotmatch '^[A-Za-z0-9][A-Za-z0-9-]{0,40}$') { throw 'daily folder unreadable' }
  function Read-Obj($p) {
    if (Test-Path -LiteralPath $p) { try { $o = [IO.File]::ReadAllText($p) | ConvertFrom-Json; if ($o -is [psobject] -and -not ($o -is [array])) { return $o } } catch { } }
    return New-Object psobject
  }
  function Set-Key($o, $k, $val) { if ($o.PSObject.Properties.Name -contains $k) { $o.$k = $val } else { $o | Add-Member -NotePropertyName $k -NotePropertyValue $val } }
  $tf = Join-Path $od 'templates.json'
  $t = Read-Obj $tf; Set-Key $t 'folder' '_templates'
  [IO.File]::WriteAllText($tf, ($t | ConvertTo-Json -Depth 6), $enc8)
  $dnf = Join-Path $od 'daily-notes.json'
  $dn = Read-Obj $dnf; Set-Key $dn 'folder' $df; Set-Key $dn 'format' 'YYYY-MM-DD'; Set-Key $dn 'template' '_templates/daily'
  [IO.File]::WriteAllText($dnf, ($dn | ConvertTo-Json -Depth 6), $enc8)
  $cpf = Join-Path $od 'core-plugins.json'
  $default = @('file-explorer','global-search','switcher','graph','backlink','outgoing-link','tag-pane','page-preview','templates','note-composer','command-palette','editor-status','bookmarks','outline','word-count','file-recovery')
  $raw = $null
  if (Test-Path -LiteralPath $cpf) { try { $raw = ConvertFrom-Json ([IO.File]::ReadAllText($cpf)) } catch { $raw = $null } }
  if ($raw -is [psobject] -and -not ($raw -is [array]) -and $raw.PSObject.Properties.Count -gt 0 -and -not ($raw -is [string])) {
    Set-Key $raw 'templates' $true; Set-Key $raw 'daily-notes' $false
    [IO.File]::WriteAllText($cpf, ($raw | ConvertTo-Json -Depth 6), $enc8)
  } else {
    $list = @(); if ($null -ne $raw) { foreach ($x in $raw) { if ($x -is [string] -and $x -match '^[A-Za-z0-9._-]+$') { $list += $x } } }
    if ($list.Count -eq 0) { $list = $default }
    $list = @($list | Where-Object { $_ -ne 'daily-notes' }); if ($list -notcontains 'templates') { $list += 'templates' }
    [IO.File]::WriteAllText($cpf, ('[' + (($list | ForEach-Object { '"' + $_ + '"' }) -join ',') + ']'), $enc8)
  }
}
Act 'install-helpers' (Join-Path $vault '.claude\skills') {
  $mode = "$($prof.mode)".Trim(); if ($mode -notmatch '^[a-z-]+$') { $mode = 'personal' }
  $modeFile = Join-Path $seed "playbook\profiles\mode-$mode.md"
  $text = [IO.File]::ReadAllText($modeFile)
  $m = [regex]::Match($text, '(?ms)^## Bundles\s*$\s*^([^\r\n(]+)')
  if (-not $m.Success) { throw 'bundles line missing' }
  foreach ($b in ($m.Groups[1].Value -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^[a-z0-9-]+$' })) {
    $bdir = Join-Path $seed "playbook\bundles\$b"
    if (-not (Test-Path -LiteralPath $bdir)) { throw "bundle missing $b" }
    Get-ChildItem -LiteralPath $bdir -Directory | ForEach-Object {
      $src = Join-Path $_.FullName 'SKILL.md'
      $dest = Join-Path $vault ('.claude\skills\' + $_.Name + '\SKILL.md')
      if ((Test-Path -LiteralPath $src) -and -not (Test-Path -LiteralPath $dest)) {
        New-Item -ItemType Directory -Force (Split-Path -Parent $dest) | Out-Null
        Copy-Item -LiteralPath $src -Destination $dest
      }
    }
  }
}
# The planning tool (a pinned version) goes into .claude\get-shit-done. It needs Node.js, installed above.
# A problem here never fails the install: stage 1 tries once more, and the planning helper works without it.
Act 'install-planner' (Join-Path $vault '.claude\get-shit-done') -App {
  $tool = Join-Path $vault 'playbook\tools\install-planner.ps1'
  if (-not (Test-Path -LiteralPath $tool)) { throw 'install-planner tool missing' }
  & powershell -NoProfile -ExecutionPolicy Bypass -File $tool -Vault $vault | Out-Null
  if ($LASTEXITCODE -ne 0) { Write-Log "NOTE install-planner exit $LASTEXITCODE (stage 1 tries again)" }
}
# A setup may ship one extra tool installer (the job-hunt setup adds uv, the small program the job search tool runs on).
# Like the planning tool, a problem here never fails the install: the helper that needs it has a plain fallback.
$uvTool = Join-Path $seed 'playbook\tools\install-uv.ps1'
if (Test-Path -LiteralPath $uvTool) {
  Act 'install-uv' 'astral-sh.uv' -App {
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $vault 'playbook\tools\install-uv.ps1') | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "install-uv exit $LASTEXITCODE (uv missing; the job search uses its fallback)" }
  }
}
# Stage 1 reads this instead of running a check command (a command raised a permission box on every run).
Act 'record-apps' (Join-Path $vault 'playbook\state\apps.md') {
  $found = (Test-Path -LiteralPath (Join-Path $env:LOCALAPPDATA 'Programs\Obsidian\Obsidian.exe')) -or (Test-Path -LiteralPath (Join-Path $env:ProgramFiles 'Obsidian\Obsidian.exe'))
  $st = Join-Path $vault 'playbook\state'
  if (-not (Test-Path -LiteralPath $st)) { New-Item -ItemType Directory -Force $st | Out-Null }
  [IO.File]::WriteAllText((Join-Path $st 'apps.md'), ("obsidian: " + $(if ($found) { 'found' } else { 'missing' }) + "`n"), (New-Object Text.UTF8Encoding $false))
}
Act 'git-init' $vault {
  $git = Get-GitExe
  & $git -C $vault init -q
  if ($LASTEXITCODE -ne 0) { throw "git init exit $LASTEXITCODE" }
  & $git -C $vault config core.quotepath false
  if ($LASTEXITCODE -ne 0) { throw "git config exit $LASTEXITCODE" }
}
# Repo-local identity. Stage 6 can update it. Skipped when one is already set (re-run).
Act 'git-identity' $vault {
  $git = Get-GitExe
  $existing = "$(& $git -C $vault config --local user.email)".Trim()
  if (-not $existing) {
    $n = "$($prof.name)".Trim()
    if (-not $n) { $n = 'user' }
    $mail = "$($prof.email)".Trim()
    if (-not $mail) {
      $plain = $n.Normalize([Text.NormalizationForm]::FormD) -replace '\p{Mn}', ''
      $slug = ($plain.ToLower() -replace '[^a-z0-9]', '-').Trim('-')
      if (-not $slug) { $slug = 'user' }
      $mail = "$slug@users.noreply.github.com"
    }
    & $git -C $vault config user.name $n
    if ($LASTEXITCODE -ne 0) { throw "git config exit $LASTEXITCODE" }
    & $git -C $vault config user.email $mail
    if ($LASTEXITCODE -ne 0) { throw "git config exit $LASTEXITCODE" }
  }
}
# Keep a copy of the log at the notebook root (help-bundle reads it there), only when git-ignored.
Act 'copy-log' (Join-Path $vault 'install-log.txt') {
  $git = Get-GitExe
  & $git -C $vault check-ignore -q 'install-log.txt'
  if ($LASTEXITCODE -eq 0) {
    Copy-Item -LiteralPath $log -Destination (Join-Path $vault 'install-log.txt') -Force
  } else { Write-Log 'SKIPPED copy-log (not git-ignored)' }
}
if (-not $DryRun -and -not $SkipApps) {
  if ($script:Failed) {
    $msg = if ($es) { "Casi listo, pero algo necesita ayuda. Abre Claude y escribe: Ayuda" } elseif ($lt) { LtText 'Beveik baigta, bet ka~zkam reikia pagalbos. Atidarykite Claude ir para~sykite: Pagalba' } else { "Almost done, but something needs a hand. Open Claude and type: Help" }
  } else {
    $msg = if ($es) { "Todo listo. Abre la app de Claude, elige Code y la carpeta Mi-Vida en Documentos, y escribe: Empieza" } elseif ($lt) { LtText 'Viskas paruo~sta. Claude programoje spustel~ekite Code, pasirinkite aplank~a Mano-Gyvenimas (Documents) ir para~sykite: Prad~ekime' } else { "All done. In the Claude app, click Code, pick the My-Life folder in Documents, and type: Start" }
  }
  Show-Box $msg $(if ($es) { 'Mi Vida' } elseif ($lt) { 'Mano Gyvenimas' } else { 'My Life' })
}
# Last, after the box is closed, so the box can never open hidden behind the Claude window.
Act 'open-claude' $vault -App { Start-Process 'claude://' -ErrorAction SilentlyContinue }
# A failed step gives a non-zero exit, so the paste-in text's "if something fails" step can work.
if ($script:Failed) { exit 1 }
exit 0
