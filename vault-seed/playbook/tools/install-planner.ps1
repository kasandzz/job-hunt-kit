# install-planner.ps1 - put the pinned planning tool (the npm package get-shit-done-cc) into this notebook's .claude folder.
# Safe to run again: it does nothing when the pinned version is already there.
# The installer may only ADD its own files. The notebook's safety settings (.claude\settings.json) and every file in
# .claude\hooks are put back byte for byte afterwards, so the installer can never change or weaken them.
# Exit codes: 0 installed or already there, 3 Node.js missing, 4 the install failed.
param([string]$Vault = '', [string]$NpxPath = '', [int]$TimeoutSeconds = 300)
$ErrorActionPreference = 'Stop'
$Version = '1.30.0'
if (-not $Vault) { $Vault = Split-Path -Parent (Split-Path -Parent $PSScriptRoot) }
$claude = Join-Path $Vault '.claude'
$verFile = Join-Path $claude 'get-shit-done\VERSION'
function Get-PlannerVersion {
  if (Test-Path -LiteralPath $verFile -PathType Leaf) { return ([IO.File]::ReadAllText($verFile)).Trim() }
  return ''
}
if ((Get-PlannerVersion) -eq $Version) { Write-Output "planner: already installed ($Version)"; exit 0 }
$npx = $NpxPath
if (-not $npx) {
  $cmd = Get-Command npx.cmd -ErrorAction SilentlyContinue
  if ($cmd) { $npx = $cmd.Source }
  else {
    foreach ($c in (Join-Path $env:ProgramFiles 'nodejs\npx.cmd'), (Join-Path $env:LOCALAPPDATA 'Programs\nodejs\npx.cmd')) {
      if (Test-Path -LiteralPath $c -PathType Leaf) { $npx = $c; break }
    }
  }
}
if (-not $npx -or -not (Test-Path -LiteralPath $npx -PathType Leaf)) {
  [Console]::Error.WriteLine('planner: Node.js is not installed, so the planning tool was not added.')
  exit 3
}
# Remember the safety files exactly as they are now.
$settings = Join-Path $claude 'settings.json'
$settingsBefore = $null
if (Test-Path -LiteralPath $settings -PathType Leaf) { $settingsBefore = [IO.File]::ReadAllBytes($settings) }
$hookDir = Join-Path $claude 'hooks'
$hooksBefore = @{}
if (Test-Path -LiteralPath $hookDir -PathType Container) {
  Get-ChildItem -LiteralPath $hookDir -Force -File | ForEach-Object { $hooksBefore[$_.FullName] = [IO.File]::ReadAllBytes($_.FullName) }
}
function Test-SameBytes($a, $b) {
  if ($null -eq $a -or $null -eq $b) { return $false }
  if ($a.Length -ne $b.Length) { return $false }
  return ([Convert]::ToBase64String($a) -ceq [Convert]::ToBase64String($b))
}
$tag = [guid]::NewGuid().ToString()
$inFile = Join-Path $env:TEMP "pol-planner-$tag-in.txt"
$outFile = Join-Path $env:TEMP "pol-planner-$tag-out.txt"
$errFile = Join-Path $env:TEMP "pol-planner-$tag-err.txt"
[IO.File]::WriteAllText($inFile, '')
$exit = 1
try {
  $p = Start-Process -FilePath $npx -ArgumentList @('-y', "get-shit-done-cc@$Version", '--claude', '--local') -WorkingDirectory $Vault `
    -PassThru -WindowStyle Hidden -RedirectStandardInput $inFile -RedirectStandardOutput $outFile -RedirectStandardError $errFile
  $null = $p.Handle
  if ($p.WaitForExit($TimeoutSeconds * 1000)) { $exit = $p.ExitCode }
  else { try { $p.Kill() } catch { }; $exit = 124 }
} catch {
  $exit = 1
} finally {
  # Put the safety files back, whatever happened.
  if ($null -ne $settingsBefore) {
    $now = $null
    if (Test-Path -LiteralPath $settings -PathType Leaf) { $now = [IO.File]::ReadAllBytes($settings) }
    if (-not (Test-SameBytes $settingsBefore $now)) { [IO.File]::WriteAllBytes($settings, $settingsBefore) }
  } elseif (Test-Path -LiteralPath $settings -PathType Leaf) {
    [IO.File]::Delete($settings)
  }
  foreach ($k in @($hooksBefore.Keys)) {
    $now = $null
    if (Test-Path -LiteralPath $k -PathType Leaf) { $now = [IO.File]::ReadAllBytes($k) }
    if (-not (Test-SameBytes $hooksBefore[$k] $now)) { [IO.File]::WriteAllBytes($k, $hooksBefore[$k]) }
  }
  foreach ($f in $inFile, $outFile, $errFile) { if (Test-Path -LiteralPath $f) { [IO.File]::Delete($f) } }
}
if ($exit -eq 0 -and (Get-PlannerVersion) -eq $Version) { Write-Output "planner: installed ($Version)"; exit 0 }
[Console]::Error.WriteLine('planner: the planning tool could not be added this time. It can be tried again later.')
exit 4
