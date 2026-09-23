@echo off
setlocal ENABLEDELAYEDEXPANSION
echo === Full compiler test ===
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
echo Exit vcvars64: !ERRORLEVEL!
echo INCLUDE: %INCLUDE%
echo LIB: %LIB%
echo.
echo === Compile a simple hello world ===
echo #include ^<stdio.h^> > C:\Users\srees\test_hello.c
echo int main() { printf("hello\n"); return 0; } >> C:\Users\srees\test_hello.c
cl.exe /nologo /Fe:C:\Users\srees\test_hello.exe C:\Users\srees\test_hello.c 2>&1
echo Compile Exit: !ERRORLEVEL!
endlocal
