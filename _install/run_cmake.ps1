$env:UE_ROOT = "A:\unreal\UE_5.1"
$env:PATH = "C:\Windows\system32;C:\Windows;C:\BuildTools\VC\Tools\MSVC\14.44.35207\bin\Hostx64\x64;C:\BuildTools\Common7\Tools;C:\BuildTools\MSBuild\Current\Bin\amd64;C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja;C:\Projects\GarudaOS\ProjectAirSim\_install\cmake-3.28.3-windows-x86_64\bin;" + $env:PATH

Write-Host "UE_ROOT=$env:UE_ROOT"
Write-Host "CMake=" (Get-Command cmake -ErrorAction SilentlyContinue).Path
Write-Host "Ninja=" (Get-Command ninja -ErrorAction SilentlyContinue).Path
Write-Host "cl=" (Get-Command cl -ErrorAction SilentlyContinue).Path

Set-Location "C:\Projects\GarudaOS\ProjectAirSim"
& cmake -S . -B build\win64\UE5.1\Debug -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=cl.exe -DCMAKE_CXX_COMPILER=cl.exe
Write-Host "CMAKE_EXIT=$LASTEXITCODE"
