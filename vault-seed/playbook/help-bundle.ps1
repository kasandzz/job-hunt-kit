# Makes a small zip on the Desktop for Kas: setup log, progress, setup state and settings.
# It NEVER includes notes, interview answers, seeds, questions, profile (email) or owner data.
param(
  [string]$VaultRoot = (Split-Path -Parent $PSScriptRoot),
  [string]$OutDir = [Environment]::GetFolderPath('Desktop')
)
$ErrorActionPreference = 'Continue'
$utf8 = New-Object Text.UTF8Encoding $false
$stage = Join-Path $env:TEMP ('help-' + [guid]::NewGuid())
New-Item -ItemType Directory -Force $stage | Out-Null

# State files are copied only if they are on this allowlist (technical info only).
$allowed = 'connectors.md','timezone.md','folders.md','backup.md','phone.md','helper.json','test-log.md',
           'last-push-failed','limit-hits.log','suggest-upgrade.flag','upgrade-dismissed.md'
# Second layer: private files never leave the computer, even if someone adds them to the allowlist.
$private = 'interview.md','interview-current.md','seeds.md','deeper-questions.md','book-checkpoint.md',
           'owner.json','profile.json','session-files.txt','test-answers.md'
$marker = '# personal-os-lite install log'

foreach ($rel in 'install-log.txt','playbook\progress.md','.claude\settings.json') {
  $src = Join-Path $VaultRoot $rel
  if (Test-Path -LiteralPath $src -PathType Leaf) {
    Copy-Item -LiteralPath $src (Join-Path $stage ($rel -replace '\\','_'))
  }
}

# The installer writes install-log.txt next to the unzipped kit, not in the notebook.
# If it is not in the notebook, take the newest one from Downloads that is ours: the first line
# must be the kit marker, and the kit's start sheet must sit in the same folder.
if (-not (Test-Path -LiteralPath (Join-Path $stage 'install-log.txt'))) {
  $dl = Join-Path $env:USERPROFILE 'Downloads'
  if (Test-Path -LiteralPath $dl) {
    $cand = Get-ChildItem -LiteralPath $dl -Directory -ErrorAction SilentlyContinue | ForEach-Object {
      $p = Join-Path $_.FullName 'install-log.txt'
      $sheet = (Test-Path -LiteralPath (Join-Path $_.FullName 'START-HERE.md')) -or (Test-Path -LiteralPath (Join-Path $_.FullName 'EMPIEZA-AQUI.md'))
      if ($sheet -and (Test-Path -LiteralPath $p -PathType Leaf)) { Get-Item -LiteralPath $p }
    } | Where-Object {
      $first = Get-Content -LiteralPath $_.FullName -TotalCount 1 -ErrorAction SilentlyContinue
      "$first".Trim() -eq $marker
    } | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($cand) { Copy-Item -LiteralPath $cand.FullName (Join-Path $stage 'install-log.txt') }
  }
}

# Setup state files only (top level, files only; never a folder of notes).
$stDir = Join-Path $VaultRoot 'playbook\state'
if (Test-Path -LiteralPath $stDir) {
  Get-ChildItem -LiteralPath $stDir -File -ErrorAction SilentlyContinue |
    Where-Object { $n = $_.Name.ToLower(); ($allowed -contains $n -or $n -like 'stage-*.done') -and ($private -notcontains $n) } |
    ForEach-Object { Copy-Item -LiteralPath $_.FullName (Join-Path $stage ('state_' + $_.Name)) }
}

$git = 'git'; if (-not (Get-Command git -ErrorAction SilentlyContinue)) { $git = 'C:\Program Files\Git\cmd\git.exe' }
$gl = @()
try { $gl = @(& $git -C $VaultRoot log -5 '--format=%h %ad %s' --date=short 2>$null) } catch { $gl = @('git log not available') }
# Only automatic backup subjects are kept; any other subject could name a note.
$gl = @($gl | ForEach-Object {
  $parts = "$_" -split ' ', 3
  if ($parts.Count -eq 3 -and $parts[2] -notmatch '^auto-backup \d{4}-\d{2}-\d{2} \d{2}:\d{2}$') { $parts[0] + ' ' + $parts[1] + ' (other save)' } else { "$_" }
})
$rm = @()
try { $rm = @(& $git -C $VaultRoot remote -v 2>$null) } catch { }
# Strip any user name or token from remote addresses.
$rm = @($rm | ForEach-Object { "$_" -replace '://[^/\s]*@', '://' })
[IO.File]::WriteAllText((Join-Path $stage 'git-log.txt'), ((@($gl) + '' + 'remotes:' + @($rm)) -join "`r`n"), $utf8)

if (-not (Test-Path -LiteralPath $OutDir)) { New-Item -ItemType Directory -Force $OutDir | Out-Null }
$zip = Join-Path $OutDir ('help-for-kas-' + (Get-Date -Format 'yyyyMMdd-HHmm') + '.zip')
Compress-Archive -Path (Join-Path $stage '*') -DestinationPath $zip -Force
Remove-Item -LiteralPath $stage -Recurse -Force -ErrorAction SilentlyContinue
if (Test-Path -LiteralPath $zip) { Write-Output $zip; exit 0 }
Write-Output 'help file could not be made'
exit 1
