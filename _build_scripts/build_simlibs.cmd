@echo off
setlocal ENABLEDELAYEDEXPANSION

echo === Setting up MSVC + Windows SDK environment ===

:: Run vcvarsall to get MSVC paths
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64
echo vcvarsall exit: !ERRORLEVEL!

echo.
echo === Current INCLUDE ===
echo !INCLUDE!

echo.
echo === Current LIB ===
echo !LIB!

echo.
echo === Manually prepending Windows SDK 10.0.26100.0 ===
set "WINSDK=C:\Program Files (x86)\Windows Kits\10"
set "WINSDK_VER=10.0.26100.0"
set "SDK_INC=!WINSDK!\Include\!WINSDK_VER!"
set "SDK_LIB=!WINSDK!\Lib\!WINSDK_VER!\ucrt\x64"
set "SDK_LIB_UWP=!WINSDK!\Lib\!WINSDK_VER!\um\x64"

:: Prepend SDK paths BEFORE MSVC paths
set "INCLUDE=!SDK_INC!\ucrt;!SDK_INC!\um;!SDK_INC!\shared;!SDK_INC!\winrt;!SDK_INC!\cppwinrt;!INCLUDE!"
set "LIB=!SDK_LIB!;!SDK_LIB_UWP!;!LIB!"
set "LIBPATH=!SDK_LIB!;!LIBPATH!"

:: Add SDK tools (rc.exe, mt.exe) to PATH
set "SDK_BIN=!WINSDK!\bin\!WINSDK_VER!\x64"
set "PATH=!SDK_BIN!;!PATH!"

echo.
echo === Updated INCLUDE ===
echo !INCLUDE!

echo.
echo === Verifying rc.exe and mt.exe ===
where rc.exe 2>&1
where mt.exe 2>&1

echo.
echo === Test: compile hello world ===
echo #include ^<stdio.h^> > C:\Users\srees\test_hello.c
echo int main() { printf("hello\n"); return 0; } >> C:\Users\srees\test_hello.c
cl.exe /nologo /Fe:C:\Users\srees\test_hello.exe C:\Users\srees\test_hello.c 2>&1
echo Compile exit: !ERRORLEVEL!

echo.
echo === Building simlibs_debug ===
cd /d "C:\Projects\GarudaOS\ProjectAirSim"
echo Current dir: %CD%
nmake /f "C:\Projects\GarudaOS\ProjectAirSim\build_windows.mk" simlibs_debug 2>&1
echo nmake exit: !ERRORLEVEL!
endlocal
