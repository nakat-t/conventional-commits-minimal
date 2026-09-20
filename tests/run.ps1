# Runs hooks/commit-msg.ps1 against every fixture, both via file argument and
# via stdin, and checks the exit status.
#
#   pwsh -File tests/run.ps1
#   powershell -File tests/run.ps1

$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$hook = Join-Path $here '..\hooks\commit-msg.ps1'

$pass = 0
$fail = 0

# The hook writes diagnostics through [Console]::Error, which PowerShell's
# 2> redirection does not capture; silence it for the duration of the run.
$savedError = [Console]::Error
[Console]::SetError([System.IO.TextWriter]::Null)

function Check([string]$File, [int]$Expected) {
    & $hook $File | Out-Null
    $got = $LASTEXITCODE
    if ($got -eq $Expected) { $script:pass++ }
    else {
        $script:fail++
        Write-Host "FAIL (file)  ${File}: expected $Expected, got $got"
    }

    Get-Content -LiteralPath $File | & $hook | Out-Null
    $got = $LASTEXITCODE
    if ($got -eq $Expected) { $script:pass++ }
    else {
        $script:fail++
        Write-Host "FAIL (stdin) ${File}: expected $Expected, got $got"
    }
}

Get-ChildItem (Join-Path $here 'fixtures\valid')   -Filter *.txt | ForEach-Object { Check $_.FullName 0 }
Get-ChildItem (Join-Path $here 'fixtures\skip')    -Filter *.txt | ForEach-Object { Check $_.FullName 0 }
Get-ChildItem (Join-Path $here 'fixtures\invalid') -Filter *.txt | ForEach-Object { Check $_.FullName 1 }

[Console]::SetError($savedError)
Write-Host "$($PSVersionTable.PSEdition) $($PSVersionTable.PSVersion): $pass passed, $fail failed"
if ($fail -ne 0) { exit 1 }
exit 0
