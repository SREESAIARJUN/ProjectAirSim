Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$vcvarsall = 'C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat'
Push-Location
cmd.exe /c "call `"$vcvarsall`" x64 && cl.exe 2>&1"
Pop-Location
