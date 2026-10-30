$ErrorActionPreference = 'Stop'
try { $in = [Console]::In.ReadToEnd() | ConvertFrom-Json } catch { exit 0 }
$p = $in.tool_input.file_path
if (-not $p) { $p = $in.tool_input.notebook_path }
if (-not $p) { exit 0 }
try {
  $root = $env:CLAUDE_PROJECT_DIR
  if (-not $root) { $root = (Get-Location).Path }
  $dir = Join-Path $root 'playbook\state'
  if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Force $dir | Out-Null }
  $list = Join-Path $dir 'session-files.txt'
  for ($i = 0; $i -lt 5; $i++) {
    try {
      [IO.File]::AppendAllText($list, "$p`r`n", (New-Object Text.UTF8Encoding $false))
      break
    } catch [System.IO.IOException] { Start-Sleep -Milliseconds 50 }
  }
} catch { }
exit 0
