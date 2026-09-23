@echo off
call "C:\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
set UE_ROOT=A:\unreal\UE_5.1
set CMAKE="C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"
set NINJA="C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja\ninja.exe"
set RC="C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\rc.exe"
cd /d C:\Projects\GarudaOS\ProjectAirSim
echo [Configuring Release build...]
%CMAKE% -S . -B build\win64\UE5.1\Release -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=cl.exe -DCMAKE_CXX_COMPILER=cl.exe -DCMAKE_MAKE_PROGRAM=%NINJA% -DCMAKE_SYSTEM_VERSION=10.0.19041.0 -DCMAKE_RC_COMPILER=%RC%
echo [CONFIG_EXIT]=%ERRORLEVEL%
if %ERRORLEVEL% NEQ 0 goto end
echo [Building Release simlibs...]
%CMAKE% --build build\win64\UE5.1\Release
echo [BUILD_EXIT]=%ERRORLEVEL%
:end
pause
