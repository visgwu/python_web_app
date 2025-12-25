# run_sonar_scan.ps1
# SonarQube/SonarCloud Scanner for Python Web Application
# This script installs pysonar and runs a code quality analysis

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  SonarQube Code Quality Scan" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Install pysonar if not already installed
Write-Host "[1/3] Installing pysonar..." -ForegroundColor Yellow
pip install -q pysonar
if ($LASTEXITCODE -eq 0) {
    Write-Host "  [OK] pysonar installed successfully" -ForegroundColor Green
} else {
    Write-Host "  [ERROR] Failed to install pysonar" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Step 2: Run the SonarQube scan
Write-Host "[2/3] Running SonarQube analysis..." -ForegroundColor Yellow
Write-Host "  Project: python-web-app" -ForegroundColor Gray
Write-Host "  Organization: visgwuorg" -ForegroundColor Gray
Write-Host ""

# Get Python Scripts directory
$pythonPath = python -c "import sys; import os; print(os.path.dirname(sys.executable))"
$scriptsPath = Join-Path $pythonPath "Scripts"
$pysonarPath = Join-Path $scriptsPath "pysonar.exe"

# Check if pysonar exists in Scripts, otherwise use direct command
if (Test-Path $pysonarPath) {
    & $pysonarPath --sonar-token="032921cd8d8eef461bb9f341603c1052292fbf8d" `
                   --sonar-project-key="python-web-app" `
                   --sonar-organization="visgwuorg"
} else {
    # Try from user local packages (Windows Store Python)
    $userScriptsPath = "$env:LOCALAPPDATA\Packages\PythonSoftwareFoundation.Python.3.13_qbz5n2kfra8p0\LocalCache\local-packages\Python313\Scripts\pysonar.exe"
    if (Test-Path $userScriptsPath) {
        & $userScriptsPath --sonar-token="032921cd8d8eef461bb9f341603c1052292fbf8d" `
                          --sonar-project-key="python-web-app" `
                          --sonar-organization="visgwuorg"
    } else {
        # Fall back to PATH
        pysonar --sonar-token="032921cd8d8eef461bb9f341603c1052292fbf8d" `
                --sonar-project-key="python-web-app" `
                --sonar-organization="visgwuorg"
    }
}

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "[3/3] Scan completed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  View your results at:" -ForegroundColor Cyan
    Write-Host "  https://sonarcloud.io/project/overview?id=python-web-app" -ForegroundColor White
    Write-Host "========================================" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "[3/3] Scan failed!" -ForegroundColor Red
    Write-Host "  Check the error messages above for details" -ForegroundColor Yellow
    exit 1
}
