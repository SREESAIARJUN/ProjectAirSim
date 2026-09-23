@echo off
echo Starting build_release_final.cmd
setlocal

REM Setup MSVC environment
call "C:\BuildTools\VC\Auxiliary\Build\vcvars64.bat" >NUL 2>&1

REM Set UE_ROOT
set UE_ROOT=A:\unreal\UE_5.1

REM Set paths with proper separators
set CMAKE=C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe
set NINJA=C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja\ninja.exe
set RC=C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\rc.exe

REM Set PATH with Windows SDK tools
set PATH=C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64;C:\BuildTools\VC\Tools\MSVC\14.44.35207\bin\Hostx64\x64;C:\BuildTools\Common7\Tools;C:\BuildTools\MSBuild\Current\Bin\amd64;C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja;C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin;C:\Windows\system32;C:\Windows

cd /d C:\Projects\GarudaOS\ProjectAirSim

echo UE_ROOT=%UE_ROOT%
echo VSINSTALLDIR=%VSINSTALLDIR%
echo Building with cmake=%CMAKE%

echo [Configuring Release build...]
%CMAKE% -S . -B build\win64\system\Release -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=cl.exe -DCMAKE_CXX_COMPILER=cl.exe -DCMAKE_MAKE_PROGRAM=%NINJA% -DCMAKE_RC_COMPILER=%RC% -DCMAKE_SYSTEM_VERSION=10.0.19041.0
echo [Config exit: %ERRORLEVEL%]
if %ERRORLEVEL% NEQ 0 goto end

echo [Building Release simlibs...]
%CMAKE% --build build\win64\system\Release 2>&1
echo [Build exit: %ERRORLEVEL%]

:end
echo [SCRIPT DONE]
pause
endlocal
