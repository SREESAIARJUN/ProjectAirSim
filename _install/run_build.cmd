@echo off
cd /d C:\Projects\GarudaOS\ProjectAirSim
set UE_ROOT=A:\unreal\UE_5.1
build.cmd simlibs_debug
echo BUILD_EXIT=%ERRORLEVEL%
pause
