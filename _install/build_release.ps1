$env:UE_ROOT = "A:\unreal\UE_5.1"

$cmdScript = @"
@echo off
call "C:\BuildTools\VC\Auxiliary\Build\vcvars64.bat" >NUL 2>&1
set UE_ROOT=A:\unreal\UE_5.1
cd /d C:\Projects\GarudaOS\ProjectAirSim

REM 1. Configure Release build
echo [STEP1] Configuring Release cmake...
"C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" -S . -B build\win64\UE5.1\Release -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=cl.exe -DCMAKE_CXX_COMPILER=cl.exe -DCMAKE_MAKE_PROGRAM=C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja\ninja.exe -DCMAKE_SYSTEM_VERSION=10.0.19041.0 2>&1
echo [STEP1_EXIT]=%ERRORLEVEL%

REM 2. Build Release simlibs
echo [STEP2] Building Release simlibs (this takes a while)...
"C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" --build build\win64\UE5.1\Release 2>&1
echo [STEP2_EXIT]=%ERRORLEVEL%

if %ERRORLEVEL% EQU 0 (
 echo [STEP3] Copying simlibs to UE plugin...
 xcopy /E /Y /I build\win64\UE5.1\Release\core_sim\src\*.lib unreal\Blocks\Plugins\ProjectAirSim\SimLibs\lib\Win64\Release\ >NUL 2>&1
 xcopy /E /Y /I build\win64\UE5.1\Release\physics\src\*.lib unreal\Blocks\Plugins\ProjectAirSim\SimLibs\lib\Win64\Release\ >NUL 2>&1
 xcopy /E /Y /I build\win64\UE5.1\Release\multirotor_api\src\*.lib unreal\Blocks\Plugins\ProjectAirSim\SimLibs\lib\Win64\Release\ >NUL 2>&1
 xcopy /E /Y /I build\win64\UE5.1\Release\rover_api\src\*.lib unreal\Blocks\Plugins\ProjectAirSim\SimLibs\lib\Win64\Release\ >NUL 2>&1
 xcopy /E /Y /I build\win64\UE5.1\Release\simserver\src\*.lib unreal\Blocks\Plugins\ProjectAirSim\SimLibs\lib\Win64\Release\ >NUL 2>&1
 xcopy /E /Y /I build\win64\UE5.1\Release\rendering\scene\src\*.lib unreal\Blocks\Plugins\ProjectAirSim\SimLibs\lib\Win64\Release\ >NUL 2>&1
 echo [RELEASE_DONE]
) else (
 echo [RELEASE_FAILED]
)

pause
"@

$scriptPath = "C:\Projects\GarudaOS\ProjectAirSim\_install\build_release.cmd"
Set-Content -Path $scriptPath -Value $cmdScript -Encoding ASCII

& cmd.exe /c $scriptPath
