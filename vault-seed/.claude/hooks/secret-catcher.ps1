# secret-catcher.ps1 - PostToolUse Write|Edit. Masks secrets in the written file.
$ErrorActionPreference = 'Stop'
try {
  $in = [Console]::In.ReadToEnd() | ConvertFrom-Json
  $path = $in.tool_input.file_path
  if (-not $path -or -not (Test-Path -LiteralPath $path -PathType Leaf)) { exit 0 }
  if ($path -notmatch '\.(md|txt)$') { exit 0 }
  $text = [IO.File]::ReadAllText($path)
} catch { exit 0 }
$orig = $text
$MASK = '[hidden]'
function Test-Luhn([string]$d) {
  $sum = 0; $alt = $false
  for ($i = $d.Length - 1; $i -ge 0; $i--) {
    $n = [int][string]$d[$i]
    if ($alt) { $n *= 2; if ($n -gt 9) { $n -= 9 } }
    $sum += $n; $alt = -not $alt
  }
  return ($sum % 10 -eq 0)
}
function Test-Clabe([string]$d) {
  if ($d.Length -ne 18) { return $false }
  $w = 3,7,1; $s = 0
  for ($i = 0; $i -lt 17; $i++) { $s += ([int][string]$d[$i] * $w[$i % 3]) % 10 }
  return (((10 - ($s % 10)) % 10) -eq [int][string]$d[17])
}
# Not a secret: the kit's own placeholder in any language ("(private, not saved)", "(privado, no guardado)"),
# anything already hidden, and plain answers about whether they know it ("yes", "si", "no", "la sabe").
# Without this the kit's own placeholder raised a false "password hidden" alarm (sandbox test 2026-10-30).
function Test-NotSecret([string]$v) {
  $t = $v.Trim().Trim([char]96, [char]34, [char]39, [char]42, [char]95).Trim()
  # Only the exact placeholders the kit writes (en, es, lt); any other bracketed text is still hidden.
  $ph = @('[hidden]', '(private, not saved)', '(privado, no guardado)', ('(privatu, nei' + [char]0x161 + 'saugota)'))
  if ($ph -contains $t.TrimEnd('.')) { return $true }
  return ($t -match ('(?i)^(yes|no|si|s' + [char]0xED + '|known|unknown|knows it|sabe|la sabe|no la sabe|ok|n/a|none|ninguna|taip|ne|-)$'))
}
# password-like lines: keep the label, hide the value. Separators : = - es is.
# Value stops at | or ** (table cells, markdown bold) and never swallows the CR of CRLF.
$text = [regex]::Replace($text, '(?im)^([^\r\n]*\b(?:password|passcode|pin|nip|contrase.a|slapta.odis|clave (?:de acceso|secreta|del banco|bancaria))\b[*_]*[ \t]*(?:[:=-]|\bes\b|\bis\b)[*_]*[ \t]*)(\S(?:(?!\*\*)[^|\r\n])*?)(?=[ \t]*(?:\*\*|\||\r|\n|\z))', { param($m) if (Test-NotSecret $m.Groups[2].Value) { $m.Value } else { $m.Groups[1].Value + $MASK } })
# bare PIN / NIP followed by 4-6 digits
$text = [regex]::Replace($text, '(?i)\b((?:pin|nip)[ \t]+)\d{4,6}\b', { param($m) $m.Groups[1].Value + $MASK })
# UK sort code / account
$text = [regex]::Replace($text, '(?i)(\bsort\s*code\D{0,10})\d{2}[ -]?\d{2}[ -]?\d{2}(?!\d)', { param($m) $m.Groups[1].Value + $MASK })
$text = [regex]::Replace($text, '(?i)(\baccount(?:\s*(?:no\.?|number))?(?![a-z])\D{0,15})\d{8}\b', { param($m) $m.Groups[1].Value + $MASK })
# CLABE (18 digits or 3-3-11-1), Amex (4-6-5), cards (grouped 4s, 16-19 digits); checksum / Luhn checked
$text = [regex]::Replace($text, '(?<![\d+])(?:\d{3}[ -]?\d{3}[ -]?\d{11}[ -]?\d|\d{4}[ -]?\d{6}[ -]?\d{5}|\d{4}(?:[ -]?\d{4}){2,3}\d{0,3})(?!\d)', {
  param($m)
  $d = $m.Value -replace '[ -]', ''
  if (($d.Length -ge 13 -and $d.Length -le 19 -and (Test-Luhn $d)) -or (Test-Clabe $d)) { return $MASK }
  return $m.Value
})
if ($text -ne $orig) {
  [IO.File]::WriteAllText($path, $text, (New-Object Text.UTF8Encoding $false))
  [Console]::Error.WriteLine("A private number or password was hidden in $path. Tell the user, in their language and in one short sentence, that it was hidden for safety and that passwords belong in a password manager such as Bitwarden, not in notes. If the user says it was not private, put the original text back.")
  exit 2
}
exit 0
