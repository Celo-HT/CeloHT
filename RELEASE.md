# Release Process

This document defines how CeloHT releases new versions.

## Versioning

CeloHT follows Semantic Versioning:

MAJOR.MINOR.PATCH  
Example: 1.2.0

- MAJOR: Breaking changes
- MINOR: New features
- PATCH: Bug fixes and documentation updates

## Release Steps

1. Feature completion on `develop` branch
2. Full test suite execution
3. Security and compliance review
4. Update documentation (README, DISCLAIMER, etc.)
5. Version bump
6. Merge into `main`
7. Tag release (GitHub tag)
8. Publish release notes

## Release Notes Must Include

- Summary of changes
- Security considerations
- Confirmation that:
  - CeloHT is NOT a token
  - No financial instrument was introduced

## Hotfix Policy

- Critical bugs can be patched directly from `main`
- Hotfix must include:
  - Issue description
  - Test validation
  - Maintainer approval