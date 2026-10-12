# Changelog

All notable changes to **Byakugan Scan** will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) and the [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format.

---

## [Unreleased]

> Features and fixes that are in development and not yet released.

---

## [1.0.0] — 2026-10-01

### 🎉 Initial Release

This is the first public release of Byakugan Scan — a native macOS app for instant, fully on-device OCR, QR code scanning, and barcode decoding.

### Added

#### Core Scanning Features
- **Screen Region OCR** — Select any rectangular area of your screen using a crosshair overlay and instantly extract all text using Apple's Vision framework (`VNRecognizeTextRequest`)
- **Screen QR/Barcode Capture** — Select a region of your screen to decode any QR code or barcode visible on your display
- **Live Camera Scanner** — Real-time QR code and barcode detection via AVFoundation camera capture pipeline
- **Multi-language OCR** — Support for all languages available in Apple's Vision OCR model, including English, French, German, Spanish, Portuguese, Italian, Chinese (Simplified & Traditional), Japanese, Korean, Russian, and Arabic

#### Barcode Format Support
- QR Code
- Aztec Code
- PDF417
- Data Matrix
- Code 128
- Code 39
- Code 93
- EAN-13
- EAN-8
- UPC-A
- UPC-E
- Interleaved 2 of 5 (ITF)
- ITF-14
- GS1 DataBar
- CodaBar
- MicroQR
- MicroPDF417

#### Results & Actions
- Structured result panel showing recognized text or decoded barcode content
- **Copy to Clipboard** — one-click copy of any scan result
- **Open in Browser** — directly open decoded URLs from QR codes
- Barcode type badge displayed on each scan result
- Confidence indicator for OCR results

#### Scan History
- Automatic local history for all successful scans
- Full-text search across scan history
- History item detail view with full result and metadata
- Per-item delete (right-click context menu or Delete key)
- **Clear All History** action with confirmation dialog
- History stored entirely on-device in the app's sandboxed container

#### Keyboard Shortcuts
- Global shortcut for Screen Region OCR: **⌃⌥⌘T**
- Global shortcut for Screen QR/Barcode Scan: **⌃⌥⌘Q**
- Global shortcut for Camera Scanner: **⌃⌥⌘C**
- Global shortcut to show/bring app to front: **⌃⌥⌘B**
- Fully customizable shortcuts in Settings → Shortcuts

#### User Interface
- Native SwiftUI + AppKit interface following macOS design guidelines
- **Light and Dark Mode** support with automatic system-following appearance
- Sidebar navigation (Scan Modes, History, Settings)
- Menu bar extra (optional) for quick access to scan modes without opening the main window
- Scan overlay with real-time region size indicator
- Smooth animations for scan activation, result appearance, and history transitions

#### Settings & Preferences
- Keyboard Shortcuts configuration panel
- Option to launch at login
- Menu bar icon toggle (show/hide menu bar extra)
- History retention preferences (keep all / keep last N items)
- OCR language selection override
- Camera device selection (for Macs with multiple cameras or external cameras)

#### Privacy & Security
- **Zero network requests** — all processing is fully on-device
- Screen captures processed in-memory only; never written to disk
- No analytics, telemetry, or crash reporting
- No accounts, no sign-in
- macOS App Sandbox compliant
- Hardened Runtime enabled

#### Platform
- Built with **Swift 6** and **SwiftUI**
- Requires **macOS 14.0 (Sonoma)** or later
- Universal Binary — native support for both **Apple Silicon (M-series)** and **Intel** Macs
- Distributed via Mac App Store

---

## Links

[Unreleased]: https://github.com/aritro-saha/byakugan-scan/compare/v1.0.0...HEAD  
[1.0.0]: https://github.com/aritro-saha/byakugan-scan/releases/tag/v1.0.0
