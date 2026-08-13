<#
.SYNOPSIS
    Stops the FalconExam local development environment.

.PARAMETER Purge
    Also delete the named volumes. This destroys the local database, Redis state and any emulated
    object storage. Use it when you want a clean first-run, including re-running the database init
    scripts in scripts/db/init.
#>
[CmdletBinding()]
param(
    [switch]$Purge
)

$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)

if ($Purge) {
    Write-Host "Stopping FalconExam and deleting all local data volumes..." -ForegroundColor Yellow
    docker compose down --volumes --remove-orphans
} else {
    Write-Host "Stopping FalconExam (local data is preserved)..." -ForegroundColor Cyan
    docker compose down --remove-orphans
}

if ($LASTEXITCODE -ne 0) { throw "docker compose down failed." }
Write-Host "Done." -ForegroundColor Green
