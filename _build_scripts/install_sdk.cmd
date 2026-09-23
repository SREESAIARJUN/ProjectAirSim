@echo off
set INSTALLER="%TEMP%\vs_buildtools.exe"
echo === Installing VS Build Tools with full C++ + SDK workload ===
%INSTALLER% modify --installPath "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools" --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.22621 --includeRecommended --quiet --wait --norestart
echo Exit code: %ERRORLEVEL%
