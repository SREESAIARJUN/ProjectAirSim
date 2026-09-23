$env:UE_ROOT = "A:\unreal\UE_5.1"

# Use vcvars64 to set up the compiler environment (INCLUDE, LIB, PATH)
$vcvarsCmd = 'C:\BuildTools\VC\Auxiliary\Build\vcvarsall.bat'
$env:PATH = "C:\Windows\system32;C:\Windows"

# Run vcvarsall.bat in a child cmd to set up env, then run cmake
$cmdScript = @"
@echo off
call "$vcvarsCmd" x64 >NUL 2>&1
set UE_ROOT=A:\unreal\UE_5.1
cd /d C:\Projects\GarudaOS\ProjectAirSim
echo INCLUDE=%INCLUDE%
echo LIB=%LIB%
echo [CMAKE_START]
"C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" -S . -B build\win64\UE5.1\Debug -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=cl.exe -DCMAKE_CXX_COMPILER=cl.exe -DCMAKE_MAKE_PROGRAM=C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja\ninja.exe -DCMAKE_SYSTEM_VERSION=10.0.19041.0
echo [CMAKE_EXIT]=%ERRORLEVEL%
if %ERRORLEVEL%==0 (
 echo [BUILD_START]
 "C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" --build build\win64\UE5.1\Debug 2>&1
 echo [BUILD_EXIT]=%ERRORLEVEL%
)
pause
"@

$scriptPath = "C:\Projects\GarudaOS\ProjectAirSim\_install\full_build.cmd"
Set-Content -Path $scriptPath -Value $cmdScript -Encoding ASCII

& cmd.exe /c $scriptPath
