@echo off
setlocal
cd /d C:\Projects\GarudaOS\ProjectAirSim
set UE_ROOT=A:\unreal\UE_5.1
REM Let vcvars64 handle PATH - don't inherit broken bash PATH
set PATH=C:\Windows\system32;C:\Windows
call "C:\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64
echo [DEBUG] nmake=%SystemRoot%
where nmake
echo [DEBUG] UE_ROOT=%UE_ROOT%
echo [DEBUG] VSINSTALLDIR=%VSINSTALLDIR%
call build.cmd simlibs_debug
echo BUILD_EXIT=%ERRORLEVEL%
