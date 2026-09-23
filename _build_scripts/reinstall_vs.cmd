@echo off
setlocal
echo === Re-installing VS Build Tools with all C++ components ===
set INSTALLER=%TEMP%\vs_buildtools.exe

if not exist "%INSTALLER%" (
 echo Downloading installer...
 powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vs_buildtools.exe' -OutFile '%INSTALLER%'"
)

echo Running installer with --passive mode...
%INSTALLER% install --passive --wait --norestart --installPath "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools" --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.22621 --includeRecommended
echo Exit code: %ERRORLEVEL%
endlocal
