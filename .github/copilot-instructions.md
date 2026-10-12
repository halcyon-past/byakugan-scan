# GitHub Copilot & Coding Agent Instructions — Byakugan Scan

These instructions apply to all GitHub Copilot agents, Copilot Workspace, and automated coding harnesses operating within this repository.

---

## 1. Branch Strategy & Target Selection
- **Branch Hierarchy:**
  - `dev`: Active development and feature integration.
  - `uat`: Staging and User Acceptance Testing.
  - `main`: Production release.
- **Target Branch Rule:** Pull Requests introducing new features or enhancements must target `dev` (never `main`).

## 2. Branch Naming Rules
- Branches created within this repository must adhere to:
  - `feature/<base-branch>/<feature-name>` (e.g. `feature/dev/ocr-performance`)
  - `hotfix/<feature-name>` (e.g. `hotfix/permissions-hang`)
  - Core branches: `main`, `dev`, `uat`
- PRs from forks are permitted by CI.

## 3. Mandatory Testing & Quality Gate
- Any change introducing new models, logic, extensions, or services **MUST** include automated unit tests added to `Tests/RunAllTests.swift`.
- If new Swift source files are added, register them in `scripts/run_tests.sh`.
- Always verify that `./scripts/run_tests.sh` passes completely (0 errors) before requesting reviews.

## 4. Architectural Rules
- **No Disk Capture:** Always use in-RAM clipboard capture (`/usr/sbin/screencapture -c -s -x`) to avoid Spotlight/MADService disk analysis hangs.
- **Silent Permissions:** Preflight permissions using `CGPreflightScreenCaptureAccess()`.
- **100% Offline:** Zero network requests or telemetry.
- **Code Signing:** Maintain designated requirement `cloud.aritro.byakugan-scan`.

## 5. Code Review
- Managed by `@halcyon-past` via `.github/CODEOWNERS`.
- Conventional commits required (`feat:`, `fix:`, `test:`, `docs:`, `chore:`).
