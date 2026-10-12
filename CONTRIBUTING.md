# Contributing to Byakugan Scan 🤝

Thank you for your interest in contributing to **Byakugan Scan**! As an open-source project, we welcome contributions from developers, designers, and testers of all skill levels.

---

## Code of Conduct

This project is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to **[aritrosaha2025@gmail.com](mailto:aritrosaha2025@gmail.com)**.

---

## Ways to Contribute

1. **Bug Reports:** Found something broken? File a detailed bug report using our issue template.
2. **Feature Suggestions:** Have an idea to make Byakugan Scan even better? Open a feature request.
3. **Code Contributions:** Fix open bugs, optimize performance, improve accessibility, or implement requested features.
4. **Documentation:** Improve guides, README details, website copy, or code doc comments.
5. **Localization:** Add or verify OCR language configurations and UI strings.

---

## Getting Started with Local Development

### Prerequisites
- macOS 14.0 (Sonoma) or newer
- Swift 6.0+ toolchain
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`)
- (Optional) Xcode 15+

### Fork and Clone
```bash
# 1. Fork the repository on GitHub
# 2. Clone your fork locally
git clone https://github.com/<your-username>/byakugan-scan.git
cd byakugan-scan

# 3. Add upstream remote
git remote add upstream https://github.com/halcyon-past/byakugan-scan.git
```

### Generating the Xcode Project
We use `project.yml` with XcodeGen to ensure clean version control without merge conflicts on `.pbxproj` files:
```bash
xcodegen generate
```

### Building & Running
You can compile and run via Xcode:
```bash
open ByakuganScan.xcodeproj
# Press Cmd + R in Xcode
```

Or build the standalone `.app` bundle from terminal:
```bash
./scripts/build_app.sh
open "build/Byakugan Scan.app"
```

---

## Architectural Guidelines

- **Architecture:** Lightweight MVVM with dedicated Service Singletons (`OCRService`, `BarcodeService`, `HotkeyService`, `HistoryService`).
- **Orchestration:** `ScanCoordinator` is the `@MainActor` hub that connects user triggers to screen capture and Vision processing.
- **Privacy First:** Never introduce external network calls or cloud dependencies. All OCR and barcode recognition must remain 100% on-device.
- **Swift Concurrency:** Follow Swift 6 strict concurrency rules. Annotate UI-facing methods with `@MainActor` and keep background Vision processing off the main thread.
- **Menu Bar UX:** Keep memory footprint minimal. Clean up resources immediately after scan completion.

---

## Development Workflow & Git Standards

### 1. Create a Topic Branch
Branch names should follow these conventions:
```bash
git checkout -b feat/your-feature-name
git checkout -b fix/issue-description
git checkout -b docs/documentation-improvement
```

### 2. Commit Guidelines
Write clear, concise commit messages adhering to [Conventional Commits](https://www.conventionalcommits.org/):
- `feat: add sound effect customization`
- `fix: prevent duplicate shortcut registrations`
- `docs: update troubleshooting guide for Screen Recording`
- `refactor: clean up barcode symbology mapping`

### 3. Submitting a Pull Request
1. Ensure your code compiles cleanly without warnings:
   ```bash
   ./scripts/build_app.sh
   ```
2. Push your branch to your fork:
   ```bash
   git push origin feat/your-feature-name
   ```
3. Open a Pull Request on GitHub against `main`.
4. Fill in the provided Pull Request template completely.

---

## Need Help?

If you have questions about the codebase or architecture, feel free to open a Discussion on GitHub or reach out directly at **[aritrosaha2025@gmail.com](mailto:aritrosaha2025@gmail.com)**.
