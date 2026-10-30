# Byakugan Scan — Instant Mac Screen OCR, QR Code & Barcode Scanner

> A lightweight, 100% offline macOS menu bar utility for instant in-memory screen text OCR, on-screen QR code decoding, and industrial barcode scanning powered by Apple Vision. Free, open-source (MIT), and built with Swift 6 on Apple Silicon and Intel.

- **Download Direct Universal DMG:** https://github.com/halcyon-past/byakugan-scan/releases/latest/download/ByakuganScan.dmg
- **Install via Homebrew:** `brew install --cask halcyon-past/tap/byakugan-scan`
- **Supported OS:** macOS 14.0 Sonoma, macOS 15.0 Sequoia, macOS 16+
- **License:** MIT License (100% Free & Open Source)

---

## Core Capabilities

### 1. Screen Text OCR (`⌘⇧2`)
Snatch unselectable text from video streams, protected PDFs, images, paused YouTube tutorials, and Zoom screen shares in under 50 milliseconds directly into your clipboard. Supports automatic multi-script recognition across 13+ languages.

### 2. On-Screen QR Code Reader (`⌘⇧6`)
Decode display QR codes and MicroQR codes directly on your Mac screen without reaching for your phone. Provides one-click actions: Open URL, Compose Email, Call Phone Number, or Copy Secret Key.

### 3. Industrial Barcode Scanner (`⌘⇧7`)
Scan 13+ commercial and logistics barcode symbologies directly from your display: EAN-13, EAN-8, UPC-E, Code 128, Code 39, Code 93, PDF417, Aztec, Data Matrix, and ITF-14.

### 4. Table OCR & Formatting
Automatically detects tabular layouts and converts multi-column rows into aligned Markdown tables or CSV strings directly in the clipboard.

### 5. 100% In-Memory Capture Pipeline
Captures interactive selections into volatile RAM (`NSPasteboard.general`) without writing `.png` files to disk. Completely avoids macOS Spotlight `mdwrite` indexing and `MADService` media analysis latency stalls.

### 6. Zero Telemetry & Offline Sandbox
No network client entitlements (`com.apple.security.network.client: false`). Pixels and recognized text never leave your machine.

---

## Default Shortcuts
- `⌘⇧2`: Screen Text OCR
- `⌘⇧6`: Scan QR Code
- `⌘⇧7`: Scan Barcode
- `Esc`: Cancel selection
- `⌘,`: Open Settings

---

## Raycast & Automation Deep Links (`byakugan://`)
- `byakugan://scan?mode=text`
- `byakugan://scan?mode=qr`
- `byakugan://scan?mode=barcode`
- `byakugan://scan?mode=last`
- `byakugan://settings`
- `byakugan://history`

---

## Documentation Links
- [Support Documentation](https://byakugan-scan.aritro.cloud/support)
- [Privacy Policy](https://byakugan-scan.aritro.cloud/privacy)
- [Terms of Service](https://byakugan-scan.aritro.cloud/terms)
- [Full LLM Technical Reference](https://byakugan-scan.aritro.cloud/llms-full.txt)
- [GitHub Repository](https://github.com/halcyon-past/byakugan-scan)
