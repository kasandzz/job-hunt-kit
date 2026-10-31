# Paste this / Pega esto / Įklijuokite tai

Send one of the three blocks below to the person (WhatsApp or email is fine). They:
1. install the Claude app and sign in (a paid Claude plan is needed for Code),
2. open the app, click **Code**, pick their **Documents** folder,
3. paste the block and press Enter. Claude does the rest.

Before sending: the KIT_URL placeholder (in double curly braces) appears three times, once in each block. Replace all three with the public GitHub repo address, for example `https://github.com/<owner>/<repo>`. Claude then downloads `<repo address>/archive/refs/heads/main.zip` (no git needed), unpacks it and runs the installer.

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
$d = Join-Path $env:TEMP ('job-hunt-kit-' + [guid]::NewGuid().ToString('N').Substring(0, 16)); New-Item -ItemType Directory -Path $d -ErrorAction Stop | Out-Null
$z = Join-Path $d 'kit.zip'
Invoke-WebRequest -UseBasicParsing -Uri $u -OutFile $z; Unblock-File -LiteralPath $z
$x = Join-Path $d 'kit'; Expand-Archive -LiteralPath $z -DestinationPath $x
$i = Get-ChildItem -LiteralPath $x -Recurse -Filter 'install.ps1' | Sort-Object { $_.FullName.Length } | Select-Object -First 1
& powershell -NoProfile -ExecutionPolicy Bypass -File $i.FullName -Language es-MX
"exit $LASTEXITCODE"
```

3. Antes de correrlo, avísame con palabras sencillas: puede tardar unos minutos; Windows puede mostrar un cuadro que dice "¿Quieres permitir que esta aplicación haga cambios en el dispositivo?" (a veces más de una vez, la pantalla se oscurece) y ahí le doy clic en **Sí**, porque son los programas del ayudante instalándose; y si sale un cuadro que dice "Todo listo", le doy clic en Aceptar.
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
$d = Join-Path $env:TEMP ('job-hunt-kit-' + [guid]::NewGuid().ToString('N').Substring(0, 16)); New-Item -ItemType Directory -Path $d -ErrorAction Stop | Out-Null
$z = Join-Path $d 'kit.zip'
Invoke-WebRequest -UseBasicParsing -Uri $u -OutFile $z; Unblock-File -LiteralPath $z
$x = Join-Path $d 'kit'; Expand-Archive -LiteralPath $z -DestinationPath $x
$i = Get-ChildItem -LiteralPath $x -Recurse -Filter 'install.ps1' | Sort-Object { $_.FullName.Length } | Select-Object -First 1
& powershell -NoProfile -ExecutionPolicy Bypass -File $i.FullName -Language en-GB
"exit $LASTEXITCODE"
```

3. Before you run it, warn me in plain words: it may take a few minutes; Windows may show a box asking "Do you want to allow this app to make changes to your device?" (sometimes more than once, and the screen goes darker), and I click **Yes**, because it is the helper's programs installing; and if a box says "All done", I click OK.
4. If it ends with "exit 0", it is nearly done. Tell me, one step per line: start a new chat in Code, pick the **My-Life** folder in Documents, and type **Start**. That is where the setup begins. Explain that this is needed because the rules that keep me safe only work inside that folder.
5. If something fails, don't show me the error. Tell me in one line that a piece didn't install and try once more. If it fails again, tell me to ask the person who sent me this.

---

## Lietuvių kalba

Labas, Claude. Paruoškite man pagalbininką darbui ieškoti. Kompiuterį moku naudoti nedaug: viską paaiškinkite paprastais žodžiais, po vieną žingsnį, ir niekada neprašykite manęs rašyti komandų.

1. Prieš kiekvieną leidimo langelį viena eilute pasakykite, kas tai yra ir kurį mygtuką spustelėti (dažniausiai „Allow“, tai reiškia „Leisti“).
2. Su PowerShell įrankiu paleiskite šį bloką tiksliai tokį, koks yra, su 10 minučių laukimo laiku. Jis atsisiunčia pagalbininko paketą iš GitHub (svetainės, kurioje laikomos programos) ir jį įdiegia:

```powershell
$ErrorActionPreference = 'Stop'
$u = 'https://github.com/kasandzz/job-hunt-kit'
$u = $u.Trim().TrimEnd('/'); if ($u -notmatch '\.zip$') { $u = $u + '/archive/refs/heads/main.zip' }
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$d = Join-Path $env:TEMP ('job-hunt-kit-' + [guid]::NewGuid().ToString('N').Substring(0, 16)); New-Item -ItemType Directory -Path $d -ErrorAction Stop | Out-Null
$z = Join-Path $d 'kit.zip'
Invoke-WebRequest -UseBasicParsing -Uri $u -OutFile $z; Unblock-File -LiteralPath $z
$x = Join-Path $d 'kit'; Expand-Archive -LiteralPath $z -DestinationPath $x
$i = Get-ChildItem -LiteralPath $x -Recurse -Filter 'install.ps1' | Sort-Object { $_.FullName.Length } | Select-Object -First 1
& powershell -NoProfile -ExecutionPolicy Bypass -File $i.FullName -Language lt-LT
"exit $LASTEXITCODE"
```

3. Prieš paleisdami, paprastais žodžiais mane perspėkite: tai gali užtrukti kelias minutes; Windows gali parodyti langelį, kuriame klausiama, ar leisti šiai programai atlikti pakeitimus jūsų įrenginyje (kartais ne vieną kartą, ekranas patamsėja), ir tada spustelėsiu **Taip**, nes tai diegiamos pagalbininko programos; o jei pasirodys langelis „Viskas paruošta“, spustelėsiu OK.
4. Jei pabaigoje parašyta „exit 0“, beveik viskas. Pasakykite man, po vieną žingsnį eilutėje: atidarykite naują pokalbį skiltyje Code, pasirinkite aplanką **Mano-Gyvenimas**, esantį aplanke Documents, ir parašykite **Pradėkime**. Ten prasideda paruošimas. Paaiškinkite, kad tai būtina, nes mane saugančios taisyklės veikia tik tame aplanke.
5. Jei kas nors nepavyksta, nerodykite man klaidos. Viena eilute pasakykite, kad kažkas neįsidiegė, ir pabandykite dar kartą. Jei vėl nepavyksta, pasakykite, kad paprašyčiau pagalbos žmogaus, kuris man tai atsiuntė.
