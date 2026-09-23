@echo off
setlocal
echo === Checking tool availability after vcvarsall ===
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64
echo.
echo rc.exe: %~dp$PATH:4xrc.exe%
where rc.exe
echo.
echo mt.exe:
where mt.exe
echo.
echo link.exe:
where link.exe
echo.
echo cl.exe:
where cl.exe
echo.
echo ninja.exe:
where ninja.exe
endlocal
