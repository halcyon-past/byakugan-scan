# Contributing to Byakugan Scan 🤝

Thank you for your interest in contributing to **Byakugan Scan**! As an open-source macOS utility, we welcome contributions from developers, designers, and testers of all skill levels.

---

## Code of Conduct

This project is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to **[aritrosaha2025@gmail.com](mailto:aritrosaha2025@gmail.com)**.

---

## 🌿 Branching Strategy & Workflow

We maintain a strict multi-tier branch model to keep the codebase stable and reliable:

| Branch | Purpose | Protection Policy | Target For |
| :--- | :--- | :--- | :--- |
| **`main`** | Production releases | Protected: PR required, passing CI, code owner review | Merges from `uat` or critical hotfixes |
| **`uat`** | User Acceptance Testing & Pre-release staging | Protected: PR required, passing CI, code owner review | Release stabilization before production |
| **`dev`** | Active development & feature integration | Protected: PR required, passing CI, code owner review | All general feature PRs & bugfixes |

---

## 🏷️ Branch Naming Conventions

All branches must adhere to our standardized naming rules:

### 1. Internal Repository Branches
If you have write access to the main repository, new branches **must** follow one of these patterns:
- **Feature Branches:** `feature/<base-branch>/<feature-name>`
  - Example targeting `dev`: `feature/dev/shortcut-recorder`
  - Example targeting `uat`: `feature/uat/release-fixes`
- **Hotfix Branches:** `hotfix/<feature-name>`
  - Example: `hotfix/permissions-hang`
- **Protected Core Branches:** `main`, `dev`, `uat`

### 2. Forked Repository Contributions
If you are contributing from a personal fork:
- You are free to name your branch `feature/<base-branch>/<feature-name>`, `feature/<name>`, or `fix/<name>`.
- Our GitHub Actions CI automatically recognizes fork PRs and permits their branch names while validating code quality and test execution.

---

## 🔒 Code Ownership & Review Policy

- **Code Ownership:** Managed via [`.github/CODEOWNERS`](.github/CODEOWNERS) assigned to **`@halcyon-past`**.
- **Pull Request Review:** All pull requests targeting `main`, `dev`, or `uat` require an approving review from the code owner before they can be merged.
- **Automated Status Checks:** The CI test suite must pass 100% on Apple Silicon runners (`macos-14`) before a PR can be merged.

---

## 🧪 Local Automated Testing

Before submitting a pull request, run the local automated test runner:
```bash
./scripts/run_tests.sh
```

This verifies:
1. **Swift Core Unit Tests (14/14):**
   - String formatting, URL, email, and phone detection
   - Data models (`ScanResult`, `ScanType` Codable serialization)
   - `AppSettings` defaults and persistent mutations
   - `HotkeyService` global shortcut parser
   - `NSImage` resizing and raster data conversion
   - `HistoryService` local file operations
2. **Next.js Production Website Build:**
   - Typechecking, linting, and Next.js static asset optimization

---

## 🛠️ Step-by-Step Contribution Guide

### 1. Fork and Clone
```bash
# 1. Fork on GitHub: https://github.com/halcyon-past/byakugan-scan
# 2. Clone your fork locally
git clone https://github.com/<your-username>/byakugan-scan.git
cd byakugan-scan

# 3. Add upstream remote
git remote add upstream https://github.com/halcyon-past/byakugan-scan.git
git fetch upstream
```

### 2. Enable Local Git Hooks (Recommended)
We provide a pre-push hook in `.githooks/` that catches branch naming violations before they reach remote:
```bash
git config core.hooksPath .githooks
```

### 3. Create Your Branch
Branch from **`upstream/dev`** for all new features:
```bash
git checkout -b feature/dev/your-feature-name upstream/dev
```

### 4. Build & Test Locally
Generate the Xcode project and build:
```bash
xcodegen generate
./scripts/build_app.sh
open "build/Byakugan Scan.app"
```

Verify tests:
```bash
./scripts/run_tests.sh
```

### 5. Commit & Push
Adhere to [Conventional Commits](https://www.conventionalcommits.org/):
```bash
git commit -m "feat(ocr): improve barcode detection accuracy"
git push origin feature/dev/your-feature-name
```

### 6. Open a Pull Request
1. Navigate to GitHub and open a Pull Request targeting the **`dev`** branch (or `uat`/`main` if a hotfix).
2. Complete the Pull Request template.
3. Wait for the automated CI suite to pass and for review feedback.

---

## 🤖 AI Coding Harnesses & Assistant Instructions

If you use AI coding assistants or harnesses (such as **Claude Code**, **Google Antigravity**, **OpenAI Codex**, **GitHub Copilot**, or **Cursor**), our repository includes preconfigured instruction files:

- **[AGENTS.md](AGENTS.md)**: Universal instructions for AI agents, Codex, Antigravity, and Cursor.
- **[CLAUDE.md](CLAUDE.md)**: Optimized CLI guidance for Claude Code.
- **[.github/copilot-instructions.md](.github/copilot-instructions.md)**: Repository guidelines for GitHub Copilot Workspace.

### ⚠️ Mandatory Rule for AI-Assisted PRs:
Every feature or service modification implemented via AI coding assistants **MUST include corresponding unit tests** in `Tests/RunAllTests.swift`. The assistant must run `./scripts/run_tests.sh` to ensure all tests pass (0 failures) prior to submitting a pull request.

---

## Architectural Guidelines

- **Architecture:** Lightweight MVVM with dedicated Service Singletons (`OCRService`, `ScreenCaptureService`, `HotkeyService`, `HistoryService`).
- **Orchestration:** `ScanCoordinator` is the `@MainActor` central controller.
- **Privacy First:** 100% on-device offline processing. Never introduce external network tracking or cloud OCR dependencies.
- **Memory Footprint:** Keep memory allocations transient. Releasing captured buffers immediately after recognition is essential.

---

## Need Help?

If you have questions about architecture or testing, open an issue or discussion on GitHub or contact **[aritrosaha2025@gmail.com](mailto:aritrosaha2025@gmail.com)**.

