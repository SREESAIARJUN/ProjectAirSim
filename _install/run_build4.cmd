@echo off
setlocal
cd /d C:\Projects\GarudaOS\ProjectAirSim
set UE_ROOT=A:\unreal\UE_5.1
call "C:\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64
echo =====================
echo UE_ROOT=%UE_ROOT%
echo PATH=%PATH%
where nmake
echo =====================
echo Building simlibs_debug...
nmake /f build_windows.mk simlibs_debug 2>&1
echo BUILD_EXIT=%ERRORLEVEL%
pause
