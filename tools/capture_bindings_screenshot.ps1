param(
    [string]$OutDir = (Join-Path (Split-Path $PSScriptRoot -Parent) "docs\screenshots"),
    [string]$FileName = "bindings.png"
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing
Add-Type @"
using System;
using System.Text;
using System.Collections.Generic;
using System.Runtime.InteropServices;
public class WinCap {
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr hWnd, out RECT r);
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint pid);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetWindowText(IntPtr hWnd, StringBuilder sb, int max);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr hWnd);
  public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);
  [StructLayout(LayoutKind.Sequential)] public struct RECT { public int Left, Top, Right, Bottom; }
  public static string GetTitle(IntPtr h) {
    var sb = new StringBuilder(512);
    GetWindowText(h, sb, 512);
    return sb.ToString();
  }
  public static List<IntPtr> VisibleWindowsForPid(uint pid) {
    var list = new List<IntPtr>();
    EnumWindows((h, p) => {
      uint wpid;
      GetWindowThreadProcessId(h, out wpid);
      if (wpid == pid && IsWindowVisible(h)) list.Add(h);
      return true;
    }, IntPtr.Zero);
    return list;
  }
}
"@

function Save-WindowShot([IntPtr]$hwnd, [string]$outPath) {
    [WinCap]::SetForegroundWindow($hwnd) | Out-Null
    Start-Sleep -Milliseconds 900
    $rect = New-Object WinCap+RECT
    [WinCap]::GetWindowRect($hwnd, [ref]$rect) | Out-Null
    $w = $rect.Right - $rect.Left
    $h = $rect.Bottom - $rect.Top
    if ($w -lt 200 -or $h -lt 200) { throw "Window too small (${w}x${h}), wrong target?" }
    $bmp = New-Object System.Drawing.Bitmap $w, $h
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.CopyFromScreen($rect.Left, $rect.Top, 0, 0, (New-Object System.Drawing.Size($w, $h)))
    $bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose()
    Write-Host "Saved $outPath (${w}x${h}) title=$([WinCap]::GetTitle($hwnd))"
}

function Find-WindowByTitle([uint32]$processId, [string]$pattern) {
    foreach ($hwnd in [WinCap]::VisibleWindowsForPid($processId)) {
        $title = [WinCap]::GetTitle($hwnd)
        if ($title -match $pattern) { return $hwnd }
    }
    return [IntPtr]::Zero
}

$root = Split-Path $PSScriptRoot -Parent
$ahk = "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe"
$script = Join-Path $root "HelldiversMenuVisual.ahk"
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

Get-Process AutoHotkey* -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Milliseconds 800

$proc = Start-Process $ahk -ArgumentList "`"$script`"" -PassThru
Start-Sleep -Seconds 6

$mainHwnd = [IntPtr]::Zero
for ($i = 0; $i -lt 30; $i++) {
    $mainHwnd = Find-WindowByTitle $proc.Id "Stratagem Manager|Gerenciador de Estrat"
    if ($mainHwnd -ne [IntPtr]::Zero) { break }
    Start-Sleep -Milliseconds 500
}
if ($mainHwnd -eq [IntPtr]::Zero) { throw "Main window not found (pid $($proc.Id))" }

[WinCap]::SetForegroundWindow($mainHwnd) | Out-Null
Start-Sleep -Milliseconds 600

# F7 = global hotkey in the AHK script
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait("{F7}")
Start-Sleep -Seconds 2

$bindHwnd = [IntPtr]::Zero
for ($i = 0; $i -lt 20; $i++) {
    $bindHwnd = Find-WindowByTitle $proc.Id "^Bindings"
    if ($bindHwnd -ne [IntPtr]::Zero) { break }
    Start-Sleep -Milliseconds 400
}
if ($bindHwnd -eq [IntPtr]::Zero) {
    $titles = [WinCap]::VisibleWindowsForPid([uint32]$proc.Id) | ForEach-Object { [WinCap]::GetTitle($_) }
    throw "Bindings window not found. Visible: $($titles -join ' | ')"
}

$outPath = Join-Path $OutDir $FileName
Save-WindowShot $bindHwnd $outPath

Get-Process -Id $proc.Id -ErrorAction SilentlyContinue | Stop-Process -Force
