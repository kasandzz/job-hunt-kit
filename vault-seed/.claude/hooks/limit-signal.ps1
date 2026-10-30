$ErrorActionPreference = 'Continue'
try { $in = [Console]::In.ReadToEnd() | ConvertFrom-Json } catch { exit 0 }
if (-not $in) { exit 0 }
$ev = "$($in.hook_event_name)"
$kw = '(?i)usage limit|rate limit|limit reached|quota|limite de uso'

function ConvertTo-Text($x) {
  if ($null -eq $x) { return '' }
  if ($x -is [string]) { return $x }
  try { return (ConvertTo-Json -InputObject $x -Compress -Depth 6) } catch { return "$x" }
}

$hit = $false
if ($ev -eq 'StopFailure') {
  # matcher rate_limit already scopes this event: it is a hit even without keywords
  $hit = $true
} else {
  $text = (ConvertTo-Text $in.message)
  if ($text -match $kw) { $hit = $true }
}
if (-not $hit) { exit 0 }

$root = $env:CLAUDE_PROJECT_DIR
if (-not $root) { $root = (Get-Location).Path }
$stateDir = Join-Path $root 'playbook\state'
$log = Join-Path $stateDir 'limit-hits.log'
try {
  if (-not (Test-Path -LiteralPath $stateDir)) { New-Item -ItemType Directory -Force $stateDir | Out-Null }
  $inv = [Globalization.CultureInfo]::InvariantCulture
  $now = Get-Date
  $keep = @(); $last = [datetime]::MinValue; $recent = 0
  if (Test-Path -LiteralPath $log) {
    foreach ($line in [IO.File]::ReadAllLines($log)) {
      $l = $line.Trim()
      if (-not $l) { continue }
      $d = [datetime]::MinValue
      if ([datetime]::TryParse($l, $inv, [Globalization.DateTimeStyles]::None, [ref]$d)) {
        if ($d -gt $now.AddDays(-30)) { $keep += $l }   # prune hits older than 30 days
        if ($d -gt $last) { $last = $d }
        if ($d -gt $now.AddDays(-7)) { $recent++ }
      }
    }
  }
  # one limit event can fire both StopFailure and Notification: count once per 15 minutes
  if ($last -gt $now.AddMinutes(-15)) { exit 0 }
  $keep += $now.ToString('s', $inv); $recent++
  [IO.File]::WriteAllText($log, (($keep -join "`r`n") + "`r`n"), (New-Object Text.UTF8Encoding $false))
  if ($recent -ge 3) { New-Item -ItemType File -Force (Join-Path $stateDir 'suggest-upgrade.flag') | Out-Null }
} catch { }
exit 0
