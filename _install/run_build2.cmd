@echo off
REM Build script that runs entirely in one cmd.exe process
cd /d C:\Projects\GarudaOS\ProjectAirSim
set UE_ROOT=A:\unreal\UE_5.1
REM Fix broken PATH from git bash
set PATH=C:\BuildTools\VC\Tools\MSVC\14.44.35207\bin\Hostx64\x64;C:\BuildTools\Common7\Tools;C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja;C:\BuildTools\MSBuild\Current\Bin\amd64;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;%USERPROFILE%\AppData\Local\Microsoft\WindowsApps;%USERPROFILE%\AppData\Local\Programs\Python\Python310;%USERPROFILE%\AppData\Local\Programs\Python\Python310\Scripts
call build.cmd simlibs_debug
echo BUILD_EXIT=%ERRORLEVEL%
