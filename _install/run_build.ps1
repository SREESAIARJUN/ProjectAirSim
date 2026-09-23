Set-Location "C:\Projects\GarudaOS\ProjectAirSim"
$env:UE_ROOT = "A:\unreal\UE_5.1"
$env:PATH = "C:\BuildTools\VC\Tools\MSVC\14.44.35207\bin\Hostx64\x64;C:\BuildTools\Common7\Tools;C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja;C:\Projects\GarudaOS\ProjectAirSim\_install\cmake-3.28.3-windows-x86_64\bin;C:\Projects\GarudaOS\ProjectAirSim\_install;" + $env:PATH
cmd.exe /c "cd /d C:\Projects\GarudaOS\ProjectAirSim && set UE_ROOT=A:\unreal\UE_5.1 && call build.cmd simlibs_debug"
Write-Host "BUILD_EXIT: $LASTEXITCODE"
