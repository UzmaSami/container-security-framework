# ================================================
# Install Container Security Scanning Tools
# ================================================
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "    INSTALLING SECURITY TOOLS" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# 1. Check Docker
Write-Host "`n[1] Checking Docker..." -ForegroundColor Yellow
$docker = docker --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Docker found: $docker" -ForegroundColor Green
} else {
    Write-Host "❌ Docker not found. Please install Docker Desktop." -ForegroundColor Red
    exit 1
}

# 2. Install Trivy
Write-Host "`n[2] Installing Trivy..." -ForegroundColor Yellow
$trivyCheck = trivy --version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "[*] Downloading Trivy..." -ForegroundColor Yellow
    
    # FIXED: Hardcoded to a reliable stable release string or dynamically fetched. 
    # GitHub 'latest/download' archives don't always use a generic name pattern.
    $trivyUrl = "https://github.com/aquasecurity/trivy/releases/download/v0.50.1/trivy_0.50.1_windows-64bit.zip"
    
    # FIXED: Ensure the destination directory exists before attempting Expand-Archive
    if (!(Test-Path "C:\tools\trivy")) {
        New-Item -ItemType Directory -Path "C:\tools\trivy" -Force | Out-Null
    }

    Invoke-WebRequest -Uri $trivyUrl -OutFile "trivy.zip"
    Expand-Archive -Path "trivy.zip" -DestinationPath "C:\tools\trivy" -Force
    
    # FIXED: Persist the PATH to the Machine environment so it stays permanent after VS Code restarts
    $oldPath = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::Machine)
    if ($oldPath -notlike "*C:\tools\trivy*") {
        [Environment]::SetEnvironmentVariable("PATH", "$oldPath;C:\tools\trivy", [EnvironmentVariableTarget]::Machine)
    }
    # Keep this so the current running session can find it immediately
    $env:PATH += ";C:\tools\trivy"
    
    Remove-Item "trivy.zip"
    Write-Host "✅ Trivy installed!" -ForegroundColor Green
} else {
    Write-Host "✅ Trivy already installed: $trivyCheck" -ForegroundColor Green
}

# 3. Install Python report tools
Write-Host "`n[3] Installing Python tools..." -ForegroundColor Yellow

# FIXED: Explicitly use the specific Python 3.13 executable we fixed earlier to avoid virtualenv mixing
C:/Users/hp/AppData/Local/Programs/Python/Python313/python.exe -m pip install jinja2 pandas tabulate -q

Write-Host "✅ Python tools installed!" -ForegroundColor Green

Write-Host "`n=========================================" -ForegroundColor Green
Write-Host "   ALL TOOLS INSTALLED SUCCESSFULLY" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green