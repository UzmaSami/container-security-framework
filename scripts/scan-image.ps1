# ================================================
# Scan a Single Docker Image for Vulnerabilities
# ================================================
param(
    [Parameter(Mandatory=$true)]
    [string]$ImageName,

    [string]$Severity = "HIGH,CRITICAL",
    [string]$OutputFormat = "table"
)

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   CONTAINER SECURITY SCAN" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Image    : $ImageName" -ForegroundColor White
Write-Host "Severity : $Severity" -ForegroundColor White
Write-Host "Time     : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor White
Write-Host "=========================================" -ForegroundColor Cyan

# Check if image exists
Write-Host "`n[*] Checking if image exists..." -ForegroundColor Yellow
$imageCheck = docker image inspect $ImageName 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "[*] Image not found locally. Pulling..." -ForegroundColor Yellow
    docker pull $ImageName
}

# Run Trivy vulnerability scan
Write-Host "`n[*] Running vulnerability scan..." -ForegroundColor Yellow

# FIXED: Replaced 'docker run' container scanning with your native 'trivy' command.
# This prevents Windows path errors with /var/run/docker.sock.
trivy image `
    --severity $Severity `
    --format $OutputFormat `
    $ImageName

# Scan result
if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Scan complete - No critical issues found!" -ForegroundColor Green
} else {
    Write-Host "`n🚨 Scan complete - Vulnerabilities found!" -ForegroundColor Red
}

Write-Host "=========================================" -ForegroundColor Cyan