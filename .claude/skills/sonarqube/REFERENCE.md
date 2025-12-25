# SonarQube Skill - Reference Documentation

This document provides detailed information about the SonarQube scanning skill, including configuration options, advanced usage, and troubleshooting.

## Table of Contents

1. [Configuration](#configuration)
2. [Advanced Usage](#advanced-usage)
3. [pysonar Options](#pysonar-options)
4. [Environment Variables](#environment-variables)
5. [CI/CD Integration](#cicd-integration)
6. [Troubleshooting](#troubleshooting)
7. [Best Practices](#best-practices)

## Configuration

### Current Configuration

The skill is currently configured with:
- **SonarCloud Token**: `032921cd8d8eef461bb9f341603c1052292fbf8d`
- **Project Key**: `python-web-app`
- **Organization**: `visgwuorg`
- **Platform**: SonarCloud (cloud-hosted)

### Updating Configuration

To update the configuration, edit the script files:
- Windows: `.claude/skills/sonarqube/scripts/run_sonar_scan.ps1`
- Linux/Mac: `.claude/skills/sonarqube/scripts/run_sonar_scan.sh`

Update the following parameters:
```bash
pysonar --sonar-token="YOUR_TOKEN" \
        --sonar-project-key="YOUR_PROJECT_KEY" \
        --sonar-organization="YOUR_ORG"
```

### Getting SonarCloud Credentials

1. **Create Account**: Sign up at https://sonarcloud.io
2. **Generate Token**:
   - Go to Account > Security > Generate Token
   - Copy the token
3. **Create Project**:
   - Click "+" > Analyze new project
   - Set up your project and get the project key
4. **Find Organization**:
   - Check your account settings for organization key

## Advanced Usage

### Custom Source Paths

By default, pysonar scans the current directory. To specify custom paths:

```bash
pysonar --sonar-token="YOUR_TOKEN" \
        --sonar-project-key="YOUR_PROJECT" \
        --sonar-organization="YOUR_ORG" \
        --sources="src,lib"
```

### Exclusions

Exclude files or directories from scanning:

```bash
pysonar --sonar-token="YOUR_TOKEN" \
        --sonar-project-key="YOUR_PROJECT" \
        --sonar-organization="YOUR_ORG" \
        --exclusions="**/test/**,**/__pycache__/**,**/migrations/**"
```

### Branch Analysis

Analyze a specific branch:

```bash
pysonar --sonar-token="YOUR_TOKEN" \
        --sonar-project-key="YOUR_PROJECT" \
        --sonar-organization="YOUR_ORG" \
        --branch="feature/new-feature"
```

## pysonar Options

### Common Options

| Option | Description | Example |
|--------|-------------|---------|
| `--sonar-token` | Authentication token | `--sonar-token="abc123"` |
| `--sonar-project-key` | Unique project identifier | `--sonar-project-key="my-project"` |
| `--sonar-organization` | SonarCloud organization | `--sonar-organization="myorg"` |
| `--sonar-host-url` | Custom SonarQube server | `--sonar-host-url="https://sonar.company.com"` |
| `--sources` | Source code directories | `--sources="src,lib"` |
| `--exclusions` | Files/folders to exclude | `--exclusions="**/test/**"` |
| `--encoding` | Source file encoding | `--encoding="UTF-8"` |
| `--branch` | Branch name | `--branch="main"` |
| `--debug` | Enable debug mode | `--debug` |

### Quality Gate Options

Configure quality gate thresholds:

```bash
--quality-gate-wait=true          # Wait for quality gate result
--quality-gate-timeout=300        # Timeout in seconds
```

## Environment Variables

Instead of command-line arguments, you can use environment variables:

### Windows (PowerShell)
```powershell
$env:SONAR_TOKEN = "your_token"
$env:SONAR_PROJECT_KEY = "your_project"
$env:SONAR_ORGANIZATION = "your_org"
pysonar
```

### Linux/Mac (Bash)
```bash
export SONAR_TOKEN="your_token"
export SONAR_PROJECT_KEY="your_project"
export SONAR_ORGANIZATION="your_org"
pysonar
```

### Using .env File

Create a `.env` file (add to `.gitignore`):
```env
SONAR_TOKEN=your_token_here
SONAR_PROJECT_KEY=python-web-app
SONAR_ORGANIZATION=visgwuorg
```

## CI/CD Integration

### GitHub Actions

Create `.github/workflows/sonarcloud.yml`:

```yaml
name: SonarCloud Analysis
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  sonarcloud:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.x'

      - name: Install pysonar
        run: pip install pysonar

      - name: Run SonarCloud Scan
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        run: |
          pysonar --sonar-token="${SONAR_TOKEN}" \
                  --sonar-project-key="python-web-app" \
                  --sonar-organization="visgwuorg"
```

### GitLab CI

Create `.gitlab-ci.yml`:

```yaml
sonarcloud-check:
  stage: test
  image: python:3.11
  script:
    - pip install pysonar
    - pysonar --sonar-token="${SONAR_TOKEN}"
            --sonar-project-key="python-web-app"
            --sonar-organization="visgwuorg"
  only:
    - main
    - merge_requests
```

### Jenkins Pipeline

Add to `Jenkinsfile`:

```groovy
stage('SonarQube Analysis') {
    steps {
        withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
            sh '''
                pip install pysonar
                pysonar --sonar-token="${SONAR_TOKEN}" \
                        --sonar-project-key="python-web-app" \
                        --sonar-organization="visgwuorg"
            '''
        }
    }
}
```

## Troubleshooting

### Common Issues

#### 1. Authentication Failed

**Error**: `Unauthorized: Invalid credentials`

**Solutions**:
- Verify your SonarCloud token is correct
- Check if token has expired (regenerate if needed)
- Ensure project key and organization are correct
- Confirm you have permissions on the project

#### 2. Project Not Found

**Error**: `Project 'python-web-app' not found`

**Solutions**:
- Verify project key matches exactly (case-sensitive)
- Check project exists in your SonarCloud organization
- Ensure you're using the correct organization key

#### 3. Network Issues

**Error**: `Connection timeout` or `Connection refused`

**Solutions**:
- Check internet connectivity
- Verify firewall/proxy settings
- Check SonarCloud status: https://status.sonarcloud.io
- Try increasing timeout: `--timeout=600`

#### 4. pysonar Installation Fails

**Error**: `pip install pysonar` fails

**Solutions**:
- Update pip: `pip install --upgrade pip`
- Check Python version compatibility (3.7+)
- Try with user flag: `pip install --user pysonar`
- Check for conflicting packages

#### 5. Scan Takes Too Long

**Issue**: Scan runs for very long time

**Solutions**:
- Add exclusions for large directories
- Exclude test files and dependencies
- Use `--debug` to see what's being scanned
- Check for large binary files

#### 6. Quality Gate Failed

**Error**: Build fails due to quality gate

**Solutions**:
- Review issues in SonarCloud dashboard
- Fix critical bugs and security vulnerabilities first
- Adjust quality gate thresholds if needed
- Use `--quality-gate-wait=false` to not block on failures

### Debug Mode

Enable verbose output for troubleshooting:

```bash
pysonar --debug \
        --sonar-token="YOUR_TOKEN" \
        --sonar-project-key="YOUR_PROJECT" \
        --sonar-organization="YOUR_ORG"
```

## Best Practices

### 1. Security

- **Never commit tokens** to version control
- Store tokens in environment variables or secrets management
- Rotate tokens regularly
- Use read-only tokens for CI/CD when possible

### 2. Scan Configuration

- **Exclude unnecessary files**: tests, migrations, generated code
- **Scan on every PR**: Catch issues early
- **Monitor trends**: Track metrics over time
- **Set realistic quality gates**: Don't block on minor issues

### 3. Performance

- **Exclude large directories**: `node_modules`, `venv`, `__pycache__`
- **Scan only source code**: Exclude docs, assets
- **Use branch analysis**: Compare against base branch
- **Cache dependencies**: Speed up CI/CD pipelines

### 4. Code Quality

- **Fix critical issues first**: Security > Bugs > Code Smells
- **Review new issues**: Focus on recently introduced problems
- **Set up notifications**: Get alerts for failed quality gates
- **Regular maintenance**: Schedule periodic quality reviews

### 5. Team Collaboration

- **Share results**: Make dashboards visible to team
- **Set team standards**: Agree on quality thresholds
- **Code review integration**: Link SonarCloud to PRs
- **Training**: Educate team on interpreting results

## Additional Resources

- **SonarCloud Documentation**: https://docs.sonarcloud.io
- **pysonar GitHub**: https://github.com/pysonar/pysonar
- **SonarQube Rules**: https://rules.sonarsource.com/python
- **Community Forum**: https://community.sonarsource.com

## Support

For issues with:
- **This skill**: Check this documentation or modify scripts
- **pysonar tool**: Visit pysonar GitHub issues
- **SonarCloud platform**: Contact SonarCloud support
- **Quality gate rules**: Check SonarCloud project settings
