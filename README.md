# 🐳 Container Security & Image Scanning Framework

## Overview
A comprehensive container security framework that scans Docker images
for vulnerabilities, enforces security policies, validates Dockerfiles,
and generates professional security reports automatically.

## Features
- ✅ Trivy - Container vulnerability scanning
- ✅ Hadolint - Dockerfile security linting
- ✅ Security policy enforcement (JSON-based)
- ✅ Automated daily scans via GitHub Actions
- ✅ Professional PDF security report generation
- ✅ Non-root container best practices
- ✅ Full test suite for security validation

## How to Run Locally
'''powershell
.\scripts\install-tools.ps1
.\tests\test-security.ps1
python reports/report-generator.py
.\scripts\scan-image.ps1 -ImageName "python:3.11-slim"
'''

## Technologies
- Docker & Dockerfile Security
- Trivy & Hadolint
- GitHub Actions
- Python & PowerShell
- Azure Container Registry

## Author
Uzma Shabbir Cloud Security Engineer
