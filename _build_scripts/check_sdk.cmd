@echo off
echo === Checking SDK and rc.exe availability ===
if exist "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.44.35207\bin\Hostx64\x64\rc.exe" (
 echo rc.exe found in MSVC tools
) else (
 echo rc.exe NOT in MSVC tools
)

if exist "C:\Program Files (x86)\Windows Kits\10\bin\10.0.22621.0\x64\rc.exe" (
 echo rc.exe found in Windows SDK
) else (
 echo rc.exe NOT in Windows SDK
)

dir "C:\Program Files (x86)\Windows Kits" /b 2>nul
