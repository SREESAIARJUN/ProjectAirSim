@echo off
setlocal
echo === Checking registry AutoRun entries ===
reg query "HKLM\Software\Microsoft\Command Processor" /v AutoRun 2>&1
reg query "HKCU\Software\Microsoft\Command Processor" /v AutoRun 2>&1
echo.
echo === Initial PATH ===
echo %PATH%
echo.
echo === After vcvarsall ===
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64
echo %PATH%
endlocal
