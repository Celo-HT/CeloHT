#!/bin/bash

GITHUB_USERNAME="Celo-HT"
GITHUB_REPO="CeloHT"
REMOTE_URL="git@github.com:$GITHUB_USERNAME/$GITHUB_REPO.git"

# Check prerequisites
command -v git >/dev/null 2>&1 || { echo "git not found. Install git."; exit 1; }
command -v node >/dev/null 2>&1 || { echo "Node.js not found. Install Node.js."; exit 1; }
command -v npm >/dev/null 2>&1 || { echo "npm not found. Install npm."; exit 1; }

mkdir -p $GITHUB_REPO/.github/workflows
cd $GITHUB_REPO || exit

# .env.example
cat > .env.example << 'EOF'
APP_NAME=CeloHT
APP_ENV=development
APP_DEBUG=true
APP_URL=http://localhost:3000
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=celoht_db
DB_USERNAME=root
DB_PASSWORD=secret
CELO_NODE_URL=https://forno.celo.com
CELO_PRIVATE_KEY=your_private_key_here
CELO_ACCOUNT_ADDRESS=your_account_address_here
REDIS_URL=redis://127.0.0.1:6379
EOF

# ISSUE_TEMPLATE.md
cat > .github/ISSUE_TEMPLATE.md << EOF
---
name: Bug / Issue
about: Report a bug or request a feature
title: "[ISSUE]"
labels: bug
assignees: ''

## Description
Provide a clear description of the issue.

## Steps to Reproduce
1. Step one
2. Step two
3. Step three

## Expected Result
Describe expected behavior.

## Additional Info
Provide any relevant context.
EOF

# PULL_REQUEST_TEMPLATE.md
cat > .github/PULL_REQUEST_TEMPLATE.md << EOF
## Summary
Provide a summary and reference the related issue.
Fixes #(issue)

## Type of Change
- [ ] Bug Fix
- [ ] New Feature
- [ ] Documentation Update
- [ ] Other

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added where necessary
- [ ] Documentation updated if needed
- [ ] No new warnings

## Notes
Provide additional information if necessary.
EOF

# ci.yml
cat > .github/workflows/ci.yml << EOF
name: CI
on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]
jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '20'
      - name: Install Dependencies
        run: npm ci
      - name: Run Tests
        run: npm test
      - name: Build
        run: npm run build
EOF

# CODEOWNERS
cat > CODEOWNERS << EOF
*       @$GITHUB_USERNAME
/docs/  @doc-team
/src/   @dev-team
EOF

# MAINTAINERS.md
cat > MAINTAINERS.md << EOF
# Maintainers
## Core Team
- Lead Developer: @$GITHUB_USERNAME
- Blockchain Engineer: @blockchain-dev
- DevOps: @devops-team
## Documentation
- Docs Maintainer: @doc-team
## Contact
Open an issue or contact the core team via GitHub.
EOF

# Git init
if [ ! -d ".git" ]; then
    git init
    git add .
    git commit -m "Initial commit: professional repo structure"
fi

# Branches
git checkout -b main 2>/dev/null || git checkout main
git checkout -b develop 2>/dev/null || git checkout develop
git checkout main

# Remote
if ! git remote | grep -q origin; then
    git remote add origin $REMOTE_URL
fi

# Push
git push -u origin main
git push -u origin develop

