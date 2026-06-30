param(
    [string]$OutDir = (Join-Path (Split-Path $PSScriptRoot -Parent) "docs\screenshots"),
    [string]$FileName = "main.png",
    [int]$WaitSeconds = 6
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WinCap {
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr hWnd, out RECT r);
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
  [StructLayout(LayoutKind.Sequential)] public struct RECT { public int Left, Top, Right, Bottom; }
}
"@

$root = Split-Path $PSScriptRoot -Parent
$ahk = "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe"
$script = Join-Path $root "HelldiversMenuVisual.ahk"

if (-not (Test-Path $ahk)) { throw "AutoHotkey v2 not found: $ahk" }
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

Get-Process AutoHotkey* -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Milliseconds 800

$proc = Start-Process $ahk -ArgumentList "`"$script`"" -PassThru
Start-Sleep -Seconds $WaitSeconds

$hwnd = [IntPtr]::Zero
for ($i = 0; $i -lt 30; $i++) {
    $proc.Refresh()
    if ($proc.MainWindowHandle -ne [IntPtr]::Zero) {
        $hwnd = $proc.MainWindowHandle
        break
    }
    Get-Process | Where-Object { $_.MainWindowTitle -match "Helldivers|Stratagem|HELLDIVERS" } | ForEach-Object {
        $hwnd = $_.MainWindowHandle
    }
    if ($hwnd -ne [IntPtr]::Zero) { break }
    Start-Sleep -Milliseconds 500
}

if ($hwnd -eq [IntPtr]::Zero) { throw "App window not found" }

[WinCap]::SetForegroundWindow($hwnd) | Out-Null
Start-Sleep -Milliseconds 900

$rect = New-Object WinCap+RECT
[WinCap]::GetWindowRect($hwnd, [ref]$rect) | Out-Null
$w = $rect.Right - $rect.Left
$h = $rect.Bottom - $rect.Top

$bmp = New-Object System.Drawing.Bitmap $w, $h
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.CopyFromScreen($rect.Left, $rect.Top, 0, 0, (New-Object System.Drawing.Size($w, $h)))

$outPath = Join-Path $OutDir $FileName
$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()

Write-Host "Saved $outPath ($w x $h)"
