$env:UE_ROOT = "A:\unreal\UE_5.1"

# Build a clean PATH
$ninjaPath = "C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja"
$cmakePath = "C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin"
$msvcPath = "C:\BuildTools\VC\Tools\MSVC\14.44.35207\bin\Hostx64\x64"
$toolsPath = "C:\BuildTools\Common7\Tools"
$msbuildPath = "C:\BuildTools\MSBuild\Current\Bin\amd64"

$env:PATH = "$ninjaPath;$cmakePath;$msvcPath;$toolsPath;$msbuildPath;C:\Windows\system32;C:\Windows"

$cmake = Join-Path $cmakePath "cmake.exe"
$ninja = Join-Path $ninjaPath "ninja.exe"

Write-Host "ninja exists=" (Test-Path $ninja)
Write-Host "cmake exists=" (Test-Path $cmake)

Set-Location "C:\Projects\GarudaOS\ProjectAirSim"

# Build the existing debug config
& $cmake --build build\win64\system\Debug 2>&1
Write-Host "BUILD_EXIT=$LASTEXITCODE"
