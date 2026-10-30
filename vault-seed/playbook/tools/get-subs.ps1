# get-subs.ps1 - download subtitles (never media) for one YouTube/Vimeo URL. Locked-down wrapper around yt-dlp.
param([Parameter(Mandatory)][string]$Url, [switch]$ValidateOnly)
$ErrorActionPreference = 'Stop'
$OutDir = Join-Path $env:TEMP 'pol-subs'
$pattern = '^https://(www\.|m\.)?(youtube\.com/(watch\?v=|shorts/)[A-Za-z0-9_-]{6,}|youtu\.be/[A-Za-z0-9_-]{6,}|vimeo\.com/\d+)([?&#][A-Za-z0-9_=&%.-]*)?\z'
if ($Url -notmatch $pattern) {
  [Console]::Error.WriteLine('Rejected: only plain https YouTube or Vimeo video links are allowed.')
  exit 2
}
if ($ValidateOnly) { exit 0 }
$exe = $null
$cmd = Get-Command yt-dlp -ErrorAction SilentlyContinue
if ($cmd) { $exe = $cmd.Source }
else {
  $alt = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links\yt-dlp.exe'
  if (Test-Path -LiteralPath $alt) { $exe = $alt }
}
if (-not $exe) { [Console]::Error.WriteLine('yt-dlp is not installed.'); exit 3 }
New-Item -ItemType Directory -Force $OutDir | Out-Null
$start = Get-Date
$ytArgs = @('--ignore-config', '--skip-download', '--write-subs', '--write-auto-subs', '--sub-langs', 'en.*,es.*', '--sub-format', 'vtt',
  '-o', (Join-Path $OutDir '%(id)s'), '--', $Url)
& $exe @ytArgs | Out-Null
Get-ChildItem -LiteralPath $OutDir -Filter *.vtt | Where-Object { $_.LastWriteTime -ge $start.AddSeconds(-2) } | ForEach-Object { $_.FullName }
exit 0
