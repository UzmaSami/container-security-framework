# ================================================
# Container Security Tests
# ================================================
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   RUNNING SECURITY TESTS" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# FIXED: Explictly set scope variables to 0. 
# Inside functions, PowerShell requires modifying the 'script' or 'global' scope tracking.
$script:passed = 0
$script:failed = 0

function Test-Check {
    param($Name, $Result)
    if ($Result) {
        Write-Host "✅ PASS : $Name" -ForegroundColor Green
        $script:passed++
    } else {
        Write-Host "❌ FAIL : $Name" -ForegroundColor Red
        $script:failed++
    }
}

# Test 1 - Dockerfile exists
Test-Check "Secure Dockerfile exists" `
    (Test-Path "images/secure.Dockerfile")

# Test 2 - Policy file exists
Test-Check "Security policy exists" `
    (Test-Path "policies/security-policy.json")

# Test 3 - Policy file is valid JSON
try {
    $policy = Get-Content "policies/security-policy.json" | ConvertFrom-Json
    Test-Check "Security policy is valid JSON" $true
} catch {
    Test-Check "Security policy is valid JSON" $false
}

# Test 4 - Non-root user in Dockerfile
$dockerfile = Get-Content "images/secure.Dockerfile" -Raw
Test-Check "Dockerfile uses non-root user" `
    ($dockerfile -match "USER secureuser")

# Test 5 - Healthcheck in Dockerfile
Test-Check "Dockerfile has HEALTHCHECK" `
    ($dockerfile -match "HEALTHCHECK")

# Test 6 - No latest tag used
# FIXED: Changed regex match string. Your previous pattern looked for 'FROM.*:latest'.
# Since your Dockerfile uses 'FROM python:3.11-slim', it doesn't contain ':latest', 
# but -notmatch on a missing pattern returns $true. If someone changed it to 'FROM ubuntu:latest', 
# it would trigger $false (FAIL). The logic was correct, but we must protect against blank/malformed strings.
Test-Check "Dockerfile does not use latest tag" `
    ($dockerfile -notmatch "FROM\s+[a-zA-Z0-9./_-]+:latest")

# Test 7 - Report generator exists
Test-Check "Report generator exists" `
    (Test-Path "reports/report-generator.py")

# Test 8 - GitHub workflow exists
Test-Check "GitHub Actions workflow exists" `
    (Test-Path ".github/workflows/container-scan.yml")

# Summary
Write-Host "`n=========================================" -ForegroundColor Cyan
Write-Host "   TEST RESULTS SUMMARY" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "✅ Passed : $script:passed" -ForegroundColor Green
Write-Host "❌ Failed : $script:failed" -ForegroundColor Red
Write-Host "=========================================" -ForegroundColor Cyan