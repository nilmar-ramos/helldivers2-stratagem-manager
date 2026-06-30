# Compila HelldiversMenuVisual.ahk e monta pasta dist/ para distribuição.
# Requer AutoHotkey v2 instalado.

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
$dist = Join-Path $root "dist"
$mainAhk = Join-Path $root "HelldiversMenuVisual.ahk"
$outExe = Join-Path $dist "Helldivers2-Stratagems.exe"
$outTmp = Join-Path $dist "Helldivers2-Stratagems.build.exe"

function Find-Ahk2Exe {
    foreach ($path in @(
        "$env:ProgramFiles\AutoHotkey\Compiler\Ahk2Exe.exe",
        "${env:ProgramFiles(x86)}\AutoHotkey\Compiler\Ahk2Exe.exe",
        "$env:LocalAppData\Programs\AutoHotkey\Compiler\Ahk2Exe.exe"
    )) {
        if (Test-Path $path) { return $path }
    }
    return $null
}

function Find-AhkBase {
    foreach ($path in @(
        "$env:ProgramFiles\AutoHotkey\v2\AutoHotkey64.exe",
        "$env:ProgramFiles\AutoHotkey\v2\AutoHotkey32.exe",
        "$env:LocalAppData\Programs\AutoHotkey\v2\AutoHotkey64.exe"
    )) {
        if (Test-Path $path) { return $path }
    }
    return $null
}

$ahk2exe = Find-Ahk2Exe
$base = Find-AhkBase

if (-not $ahk2exe) {
    throw "Ahk2Exe não encontrado. Instale AutoHotkey v2: https://www.autohotkey.com/"
}
if (-not $base) {
    throw "AutoHotkey64.exe não encontrado. Reinstale AutoHotkey v2."
}
if (-not (Test-Path $mainAhk)) {
    throw "Arquivo não encontrado: $mainAhk"
}

New-Item -ItemType Directory -Force -Path $dist | Out-Null

# .exe em uso impede sobrescrever — fecha instância anterior
Get-Process -Name "Helldivers2-Stratagems" -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Milliseconds 300

if (Test-Path $outTmp) { Remove-Item $outTmp -Force -ErrorAction SilentlyContinue }

Write-Host "Compilando..." -ForegroundColor Cyan
Write-Host "  Ahk2Exe: $ahk2exe"
Write-Host "  Base:    $base"

$log = & $ahk2exe /in $mainAhk /out $outTmp /base $base 2>&1 | Out-String
if ($log.Trim()) { Write-Host $log }

Start-Sleep -Milliseconds 200

if (-not (Test-Path $outTmp)) {
    Write-Host "Tentando compilação sem /base explícito..." -ForegroundColor Yellow
    $log2 = & $ahk2exe /in $mainAhk /out $outTmp 2>&1 | Out-String
    if ($log2.Trim()) { Write-Host $log2 }
    Start-Sleep -Milliseconds 200
}

if (-not (Test-Path $outTmp)) {
    throw @"
Falha na compilação.

Possíveis causas:
  - Helldivers2-Stratagems.exe ainda aberto (feche com F12)
  - Antivírus bloqueou o arquivo
  - AutoHotkey v2 incompleto ou corrompido

Saída do compilador:
$log
"@
}

if (Test-Path $outExe) { Remove-Item $outExe -Force }
Move-Item $outTmp $outExe -Force

$iconsSrc = Join-Path $root "icons"
$iconsDst = Join-Path $dist "icons"
if (Test-Path $iconsSrc) {
    if (Test-Path $iconsDst) { Remove-Item $iconsDst -Recurse -Force }
    Copy-Item $iconsSrc $iconsDst -Recurse -Force
}

$readme = @"
Helldivers 2 — Gerenciador de Estratégias
=========================================

Como usar
---------
1. Execute Helldivers2-Stratagems.exe
2. F6 = janela principal | F7 = bindings | F8 = pausar | F12 = sair
3. Duplo-clique numa estratégia para associar tecla do Numpad
4. Os arquivos config.ini, bindings.ini e stratagems.ini são criados nesta pasta na primeira execução

Requisitos
----------
- Windows 10/11
- NÃO precisa instalar AutoHotkey (já está embutido no .exe)
- Helldivers 2 (opcional: ativação automática da janela do jogo)

Distribuição
------------
Pode zipar esta pasta inteira e compartilhar.
Mantenha o .exe na mesma pasta dos .ini gerados (não mova só o exe sem os configs).
"@
Set-Content -Path (Join-Path $dist "LEIA-ME.txt") -Value $readme -Encoding UTF8

$zip = Join-Path $root "Helldivers2-Stratagems.zip"
if (Test-Path $zip) { Remove-Item $zip -Force }

# Empacota exe + leia-me + icons (nao inclui .ini pessoais do dev)
$zipItems = @(
    $outExe,
    (Join-Path $dist "LEIA-ME.txt"),
    $iconsDst
) | Where-Object { $_ -and (Test-Path $_) }
Compress-Archive -Path $zipItems -DestinationPath $zip -Force

Write-Host ""
Write-Host "Pronto!" -ForegroundColor Green
Write-Host "  Pasta: $dist"
Write-Host "  ZIP:   $zip"
Write-Host ""
Get-ChildItem $outExe, (Join-Path $dist "LEIA-ME.txt"), $iconsDst -ErrorAction SilentlyContinue |
    Format-Table Name, Length -AutoSize
