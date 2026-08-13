<#
.SYNOPSIS
    Starts the FalconExam local development environment.

.DESCRIPTION
    Brings up the backing services (PostgreSQL, Redis, Cloud Storage emulator, mail catcher) and
    waits for them to report healthy. Milestone 1 acceptance requires the local environment to start
    with one command; this is that command.

.PARAMETER Recreate
    Recreate containers even if they are already running.
#>
[CmdletBinding()]
param(
    [switch]$Recreate
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    throw "Docker is not installed or not on PATH. Install Docker Desktop and try again."
}

docker info *> $null
if ($LASTEXITCODE -ne 0) {
    throw "Docker is installed but not running. Start Docker Desktop and try again."
}

if (-not (Test-Path '.env')) {
    Write-Host "No .env found - creating one from .env.example" -ForegroundColor Yellow
    Copy-Item '.env.example' '.env'
}

$composeArgs = @('compose', 'up', '-d', '--wait')
if ($Recreate) { $composeArgs += '--force-recreate' }

Write-Host "Starting FalconExam backing services..." -ForegroundColor Cyan
& docker @composeArgs
if ($LASTEXITCODE -ne 0) {
    throw "docker compose up failed. Run 'docker compose logs' to see why."
}

# Read the ports back from .env so the printed URLs match what actually got published.
$ports = @{ POSTGRES_PORT = '5432'; REDIS_PORT = '6379'; STORAGE_PORT = '4443'; MAIL_UI_PORT = '8025' }
foreach ($line in Get-Content '.env') {
    if ($line -match '^\s*([A-Z_]+)\s*=\s*(.+?)\s*$' -and $ports.ContainsKey($Matches[1])) {
        $ports[$Matches[1]] = $Matches[2]
    }
}

Write-Host ""
Write-Host "FalconExam local environment is up." -ForegroundColor Green
Write-Host ("  PostgreSQL        localhost:{0}" -f $ports.POSTGRES_PORT)
Write-Host ("  Redis             localhost:{0}" -f $ports.REDIS_PORT)
Write-Host ("  Storage emulator  http://localhost:{0}" -f $ports.STORAGE_PORT)
Write-Host ("  Mail UI           http://localhost:{0}" -f $ports.MAIL_UI_PORT)
Write-Host ""
Write-Host "Application services (api, ai, web) arrive with Milestone 1." -ForegroundColor DarkGray
Write-Host "Stop everything with .\scripts\dev-down.ps1" -ForegroundColor DarkGray
