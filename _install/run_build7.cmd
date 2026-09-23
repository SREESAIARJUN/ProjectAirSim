@echo off
cd /d C:\Projects\GarudaOS\ProjectAirSim
set UE_ROOT=A:\unreal\UE_5.1
REM Set clean PATH to avoid git bash contamination
set PATH=C:\Windows\system32;C:\Windows;C:\BuildTools\VC\Tools\MSVC\14.44.35207\bin\Hostx64\x64;C:\BuildTools\Common7\Tools;C:\BuildTools\MSBuild\Current\Bin\amd64;C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja;C:\Users\srees\AppData\Local\Programs\Python\Python310
call build.cmd simlibs_debug
echo [EXIT]=%ERRORLEVEL%
