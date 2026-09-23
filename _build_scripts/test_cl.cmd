@echo off
echo === Compiler test ===
"C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.44.35207\bin\Hostx64\x64\cl.exe" /nologo /Fe:test_hello.exe test_hello.c
echo Exit: %ERRORLEVEL%
pause
