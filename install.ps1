param([switch]$DryRun, [switch]$SkipApps, [string]$DocumentsDir = [Environment]::GetFolderPath('MyDocuments'),
      [ValidateSet('','en-GB','es-MX')][string]$Language = '')
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

if (-not $DryRun) {
  $od = "$env:OneDrive"
  $onOd = ($od -ne '') -and $DocumentsDir.StartsWith($od, [StringComparison]::OrdinalIgnoreCase)
  Write-Log ("NOTE documents-onedrive " + $(if ($onOd) { 'yes' } else { 'no' }))
}

Act 'set-temp' 'C:\tmp\inst' {
  New-Item -ItemType Directory -Force 'C:\tmp\inst' | Out-Null
  if (-not (Test-Path -LiteralPath 'C:\tmp\inst')) { throw 'set-temp folder missing' }
  $env:TEMP = 'C:\tmp\inst'; $env:TMP = 'C:\tmp\inst'
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
$vaultName = if ($es) { 'Mi-Vida' } else { 'My-Life' }
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
    if ($LASTEXITCODE -ne 0) { Write-Log "NOTE install-uv exit $LASTEXITCODE (the job search uses its fallback)" }
  }
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
    $msg = if ($es) { "Casi listo, pero algo necesita ayuda. Abre Claude y escribe: Ayuda" } else { "Almost done, but something needs a hand. Open Claude and type: Help" }
  } else {
    $msg = if ($es) { "Todo listo. Abre la app de Claude, elige Code y la carpeta Mi-Vida en Documentos, y escribe: Empieza" } else { "All done. In the Claude app, click Code, pick the My-Life folder in Documents, and type: Start" }
  }
  Show-Box $msg $(if ($es) { 'Mi Vida' } else { 'My Life' })
}
# Last, after the box is closed, so the box can never open hidden behind the Claude window.
Act 'open-claude' $vault -App { Start-Process 'claude://' -ErrorAction SilentlyContinue }
exit 0
