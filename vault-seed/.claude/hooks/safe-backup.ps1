$ErrorActionPreference = 'Continue'
$env:GIT_TERMINAL_PROMPT = '0'
$env:GCM_INTERACTIVE = 'never'
try { [Console]::OutputEncoding = New-Object Text.UTF8Encoding $false } catch { }
$root = $env:CLAUDE_PROJECT_DIR
if (-not $root) { $root = (Get-Location).Path }
$list = Join-Path $root 'playbook\state\session-files.txt'
$utf8 = New-Object Text.UTF8Encoding $false

# Long-path normaliser: handles 8.3 short names such as C:\Users\ABCDEF~1
$sig = '[System.Runtime.InteropServices.DllImport("kernel32.dll", CharSet = System.Runtime.InteropServices.CharSet.Unicode, SetLastError = true)] public static extern uint GetLongPathName(string shortPath, System.Text.StringBuilder longPath, uint bufLen);'
$haveLP = $true
try { Add-Type -ErrorAction Stop -Name NativeLP -Namespace PolBackup -MemberDefinition $sig } catch { $haveLP = $false }
function Get-LongPath([string]$p) {
  try {
    $full = [IO.Path]::GetFullPath($p)
    if ($haveLP) {
      $sb = New-Object System.Text.StringBuilder 32768
      $n = [PolBackup.NativeLP]::GetLongPathName($full, $sb, 32768)
      if ($n -gt 0 -and $n -lt 32768) { return $sb.ToString() }
    }
    return $full
  } catch { return $null }
}

$git = 'git'; if (-not (Get-Command git -ErrorAction SilentlyContinue)) { $git = 'C:\Program Files\Git\cmd\git.exe' }
$rootLong = Get-LongPath $root
# Never run vault-local git hooks or fsmonitor commands during the backup.
$gsafe = @('-c', 'core.hooksPath=NUL', '-c', 'core.fsmonitor=false')
if (-not $rootLong) { exit 0 }
$rootPrefix = $rootLong.TrimEnd('\') + '\'
$hadList = Test-Path -LiteralPath $list
$paths = @()
if ($hadList) { $paths = @(Get-Content -LiteralPath $list -Encoding UTF8 | Where-Object { $_.Trim() } | ForEach-Object { $_.Trim() }) }
# progress.md and stage-N.done are written by hooks/shell, never by Write/Edit, so the tracker misses them
$prog = Join-Path $root 'playbook\progress.md'
if (Test-Path -LiteralPath $prog) { $paths += $prog }
$stDir = Join-Path $root 'playbook\state'
if (Test-Path -LiteralPath $stDir) { $paths += @(Get-ChildItem -LiteralPath $stDir -Filter 'stage-*.done' -File -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName }) }
$paths = @($paths | Sort-Object -Unique)
$ok = $true
$cand = @()   # relative, forward-slash paths to stage
foreach ($p in $paths) {
  $full = Get-LongPath $p
  if (-not $full) { continue }
  if (-not $full.StartsWith($rootPrefix, [StringComparison]::OrdinalIgnoreCase)) { continue }
  if ($full -match '\\playbook\\state\\session-files\.txt$') { continue }
  if (-not (Test-Path -LiteralPath $full -PathType Leaf)) { continue }
  $rel = $full.Substring($rootPrefix.Length).Replace('\', '/')
  & $git -C $rootLong @gsafe -c core.quotepath=false check-ignore -q -- $rel 2>$null
  if ($LASTEXITCODE -eq 0) { continue }   # deliberately ignored: skip and drop from list
  $cand += $rel
}

$tmp = [IO.Path]::GetTempFileName()
$env:GIT_LITERAL_PATHSPECS = '1'   # not for check-ignore, which rejects pathspec magic
function Write-Pathspec($items) { [IO.File]::WriteAllText($tmp, (($items -join "`0") + "`0"), $utf8) }
try {
  $staged = @()
  if ($cand.Count -gt 0) {
    Write-Pathspec $cand
    & $git -C $rootLong @gsafe -c core.quotepath=false add "--pathspec-from-file=$tmp" --pathspec-file-nul 2>$null
    if ($LASTEXITCODE -eq 0) { $staged = $cand }
    else {
      $ok = $false   # keep the list so the next Stop retries
      foreach ($rel in $cand) {
        & $git -C $rootLong @gsafe -c core.quotepath=false add -- $rel 2>$null
        if ($LASTEXITCODE -eq 0) { $staged += $rel }
      }
    }
  }
  if ($staged.Count -gt 0) {
    $names = @(& $git -C $rootLong @gsafe -c core.quotepath=false diff --cached --name-only 2>$null)
    $changed = @($staged | Where-Object { $names -contains $_ })
    if ($changed.Count -gt 0) {
      Write-Pathspec $changed
      & $git -C $rootLong @gsafe -c core.quotepath=false commit -q -m ("auto-backup " + (Get-Date -Format 'yyyy-MM-dd HH:mm')) "--pathspec-from-file=$tmp" --pathspec-file-nul 2>$null
      if ($LASTEXITCODE -ne 0) { $ok = $false }
      else {
        $remote = & $git -C $rootLong @gsafe remote 2>$null
        if ($remote -contains 'origin') {
          $flag = Join-Path $root 'playbook\state\last-push-failed'
          & $git -C $rootLong @gsafe -c credential.interactive=never push -q origin HEAD 2>$null
          if ($LASTEXITCODE -eq 0) { Remove-Item -LiteralPath $flag -Force -ErrorAction SilentlyContinue }
          else { try { [IO.File]::WriteAllText($flag, (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $utf8) } catch { } }
        }
      }
    }
  }
} finally { Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue }
# Keep the list if anything failed so the next Stop retries.
if ($ok -and $hadList) { [IO.File]::WriteAllText($list, '', $utf8) }
exit 0
