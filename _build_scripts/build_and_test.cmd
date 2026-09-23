@echo off
setlocal ENABLEDELAYEDEXPANSION

echo === Setting up MSVC + Windows SDK environment ===
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64

set "WINSDK=C:\Program Files (x86)\Windows Kits\10"
set "WINSDK_VER=10.0.26100.0"
set "SDK_INC=!WINSDK!\Include\!WINSDK_VER!"
set "SDK_LIB=!WINSDK!\Lib\!WINSDK_VER!\ucrt\x64"
set "SDK_LIB_UWP=!WINSDK!\Lib\!WINSDK_VER!\um\x64"
set "INCLUDE=!SDK_INC!\ucrt;!SDK_INC!\um;!SDK_INC!\shared;!SDK_INC!\winrt;!SDK_INC!\cppwinrt;!INCLUDE!"
set "LIB=!SDK_LIB!;!SDK_LIB_UWP!;!LIB!"
set "LIBPATH=!SDK_LIB!;!LIBPATH!"
set "SDK_BIN=!WINSDK!\bin\!WINSDK_VER!\x64"
set "PATH=!SDK_BIN!;!PATH!"

cd /d "C:\Projects\GarudaOS\ProjectAirSim"

echo.
echo === Reconfiguring with BUILD_TESTING=ON ===
cmake -G "Ninja" -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON -B build\win64\system\Debug 2>&1
echo Configure exit: !ERRORLEVEL!

echo.
echo === Building simlibs_unit_tests ===
cmake --build build\win64\system\Debug --target simlibs_unit_tests 2>&1
echo Build exit: !ERRORLEVEL!

echo.
echo === Running C++ unit tests ===
cd build\win64\system\Debug
ctest -C Debug -V --output-on-failure 2>&1
echo CTest exit: !ERRORLEVEL!

echo.
echo === Checking built test executables ===
cd C:\Projects\GarudaOS\ProjectAirSim
find build\win64\system\Debug -maxdepth 4 -name "*test*.exe" -o -name "*_test.exe" 2>nul

endlocal
