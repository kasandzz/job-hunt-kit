# install-uv.ps1 - adds uv (the small program the job search tool runs on) and points the notebook's .mcp.json
# at it by full path, so the Claude app finds it even before Windows refreshes its program list.
# Exit 0 = ready, 3 = uv missing (the job-finder helper then searches the job sites by hand). ASCII only.
param([string]$Vault = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)))
$ErrorActionPreference = 'Continue'
$Pin = 'mcp-jobspy@1.4.1'
function Find-Uvx {
  $c = @(
    (Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links\uvx.exe'),
    (Join-Path $env:USERPROFILE '.local\bin\uvx.exe'),
    (Join-Path $env:USERPROFILE '.cargo\bin\uvx.exe')
  )
  foreach ($p in $c) { if ($p -and (Test-Path -LiteralPath $p)) { return $p } }
  $w = Get-Command uvx.exe -ErrorAction SilentlyContinue
  if ($w) { return $w.Source }
  $pk = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages'
  if (Test-Path -LiteralPath $pk) {
    $f = Get-ChildItem -LiteralPath $pk -Recurse -Filter uvx.exe -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($f) { return $f.FullName }
  }
  return $null
}
function Test-Uvx($p) {
  if (-not $p) { return $false }
  try { $v = & $p --version 2>$null; return ($LASTEXITCODE -eq 0 -and "$v" -match '\d+\.\d+') } catch { return $false }
}
# Really installed means uvx answers with a version, not only that a file exists. Two tries with winget.
$uvx = Find-Uvx
for ($try = 0; $try -lt 2 -and -not (Test-Uvx $uvx); $try++) {
  winget install --id astral-sh.uv --exact --silent --accept-package-agreements --accept-source-agreements --disable-interactivity | Out-Null
  $uvx = Find-Uvx
}
if (-not (Test-Uvx $uvx)) { $uvx = $null }
$state = Join-Path $Vault 'playbook\state'
if (-not (Test-Path -LiteralPath $state)) { New-Item -ItemType Directory -Force $state | Out-Null }
$enc = New-Object Text.UTF8Encoding $false
if (-not $uvx) {
  [IO.File]::WriteAllText((Join-Path $state 'job-search-tool.md'), "job_search_tool: missing`n", $enc)
  exit 3
}
$cfg = [ordered]@{ mcpServers = [ordered]@{ jobspy = [ordered]@{ command = $uvx; args = @($Pin) } } }
[IO.File]::WriteAllText((Join-Path $Vault '.mcp.json'), ($cfg | ConvertTo-Json -Depth 5), $enc)
[IO.File]::WriteAllText((Join-Path $state 'job-search-tool.md'), "job_search_tool: ready`n", $enc)
# Warm-up: the first start downloads the tool's parts (over 4 minutes in the 2026-10-30 sandbox test; later starts
# take about 3 s). Start it once now, hidden and in the background, with empty input so it stops on its own when
# ready; the install does not wait, and the job search comes much later in the setup.
try {
  $wd = Join-Path ([IO.Path]::GetTempPath()) ('pol-jobspy-warm-' + [guid]::NewGuid().ToString('N').Substring(0, 8))
  New-Item -ItemType Directory -Force $wd | Out-Null
  $emptyIn = Join-Path $wd 'in.txt'; [IO.File]::WriteAllText($emptyIn, '', $enc)
  # A small hidden helper starts it and stops it after 15 minutes at the latest, so nothing is left running.
  $warm = Join-Path $wd 'warm.ps1'
  $q = { param($s) "'" + $s.Replace("'", "''") + "'" }
  $body = '$p = Start-Process -FilePath ' + (& $q $uvx) + ' -ArgumentList ' + (& $q $Pin) + ' -WorkingDirectory ' + (& $q $wd) +
    ' -WindowStyle Hidden -PassThru -RedirectStandardInput ' + (& $q $emptyIn) + ' -RedirectStandardOutput ' + (& $q (Join-Path $wd 'out.txt')) +
    ' -RedirectStandardError ' + (& $q (Join-Path $wd 'err.txt')) + "`r`n" + 'if (-not $p.WaitForExit(900000)) { try { $p.Kill() } catch { } }' + "`r`n"
  [IO.File]::WriteAllText($warm, $body, $enc)
  Start-Process -FilePath 'powershell.exe' -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-WindowStyle', 'Hidden', '-File', ('"' + $warm + '"')) -WindowStyle Hidden | Out-Null
  Add-Content -LiteralPath (Join-Path $state 'job-search-tool.md') -Value 'warm_up: started' -Encoding UTF8
} catch {
  Add-Content -LiteralPath (Join-Path $state 'job-search-tool.md') -Value 'warm_up: failed' -Encoding UTF8
}
exit 0
