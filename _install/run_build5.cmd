@echo off
setlocal
cd /d C:\Projects\GarudaOS\ProjectAirSim
set UE_ROOT=A:\unreal\UE_5.1
call "C:\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64 >NUL 2>&1
echo [BEFORE_VARS] UE_ROOT=%UE_ROOT%
echo [BEFORE_VARS] VSINSTALLDIR=%VSINSTALLDIR%
echo [BEFORE_VARS] PATH=%PATH%
echo [BEFORE_VARS] where_nmake=...
where nmake
echo [BEFORE_VARS] done
echo [BUILD_START]
call build.cmd simlibs_debug
echo [BUILD_EXIT]=%ERRORLEVEL%
