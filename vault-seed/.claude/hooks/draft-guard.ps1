# draft-guard.ps1 - PreToolUse on Gmail create_draft / update_draft, plus second-layer block on send/share/trash tools. Fails closed.
$ErrorActionPreference = 'Stop'
function Normalize-Addr($a) {
  $a = "$a".Trim().ToLower()
  if ($a -match '^([^@]+)@(.+)$') {
    $l = $Matches[1]; $d = $Matches[2]
    if ($d -eq 'googlemail.com') { $d = 'gmail.com' }
    if ($d -eq 'gmail.com') { $l = ($l -split '\+')[0].Replace('.', '') }
    return "$l@$d"
  }
  return $a
}
function Get-Addrs($raw) {
  $out = @()
  foreach ($part in ("$raw" -split '[,;]')) {
    $p = $part.Trim()
    if ($p -eq '') { continue }
    $m = [regex]::Matches($p, '<([^>]*)>')
    if ($m.Count -gt 0) { foreach ($x in $m) { if ($x.Groups[1].Value.Trim() -ne '') { $out += (Normalize-Addr $x.Groups[1].Value) } } }
    else { $out += (Normalize-Addr $p) }
  }
  return $out
}
try {
  $in = [Console]::In.ReadToEnd() | ConvertFrom-Json
  if ($null -eq $in) { throw 'empty' }
  $name = "$($in.tool_name)"
  if ($name -match '__(send_message|reply|forward|trash_[a-z_]+|share_file|trash_file)$') {
    [Console]::Error.WriteLine('Blocked: sending email, sharing files and trashing items are never done by Claude. Make a draft or tell the user what to do by hand.')
    exit 2
  }
  if ($name -like '*update_draft') {
    [Console]::Error.WriteLine('Do not update drafts: it detaches them from the email thread. Create a new draft instead, then delete the old one with delete_draft.')
    exit 2
  }
  if ($name -notlike '*create_draft') { exit 0 }
  $to = @()
  foreach ($e in @($in.tool_input.to)) { if ($e) { $to += @(Get-Addrs $e) } }
  if ($to.Count -eq 0) {
    [Console]::Error.WriteLine('Draft blocked: no recipient. Set the To address explicitly and show it to the user before saving.')
    exit 2
  }
  $root = $env:CLAUDE_PROJECT_DIR
  if (-not $root) { $root = (Get-Location).Path }
  $ownerFile = Join-Path $root 'playbook\state\owner.json'
  # D-26: packs ship without an address. No owner.json, or no email in it, means setup is unfinished: fail closed.
  $setupMsg = 'Draft blocked: finish setting up your email address first (ask: set up my email).'
  if (-not (Test-Path -LiteralPath $ownerFile)) { [Console]::Error.WriteLine($setupMsg); exit 2 }
  $ownerJson = $null
  try { $ownerJson = Get-Content -LiteralPath $ownerFile -Raw | ConvertFrom-Json } catch { [Console]::Error.WriteLine('Blocked: could not read the owner settings.'); exit 2 }
  if ($null -eq $ownerJson) { [Console]::Error.WriteLine('Blocked: could not read the owner settings.'); exit 2 }
  $owner = Normalize-Addr $ownerJson.email
  if (-not $owner -or $owner -notmatch '^[^@\s]+@[^@\s]+$') { [Console]::Error.WriteLine($setupMsg); exit 2 }
  foreach ($t in $to) {
    if ($t -eq $owner) {
      [Console]::Error.WriteLine("Draft blocked: it is addressed to the user's own email. For a reply, set To to the original sender explicitly, show the full draft and the To line to the user, then try again.")
      exit 2
    }
  }
  exit 0
} catch {
  [Console]::Error.WriteLine('Blocked: could not read the request.')
  exit 2
}
