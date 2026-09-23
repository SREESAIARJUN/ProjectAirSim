$logFile = "C:\Projects\GarudaOS\ProjectAirSim\_install\ue57_monitor.log"

function Log($msg) {
 $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
 Add-Content -Path $logFile -Value "[$ts] $msg" -Encoding UTF8
}

# Check locations for UE 5.7
$uePaths = @(
 "C:\Program Files\Epic Games\UE_5.7",
 "C:\Program Files\Epic Games\UE_5.7.4",
 "A:\unreal\UE_5.7",
 "A:\unreal\UE_5.7.4"
)

$found = $null
foreach ($p in $uePaths) {
 if (Test-Path "$p\Engine\Build\BatchFiles\Build.bat") {
 $found = $p
 break
 }
}

if (-not $found) {
 # Search for any UE_5.7* directories
 $drives = @("C:", "A:", "D:", "E:")
 foreach ($d in $drives) {
 $matches = Get-ChildItem -Path "$d\" -Directory -Filter "UE_5.7*" -ErrorAction SilentlyContinue
 if ($matches) {
 foreach ($m in $matches) {
 $buildBat = Join-Path $m.FullName "Engine\Build\BatchFiles\Build.bat"
 if (Test-Path $buildBat) {
 $found = $m.FullName
 break
 }
 }
 }
 if ($found) { break }
 }
}

if (-not $found) {
 Log "UE 5.7 not found yet, will check again"
 exit 0
}

Log "FOUND UE 5.7 at: $found"

# Disable this scheduled task since UE is found
$taskName = "ProjectAirSim_UE57_Monitor"
schtasks /change /tn $taskName /disable 2>&1 | Out-Null

Log "Build starting..."

$ueRoot = $found
$dotnetDir = "C:\Users\srees\.dotnet"
$env:DOTNET_ROOT = $dotnetDir
$env:PATH = "$dotnetDir;$env:PATH"

$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = Join-Path $ueRoot "Engine\Build\BatchFiles\Build.bat"
$psi.Arguments = "Blocks Win64 DebugGame -project=`"C:\Projects\GarudaOS\ProjectAirSim\unreal\Blocks\Blocks.uproject`""
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.CreateNoWindow = $true

$proc = [System.Diagnostics.Process]::Start($psi)
$stdout = $proc.StandardOutput.ReadToEnd()
$stderr = $proc.StandardError.ReadToEnd()
$proc.WaitForExit()

$buildLog = "C:\Projects\GarudaOS\ProjectAirSim\_install\ue57_build.log"
Set-Content -Path $buildLog -Value $stdout -Encoding UTF8
Add-Content -Path $buildLog -Value "`n=== STDERR ===" -Encoding UTF8
Add-Content -Path $buildLog -Value $stderr -Encoding UTF8
Add-Content -Path $buildLog -Value "`n=== EXIT: $($proc.ExitCode) ===" -Encoding UTF8

if ($proc.ExitCode -eq 0) {
 Log "BUILD SUCCESSFUL"
} else {
 Log "BUILD FAILED with exit $($proc.ExitCode) - see $buildLog"
}
