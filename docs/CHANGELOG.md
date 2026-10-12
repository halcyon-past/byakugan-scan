# Changelog

All notable changes to **Byakugan Scan** will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) and the [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format.

---

## [Unreleased]

### Added
- **Official Homebrew Cask Distribution:** Added official Homebrew Cask formula (`Casks/byakugan-scan.rb`) and official tap support (`halcyon-past/tap/byakugan-scan`), enabling seamless installation and upgrades via `brew install --cask halcyon-past/tap/byakugan-scan`.
- **Interactive Web Installer Tabs:** Added a dual-tab installation card to the marketing website hero section featuring one-click copyable Homebrew commands, direct DMG downloads, SHA-256 checksum copying, and file size badges.

### Changed
- **Conflict-Free Default Shortcuts:** Changed default QR code scan shortcut to `⌘⇧6` and barcode scan shortcut to `⌘⇧7` to eliminate hotkey collisions with native macOS system screenshot shortcuts (`⌘⇧3`, `⌘⇧4`, `⌘⇧5`).
- **3D Follower Eyeball Trajectory:** Recalibrated 3D Three.js Byakugan eyeball follower coordinates and ambient lighting stages for improved visual hierarchy across desktop and mobile devices.

### Fixed
- **Xcode Target Compilation:** Regenerated `ByakuganScan.xcodeproj` via `xcodegen` to ensure `UpdateService.swift` and related components are properly included in the build target.

### Security
- **Hardened GitHub Actions Token Permissions:** Added explicit least-privilege `permissions` blocks (`contents: read` / `contents: write`) across all CI/CD workflow manifests.
- **Dependency Vulnerability Remediation:** Upgraded Next.js to 15.2.3 and refreshed website packages to eliminate all reported Dependabot security vulnerabilities.

---

## [1.0.1] — 2026-10-12

### Added
- **Native Zero-Dependency In-Place Auto-Updater:** Seamless in-app version checker in the About settings tab that queries the GitHub Releases API and executes an atomic in-place binary swap and restart without requiring users to download or drag a DMG.
- **Automatic Background Update Checks on Launch:** Configurable user preference in General settings to silently check for new releases when Byakugan Scan launches.
- **Interactive Update Notification Banner:** Dynamic notification badge in the menu bar popover and About settings directing users to update with a single click.
- **ZIP Release Artifacts:** Added compressed `ByakuganScan.zip` release packages alongside universal DMGs for instantaneous in-place extraction via native macOS `ditto`.
- **Automated Test Suite Expansion:** Added automated unit tests covering semantic version comparison, numeric chunk sorting, GitHub release asset discovery, and update lifecycle states (21 passing tests).

---

## [1.0.0] — 2026-10-12

### 🎉 Initial Release

The official 1.0.0 release of **Byakugan Scan** — a high-performance, lightweight, fully on-device macOS utility for instant OCR, QR code scanning, and barcode recognition.

### Added

#### Core Performance & Capture Pipeline
- **Instant In-Memory Screen Capture:** Direct RAM capture via `/usr/sbin/screencapture -c -s -x` eliminating disk I/O and Spotlight metadata (`mdwrite`) indexing delays.
- **Hardware-Accelerated Vision OCR:** Native `VNRecognizeTextRequest` Revision 3 running directly on the Apple Silicon Neural Engine (ANE) with sub-90ms recognition speed.
- **Background Pre-Warming:** Vision and CoreML neural models pre-warm automatically on launch to eliminate cold-start latency on the first scan.
- **Re-scan Last Selection:** Instantly re-process the most recent rectangular region (`⌘⌥S`) without re-dragging.
- **TCC Screen Recording Stability:** Persistent ad-hoc Designated Requirement (`designated => identifier "cloud.aritro.byakugan-scan"`) ensuring macOS Privacy permissions stay valid across updates.

#### Scanning Modes & Formats
- **Text OCR:** Instant text extraction across 30+ BCP-47 language models with automatic whitespace trimming and line-break controls.
- **QR Code Detection:** High-speed QR code decoding with optional automatic URL opening.
- **Universal Barcode Detection:** Full support for Aztec, Code 128, Code 39, Code 93, Data Matrix, EAN-8, EAN-13, ITF-14, PDF417, UPC-E, Micro QR, and Micro PDF417.

#### Advanced Productivity Controls
- **Additive Clipboard Mode:** Seamlessly accumulate successive screen captures onto the clipboard separated by newlines.
- **Text-to-Speech Engine:** Built-in `AVSpeechSynthesizer` narration with customizable speech rate (90–300 WPM).
- **In-Flight Capture Modifiers:** Dedicated shortcuts for text capture with line breaks (`⌘⇧2` / `⌘L`), single-line capture (`⌘H`), and text-to-speech capture (`⌘S`).
- **Auto-Open URLs:** Automatically detects and opens captured web links in the default browser.

#### Menu Bar Utility & User Interface
- **Menu Bar Companion:** Lightweight accessory app (`LSUIElement = true`) living in the status bar with custom Light/Dark mode template icons.
- **Quick-Access Popover:** Recent scans, instant action buttons, and segmented view switcher.
- **Floating Settings Window:** Dedicated `NSWindow` with floating window-level focus (`⌘,`) featuring General, Shortcuts, OCR, Clipboard, Appearance, and About preferences.
- **Local Scan History:** Searchable, favorite-toggleable history list persisted locally in `~/Library/Application Support/ByakuganScan/history.json`.

#### Privacy, Security & Offline Guarantee
- **100% On-Device:** Zero cloud dependencies, zero external network requests (`com.apple.security.network.client: false`).
- **Zero Telemetry:** No analytics, user tracking, or crash-reporting daemons.
- **Privacy Policy & Terms:** Full in-app and web-published legal policies.

#### Engineering & CI/CD
- **Branch Strategy:** Tri-branch architecture (`main`, `uat`, `dev`) protected by GitHub branch rules and code owner review.
- **Branch Naming Policy:** Enforced `feature/<base>/<feature-name>` and `hotfix/<feature-name>` conventions with fork PR exemptions.
- **Automated CI Quality Gate:** GitHub Actions workflows running on Apple Silicon (`macos-14`) validating 14 unit test suites and Next.js website production builds.

---

## Links

- **Repository:** [https://github.com/halcyon-past/byakugan-scan](https://github.com/halcyon-past/byakugan-scan)
- **Website:** [https://byakugan-scan.aritro.cloud](https://byakugan-scan.aritro.cloud)
- **Support:** [https://byakugan-scan.aritro.cloud/support](https://byakugan-scan.aritro.cloud/support)
