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
$uvx = Find-Uvx
if (-not $uvx) {
  winget install --id astral-sh.uv --exact --silent --accept-package-agreements --accept-source-agreements --disable-interactivity | Out-Null
  $uvx = Find-Uvx
}
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
exit 0
