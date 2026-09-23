$env:UE_ROOT = "A:\unreal\UE_5.1"
$ninjaPath = "C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja"
$cmake = "C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"

$env:PATH = "C:\Windows\system32;C:\Windows;C:\BuildTools\VC\Tools\MSVC\14.44.35207\bin\Hostx64\x64;C:\BuildTools\Common7\Tools;C:\BuildTools\MSBuild\Current\Bin\amd64;" + $ninjaPath + ";" + [Environment]::GetEnvironmentVariable("PATH","Machine")

Write-Host "UE_ROOT=$env:UE_ROOT"
Write-Host "Ninja in PATH=" (Get-Command ninja -ErrorAction SilentlyContinue).Path

Set-Location "C:\Projects\GarudaOS\ProjectAirSim"
& $cmake -S . -B build\win64\UE5.1\Debug -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=cl.exe -DCMAKE_CXX_COMPILER=cl.exe
Write-Host "CMAKE_EXIT=$LASTEXITCODE"
