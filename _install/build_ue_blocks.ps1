$env:UE_ROOT = "A:\unreal\UE_5.1"

# Use vcvars64 to set up the compiler environment
$cmdScript = @"
@echo off
call "C:\BuildTools\VC\Auxiliary\Build\vcvars64.bat" >NUL 2>&1
set UE_ROOT=A:\unreal\UE_5.1
cd /d C:\Projects\GarudaOS\ProjectAirSim
echo [UE_BUILD] UE_ROOT=%UE_ROOT%
echo [UE_BUILD] VSINSTALLDIR=%VSINSTALLDIR%
echo [UE_BUILD] Building Blocks Win64 DebugGame...
"%UE_ROOT%\Engine\Build\BatchFiles\Build.bat" Blocks Win64 DebugGame -project="C:\Projects\GarudaOS\ProjectAirSim\unreal\Blocks\Blocks.uproject" -verbose 2>&1
echo [UE_BUILD_EXIT]=%ERRORLEVEL%
pause
"@

$scriptPath = "C:\Projects\GarudaOS\ProjectAirSim\_install\build_ue_blocks.cmd"
Set-Content -Path $scriptPath -Value $cmdScript -Encoding ASCII

& cmd.exe /c $scriptPath
