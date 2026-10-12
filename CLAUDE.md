# Claude Code Operating Guidelines — Byakugan Scan

This document defines core instructions and commands for **Claude Code** when working on the **Byakugan Scan** repository.

---

## 🛠️ Essential Commands

### Build & Test Commands
```bash
# Run the complete test suite (Swift unit tests + Next.js website build)
./scripts/run_tests.sh

# Build and codesign the macOS app bundle (.app in ./build)
./scripts/build_app.sh

# Build website only
cd website && npm run build

# Run website locally in development mode
cd website && npm run dev
```

### Git Branching & Workflow Commands
```bash
# Switch to dev branch and pull latest changes
git checkout dev && git pull origin dev

# Create a new feature branch adhering to branch rules
git checkout -b feature/dev/<feature-name>

# Create an emergency hotfix branch
git checkout -b hotfix/<hotfix-name>

# Verify branch conforms to CI rules before pushing
git status
```

---

## 🌿 Branch Hierarchy & Naming Rules

We strictly protect `main`, `uat`, and `dev`. Direct pushes are disabled.

1. **Branch Roles:**
   - **`dev`**: Active development. All feature PRs MUST branch from and target `dev`.
   - **`uat`**: Pre-release staging & User Acceptance Testing. Merges from `dev`.
   - **`main`**: Production release. Merges from `uat` or critical hotfixes.
2. **Branch Naming Standard:**
   - Features: `feature/<base-branch>/<feature-name>` (e.g., `feature/dev/hotkey-recorder`)
   - Hotfixes: `hotfix/<fix-name>` (e.g., `hotfix/permissions-hang`)
   - Core branches: `main`, `dev`, `uat`
   - *Fork PRs*: Permitted by CI with standard descriptive names (`feature/*`, `fix/*`).

---

## 🧪 Mandatory Test-Driven Development (TDD)

Every new feature or bugfix MUST include automated tests.
1. **Unit Tests:** Add tests to `Tests/RunAllTests.swift`.
2. **Include New Files:** If adding a new Swift file under `ByakuganScan/Core/` or `ByakuganScan/Shared/`, add it to `SWIFT_FILES` in `scripts/run_tests.sh`.
3. **Execution:** Run `./scripts/run_tests.sh` before raising any PR or finishing your task. All tests must pass (100% success).

---

## ⚡ Performance & System Invariants

1. **Zero Cloud / 100% Offline:** Never add network requests, telemetry, or remote analytics to the macOS app.
2. **In-RAM Screen Capture:** Never write screenshot files to disk (`/tmp`). Use `/usr/sbin/screencapture -c -s -x` to copy directly to `NSPasteboard.general` and read the image in-memory.
3. **Silent Permission Preflight:** Use `CGPreflightScreenCaptureAccess()`, never `CGWindowListCreateImage`, to avoid system permission popups.
4. **Code Signing:** Maintain Designated Requirement `-r='designated => identifier "cloud.aritro.byakugan-scan"'` during `codesign`.

---

## 🔒 Code Ownership & PR Review

- **Code Owner:** `@halcyon-past` (Aritro Saha) via `.github/CODEOWNERS`.
- All PRs require review approval from the code owner before merging.
- Commit messages must follow Conventional Commits (`feat:`, `fix:`, `test:`, `docs:`, `refactor:`, `chore:`).
