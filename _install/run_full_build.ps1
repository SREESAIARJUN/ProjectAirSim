$env:UE_ROOT = "A:\unreal\UE_5.1"
$ninjaPath = "C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja"
$cmakePath = "C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin"
$msvcPath = "C:\BuildTools\VC\Tools\MSVC\14.44.35207\bin\Hostx64\x64"
$toolsPath = "C:\BuildTools\Common7\Tools"
$msbuildPath = "C:\BuildTools\MSBuild\Current\Bin\amd64"

$env:PATH = "$ninjaPath;$cmakePath;$msvcPath;$toolsPath;$msbuildPath;C:\Windows\system32;C:\Windows"

$cmake = Join-Path $cmakePath "cmake.exe"
$ninja = Join-Path $ninjaPath "ninja.exe"

Set-Location "C:\Projects\GarudaOS\ProjectAirSim"

# Clean stale cache
Remove-Item -Recurse -Force build\win64\UE5.1\Debug -ErrorAction SilentlyContinue

& $cmake -S . -B build\win64\UE5.1\Debug -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=cl.exe -DCMAKE_CXX_COMPILER=cl.exe -DCMAKE_MAKE_PROGRAM=$ninja -DCMAKE_SYSTEM_VERSION=10.0.19041.0
Write-Host "CMAKE_EXIT=$LASTEXITCODE"

# Build
if ($LASTEXITCODE -eq 0) {
 & $cmake --build build\win64\UE5.1\Debug 2>&1
 Write-Host "BUILD_EXIT=$LASTEXITCODE"
}
