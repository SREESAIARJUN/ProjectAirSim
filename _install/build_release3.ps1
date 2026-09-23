$env:UE_ROOT = "A:\unreal\UE_5.1"
$rcCompiler = "C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\rc.exe"

$cmdScript = @'
@echo off
call "C:\BuildTools\VC\Auxiliary\Build\vcvars64.bat" >NUL 2>&1
set UE_ROOT=A:\unreal\UE_5.1
cd /d C:\Projects\GarudaOS\ProjectAirSim
echo [STEP1] Configuring Release cmake...
"C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" -S . -B build\win64\UE5.1\Release -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=cl.exe -DCMAKE_CXX_COMPILER=cl.exe -DCMAKE_MAKE_PROGRAM=C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja\ninja.exe -DCMAKE_SYSTEM_VERSION=10.0.19041.0 -DCMAKE_RC_COMPILER="C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\rc.exe" 2>&1
echo [STEP1_EXIT]=%ERRORLEVEL%
if %ERRORLEVEL% EQU 0 (
 echo [STEP2] Building Release simlibs...
 "C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" --build build\win64\UE5.1\Release 2>&1
 echo [STEP2_EXIT]=%ERRORLEVEL%
)
pause
'@

$scriptPath = "C:\Projects\GarudaOS\ProjectAirSim\_install\build_release3.cmd"
Set-Content -Path $scriptPath -Value $cmdScript -Encoding ASCII

& cmd.exe /c $scriptPath
