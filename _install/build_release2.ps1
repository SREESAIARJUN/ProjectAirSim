$env:UE_ROOT = "A:\unreal\UE_5.1"

$cmdScript = @"
@echo off
REM Initialize MSVC environment via vcvars64.bat
call "C:\BuildTools\VC\Auxiliary\Build\vcvars64.bat" >NUL 2>&1
set UE_ROOT=A:\unreal\UE_5.1

echo [ENV] VSINSTALLDIR=%VSINSTALLDIR%
echo [ENV] INCLUDE contains Windows SDK:
echo %INCLUDE% | findstr /I "Windows Kits" >NUL && echo YES || echo NO
echo [ENV] RC in PATH:
where rc

cd /d C:\Projects\GarudaOS\ProjectAirSim

REM 1. Configure Release build with full MSVC environment
echo [STEP1] Configuring Release cmake...
"C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" -S . -B build\win64\UE5.1\Release -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=cl.exe -DCMAKE_CXX_COMPILER=cl.exe -DCMAKE_MAKE_PROGRAM=C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja\ninja.exe -DCMAKE_SYSTEM_VERSION=10.0.19041.0 2>&1
echo [STEP1_EXIT]=%ERRORLEVEL%

if %ERRORLEVEL% EQU 0 (
 REM 2. Build Release simlibs
 echo [STEP2] Building Release simlibs (this takes 5-15 minutes)...
 "C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" --build build\win64\UE5.1\Release 2>&1
 echo [STEP2_EXIT]=%ERRORLEVEL%
)

pause
"@

$scriptPath = "C:\Projects\GarudaOS\ProjectAirSim\_install\build_release2.cmd"
Set-Content -Path $scriptPath -Value $cmdScript -Encoding ASCII

& cmd.exe /c $scriptPath
