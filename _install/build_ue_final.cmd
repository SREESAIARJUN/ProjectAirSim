@echo off
echo ============================================
echo Building UE Blocks ProjectAirSim (DebugGame)
echo ============================================
setlocal

REM Set UE_ROOT to the actual install location
set UE_ROOT=A:\unreal\UE_5.1

REM Initialize MSVC environment
call "C:\BuildTools\VC\Auxiliary\Build\vcvars64.bat" >NUL 2>&1

REM Set minimal PATH - don't override what vcvars64 set
set PATH=%PATH%;C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64

cd /d C:\Projects\GarudaOS\ProjectAirSim

echo UE_ROOT=%UE_ROOT%
echo Building Blocks Win64 DebugGame...

REM Build the UE project
"%UE_ROOT%\Engine\Build\BatchFiles\Build.bat" Blocks Win64 DebugGame -project="C:\Projects\GarudaOS\ProjectAirSim\unreal\Blocks\Blocks.uproject" 2>&1
echo [UE_BUILD_EXIT]=%ERRORLEVEL%

if %ERRORLEVEL% EQU 0 (
 echo ========================================
 echo UE BUILD SUCCESSFUL
 echo ========================================
) else (
 echo ========================================
 echo UE BUILD FAILED
 echo ========================================
)

pause
endlocal
