# ================================================
# Scan ALL Local Docker Images
# ================================================
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   SCANNING ALL LOCAL DOCKER IMAGES" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Get all local images
# FIXED: Wrapped in @() to force PowerShell to treat $images as an Array, 
# even if only 1 single image is returned (otherwise .Count fails).
$images = @(docker images --format "{{.Repository}}:{{.Tag}}" | 
          Where-Object { $_ -notlike "*<none>*" })

if ($images.Count -eq 0 -or $images[0] -eq $null) {
    Write-Host "No local Docker images found." -ForegroundColor Yellow
    exit 0
}

Write-Host "Found $($images.Count) images to scan`n" -ForegroundColor White

$results = @()

foreach ($image in $images) {
    Write-Host "[*] Scanning: $image" -ForegroundColor Yellow

    # FIXED: Replaced 'docker run' with your native local 'trivy' command
    # Added '--quiet' so it doesn't clutter your loop output, matching your intent.
    $scanResult = trivy image --severity HIGH,CRITICAL --quiet $image 2>&1

    $status = if ($LASTEXITCODE -eq 0) { "✅ CLEAN" } else { "🚨 ISSUES FOUND" }

    $results += [PSCustomObject]@{
        Image  = $image
        Status = $status
        Time   = Get-Date -Format "HH:mm:ss"
    }

    Write-Host "   Result: $status`n" -ForegroundColor White
}

# Print summary table
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   SCAN SUMMARY" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
$results | Format-Table -AutoSize

Write-Host "`n[+] All scans complete!" -ForegroundColor Green