# Bandit Security Scanner - Reference Documentation

This document provides comprehensive information about the Bandit security scanning skill, including advanced configuration, common security tests, and integration patterns.

## Table of Contents

1. [Installation Options](#installation-options)
2. [Command-Line Usage](#command-line-usage)
3. [Configuration Files](#configuration-files)
4. [Security Tests](#security-tests)
5. [Output Formats](#output-formats)
6. [Severity and Confidence Levels](#severity-and-confidence-levels)
7. [Suppressing False Positives](#suppressing-false-positives)
8. [CI/CD Integration](#cicd-integration)
9. [Pre-commit Hooks](#pre-commit-hooks)
10. [Best Practices](#best-practices)
11. [Common Security Issues](#common-security-issues)
12. [Troubleshooting](#troubleshooting)

## Installation Options

### Basic Installation
```bash
pip install bandit
```

### With Optional Features
```bash
# TOML support (for pyproject.toml config)
pip install bandit[toml]

# SARIF output format
pip install bandit[sarif]

# Baseline functionality
pip install bandit[baseline]

# All features (recommended)
pip install "bandit[toml,sarif,baseline]"
```

### Installation in Virtual Environment
```bash
python3 -m venv bandit-env
source bandit-env/bin/activate  # Linux/Mac
# OR
.\bandit-env\Scripts\activate   # Windows
pip install "bandit[toml,sarif,baseline]"
```

### Install from Source
```bash
pip install git+https://github.com/PyCQA/bandit#egg=bandit
```

## Command-Line Usage

### Basic Scanning

```bash
# Scan a single file
bandit file.py

# Scan multiple files
bandit file1.py file2.py file3.py

# Scan directory recursively
bandit -r /path/to/project

# Scan current directory
bandit -r .
```

### Filtering by Severity

```bash
# Only show high severity issues
bandit -r . -ll

# Only show medium and high severity
bandit -r . -l

# Show all severity levels (default)
bandit -r .
```

### Output Formats

```bash
# JSON output
bandit -r . -f json -o report.json

# HTML output
bandit -r . -f html -o report.html

# CSV output
bandit -r . -f csv -o report.csv

# XML output
bandit -r . -f xml -o report.xml

# SARIF output (requires sarif feature)
bandit -r . -f sarif -o report.sarif

# Screen output (default, colorized)
bandit -r . -f screen
```

### Context Lines

```bash
# Show 3 lines of context around each issue
bandit -r . -n 3

# Show 5 lines of context
bandit -r . -n 5
```

### Excluding Files/Directories

```bash
# Exclude specific directories
bandit -r . -x tests,docs,venv

# Exclude using glob patterns
bandit -r . --exclude '/test*,*/venv/*'
```

### Running Specific Tests

```bash
# Run only specific tests
bandit -r . -t B201,B301

# Skip specific tests
bandit -r . -s B101,B601

# Run tests from a profile
bandit -r . -p ShellInjection
```

### Baseline Comparison

```bash
# Generate baseline
bandit -r . -f json -o baseline.json

# Compare against baseline (only show new issues)
bandit -r . -b baseline.json
```

### Using Configuration Files

```bash
# Use custom INI config
bandit --ini custom.ini -r .

# Use YAML config
bandit -c bandit.yaml -r .

# Use TOML config
bandit -c pyproject.toml -r .
```

### Other Useful Options

```bash
# Show available tests
bandit -l

# Aggregate output by filename
bandit -r . --aggregate file

# Aggregate output by vulnerability type
bandit -r . --aggregate vuln

# Verbose output
bandit -r . -v

# Quiet mode (minimal output)
bandit -r . -q
```

## Configuration Files

### .bandit (INI Format)

Create `.bandit` in your project root:

```ini
[bandit]
# Paths to exclude from scanning
exclude = /tests,/venv,/__pycache__,*.pyc

# Tests to skip (comma-separated test IDs)
skips = B101,B601

# Only run specific tests (if specified, only these run)
tests = B201,B301

# Exclude specific paths
exclude_dirs = tests,docs,build,dist

# Number of context lines to show
number = 3
```

### bandit.yaml (YAML Format)

Create `bandit.yaml`:

```yaml
# Exclude directories
exclude_dirs:
  - tests
  - venv
  - __pycache__
  - .git
  - build
  - dist

# Tests to skip
skips:
  - B101  # assert_used
  - B601  # paramiko_calls

# Only run specific tests
tests:
  - B201  # flask_debug_true
  - B301  # pickle

# Plugin-specific settings
any_other_function_with_shell_equals_true:
  no_shell:
    - os.execl
    - os.execle
```

Run with: `bandit -c bandit.yaml -r .`

### pyproject.toml (TOML Format)

Add to your `pyproject.toml`:

```toml
[tool.bandit]
exclude_dirs = ["tests", "venv", "__pycache__", ".git"]
skips = ["B101", "B601"]
tests = ["B201", "B301"]

[tool.bandit.any_other_function_with_shell_equals_true]
no_shell = ["os.execl", "os.execle"]
```

Run with: `bandit -c pyproject.toml -r .`

## Security Tests

### Common Security Test IDs

| Test ID | Description | Severity |
|---------|-------------|----------|
| B101 | Use of assert | LOW |
| B102 | exec used | MEDIUM |
| B103 | set_bad_file_permissions | HIGH |
| B104 | hardcoded_bind_all_interfaces | MEDIUM |
| B105 | hardcoded_password_string | LOW |
| B106 | hardcoded_password_funcarg | LOW |
| B107 | hardcoded_password_default | LOW |
| B108 | hardcoded_tmp_directory | MEDIUM |
| B110 | try_except_pass | LOW |
| B112 | try_except_continue | LOW |
| B201 | flask_debug_true | HIGH |
| B301 | pickle | MEDIUM |
| B302 | marshal | MEDIUM |
| B303 | md5 | MEDIUM |
| B304 | insecure_cipher | HIGH |
| B305 | insecure_cipher_mode | MEDIUM |
| B306 | mktemp_q | MEDIUM |
| B307 | eval | HIGH |
| B308 | mark_safe | MEDIUM |
| B309 | httpsconnection | MEDIUM |
| B310 | urllib_urlopen | MEDIUM |
| B311 | random | LOW |
| B312 | telnetlib | HIGH |
| B313 | xml_bad_cElementTree | MEDIUM |
| B314 | xml_bad_ElementTree | MEDIUM |
| B315 | xml_bad_expatreader | MEDIUM |
| B316 | xml_bad_expatbuilder | MEDIUM |
| B317 | xml_bad_sax | MEDIUM |
| B318 | xml_bad_minidom | MEDIUM |
| B319 | xml_bad_pulldom | MEDIUM |
| B320 | xml_bad_etree | MEDIUM |
| B321 | ftplib | HIGH |
| B322 | input | HIGH |
| B323 | unverified_context | MEDIUM |
| B324 | hashlib_insecure_functions | MEDIUM |
| B325 | tempnam | HIGH |
| B401 | import_telnetlib | HIGH |
| B402 | import_ftplib | HIGH |
| B403 | import_pickle | LOW |
| B404 | import_subprocess | LOW |
| B405 | import_xml_etree | LOW |
| B406 | import_xml_sax | LOW |
| B407 | import_xml_expat | LOW |
| B408 | import_xml_minidom | LOW |
| B409 | import_xml_pulldom | LOW |
| B410 | import_lxml | LOW |
| B411 | import_xmlrpclib | HIGH |
| B412 | import_httpoxy | MEDIUM |
| B413 | import_pycrypto | HIGH |
| B501 | request_with_no_cert_validation | HIGH |
| B502 | ssl_with_bad_version | HIGH |
| B503 | ssl_with_bad_defaults | MEDIUM |
| B504 | ssl_with_no_version | HIGH |
| B505 | weak_cryptographic_key | HIGH |
| B506 | yaml_load | MEDIUM |
| B507 | ssh_no_host_key_verification | HIGH |
| B601 | paramiko_calls | MEDIUM |
| B602 | subprocess_popen_with_shell_equals_true | HIGH |
| B603 | subprocess_without_shell_equals_true | LOW |
| B604 | any_other_function_with_shell_equals_true | HIGH |
| B605 | start_process_with_a_shell | HIGH |
| B606 | start_process_with_no_shell | LOW |
| B607 | start_process_with_partial_path | LOW |
| B608 | hardcoded_sql_expressions | MEDIUM |
| B609 | linux_commands_wildcard_injection | HIGH |
| B610 | django_extra_used | MEDIUM |
| B611 | django_rawsql_used | MEDIUM |
| B701 | jinja2_autoescape_false | HIGH |
| B702 | use_of_mako_templates | MEDIUM |
| B703 | django_mark_safe | MEDIUM |

### Test Categories

**Injection Vulnerabilities:**
- B608: SQL injection
- B609: Command injection with wildcards
- B602, B604, B605: Shell injection

**Cryptography Issues:**
- B303, B324: Weak hash functions (MD5, SHA1)
- B304, B305: Insecure ciphers
- B505: Weak cryptographic keys

**Authentication & Authorization:**
- B105, B106, B107: Hardcoded passwords
- B501: No certificate validation
- B507: No host key verification

**Dangerous Functions:**
- B307: eval usage
- B102: exec usage
- B312: telnetlib usage
- B321: ftplib usage

**Deserialization:**
- B301: pickle usage
- B302: marshal usage
- B506: unsafe YAML loading

**XML Vulnerabilities:**
- B313-B320: XML parsing vulnerabilities

## Output Formats

### Screen (Console) Format

Default colorized terminal output:
```bash
bandit -r . -f screen
```

### JSON Format

Machine-readable format for automation:
```bash
bandit -r . -f json -o report.json
```

Example JSON structure:
```json
{
  "errors": [],
  "generated_at": "2025-12-25T12:00:00Z",
  "metrics": {
    "total_lines": 1000,
    "total_loc": 800,
    "nosec": 5
  },
  "results": [
    {
      "code": "password = 'hardcoded'",
      "filename": "app.py",
      "issue_confidence": "HIGH",
      "issue_severity": "LOW",
      "issue_text": "Possible hardcoded password",
      "line_number": 10,
      "line_range": [10],
      "more_info": "https://bandit.readthedocs.io/...",
      "test_id": "B105",
      "test_name": "hardcoded_password_string"
    }
  ]
}
```

### HTML Format

Browser-viewable report:
```bash
bandit -r . -f html -o report.html
```

### CSV Format

Spreadsheet-compatible format:
```bash
bandit -r . -f csv -o report.csv
```

### XML Format

XML-based reporting:
```bash
bandit -r . -f xml -o report.xml
```

### SARIF Format

Static Analysis Results Interchange Format (for IDE integration):
```bash
bandit -r . -f sarif -o report.sarif
```

## Severity and Confidence Levels

### Severity Levels

**HIGH**: Critical security issues
- Should be fixed immediately
- Examples: SQL injection, command injection, hardcoded secrets in production

**MEDIUM**: Moderate security concerns
- Should be reviewed and fixed
- Examples: Use of weak cryptography, insecure deserialization

**LOW**: Minor issues or informational
- May not be actual vulnerabilities
- Examples: Use of assert, imports of potentially dangerous modules

### Confidence Levels

**HIGH**: Very likely to be a real security issue
- High probability of being exploitable
- Requires immediate attention

**MEDIUM**: Probable security issue
- Likely a real vulnerability but may need context
- Should be reviewed carefully

**LOW**: Possible issue
- May be a false positive
- Requires manual code review to determine if it's a real issue

### Filtering by Levels

```bash
# Only HIGH severity
bandit -r . -lll

# MEDIUM and HIGH severity
bandit -r . -ll

# LOW, MEDIUM, and HIGH (default)
bandit -r .
```

## Suppressing False Positives

### Using # nosec Comments

Suppress specific line:
```python
password = "test123"  # nosec
```

Suppress with specific test IDs:
```python
password = "test123"  # nosec B105, B106
```

Suppress with reason:
```python
password = "test123"  # nosec B105 - This is a test password
```

### Using Configuration Files

In `.bandit`:
```ini
[bandit]
skips = B101,B601
```

In `bandit.yaml`:
```yaml
skips:
  - B101
  - B601
```

### Using Command Line

```bash
# Skip specific tests
bandit -r . -s B101,B601

# Only run specific tests
bandit -r . -t B201,B301
```

## CI/CD Integration

### GitHub Actions

Create `.github/workflows/bandit.yml`:

```yaml
name: Bandit Security Scan

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  bandit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.x'

      - name: Install Bandit
        run: pip install "bandit[toml,sarif]"

      - name: Run Bandit
        run: |
          bandit -r . -ll -f json -o bandit-report.json
          bandit -r . -ll -f sarif -o bandit-report.sarif

      - name: Upload SARIF to GitHub
        uses: github/codeql-action/upload-sarif@v2
        if: always()
        with:
          sarif_file: bandit-report.sarif

      - name: Upload JSON report
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: bandit-report
          path: bandit-report.json
```

### GitLab CI

Add to `.gitlab-ci.yml`:

```yaml
bandit-sast:
  stage: test
  image: python:3.11
  script:
    - pip install "bandit[toml]"
    - bandit -r . -ll -f json -o bandit-report.json
  artifacts:
    reports:
      sast: bandit-report.json
    paths:
      - bandit-report.json
    expire_in: 1 week
  only:
    - main
    - merge_requests
```

### Jenkins Pipeline

Add to `Jenkinsfile`:

```groovy
pipeline {
    agent any

    stages {
        stage('Security Scan') {
            steps {
                sh '''
                    pip install "bandit[toml]"
                    bandit -r . -ll -f json -o bandit-report.json
                    bandit -r . -ll -f html -o bandit-report.html
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'bandit-report.*', allowEmptyArchive: true
            publishHTML([
                reportDir: '.',
                reportFiles: 'bandit-report.html',
                reportName: 'Bandit Security Report'
            ])
        }
    }
}
```

### Azure Pipelines

Create `azure-pipelines.yml`:

```yaml
trigger:
  - main

pool:
  vmImage: 'ubuntu-latest'

steps:
- task: UsePythonVersion@0
  inputs:
    versionSpec: '3.x'

- script: |
    pip install "bandit[toml]"
    bandit -r . -ll -f json -o bandit-report.json
  displayName: 'Run Bandit Security Scan'

- task: PublishBuildArtifacts@1
  inputs:
    pathToPublish: 'bandit-report.json'
    artifactName: 'bandit-report'
```

## Pre-commit Hooks

### Setup

Install pre-commit:
```bash
pip install pre-commit
```

Create `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/PyCQA/bandit
    rev: '1.7.5'  # Use latest version
    hooks:
      - id: bandit
        args: ['-ll', '-r', '.']
        exclude: '^tests/'
```

Install the hook:
```bash
pre-commit install
```

### Advanced Pre-commit Configuration

```yaml
repos:
  - repo: https://github.com/PyCQA/bandit
    rev: '1.7.5'
    hooks:
      - id: bandit
        args:
          - '-ll'              # Medium and high severity only
          - '-r'               # Recursive
          - '.'
          - '-x'               # Exclude
          - 'tests,venv'
        exclude: '^(tests/|docs/)'
        files: '\.py$'
```

## Best Practices

### 1. Regular Scanning

- Run Bandit on every commit (pre-commit hooks)
- Include in CI/CD pipeline
- Schedule periodic full scans
- Review reports regularly

### 2. Configuration Management

- Create `.bandit` configuration file
- Version control your configuration
- Document suppressed tests
- Review suppressions periodically

### 3. Prioritization

- Fix HIGH severity issues first
- Address HIGH confidence issues immediately
- Review MEDIUM severity issues
- Evaluate LOW severity in context

### 4. Team Collaboration

- Share Bandit reports with team
- Establish security standards
- Code review security findings
- Train team on common vulnerabilities

### 5. False Positive Management

- Use `# nosec` sparingly
- Document why issues are suppressed
- Review suppressions in code review
- Re-evaluate suppressions periodically

### 6. Integration

- Integrate with IDEs (SARIF format)
- Link to issue tracking systems
- Automate report distribution
- Track metrics over time

## Common Security Issues

### Hardcoded Passwords

**Bad:**
```python
PASSWORD = "admin123"
db_password = "secretpass"
```

**Good:**
```python
import os
PASSWORD = os.environ.get('PASSWORD')
db_password = config.get('database', 'password')
```

### SQL Injection

**Bad:**
```python
query = "SELECT * FROM users WHERE id = " + user_id
cursor.execute(query)
```

**Good:**
```python
query = "SELECT * FROM users WHERE id = %s"
cursor.execute(query, (user_id,))
```

### Command Injection

**Bad:**
```python
os.system("ls " + user_input)
subprocess.call("rm -rf " + filename, shell=True)
```

**Good:**
```python
subprocess.call(['ls', user_input])
subprocess.call(['rm', '-rf', filename])
```

### Weak Cryptography

**Bad:**
```python
import md5
hash = md5.new(data).hexdigest()
```

**Good:**
```python
import hashlib
hash = hashlib.sha256(data).hexdigest()
```

### Insecure Deserialization

**Bad:**
```python
import pickle
data = pickle.loads(user_input)
```

**Good:**
```python
import json
data = json.loads(user_input)
```

### Flask Debug Mode

**Bad:**
```python
app.run(debug=True)
```

**Good:**
```python
app.run(debug=False)
# Or use environment variable
app.run(debug=os.environ.get('DEBUG', False))
```

## Troubleshooting

### Issue: Bandit not found after installation

**Solutions:**
- Ensure pip installed successfully: `pip show bandit`
- Check PATH includes Python Scripts directory
- Try: `python -m bandit -r .`
- Reinstall: `pip install --force-reinstall bandit`

### Issue: Too many false positives

**Solutions:**
- Create `.bandit` configuration file
- Use `skips` to exclude problematic tests
- Add `# nosec` comments for known safe code
- Adjust confidence/severity filters: `-ll`

### Issue: Scan takes too long

**Solutions:**
- Exclude large directories (venv, node_modules)
- Use `.bandit` exclude configuration
- Scan only changed files in CI
- Use baseline comparison for incremental scans

### Issue: Configuration file not being used

**Solutions:**
- Ensure file is named `.bandit` (with dot)
- Place in project root directory
- Use `-r` flag to enable auto-discovery
- Explicitly specify: `bandit -c .bandit -r .`

### Issue: Reports not generated

**Solutions:**
- Check output path is writable
- Ensure format is valid: `json`, `html`, `csv`, `xml`, `sarif`
- Use absolute paths for output files
- Check disk space available

### Issue: Integration with IDE not working

**Solutions:**
- Generate SARIF format: `bandit -r . -f sarif -o report.sarif`
- Install bandit extension in IDE
- Configure IDE to read SARIF reports
- Check IDE logs for errors

## Additional Resources

- **Official Documentation**: https://bandit.readthedocs.io/
- **GitHub Repository**: https://github.com/PyCQA/bandit
- **PyPI Package**: https://pypi.org/project/bandit/
- **Discord Community**: Join PyCQA Discord
- **Issue Tracker**: https://github.com/PyCQA/bandit/issues
- **Security Best Practices**: OWASP Python Security
- **CWE Database**: https://cwe.mitre.org/

## Support

For issues with:
- **This skill**: Check this documentation or modify scripts
- **Bandit tool**: Visit GitHub issues
- **Security questions**: Consult security team or OWASP resources
- **Configuration help**: See official Bandit documentation
