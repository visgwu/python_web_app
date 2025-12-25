#!/bin/bash
# run_bandit_scan.sh
# Bandit Security Scanner for Python Applications
# This script installs Bandit and runs comprehensive security analysis

echo "========================================"
echo "  Bandit Security Analysis"
echo "========================================"
echo ""

# Step 1: Install Bandit with all optional features
echo "[1/4] Installing Bandit..."
pip install -q "bandit[toml,sarif,baseline]"
if [ $? -eq 0 ]; then
    echo "  [OK] Bandit installed successfully"
else
    echo "  [ERROR] Failed to install Bandit"
    exit 1
fi
echo ""

# Step 2: Check for configuration file
echo "[2/4] Checking configuration..."
if [ -f ".bandit" ]; then
    echo "  [OK] Found .bandit configuration file"
elif [ -f "pyproject.toml" ]; then
    echo "  [INFO] Found pyproject.toml (checking for Bandit config)"
else
    echo "  [INFO] No configuration file found, using defaults"
fi
echo ""

# Step 3: Run Bandit security scan
echo "[3/4] Running security analysis..."
echo "  Scanning Python files recursively..."
echo "  Target: Current directory"
echo ""

# Run Bandit with comprehensive options
# -r: recursive
# -ll: only show medium and high severity issues
# -f json: output JSON format
# -o: output file
bandit -r . -ll -f json -o bandit-report.json

scanExitCode=$?

# Also generate HTML report for easier viewing
bandit -r . -ll -f html -o bandit-report.html

# Generate console output with full details
echo ""
echo "  Detailed findings:"
echo ""
bandit -r . -ll -f screen

echo ""

# Step 4: Report results
if [ $scanExitCode -eq 0 ]; then
    echo "[4/4] Scan completed - No issues found!"
    echo ""
    echo "========================================"
    echo "  Security Scan Summary"
    echo "========================================"
    echo "  Status: PASSED"
    echo "  No security issues detected"
    echo ""
elif [ $scanExitCode -eq 1 ]; then
    echo "[4/4] Scan completed - Security issues found!"
    echo ""
    echo "========================================"
    echo "  Security Scan Summary"
    echo "========================================"
    echo "  Status: ISSUES FOUND"
    echo ""
    echo "  Reports generated:"
    echo "    - bandit-report.json (machine-readable)"
    echo "    - bandit-report.html (view in browser)"
    echo ""
    echo "  Next steps:"
    echo "    1. Open bandit-report.html in your browser"
    echo "    2. Review HIGH severity issues first"
    echo "    3. Fix critical security vulnerabilities"
    echo "    4. Re-run scan to verify fixes"
    echo ""
else
    echo "[4/4] Scan failed!"
    echo "  Check the error messages above for details"
    exit 1
fi

echo "========================================"
