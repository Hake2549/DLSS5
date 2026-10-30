param([ValidateSet('install','check','uninstall')][string]$Action = 'check')

$ErrorActionPreference = 'Stop'
$Root  = Split-Path (Split-Path $PSCommandPath -Parent) -Parent
$Files = Join-Path $Root 'files'

$MOD   = @('dxgi.dll','renodx-dlss5.addon64','nvngx_dlssnr.dll','ReShade.ini')
$EXTRA = @('ReShade.log','ReShadePreset.ini','ReShade.ini.bak','renodx-dlss5.log')

function Line { Write-Host ('-' * 68) -ForegroundColor DarkGray }
function Head($t) { Write-Host ''; Line; Write-Host "  $t" -ForegroundColor Cyan; Line }

function Find-Game {
    $cands = New-Object System.Collections.Generic.List[string]
    foreach ($sr in @("${env:ProgramFiles(x86)}\Steam", "$env:ProgramFiles\Steam")) {
        $vdf = Join-Path $sr 'steamapps\libraryfolders.vdf'
        if (Test-Path $vdf) {
            foreach ($m in [regex]::Matches((Get-Content $vdf -Raw), '"path"\s+"([^"]+)"')) {
                $cands.Add(($m.Groups[1].Value.Replace('\\','\')))
            }
        }
    }
    foreach ($d in (Get-PSDrive -PSProvider FileSystem)) {
        if ($d.Name -match '^[A-Za-z]$') { $cands.Add($d.Name + ':') }
    }
    $seen = @{}
    foreach ($c in $cands) {
        if (-not $c -or $seen[$c]) { continue }
        $seen[$c] = $true
        foreach ($sub in @(
            'steamapps\common\Wuthering Waves\Client\Binaries\Win64',
            'Wuthering Waves\Client\Binaries\Win64',
            'Wuthering Waves Game\Client\Binaries\Win64',
            'Epic Games\WutheringWaves\Client\Binaries\Win64'
        )) {
            $p = Join-Path $c $sub
            if (Test-Path (Join-Path $p 'Client-Win64-Shipping.exe')) { return $p }
        }
    }
    return $null
}

$Game = Find-Game
if (-not $Game) {
    Head 'Game folder not found'
    Write-Host '  Paste the folder that contains Client-Win64-Shipping.exe' -ForegroundColor Yellow
    Write-Host '  e.g. D:\SteamLibrary\steamapps\common\Wuthering Waves\Client\Binaries\Win64'
    Write-Host ''
    $Game = (Read-Host '  Path').Trim('"').Trim()
    if (-not (Test-Path (Join-Path $Game 'Client-Win64-Shipping.exe'))) {
        Write-Host '  Invalid - Client-Win64-Shipping.exe not found there' -ForegroundColor Red
        Read-Host '  Press Enter to close' | Out-Null; exit 1
    }
}

Head 'Game folder'
Write-Host "  $Game"

if (Get-Process 'Client-Win64-Shipping' -ErrorAction SilentlyContinue) {
    Write-Host ''
    Write-Host '  !! The game is running. Close it first, then run this again.' -ForegroundColor Red
    Read-Host '  Press Enter to close' | Out-Null; exit 1
}

switch ($Action) {

'install' {
    Head 'Installing'
    $missing = @($MOD | Where-Object { -not (Test-Path (Join-Path $Files $_)) })
    if ($missing.Count -gt 0) {
        Write-Host '  Pack is incomplete. Missing from files\ :' -ForegroundColor Red
        $missing | ForEach-Object { Write-Host "    $_" -ForegroundColor Red }
        Write-Host '  See README.txt section "FILES MISSING"' -ForegroundColor Yellow
        Read-Host '  Press Enter to close' | Out-Null; exit 1
    }
    foreach ($f in $MOD) {
        $dst = Join-Path $Game $f
        if ($f -eq 'ReShade.ini' -and (Test-Path $dst)) {
            Copy-Item $dst "$dst.bak" -Force
            Write-Host '  Backed up existing ReShade.ini -> ReShade.ini.bak' -ForegroundColor DarkYellow
        }
        Copy-Item (Join-Path $Files $f) $dst -Force
        Write-Host ("  [ OK ] {0,-24} {1,13:N0} bytes" -f $f, (Get-Item $dst).Length) -ForegroundColor Green
    }
    Head 'Done'
    Write-Host '  1) Launch the game'
    Write-Host '  2) Graphics settings -> Super Resolution = DLSS   (REQUIRED)'
    Write-Host '  3) Press Home -> Add-ons tab -> DLSS 5 Neural Rendering'
    Write-Host '  4) F6 toggles neural rendering on/off'
    Write-Host ''
    Write-Host '  READ README.txt FIRST - it covers the account-ban risk.' -ForegroundColor Yellow
}

'check' {
    Head 'Checking installation'
    $miss = 0
    foreach ($f in $MOD) {
        $p = Join-Path $Game $f
        if (Test-Path $p) {
            $i = Get-Item $p
            $v = $i.VersionInfo.FileVersion
            Write-Host ("  [ OK ] {0,-24} {1,13:N0} bytes  {2}" -f $f, $i.Length, $(if ($v) { "v$v" } else { '' })) -ForegroundColor Green
        } else {
            Write-Host ("  [MISS] {0}" -f $f) -ForegroundColor Red
            $miss++
        }
    }
    Write-Host ''
    $engine = Split-Path (Split-Path (Split-Path $Game -Parent) -Parent) -Parent
    $dlss = Get-ChildItem $engine -Recurse -Filter 'nvngx_dlss.dll' -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($dlss) { Write-Host "  [ OK ] Game ships its own nvngx_dlss.dll (v$($dlss.VersionInfo.FileVersion))" -ForegroundColor Green }
    else { Write-Host '  [WARN] Game nvngx_dlss.dll not found - enable DLSS in game settings' -ForegroundColor Yellow }

    $log = Join-Path $Game 'ReShade.log'
    if (Test-Path $log) {
        $txt = Get-Content $log -Raw -ErrorAction SilentlyContinue
        Write-Host ''
        Write-Host '  --- from last ReShade.log ---' -ForegroundColor DarkGray
        if ($txt -match 'Registered add-on "DLSS 5 Neural Rendering" v([^\s]+)') {
            Write-Host "  add-on loaded: v$($Matches[1])" -ForegroundColor Green
        } else { Write-Host '  add-on NOT loaded yet' -ForegroundColor Yellow }
        $ev = ([regex]::Matches($txt, 'inline feature 18 evaluation succeeded')).Count
        if ($ev -gt 0) { Write-Host "  feature 18 WORKING ($ev evaluations logged)" -ForegroundColor Green }
        elseif ($txt -match 'feature 18') { Write-Host '  feature 18 created but no successful evaluation' -ForegroundColor Yellow }
        if ($txt -match 'DXGI_ERROR_DEVICE_HUNG') { Write-Host '  WARNING: GPU hang recorded - see README "CRASHES"' -ForegroundColor Red }
    }
    Write-Host ''
    if ($miss -eq 0) { Write-Host '  >>> ALL FILES PRESENT' -ForegroundColor Green }
    else { Write-Host "  >>> $miss file(s) missing - run install.bat" -ForegroundColor Red }
}

'uninstall' {
    Head 'Uninstall'
    Write-Host '  Removes only the mod files. Game files are NOT touched.'
    Write-Host ''
    if ((Read-Host '  Type YES to continue') -ne 'YES') {
        Write-Host '  Aborted.'; Read-Host '  Press Enter to close' | Out-Null; exit 0
    }
    foreach ($f in ($MOD + $EXTRA)) {
        $p = Join-Path $Game $f
        if (Test-Path $p) { Remove-Item $p -Force -ErrorAction SilentlyContinue; Write-Host "  removed $f" -ForegroundColor DarkYellow }
    }
    foreach ($d in @('reshade-shaders','reshade-shaders-original','reshade-addons')) {
        $p = Join-Path $Game $d
        if (Test-Path $p) { Remove-Item $p -Recurse -Force -ErrorAction SilentlyContinue; Write-Host "  removed $d\" -ForegroundColor DarkYellow }
    }
    Write-Host ''
    Write-Host '  Game is back to stock.' -ForegroundColor Green
}

}

Write-Host ''
Read-Host '  Press Enter to close' | Out-Null
