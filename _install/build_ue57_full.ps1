param()
$ErrorActionPreference = 'Stop'
$ueRoot = 'A:\unreal\UE_5.7'
$env:UE_ROOT = $ueRoot
$proj = (Resolve-Path '.\unreal\Blocks\Blocks.uproject').Path

Write-Host "Generating VS project files..."
$proc = Start-Process -FilePath (Join-Path $ueRoot 'Engine\Build\BatchFiles\GenerateProjectFiles.bat') `
 -ArgumentList "-project=`"$proj`" -game -engine -vscode -2017" `
 -NoNewWindow -Wait -PassThru `
 -RedirectStandardOutput '_install\genproj_out.log' `
 -RedirectStandardError '_install\genproj_err.log'
Write-Host "GenerateProjectFiles exit: $($proc.ExitCode)"

Write-Host "Building Blocks project with UE 5.7..."
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = (Join-Path $ueRoot 'Engine\Build\BatchFiles\Build.bat')
$psi.Arguments = "Blocks Win64 DebugGame -project=`"$proj`" -waitmutex -nop4"
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.CreateNoWindow = $true
$p = [System.Diagnostics.Process]::Start($psi)
$out = $p.StandardOutput.ReadToEnd()
$err = $p.StandardError.ReadToEnd()
$p.WaitForExit()
Set-Content -Path '_install\ue57_build_stdout.log' -Value $out -Encoding UTF8
Set-Content -Path '_install\ue57_build_stderr.log' -Value $err -Encoding UTF8
Add-Content -Path '_install\ue57_build_stdout.log' -Value "`n=== STDERR ===" -Encoding UTF8
Add-Content -Path '_install\ue57_build_stdout.log' -Value $err -Encoding UTF8
Add-Content -Path '_install\ue57_build_stdout.log' -Value "`n=== EXIT: $($p.ExitCode) ===" -Encoding UTF8
Write-Host "UE Build exit: $($p.ExitCode)"
