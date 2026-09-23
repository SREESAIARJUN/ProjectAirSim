@echo off
cd /d C:\Projects\GarudaOS\ProjectAirSim
set UE_ROOT=A:\unreal\UE_5.1
dir build.cmd
echo --- calling build.cmd ---
.\build.cmd simlibs_debug
echo [EXIT]=%ERRORLEVEL%
