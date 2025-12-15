# Tests

This document describes the testing strategy for the CeloHT project.

## Test Philosophy

CeloHT prioritizes:
- Security
- Transparency
- Reliability
- Compliance with Web3 best practices

All critical components must be tested before any release.

## Types of Tests

### 1. Unit Tests
- Test individual functions and modules
- Focus on business logic related to:
  - Education services
  - Agent operations
  - Reforestation tracking
- Required coverage: minimum 80%

### 2. Integration Tests
- Verify interactions between modules
- Validate integration with:
  - Celo network
  - cUSD
  - Valora-compatible flows

### 3. Security Tests
- Static analysis
- Dependency vulnerability scans

### 4. Manual Reviews
- Code review by maintainers
- Compliance review (non-token confirmation)

## Test Environment

- Node.js LTS
- Testnet only (no mainnet testing without approval)

## Continuous Integration

- Tests must pass before merging to `main`
- Pull Requests without tests will be rejected