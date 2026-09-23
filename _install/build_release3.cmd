@echo off
call "C:\BuildTools\VC\Auxiliary\Build\vcvars64.bat" >NUL 2>&1
set UE_ROOT=A:\unreal\UE_5.1
cd /d C:\Projects\GarudaOS\ProjectAirSim
echo [ENV] VSINSTALLDIR=%VSINSTALLDIR% > "C:\Projects\GarudaOS\ProjectAirSim\_install\release_build2.log" 2>&1
where rc >> "C:\Projects\GarudaOS\ProjectAirSim\_install\release_build2.log" 2>&1
echo [STEP1] Configuring Release cmake... >> "C:\Projects\GarudaOS\ProjectAirSim\_install\release_build2.log" 2>&1
"C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" -S . -B build\win64\UE5.1\Release -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=cl.exe -DCMAKE_CXX_COMPILER=cl.exe -DCMAKE_MAKE_PROGRAM=C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja\ninja.exe -DCMAKE_SYSTEM_VERSION=10.0.19041.0 >> "C:\Projects\GarudaOS\ProjectAirSim\_install\release_build2.log" 2>&1
echo [STEP1_EXIT]=%ERRORLEVEL% >> "C:\Projects\GarudaOS\ProjectAirSim\_install\release_build2.log" 2>&1
if %ERRORLEVEL% EQU 0 (
 echo [STEP2] Building Release simlibs... >> "C:\Projects\GarudaOS\ProjectAirSim\_install\release_build2.log" 2>&1
 "C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" --build build\win64\UE5.1\Release >> "C:\Projects\GarudaOS\ProjectAirSim\_install\release_build2.log" 2>&1
 echo [STEP2_EXIT]=%ERRORLEVEL% >> "C:\Projects\GarudaOS\ProjectAirSim\_install\release_build2.log" 2>&1
)
echo [DONE] >> "C:\Projects\GarudaOS\ProjectAirSim\_install\release_build2.log" 2>&1
