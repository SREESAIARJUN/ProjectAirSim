@echo off
setlocal ENABLEDELAYEDEXPANSION

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

cd /d "C:\Projects\GarudaOS\ProjectAirSim\build\win64\system\Debug"

echo.
echo === [1/5] core_sim_gtests ===
unit_tests\core_sim_gtests.exe 2>&1
echo Exit: !ERRORLEVEL!

echo.
echo === [2/5] multirotor_api_gtests ===
unit_tests\multirotor_api_gtests.exe 2>&1
echo Exit: !ERRORLEVEL!

echo.
echo === [3/5] physics_gtests ===
unit_tests\physics_gtests.exe 2>&1
echo Exit: !ERRORLEVEL!

echo.
echo === [4/5] rendering_scene_gtests ===
unit_tests\rendering_scene_gtests.exe 2>&1
echo Exit: !ERRORLEVEL!

echo.
echo === [5/5] rover_api_gtests ===
unit_tests\rover_api_gtests.exe 2>&1
echo Exit: !ERRORLEVEL!

echo.
echo === [6/6] MavLinkTest ===
mavlinkcom\test\MavLinkTest.exe 2>&1
echo Exit: !ERRORLEVEL!

echo.
echo ========================================
echo ALL NATIVE TESTS COMPLETE
echo ========================================

endlocal
