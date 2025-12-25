# run_bandit_scan.ps1
# Bandit Security Scanner for Python Applications
# This script installs Bandit and runs comprehensive security analysis

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Bandit Security Analysis" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Install Bandit with all optional features
Write-Host "[1/4] Installing Bandit..." -ForegroundColor Yellow
pip install -q "bandit[toml,sarif,baseline]"
if ($LASTEXITCODE -eq 0) {
    Write-Host "  [OK] Bandit installed successfully" -ForegroundColor Green
} else {
    Write-Host "  [ERROR] Failed to install Bandit" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Step 2: Check for configuration file
Write-Host "[2/4] Checking configuration..." -ForegroundColor Yellow
if (Test-Path ".bandit") {
    Write-Host "  [OK] Found .bandit configuration file" -ForegroundColor Green
} elseif (Test-Path "pyproject.toml") {
    Write-Host "  [INFO] Found pyproject.toml (checking for Bandit config)" -ForegroundColor Gray
} else {
    Write-Host "  [INFO] No configuration file found, using defaults" -ForegroundColor Gray
}
Write-Host ""

# Step 3: Run Bandit security scan
Write-Host "[3/4] Running security analysis..." -ForegroundColor Yellow
Write-Host "  Scanning Python files recursively..." -ForegroundColor Gray
Write-Host "  Target: Current directory" -ForegroundColor Gray
Write-Host ""

# Get Python Scripts directory for bandit executable
$pythonPath = python -c "import sys; import os; print(os.path.dirname(sys.executable))"
$scriptsPath = Join-Path $pythonPath "Scripts"
$banditPath = Join-Path $scriptsPath "bandit.exe"

# Check if bandit exists in Scripts, otherwise use fallback paths
if (Test-Path $banditPath) {
    $banditCmd = $banditPath
} else {
    # Try from user local packages (Windows Store Python)
    $userScriptsPath = "$env:LOCALAPPDATA\Packages\PythonSoftwareFoundation.Python.3.13_qbz5n2kfra8p0\LocalCache\local-packages\Python313\Scripts\bandit.exe"
    if (Test-Path $userScriptsPath) {
        $banditCmd = $userScriptsPath
    } else {
        # Fall back to PATH
        $banditCmd = "bandit"
    }
}

# Run Bandit with comprehensive options
# -r: recursive
# -ll: only show medium and high severity issues
# -f json: output JSON format
# -o: output file
& $banditCmd -r . -ll -f json -o bandit-report.json

$scanExitCode = $LASTEXITCODE

# Also generate HTML report for easier viewing
& $banditCmd -r . -ll -f html -o bandit-report.html

# Generate console output with full details
Write-Host ""
Write-Host "  Detailed findings:" -ForegroundColor Cyan
Write-Host ""
& $banditCmd -r . -ll -f screen

Write-Host ""

# Step 4: Report results
if ($scanExitCode -eq 0) {
    Write-Host "[4/4] Scan completed - No issues found!" -ForegroundColor Green
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Security Scan Summary" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Status: PASSED" -ForegroundColor Green
    Write-Host "  No security issues detected" -ForegroundColor White
    Write-Host ""
} elseif ($scanExitCode -eq 1) {
    Write-Host "[4/4] Scan completed - Security issues found!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host "  Security Scan Summary" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host "  Status: ISSUES FOUND" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Reports generated:" -ForegroundColor White
    Write-Host "    - bandit-report.json (machine-readable)" -ForegroundColor Gray
    Write-Host "    - bandit-report.html (view in browser)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Next steps:" -ForegroundColor White
    Write-Host "    1. Open bandit-report.html in your browser" -ForegroundColor Gray
    Write-Host "    2. Review HIGH severity issues first" -ForegroundColor Gray
    Write-Host "    3. Fix critical security vulnerabilities" -ForegroundColor Gray
    Write-Host "    4. Re-run scan to verify fixes" -ForegroundColor Gray
    Write-Host ""
} else {
    Write-Host "[4/4] Scan failed!" -ForegroundColor Red
    Write-Host "  Check the error messages above for details" -ForegroundColor Yellow
    exit 1
}

Write-Host "========================================" -ForegroundColor Cyan
