$ErrorActionPreference = 'Continue'
$root = $env:CLAUDE_PROJECT_DIR
if (-not $root) { $root = (Get-Location).Path }
$pf = Join-Path $root 'playbook\progress.md'
if (-not (Test-Path -LiteralPath $pf)) { exit 0 }
try {
  $t = [IO.File]::ReadAllText($pf)
  $m = [regex]::Match($t, '(?m)^current_stage:\s*(\d+)')
  $cur = if ($m.Success) { [int]$m.Groups[1].Value } else { 1 }
  $n = 0
  while ($n -lt 8 -and (Test-Path -LiteralPath (Join-Path $root ('playbook\state\stage-' + ($n + 1) + '.done')))) { $n++ }
  $want = $n + 1
  if ($want -gt $cur) {
    # [^\r\n]* (not .*) so CRLF line endings survive
    $t = [regex]::Replace($t, '(?m)^current_stage:[ \t]*\d+', "current_stage: $want")
    $t = [regex]::Replace($t, '(?m)^updated:[^\r\n]*', ('updated: ' + (Get-Date -Format s)))
    [IO.File]::WriteAllText($pf, $t, (New-Object Text.UTF8Encoding $false))
  }
} catch { }
exit 0
