$env:UE_ROOT = "A:\unreal\UE_5.1"
$cmdScript = @'
@echo off
call "C:\BuildTools\VC\Auxiliary\Build\vcvars64.bat" >NUL 2>&1
set UE_ROOT=A:\unreal\UE_5.1
cd /d C:\Projects\GarudaOS\ProjectAirSim

echo [STEP1] Copying Debug simlibs to UE plugin...
xcopy /E /Y /I build\win64\UE5.1\Debug\core_sim\src\*.lib unreal\Blocks\Plugins\ProjectAirSim\SimLibs\lib\Win64\Debug\ >NUL 2>&1
xcopy /E /Y /I build\win64\UE5.1\Debug\physics\src\*.lib unreal\Blocks\Plugins\ProjectAirSim\SimLibs\lib\Win64\Debug\ >NUL 2>&1
xcopy /E /Y /I build\win64\UE5.1\Debug\multirotor_api\src\*.lib unreal\Blocks\Plugins\ProjectAirSim\SimLibs\lib\Win64\Debug\ >NUL 2>&1
xcopy /E /Y /I build\win64\UE5.1\Debug\rover_api\src\*.lib unreal\Blocks\Plugins\ProjectAirSim\SimLibs\lib\Win64\Debug\ >NUL 2>&1
xcopy /E /Y /I build\win64\UE5.1\Debug\simserver\src\*.lib unreal\Blocks\Plugins\ProjectAirSim\SimLibs\lib\Win64\Debug\ >NUL 2>&1
xcopy /E /Y /I build\win64\UE5.1\Debug\rendering\scene\src\*.lib unreal\Blocks\Plugins\ProjectAirSim\SimLibs\lib\Win64\Debug\ >NUL 2>&1
echo [STEP1_DONE]

echo [STEP2] Generating UE project files...
"%UE_ROOT%\Engine\Build\BatchFiles\GenerateProjectFiles.bat" -project="C:\Projects\GarudaOS\ProjectAirSim\unreal\Blocks\Blocks.uproject" -game -rocket -progress >NUL 2>&1
echo [STEP2_EXIT]=%ERRORLEVEL%

echo [STEP3] Building UE Blocks (DebugGame)...
"%UE_ROOT%\Engine\Build\BatchFiles\Build.bat" Blocks Win64 DebugGame -project="C:\Projects\GarudaOS\ProjectAirSim\unreal\Blocks\Blocks.uproject" 2>&1
echo [STEP3_EXIT]=%ERRORLEVEL%

pause
'@

$scriptPath = "C:\Projects\GarudaOS\ProjectAirSim\_install\build_ue3.cmd"
Set-Content -Path $scriptPath -Value $cmdScript -Encoding ASCII

& cmd.exe /c $scriptPath
