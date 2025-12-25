#!/bin/bash
# run_sonar_scan.sh
# SonarQube/SonarCloud Scanner for Python Web Application
# This script installs pysonar and runs a code quality analysis

echo "========================================"
echo "  SonarQube Code Quality Scan"
echo "========================================"
echo ""

# Step 1: Install pysonar if not already installed
echo "[1/3] Installing pysonar..."
pip install -q pysonar
if [ $? -eq 0 ]; then
    echo "  ✓ pysonar installed successfully"
else
    echo "  ✗ Failed to install pysonar"
    exit 1
fi
echo ""

# Step 2: Run the SonarQube scan
echo "[2/3] Running SonarQube analysis..."
echo "  Project: python-web-app"
echo "  Organization: visgwuorg"
echo ""

pysonar --sonar-token="032921cd8d8eef461bb9f341603c1052292fbf8d" \
        --sonar-project-key="python-web-app" \
        --sonar-organization="visgwuorg"

if [ $? -eq 0 ]; then
    echo ""
    echo "[3/3] Scan completed successfully!"
    echo ""
    echo "========================================"
    echo "  View your results at:"
    echo "  https://sonarcloud.io/project/overview?id=python-web-app"
    echo "========================================"
else
    echo ""
    echo "[3/3] Scan failed!"
    echo "  Check the error messages above for details"
    exit 1
fi
