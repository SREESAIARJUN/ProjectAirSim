$env:UE_ROOT = "A:\unreal\UE_5.1"
$dotnetDir = "C:\Users\srees\.dotnet"
$env:DOTNET_ROOT = $dotnetDir
$env:PATH = $dotnetDir + ";" + $env:PATH

$buildBat = "A:\unreal\UE_5.1\Engine\Build\BatchFiles\Build.bat"
$project = "C:\Projects\GarudaOS\ProjectAirSim\unreal\Blocks\Blocks.uproject"

$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $buildBat
$psi.Arguments = "Blocks Win64 DebugGame -project=`"$project`""
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.CreateNoWindow = $true

$proc = [System.Diagnostics.Process]::Start($psi)
$stdout = $proc.StandardOutput.ReadToEnd()
$stderr = $proc.StandardError.ReadToEnd()
$proc.WaitForExit()

$logFile = "C:\Projects\GarudaOS\ProjectAirSim\_install\ue_build2.log"
Set-Content -Path $logFile -Value $stdout -Encoding UTF8
Add-Content -Path $logFile -Value "`n=== STDERR ===" -Encoding UTF8
Add-Content -Path $logFile -Value $stderr -Encoding UTF8
Add-Content -Path $logFile -Value "`n=== EXIT: $($proc.ExitCode) ===" -Encoding UTF8

Write-Host "UE Build exit: $($proc.ExitCode)"
