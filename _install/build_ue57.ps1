$env:UE_ROOT = "A:\unreal\UE_5.7"
$dotnetDir = "C:\Users\srees\.dotnet"
$env:DOTNET_ROOT = $dotnetDir
$env:PATH = "$dotnetDir;$env:PATH"

$logFile = "C:\Projects\GarudaOS\ProjectAirSim\_install\ue57_build.log"
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = "A:\unreal\UE_5.7\Engine\Build\BatchFiles\Build.bat"
$psi.Arguments = "Blocks Win64 DebugGame -project=`"C:\Projects\GarudaOS\ProjectAirSim\unreal\Blocks\Blocks.uproject`""
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.CreateNoWindow = $true

$proc = [System.Diagnostics.Process]::Start($psi)
$stdout = $proc.StandardOutput.ReadToEnd()
$stderr = $proc.StandardError.ReadToEnd()
$proc.WaitForExit()

Set-Content -Path $logFile -Value $stdout -Encoding UTF8
Add-Content -Path $logFile -Value "`n=== STDERR ===" -Encoding UTF8
Add-Content -Path $logFile -Value $stderr -Encoding UTF8
Add-Content -Path $logFile -Value "`n=== EXIT: $($proc.ExitCode) ===" -Encoding UTF8

Write-Host "UE Build exit: $($proc.ExitCode)"
