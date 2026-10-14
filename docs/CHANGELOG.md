# Changelog

All notable changes to **Byakugan Scan** will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) and the [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format.

## [1.0.7] — 2026-10-14

### Fixed
- **Spatial Line Reading Order Reconstruction (`OCRService`):**
  - Reconstructed natural top-to-bottom, left-to-right reading order from raw Apple Vision observations for multi-column and complex layouts.
  - Fixes non-table scans where Apple Vision returned text blocks in arbitrary cluster order.
- **Table Cell & Row Band Hardening (`TableDetector`):**
  - Hardened multi-column observation tokenization with proportional sub-box fallback when Vision bounding box estimation returns full bounds.
  - Enforced strict top-to-bottom row interval ordering to eliminate inverted row sequences.
  - Enhanced intra-cell multi-line row banding dilation for dense and wide-spaced tables.

---

## [1.0.6] — 2026-10-14

### Fixed
- **Table & Grid OCR Detection Multi-Line Row-Band Clustering (`TableDetector`):**
  - Upgraded table clustering to connected component row banding with intra-cell multi-line consolidation.
  - Correctly captures multi-line cell labels (e.g., column headers and wrapped cell text) into single cohesive table rows rather than splitting into disjoint lines.
  - Replaced Euclidean midpoint column assignment with horizontal interval overlap and lane proximity, eliminating wide-to-narrow column displacement errors.
- **Smart De-Hyphenation Behavior Refinement (`String.dehyphenate`):**
  - Updated de-hyphenation so that only the split word fragment rejoins the upper line, while subsequent words on the following line remain on their original line.

### Added
- **On-Demand DMG File Creator Workflow (`.github/workflows/build-dmg.yml`):**
  - Added a GitHub Actions manual `workflow_dispatch` workflow permitting on-demand DMG generation for any branch.
  - Generates downloadable DMG artifacts and temporary download links directly in the workflow summary.
- **Release Workflow Idempotency (`.github/workflows/release.yml`):**
  - Added release pre-check and `--clobber` asset upload fallback to prevent race conditions during concurrent CI/CD runs.

---

## [1.0.5] — 2026-10-14

### Added
- **Table & Grid OCR Detection to Markdown & CSV (`TableDetector`, `TableFormatter`) (#2):**
  - High-performance, sub-millisecond geometric bounding box clustering engine that groups multi-column text observations into structured rows and column lanes.
  - Formats detected tables directly into GitHub-Flavored Markdown tables (`| Col 1 | Col 2 |`) with vertical alignment padding and pipe escaping (`\|`), or RFC 4180 compliant CSV with quotation escaping.
  - Robust handling of missing or empty cells across uneven column lanes with zero disk I/O and zero false positives on prose, code, and bullet lists.
  - Added user toggle in `Settings > Recognition > Table & Grid Recognition` with format selector (`Markdown Table` vs `Comma-Separated Values (CSV)`).
- **Smart De-Hyphenation for Multi-Line Scans (`String.formatted`) (#1):**
  - Automatically identifies trailing hyphens at line breaks from justified columns, PDF readers, and eBooks (`super-\ncomputer` → `supercomputer`), rejoining split syllables without manual editing.
  - Preserves intentional dashes, compound words, subtraction math symbols, code decrement operators, and markdown lists.
  - Configurable toggle in `Settings > Recognition > Text Formatting` (`smartDehyphenation`, defaults to enabled).

---

## [1.0.4] — 2026-10-13

### Added
- **Custom-Tinted Interactive Screen Selection Overlay (`SelectionOverlayController`) (#6):**
  - Replaced macOS's uncustomizable grey system selection rectangle with a native 60/120Hz AppKit fullscreen overlay across all displays (`SelectionOverlayWindow` & `SelectionOverlayView`).
  - Live-renders the user's selected `ThemeAccent` color (glowing 2px border, 4 corner Byakugan reticle brackets, subtle 14% inner tint fill, dashed crosshair guides, and live `W × H` pixel dimension pill) and respects the user's `overlayOpacity` screen dimming setting.
  - Captures selected regions directly into RAM pasteboard via `/usr/sbin/screencapture -c -x -R<x,y,w,h>` with zero disk I/O.
- **Interactive Selection Box Preview in Settings:**
  - Added a live visual preview canvas and a one-click **Test Capture Overlay** button inside `Settings > Appearance`.

### Fixed
- **Settings Window Layout & Appearance Swatch Overflow:**
  - Fixed horizontal clipping of the sidebar and right edge in `Settings > Appearance` by redesigning the theme swatches to use a responsive 5-column flexible layout with compact labels, removing redundant outer padding on grouped forms, and expanding default Settings window dimensions to `680 × 540`.
- **Theme Accent Propagation Across UI:**
  - Connected `AppSettings.shared.themeAccent` live to `FloatingHUDView`, `MenuBarPopoverView`, and `SettingsView` tinting.
- **CI Concurrency & Check Completion:**
  - Updated GitHub Actions `ci.yml` concurrency grouping so `push` and `pull_request` test checks never cancel each other mid-run during branch promotions.

---

## [1.0.3] — 2026-10-13

### Added
- **Transient Minimal HUD / Floating Toast (`FloatingHUDController`) (#3):**
  - Non-intrusive, frosted-glass floating pill (`NSPanel` with `.borderless, .nonactivatingPanel` across all virtual desktops and full-screen spaces).
  - Displays word and character counts for text captures, barcode previews, and context-aware one-click action buttons (`Open` for URLs, `Email` for email addresses).
  - Configurable `FeedbackStyle` preference (`Floating HUD Pill`, `System Notification`, `Both HUD & Notification`, or `Silent / Off`).
- **Selection Sound Variations & Configurable Audio Effects (`SoundEffect`) (#4):**
  - Added selectable audio profiles in Settings > General: `Classic Glass`, `Subtle Click`, `Camera Shutter`, `Haptic Pop`, and `Mute / Silent`.
  - Added an interactive preview speaker button inside Settings to test sound effects live.
- **Menu Bar Icon Activity State & Live Scanning Animation (#5):**
  - Reactive Combine observer in `AppDelegate` bound to `ScanCoordinator.shared.$isScanning`.
  - Dynamically transitions the menu bar icon to an active scanning reticle (`viewfinder.circle.fill`) during capture/OCR, flashes a completion reticle (`checkmark.circle.fill`) for 450ms upon success, and restores the default eye icon with zero disk I/O.
- **Customizable Selection Box Tint & Theme Accents (`ThemeAccent`) (#6):**
  - Added a dedicated **Appearance** tab in Settings featuring curated color swatches: `Byakugan Chakra (Lotus Pink)`, `Neon Cyan`, `Electric Purple`, `Terminal Emerald`, and `System Accent`, alongside an adjustable capture overlay dimming opacity slider.
- **Cinematic 60 FPS Demo Video Generator:**
  - Added `scripts/generate_cinematic_demo.swift` producing a 1080p @ 60 FPS native macOS demo video with procedural lo-fi audio and synchronized Foley sound effects.
- **Automated Test Suite Expansion:**
  - Added unit test suites covering `SoundEffect`, `FeedbackStyle`, `ThemeAccent`, and `FloatingHUDItem` word/character formatting.

---

## [1.0.2] — 2026-10-12

### Added
- **Deep Links & macOS Shortcuts Integration (`byakugan://`):** Registered custom URL scheme and route handler (`URLRouteService`) enabling programmatic triggers from Raycast, Alfred, Stream Deck, BetterTouchTool, terminal scripts, and macOS Shortcuts:
  - `byakugan://scan?mode=text` — Starts instant interactive text OCR capture.
  - `byakugan://scan?mode=qr` — Starts instant QR code capture.
  - `byakugan://scan?mode=barcode` — Starts commercial barcode recognition.
  - `byakugan://scan?mode=last` — Re-scans the most recent rectangular region.
  - `byakugan://settings` — Opens the Settings preferences window.
  - `byakugan://history` — Opens recent scan history popover.
- **Native macOS App Intents:** Provided Swift `AppIntent` definitions (`CaptureTextIntent`, `ScanQRCodeIntent`, `ScanBarcodeIntent`, `CaptureLastSelectionIntent`, `OpenSettingsIntent`) and `AppShortcutsProvider` for native integration with macOS Shortcuts.app and Spotlight search.
- **Official Homebrew Cask Distribution:** Added official Homebrew Cask formula (`Casks/byakugan-scan.rb`) and official tap support (`halcyon-past/tap/byakugan-scan`), enabling seamless installation and upgrades via `brew install --cask halcyon-past/tap/byakugan-scan`.
- **Interactive Web Installer Tabs:** Added a dual-tab installation card to the marketing website hero section featuring one-click copyable Homebrew commands, direct DMG downloads, SHA-256 checksum copying, and file size badges.

### Changed
- **Conflict-Free Default Shortcuts:** Changed default QR code scan shortcut to `⌘⇧6` and barcode scan shortcut to `⌘⇧7` to eliminate hotkey collisions with native macOS system screenshot shortcuts (`⌘⇧3`, `⌘⇧4`, `⌘⇧5`).
- **3D Follower Eyeball Trajectory:** Recalibrated 3D Three.js Byakugan eyeball follower coordinates and ambient lighting stages for improved visual hierarchy across desktop and mobile devices.

### Fixed
- **Xcode Target Compilation:** Regenerated `ByakuganScan.xcodeproj` via `xcodegen` to ensure `UpdateService.swift`, `URLRouteService.swift`, and related components are properly included in the build target.

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
