# Byakugan Scan 👁️

[![Platform](https://img.shields.io/badge/Platform-macOS%2014.0%2B-blue.svg?style=flat-square&logo=apple)](https://apple.com)
[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg?style=flat-square&logo=swift)](https://swift.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=flat-square)](LICENSE)
[![Website](https://img.shields.io/badge/Website-byakugan--scan.aritro.cloud-purple.svg?style=flat-square)](https://byakugan-scan.aritro.cloud)

> **The all-seeing screen scanner for macOS.** Extract unselectable text with high-precision OCR, decode QR codes, and read industrial barcodes directly from your screen with a single hotkey.

---

## 📸 Overview

**Byakugan Scan** is a super-lightweight, native macOS utility (TextSniper alternative) living discretely in your menu bar. Powered directly by Apple's native Vision framework and Neural Engine, it offers instant on-device text and code recognition with zero latency and complete privacy.

- 🌐 **Official Website:** [byakugan-scan.aritro.cloud](https://byakugan-scan.aritro.cloud)
- 🔒 **100% Private:** Zero telemetry, zero network calls, completely offline.

---

## ⚡️ Key Features

- 🔍 **Accurate Screen OCR:** Snatch text from non-selectable PDFs, protected web pages, YouTube videos, screenshots, images, presentations, and Zoom screen shares.
- 📱 **Instant QR Code Scanner:** Decode any QR code on screen directly into URLs, passwords, or text without pulling out your phone.
- 🏷️ **Industrial Barcode Scanning:** Recognize 13+ barcode symbologies: EAN-8/13, UPC-E, Code 128, Code 39, Code 93, Data Matrix, Aztec, PDF417, ITF-14, and Micro QR.
- 📋 **Clipboard Automation:** Auto-copies results directly to your clipboard with sound effects and banner notifications.
- ⌨️ **Global Keyboard Shortcuts:** Trigger actions from any application via customizable global hotkeys.
- 📜 **Scan History:** Revisit, search, and recopy recent extractions locally.
- ⚙️ **Customizable Formatting:** Control line breaks, join sentences with spaces, or trim extra whitespace.
- 🌓 **Menu Bar Companion:** Low CPU and memory footprint with dedicated Light & Dark mode taskbar icons (`AS` reticle monogram).

---

## ⌨️ Default Shortcuts

| Action | Shortcut | Description |
|---|---|---|
| **Capture Text** | `⌘ ⇧ 2` | Interactive crosshair selection for OCR text extraction |
| **Scan QR Code** | `⌘ ⇧ 3` | Select any region containing a QR code to decode its payload |
| **Scan Barcode** | `⌘ ⇧ 4` | Decode 1D and 2D commercial/logistics barcodes |

*All shortcuts can be customized in **Settings > Shortcuts**.*

---

## 🗂️ Project Architecture

Built following clean architecture and Apple engineering standards:

```
byakugan-scan/
├── ByakuganScan.xcodeproj/        # Xcode Project
├── project.yml                    # XcodeGen declaration file
├── ByakuganScan/
│   ├── App/
│   │   ├── ByakuganScanApp.swift  # SwiftUI Application entry point
│   │   └── AppDelegate.swift      # Menu bar lifecycle, statusItem, global hotkeys
│   ├── Core/
│   │   ├── Models/
│   │   │   ├── ScanResult.swift   # Scan data models & symbologies
│   │   │   └── AppSettings.swift  # App preferences state & UserDefaults
│   │   ├── Services/
│   │   │   ├── OCRService.swift         # Apple Vision text recognition
│   │   │   ├── BarcodeService.swift     # QR & barcode detection pipeline
│   │   │   ├── ScreenCaptureService.swift # Interactive capture controller
│   │   │   ├── ClipboardService.swift   # NSPasteboard operations
│   │   │   ├── HotkeyService.swift      # Carbon event tap hotkey registration
│   │   │   ├── HistoryService.swift     # Local JSON history storage
│   │   │   └── ScanCoordinator.swift   # Central scan orchestrator
│   │   └── Extensions/
│   │       ├── NSImage+Extensions.swift
│   │       └── String+Extensions.swift
│   ├── Features/
│   │   ├── Home/HomeView.swift          # Primary App Window / Dashboard
│   │   ├── Settings/SettingsView.swift  # 6-pane preferences window
│   │   └── Legal/
│   │       ├── PrivacyPolicyView.swift  # In-app Privacy Policy
│   │       └── TermsOfServiceView.swift # In-app Terms of Service
│   ├── Shared/
│   │   ├── Components/MenuBarPopoverView.swift # Native Menu Bar UI
│   │   └── Constants/AppConstants.swift
│   └── Resources/
│       ├── Assets.xcassets/       # AppIcon & MenuBarIcon (Light + Dark mode)
│       ├── Info.plist             # macOS permissions & bundle configuration
│       └── ByakuganScan.entitlements # App Sandbox configuration
├── Assets/Icons/                  # Exported standalone icon assets (Light + Dark)
├── docs/                          # App Store and Website documentation
│   ├── APP_STORE_METADATA.md      # Ready-to-copy metadata for App Store Connect
│   ├── PRIVACY_POLICY.md          # Full privacy policy text
│   ├── TERMS_OF_SERVICE.md        # Full terms of service text
│   ├── SUPPORT.md                 # Support documentation & FAQ
│   ├── CHANGELOG.md               # Version history
│   └── WEBSITE_CONTENT.md         # Web copy for byakugan-scan.aritro.cloud
└── LICENSE
```

---

## 🛠️ Build & Run Locally

### Requirements
- macOS 14.0 (Sonoma) or newer
- Xcode 15.0+ or Command Line Tools with Swift 6.0+
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`)

### Building
1. Clone the repository:
   ```bash
   git clone https://github.com/aritrosaha/byakugan-scan.git
   cd byakugan-scan
   ```

2. Generate or update the Xcode project using XcodeGen:
   ```bash
   xcodegen generate
   ```

3. Build the macOS .app bundle directly:
   ```bash
   ./scripts/build_app.sh
   open "build/Byakugan Scan.app"
   ```

4. Or open in Xcode:
   ```bash
   open ByakuganScan.xcodeproj
   ```

---

## 🧪 Automated Testing

Run the full automated test suite (Swift unit tests + Next.js build verification):
```bash
./scripts/run_tests.sh
```

Tests cover:
- String extensions (URL, email, phone number, and whitespace formatting)
- Model serialization (Codable `ScanResult`, `ScanType` symbols)
- `AppSettings` preferences mutations and defaults
- `HotkeyService` global shortcut parser
- `NSImage` resizing and PNG data generation
- `HistoryService` insertion, removal, favorite toggling, and persistence
- Next.js website production build validation

---

## 🌿 Branching & Contributing

We maintain three primary protected branches:
- **`main`**: Production releases.
- **`uat`**: Pre-release user acceptance testing.
- **`dev`**: Active development integration branch (default target for PRs).

### Branch Naming Conventions:
- **Feature branches:** `feature/<base-branch>/<feature-name>` (e.g., `feature/dev/ocr-speedup`)
- **Hotfix branches:** `hotfix/<feature-name>` (e.g., `hotfix/permissions-patch`)
- **Fork contributions:** Pull requests from forks are automatically recognized by CI and permitted.

All pull requests require code owner review and passing automated tests before merge. See our complete [Contributing Guide](CONTRIBUTING.md) for details.

---

## 📄 Privacy & Permissions

- **Screen Recording Permission:** Required by macOS to capture screen content. Byakugan Scan only captures the exact rectangular frame selected by your cursor. Pixels are processed in volatile memory and never saved to disk or network.
- **Offline Guarantee:** Byakugan Scan has no networking entitlements (`com.apple.security.network.client: false`). It cannot communicate with the internet.

---

## 📜 Legal & Policies

- [Privacy Policy](docs/PRIVACY_POLICY.md)
- [Terms of Service](docs/TERMS_OF_SERVICE.md)
- [Support Documentation](docs/SUPPORT.md)

---

## 👤 Author

**Aritro Saha**  
- Website: [byakugan-scan.aritro.cloud](https://byakugan-scan.aritro.cloud)
- Email: [aritrosaha2025@gmail.com](mailto:aritrosaha2025@gmail.com)

---

## ⚖️ License

Distributed under the MIT License. See [LICENSE](LICENSE) for details.