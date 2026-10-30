# Paste this / Pega esto

Send one of the two blocks below to the person (WhatsApp or email is fine). They:
1. install the Claude app and sign in (a paid Claude plan is needed for Code),
2. open the app, click **Code**, pick their **Documents** folder,
3. paste the block and press Enter. Claude does the rest.

Before sending: the KIT_URL placeholder (in double curly braces) appears twice, once in each block. Replace both with the public GitHub repo address, for example `https://github.com/<owner>/<repo>`. Claude then downloads `<repo address>/archive/refs/heads/main.zip` (no git needed), unpacks it and runs the installer.

---

## Español (México)

Hola Claude. Quiero que me prepares mi ayudante para buscar trabajo. No sé usar bien la computadora: explícame todo con palabras sencillas, un paso a la vez, y nunca me pidas escribir comandos.

1. Antes de cada aviso de permiso, dime en una línea qué es y qué botón tocar (casi siempre "Permitir" o "Allow").
2. Con la herramienta de PowerShell, corre este bloque tal cual, con un tiempo de espera de 10 minutos. Baja el paquete del ayudante desde GitHub (una página donde se guardan programas) y lo instala:

```powershell
$ErrorActionPreference = 'Stop'
$u = 'https://github.com/kasandzz/job-hunt-kit'
$u = $u.Trim().TrimEnd('/'); if ($u -notmatch '\.zip$') { $u = $u + '/archive/refs/heads/main.zip' }
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$d = 'C:\tmp\job-hunt-kit'; New-Item -ItemType Directory -Force $d | Out-Null
$z = Join-Path $d 'kit.zip'
Invoke-WebRequest -UseBasicParsing -Uri $u -OutFile $z; Unblock-File -LiteralPath $z
$x = Join-Path $d ('kit-' + (Get-Date -Format 'yyyyMMddHHmmss')); Expand-Archive -LiteralPath $z -DestinationPath $x
$i = Get-ChildItem -LiteralPath $x -Recurse -Filter 'install.ps1' | Sort-Object { $_.FullName.Length } | Select-Object -First 1
& powershell -NoProfile -ExecutionPolicy Bypass -File $i.FullName -Language es-MX
"exit $LASTEXITCODE"
```

3. Mientras se instala, dime que puede tardar unos minutos y que, si sale un cuadro que dice "Todo listo", le dé clic en Aceptar.
4. Si termina con "exit 0", ya casi está. Dime, un paso por línea: abre una conversación nueva en Code, escoge la carpeta **Mi-Vida** que está en Documentos, y escribe **Empieza**. Ahí empieza la preparación. Explícame que es necesario porque las reglas que me cuidan solo funcionan dentro de esa carpeta.
5. Si algo falla, no me enseñes el error. Dime en una línea que algo no se instaló y vuelve a intentar una vez. Si falla otra vez, dime que le pida ayuda a quien me mandó esto.

---

## English (UK)

Hello Claude. Please set up my job-search helper. I'm not good with computers: explain everything in plain words, one step at a time, and never ask me to type commands.

1. Before each permission box, tell me in one line what it is and which button to click (usually "Allow").
2. With the PowerShell tool, run this block exactly as it is, with a 10-minute timeout. It downloads the helper kit from GitHub (a website where programs are kept) and installs it:

```powershell
$ErrorActionPreference = 'Stop'
$u = 'https://github.com/kasandzz/job-hunt-kit'
$u = $u.Trim().TrimEnd('/'); if ($u -notmatch '\.zip$') { $u = $u + '/archive/refs/heads/main.zip' }
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$d = 'C:\tmp\job-hunt-kit'; New-Item -ItemType Directory -Force $d | Out-Null
$z = Join-Path $d 'kit.zip'
Invoke-WebRequest -UseBasicParsing -Uri $u -OutFile $z; Unblock-File -LiteralPath $z
$x = Join-Path $d ('kit-' + (Get-Date -Format 'yyyyMMddHHmmss')); Expand-Archive -LiteralPath $z -DestinationPath $x
$i = Get-ChildItem -LiteralPath $x -Recurse -Filter 'install.ps1' | Sort-Object { $_.FullName.Length } | Select-Object -First 1
& powershell -NoProfile -ExecutionPolicy Bypass -File $i.FullName -Language en-GB
"exit $LASTEXITCODE"
```

3. While it installs, tell me it may take a few minutes and that if a box says "All done", I click OK.
4. If it ends with "exit 0", it is nearly done. Tell me, one step per line: start a new chat in Code, pick the **My-Life** folder in Documents, and type **Start**. That is where the setup begins. Explain that this is needed because the rules that keep me safe only work inside that folder.
5. If something fails, don't show me the error. Tell me in one line that a piece didn't install and try once more. If it fails again, tell me to ask the person who sent me this.
