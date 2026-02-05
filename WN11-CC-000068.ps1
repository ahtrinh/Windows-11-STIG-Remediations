<#
.SYNOPSIS
    WN11-CC-000068 (V-253368): Enable "Remote host allows delegation of non-exportable credentials".
    Remediates by setting:
    HKLM\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation\AllowProtectedCreds (REG_DWORD) = 1

.NOTES
    Author          : Alex Trinh
    LinkedIn        :
    GitHub          : github.com/ahtrinh
    Date Created    : 2026-01-30
    Last Modified   : 2026-01-30
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000068

.USAGE
    Run as Administrator:
    PS C:\> .\WN11-CC-000068.ps1
#>

$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation"
$RegName = "AllowProtectedCreds"
$Expected = 1

if (-not (Test-Path $RegPath)) { New-Item -Path $RegPath -Force | Out-Null }

$current = Get-ItemPropertyValue -Path $RegPath -Name $RegName -ErrorAction SilentlyContinue
if ($current -eq $Expected) {
    Write-Host "COMPLIANT: $RegName = $Expected"
    exit 0
}

New-ItemProperty -Path $RegPath -Name $RegName -Value $Expected -PropertyType DWord -Force | Out-Null
$verify = Get-ItemPropertyValue -Path $RegPath -Name $RegName -ErrorAction SilentlyContinue

if ($verify -eq $Expected) {
    Write-Host "REMEDIATED: $RegName set to $Expected"
    exit 0
}

Write-Host "FAILED: $RegName is $verify (expected $Expected)"
exit 1
