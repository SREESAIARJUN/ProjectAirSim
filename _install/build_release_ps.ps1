$env:UE_ROOT = "A:\unreal\UE_5.1"

# Build a clean PATH with all required tools
$ninjaDir = "C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja"
$cmakeDir = "C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin"
$rcDir = "C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64"
$msvcDir = "C:\BuildTools\VC\Tools\MSVC\14.44.35207\bin\Hostx64\x64"
$toolsDir = "C:\BuildTools\Common7\Tools"
$msbuildDir = "C:\BuildTools\MSBuild\Current\Bin\amd64"

$env:PATH = "$ninjaDir;$cmakeDir;$rcDir;$msvcDir;$toolsDir;$msbuildDir;C:\Windows\system32;C:\Windows"

$ninja = Join-Path $ninjaDir "ninja.exe"
$cmake = Join-Path $cmakeDir "cmake.exe"
$rc = Join-Path $rcDir "rc.exe"

Write-Host "ninja exists=$(Test-Path $ninja)"
Write-Host "cmake exists=$(Test-Path $cmake)"
Write-Host "rc exists=$(Test-Path $rc)"
Write-Host "ninja_in_path=$(Get-Command ninja -ErrorAction SilentlyContinue).Path"

Set-Location "C:\Projects\GarudaOS\ProjectAirSim"

Write-Host "[Configuring Release cmake...]"
& $cmake -S . -B build\win64\system\Release -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=cl.exe -DCMAKE_CXX_COMPILER=cl.exe -DCMAKE_MAKE_PROGRAM=$ninja -DCMAKE_RC_COMPILER=$rc -DCMAKE_SYSTEM_VERSION=10.0.19041.0 2>&1
Write-Host "[Config exit: $LASTEXITCODE]"

if ($LASTEXITCODE -eq 0) {
 Write-Host "[Building Release simlibs...]"
 & $cmake --build build\win64\system\Release 2>&1
 Write-Host "[Build exit: $LASTEXITCODE]"
}
