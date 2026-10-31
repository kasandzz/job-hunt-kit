# run-guard.ps1 - PreToolUse on Bash / PowerShell. Fails closed.
# Running scripts or other programs is off in this notebook, except the notebook's own tools, run in their exact
# documented form. Writing files with a command is off too (notes are written with the Write and Edit tools, which
# the write guard checks). Sandbox test 2026-10-30: a .ps1 only raised a permission box, and helpers wrote notes
# with cat/printf/Add-Content, which showed raw commands in boxes. Other commands pass to the normal permission
# rules. The deny rules in settings.json stay as a second layer. ASCII only.
$ErrorActionPreference = 'Stop'
function Block($why, $msg) { [Console]::Error.WriteLine("$msg ($why)"); exit 2 }
$RunMsg = 'Blocked: running scripts or programs is switched off in this notebook, except its own tools in their exact form. Do not try another way, and never ask the person to allow it, to run it themselves or to have anyone change the settings. Tell them in plain words what you wanted to do, and carry on without it.'
$WriteMsg = 'Blocked: notes are written only with the Write and Edit tools, never with a command. Make the same change with the Write or Edit tool instead. If they ask, say plainly that the notebook only lets notes be written that way.'
try {
  $raw = [Console]::In.ReadToEnd()
  $in = $raw | ConvertFrom-Json
  $cmd = "$($in.tool_input.command)"
  if (-not $cmd.Trim()) { exit 0 }
  # 0. Before any match: no look-alike quotes or dashes, no odd spaces or line breaks, no backtick, no $( anywhere.
  if ($cmd -match '[\u2010-\u2015\u2018-\u201F\u00A0\u2028\u2029\u0085\u200B-\u200D\u2060\uFEFF`]|\$\(') { Block 'unusual characters in the command' $RunMsg }
  $c = ($cmd -replace '\s+', ' ').Trim()

  # 1. The notebook's own tools, exact forms only (either slash, optional .\ and .exe). Arguments are plain.
  # Quoted text holds only letters (any language, accents included), digits, space and . , - _ : / \ ' ! ?
  $sf = "[\p{L}\p{N} .,_:/\\'!?-]"
  $ps = '^powershell(?:\.exe)? -NoProfile -ExecutionPolicy Bypass -File (?:\.[\\/])?'
  $url = '(?:"https://[A-Za-z0-9._~:/?#=%&+-]{1,400}"|https://[A-Za-z0-9._~:/?#=%+-]{1,400})'
  $note = '(?:"' + $sf + '{1,200}\.md"|[A-Za-z0-9._/\\-]{1,200}\.md)'
  $own = @(
    ($ps + 'playbook[\\/]help-bundle\.ps1$'),
    ($ps + 'playbook[\\/]tools[\\/]install-planner\.ps1$'),
    ($ps + 'playbook[\\/]tools[\\/]get-subs\.ps1 -Url ' + $url + '(?: -ValidateOnly)?$'),
    ($ps + 'playbook[\\/]tools[\\/]make-cv-files\.ps1 -Note ' + $note + '$')
  )
  foreach ($o in $own) { if ($c -cmatch $o) { exit 0 } }
  # git and gh: only the exact commands the kit's stage and helper files give. Everything else (any other
  # subcommand or flag, --output, -c, --exec, --upload-pack, clone, pull, fetch, checkout, apply, download...) blocks.
  $nm = '[A-Za-z0-9._-]{1,100}'; $us = '[A-Za-z0-9-]{1,39}'; $cn = '(?:origin|backup-unchecked)'
  $qt = '"' + $sf + '{1,200}"'
  $pa = '(?:"' + $sf + '{1,300}"|[\p{L}\p{N}_/\\][\p{L}\p{N}._/\\-]{0,299})'
  $gitOk = @('^git --version$', '^git status(?: --short| -s| --porcelain)?$', '^git init$', '^git remote$', '^git log -1 --oneline$',
    '^git config core\.quotepath(?: false)?$', ('^git config user\.name ' + $qt + '$'), '^git config user\.email "[A-Za-z0-9._%+-]{1,64}@[A-Za-z0-9.-]{1,120}"$',
    ('^git add (?:-- )?' + $pa + '(?: ' + $pa + '){0,200}$'), ('^git commit -m ' + $qt + '$'),
    ('^git remote add backup-unchecked https://github\.com/' + $us + '/' + $nm + '$'),
    '^git remote rename (?:origin backup-unchecked|backup-unchecked origin)$', ('^git remote get-url ' + $cn + '$'),
    ('^git ls-remote ' + $cn + '$'), '^git push -u origin HEAD$')
  $ghOk = @('^gh auth status$', '^gh auth login --web --hostname github\.com --git-protocol https$', '^gh auth setup-git$',
    ('^gh repo view(?: ' + $nm + ')? --json (visibility|url|nameWithOwner) -q \.\1$'),
    ('^gh repo create ' + $nm + ' --private --source \. --remote backup-unchecked$'),
    ('^gh api users/' + $us + ' --jq "\[\.login, \.name\] \| @tsv"$'),
    ('^gh api -X PUT repos/' + $us + '/' + $nm + '/collaborators/' + $us + ' -f permission=pull$'),
    ('^gh api -X DELETE repos/' + $us + '/' + $nm + '/collaborators/' + $us + '$'))
  foreach ($o in ($gitOk + $ghOk)) { if ($c -cmatch $o) { exit 0 } }
  # Opening a web page, the Obsidian notebook or Chrome on a web page is fine (no program of the person's choosing).
  if ($c -match '^Start-Process (?:chrome )?"(?:https://|obsidian://open\?path=)[A-Za-z0-9._~:/?#=%+-]{1,800}"$') { exit 0 }

  # Installing one of the kit's own programs, in the exact form stage 1 uses.
  if ($c -cmatch '^winget install --id (?:Google\.Chrome|GitHub\.cli|Git\.Git|Obsidian\.Obsidian|yt-dlp\.yt-dlp|OpenJS\.NodeJS\.LTS|Anthropic\.Claude|astral-sh\.uv) --exact --silent --accept-package-agreements --accept-source-agreements$') { exit 0 }
  # From here on && and || count as plain separators, so a lone & is the call operator (or Bash's background).
  $c = $c.Replace('&&', ';').Replace('||', ';')
  # A command word: at the start, or after ; & | ( $( { or a backtick.
  $at = '(?:^|[;&|(`{]\s*|\$\(\s*)'

  # Output thrown away is fine (2>&1, 2>$null, >/dev/null); every other > writes a file.
  $c = [regex]::Replace($c, '(?i)[0-9*]?>{1,2}\s*(?:\$null|/dev/null|nul\b)|[0-9]?>&[0-9]', ' ')
  # 2. Writing files with a command: redirects to a file, and the commands that write, copy or move files.
  $redir = '>'
  $writers = '(?i)' + $at + '(?:add-content|set-content|out-file|tee-object|tee|new-item|ni|copy-item|cpi|cp|copy|xcopy|robocopy|move-item|mi|mv|move|rename-item|rni|ren|rename|sc|ac|truncate|dd|install|touch|mkdir|md|new-itemproperty|set-itemproperty)(?:\.exe)?(?=$|[\s;&|)])'
  if ($c -match $redir -or $c -match $writers -or $c -match '(?i)\|\s*(?:tee|out-file|set-content|add-content)\b|\[IO\.File\]::|System\.IO\.File|WriteAll(?:Text|Lines|Bytes)|\bsed\s+-i|\bperl\s+-[a-z]*i') { Block 'file write by command' $WriteMsg }

  # 3. Running scripts or other programs.
  $exts = '(?i)\.(?:ps1|psm1|psd1|ps1xml|bat|cmd|vbs|vbe|js|jse|mjs|cjs|wsf|wsh|hta|py|pyw|pyz|sh|bash|zsh|msi|msp|msc|scr|reg|lnk|url|jar|cpl|inf|appx|msix)\b'
  $progs = '(?i)' + $at + '(?:powershell|pwsh|cmd|cscript|wscript|mshta|rundll32|regsvr32|regsvcs|regasm|installutil|msbuild|node|npx|npm|pnpm|yarn|bun|deno|python3?|py|pip|pipx|uvx?|bash|sh|zsh|wsl|msiexec|java|perl|ruby|php|winget|choco|scoop|curl|wget|bitsadmin|certutil|schtasks|at|sc|reg|forfiles|explorer|start|call|invoke-expression|iex|invoke-command|icm|invoke-item|ii|start-job|start-threadjob|start-process|saps|add-type|import-module|ipmo|set-executionpolicy|register-scheduledtask|new-scheduledtask|set-alias|new-alias|invoke-webrequest|iwr|invoke-restmethod|irm|start-bitstransfer|env|exec|eval|source|xargs|nohup)(?:\.exe)?(?=$|[\s;&|)"''])'
  $calls = '(?i)' + $at + '(?:&|\.)\s*(?:["''$({]|[A-Za-z]:|\.{1,2}[\\/]|\w)|' + $at + '["'']?(?:\.{1,2}[\\/]|[A-Za-z]:[\\/]|[\\/])|\[scriptblock\]|\s-enc(?:odedcommand)?\b|\s-e\s+[A-Za-z0-9+/=]{16,}'
  if ($c -match $exts -or $c -match $progs -or $c -match $calls) { Block 'program or script' $RunMsg }
  # Inner commands ($(...), backticks, <(...), ${...}) are never needed by the kit.
  if ($c -match '\$\(|`|<\(|\$\{') { Block 'program or script' $RunMsg }
  # Every command word must be one the kit uses for reading or for git, gh and Obsidian; any other program blocks.
  $okHeads = @('git','gh','obsidian','where','where.exe','cd','set-location','sl','pwd','get-location','ls','dir','get-childitem','gci',
    'get-content','gc','cat','type','head','tail','select-string','sls','grep','findstr','get-item','gi','test-path','get-timezone',
    'get-date','date','resolve-path','split-path','join-path','measure-object','measure','sort-object','select-object','select',
    'where-object','?','foreach-object','%','format-table','ft','format-list','fl','out-null','out-string','echo','write-output',
    'write-host','wc','get-command','gcm','whoami','hostname','convertfrom-json','convertto-json','get-filehash','true')
  # Quoted text is data, not a command: set it aside so ; | & inside quotes do not split a command.
  $qs = New-Object System.Collections.Generic.List[string]
  $one = [string][char]1
  $tok = [regex]::Replace($c, '"[^"]*"|''[^'']*''', { param($m) $qs.Add($m.Value); $one + ($qs.Count - 1) + $one })
  foreach ($seg in ($tok -split '[;|&(){}\r\n]')) {
    $t = $seg.Trim(); if (-not $t) { continue }
    $head = ($t -split '\s+')[0].ToLowerInvariant()
    if ($okHeads -notcontains $head) { Block "program or script: $head" $RunMsg }
    $full = [regex]::Replace($t, ($one + '(\d+)' + $one), { param($m) $qs[[int]$m.Groups[1].Value] })
    $full = ($full -replace '\s+', ' ').Trim()
    if ($head -eq 'git' -or $head -eq 'gh') {
      $list = $gitOk; if ($head -eq 'gh') { $list = $ghOk }
      $hit = $false; foreach ($o in $list) { if ($full -cmatch $o) { $hit = $true; break } }
      if (-not $hit) { Block "git or gh command not on the notebook's list" $RunMsg }
    }
  }
  # Obsidian can run code through some of its commands.
  if ($c -match '(?i)\bobsidian\s+(?:eval|command|dev\S*|devtools|plugin\S*|theme\S*|snippet\S*)') { Block 'program or script' $RunMsg }
  exit 0
} catch {
  Block 'the safety check could not read the command' $RunMsg
}
