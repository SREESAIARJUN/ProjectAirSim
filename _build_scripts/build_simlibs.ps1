Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Write-Host '=== Setting up MSVC environment ==='
$vcvarsall = 'C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat'
Push-Location
cmd.exe /c "`"$vcvarsall`" x64 && set" | ForEach-Object {
 if ($_ -match '^([^=]+)=(.*)$') {
 [System.Environment]::SetEnvironmentVariable($Matches[1], $Matches[2], 'Process')
 }
}
Pop-Location

# Also set the Windows SDK paths explicitly
$sdkBase = 'C:\Program Files (x86)\Windows Kits\10'
$sdkVersion = '10.0.26100.0'
$sdkBin = Join-Path $sdkBase "bin\$sdkVersion\x64"
$sdkInclude = Join-Path $sdkBase "Include\$sdkVersion"
$sdkLib = Join-Path $sdkBase "Lib\$sdkVersion\ucrt\x64"

Write-Host "=== Adding SDK to environment ==="
$env:PATH = "$sdkBin;$env:PATH"
$env:INCLUDE = "$sdkInclude\ucrt;$sdkInclude\um;$sdkInclude\shared;$sdkInclude\winrt;$sdkInclude\cppwinrt;$env:INCLUDE"
$env:LIB = "$sdkLib;$env:LIB"
$env:LIBPATH = "$sdkLib;$env:LIBPATH"

Write-Host '=== Verifying tools and headers ==='
$tools = @('cl.exe', 'nmake.exe', 'rc.exe', 'mt.exe', 'ninja.exe', 'cmake.exe')
foreach ($t in $tools) {
 $found = Get-Command $t -ErrorAction SilentlyContinue
 if ($found) { Write-Host "$t OK: $($found.Source)" } else { Write-Warning "$t NOT FOUND" }
}

$win32 = Join-Path $sdkInclude 'um\Windows.h'
if (Test-Path $win32) { Write-Host "Windows.h found: $win32" } else { Write-Warning "Windows.h NOT FOUND at $win32" }

Write-Host '=== Building simlibs_debug ==='
Set-Location 'C:\Projects\GarudaOS\ProjectAirSim'
& nmake /f build_windows.mk simlibs_debug 2>&1
if ($LASTEXITCODE -ne 0) { throw "Build failed with exit code $LASTEXITCODE" }
Write-Host 'BUILD SUCCESS'
