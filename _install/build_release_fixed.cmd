@echo off
call "C:\BuildTools\VC\Auxiliary\Build\vcvars64.bat" >NUL 2>&1

REM Manually set UE_ROOT and critical paths
set UE_ROOT=A:\unreal\UE_5.1
set PATH=C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64;%PATH%
set INCLUDE=C:\BuildTools\VC\Tools\MSVC\14.44.35207\include;C:\Program Files (x86)\Windows Kits\10\Include\10.0.19041.0\ucrt;C:\Program Files (x86)\Windows Kits\10\Include\10.0.19041.0\um;C:\Program Files (x86)\Windows Kits\10\Include\10.0.19041.0\shared;%INCLUDE%
set LIB=C:\BuildTools\VC\Tools\MSVC\14.44.35207\lib\x64;C:\Program Files (x86)\Windows Kits\10\Lib\10.0.19041.0\ucrt\x64;C:\Program Files (x86)\Windows Kits\10\Lib\10.0.19041.0\um\x64;%LIB%

cd /d C:\Projects\GarudaOS\ProjectAirSim

REM Test rc
rc /?
echo [RC_TEST]=%ERRORLEVEL%

echo [STEP1] Configuring Release cmake...
"C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" -S . -B build\win64\system\Release -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=cl.exe -DCMAKE_CXX_COMPILER=cl.exe -DCMAKE_MAKE_PROGRAM=C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja\ninja.exe -DCMAKE_RC_COMPILER="C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\rc.exe" -DCMAKE_SYSTEM_VERSION=10.0.19041.0
echo [CONFIG_EXIT]=%ERRORLEVEL%
if %ERRORLEVEL% NEQ 0 goto end

echo [STEP2] Building Release simlibs...
"C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" --build build\win64\system\Release 2>&1
echo [BUILD_EXIT]=%ERRORLEVEL%
:end
pause
