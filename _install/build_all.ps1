$env:UE_ROOT = "A:\unreal\UE_5.1"

$cmdScript = @"
@echo off
call "C:\BuildTools\VC\Auxiliary\Build\vcvars64.bat" >NUL 2>&1
set UE_ROOT=A:\unreal\UE_5.1
cd /d C:\Projects\GarudaOS\ProjectAirSim

REM First build Release simlibs
echo [STEP1] Building Release simlibs...
"C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" --build build\win64\system\Release 2>&1
echo [STEP1_EXIT]=%ERRORLEVEL%

if %ERRORLEVEL% NEQ 0 (
 echo [STEP1_FAILED]
 pause
 exit /b 1
)

REM Now copy Release simlibs to UE plugin
echo [STEP2] Packaging simlibs into UE plugin...
xcopy /E /Y /I build\win64\system\Release\*.lib unreal\Blocks\Plugins\ProjectAirSim\SimLibs\lib\Win64\Release\ >NUL 2>&1
xcopy /E /Y /I build\win64\system\Release\*.dll unreal\Blocks\Plugins\ProjectAirSim\SimLibs\bin\Win64\Release\ >NUL 2>&1

REM Build UE Blocks project
echo [STEP3] Building UE Blocks Win64 Development...
"%UE_ROOT%\Engine\Build\BatchFiles\Build.bat" Blocks Win64 Development -project="C:\Projects\GarudaOS\ProjectAirSim\unreal\Blocks\Blocks.uproject" 2>&1
echo [STEP3_EXIT]=%ERRORLEVEL%

if %ERRORLEVEL% EQU 0 (
 echo ========================================
 echo BUILD SUCCESS
 echo ========================================
) else (
 echo ========================================
 echo BUILD FAILED
 echo ========================================
)

pause
"@

$scriptPath = "C:\Projects\GarudaOS\ProjectAirSim\_install\build_all.cmd"
Set-Content -Path $scriptPath -Value $cmdScript -Encoding ASCII

& cmd.exe /c $scriptPath
