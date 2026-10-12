# App Store Metadata — Byakugan Scan

> This document contains all content needed for Mac App Store submission.

---

## Basic Information

| Field | Value |
|---|---|
| **App Name** | Byakugan Scan |
| **Subtitle** | OCR, QR & Barcode Scanner |
| **Bundle ID** | `cloud.aritro.byakugan-scan` |
| **Primary Category** | Productivity |
| **Secondary Category** | Utilities |
| **Age Rating** | 4+ |
| **Price** | Free |
| **Copyright** | © 2026 Aritro Saha |
| **Primary Language** | English (U.S.) |

---

## URLs

| Field | URL |
|---|---|
| **Support URL** | https://byakugan-scan.aritro.cloud/support |
| **Marketing URL** | https://byakugan-scan.aritro.cloud |
| **Privacy Policy URL** | https://byakugan-scan.aritro.cloud/privacy |

---

## Subtitle

> **Character limit: 30**

```
OCR, QR & Barcode Scanner
```

*(25 characters)*

---

## Keywords

> **Character limit: 100** — comma-separated, no spaces after commas

```
ocr,text capture,qr code,barcode,screen capture,text recognition,scanner
```

*(73 characters)*

**Rationale:** Targeting high-intent search terms users type when looking for OCR or scanning tools on the Mac App Store.

---

## App Description

> **Character limit: 4000**

```
Byakugan Scan — Instant OCR, QR & Barcode Scanning. Entirely On Your Mac.

Byakugan Scan is the fastest, most privacy-respecting way to capture text, decode QR codes, and read barcodes on macOS. With a single keyboard shortcut, select any region of your screen and let Byakugan Scan instantly extract every word — or decode any code — in seconds. No uploads. No cloud. No accounts. Everything happens on your Mac.

─────────────────────────────────────
⚡ INSTANT SCREEN OCR
─────────────────────────────────────
See text on your screen that you can't select? Byakugan Scan has you covered. Activate the screen-capture mode with a global shortcut, drag to select any region, and watch Byakugan Scan extract all the text using Apple's industry-leading Vision OCR framework. Capture error messages, subtitles, code snippets, foreign text, menus, PDFs, images — anything visible on your display.

─────────────────────────────────────
🔍 QR CODE & BARCODE SCANNER
─────────────────────────────────────
Point your camera at any QR code or barcode, or capture one from your screen. Byakugan Scan decodes it instantly and lets you open URLs, copy text, or look up product information with one click. Supports all major barcode formats: QR, Aztec, PDF417, Code 128, Code 39, EAN-13, EAN-8, UPC-A, UPC-E, Data Matrix, and more.

─────────────────────────────────────
🔒 100% PRIVATE — ZERO DATA LEAVES YOUR MAC
─────────────────────────────────────
Your scans are your business. Byakugan Scan processes every image, every frame, and every result entirely on-device using Apple's native frameworks. There are no servers, no analytics, no accounts, and no cloud storage. The screen content you capture is never written to disk — it is processed in memory and discarded the moment your scan is complete. This is privacy-first design, not a marketing promise.

─────────────────────────────────────
📋 SMART HISTORY & CLIPBOARD INTEGRATION
─────────────────────────────────────
Every scan you perform is saved to a local history so you can revisit previous results at any time. Search through your history, copy any result, open decoded URLs in your browser, or share text — all from a clean, native macOS interface. Clearing your history takes one click.

─────────────────────────────────────
⌨️ KEYBOARD-FIRST WORKFLOW
─────────────────────────────────────
Designed for power users who live at the keyboard. Trigger any scan mode without touching the menu bar. Assign global keyboard shortcuts to screen-region OCR, QR scan, and more. Byakugan Scan fits into your workflow without interrupting it.

─────────────────────────────────────
🖥️ BUILT FOR MODERN macOS
─────────────────────────────────────
Byakugan Scan is a pure Swift, native macOS app built with SwiftUI and AppKit. It follows macOS design principles, supports Light and Dark Mode, and integrates seamlessly with your system. No Electron. No web views. Just a fast, native experience that feels at home on your Mac.

─────────────────────────────────────
KEY FEATURES
─────────────────────────────────────
• Instant screen-region OCR with global keyboard shortcut
• Live camera QR code and barcode scanning
• Screen-capture QR/barcode decoding
• Support for 10+ barcode formats (QR, Code 128, EAN, UPC, PDF417, Aztec, and more)
• Multi-language OCR powered by Apple Vision framework
• Local scan history with full-text search
• One-click copy to clipboard
• Open decoded URLs directly in your browser
• Zero network requests — fully offline capable
• Light and Dark Mode support
• Global keyboard shortcuts for all scan modes
• Native Swift + SwiftUI — no third-party dependencies
• macOS 14 Sonoma and later

─────────────────────────────────────
PERMISSIONS USED
─────────────────────────────────────
• Screen Recording — required to capture the screen region you select for OCR and QR scanning. Content is processed in-memory only and never saved or transmitted.
• Camera (optional) — used for live camera-based QR and barcode scanning only.

─────────────────────────────────────
SUPPORT & FEEDBACK
─────────────────────────────────────
Have a question or found a bug? Visit byakugan-scan.aritro.cloud/support or email aritrosaha2025@gmail.com. We read every message.

Byakugan Scan — See everything. Store nothing.
```

*(Character count: ~3,720 — within the 4,000 limit)*

---

## What's New (Version 1.0.0)

```
Welcome to Byakugan Scan — Initial Release! 🎉

• Instant screen-region OCR: select any area of your screen and extract all text in seconds
• Live camera QR code and barcode scanning
• Screen-capture QR/barcode decoding mode
• Support for 10+ barcode formats: QR, Aztec, PDF417, Code 128, Code 39, EAN-13, EAN-8, UPC-A, UPC-E, Data Matrix
• Local scan history with search
• Global keyboard shortcuts for all scan modes
• 100% on-device processing — no data ever leaves your Mac
• Native Swift + SwiftUI — fully optimized for macOS 14+

Thank you for trying Byakugan Scan. We'd love to hear your feedback!
```

---

## Age Rating Questionnaire Answers

| Question | Answer |
|---|---|
| Made for Kids | No |
| Unrestricted Web Access | No |
| User-Generated Content | No |
| Violence | None |
| Sexual Content | None |
| Profanity | None |
| Gambling | No |
| Medical/Treatment Information | No |

**Age Rating Result:** 4+

---

## App Review Notes

> *(Notes for Apple's App Review team)*

```
Thank you for reviewing Byakugan Scan.

SCREEN RECORDING PERMISSION:
Byakugan Scan requests the Screen Recording permission (Privacy & Security → Screen Recording) for its core OCR and screen-region QR/barcode scanning feature. When the user activates a screen scan, the app captures the screen region the user explicitly selects via a crosshair overlay. This captured image is:
  - Processed entirely on-device using Apple's Vision framework
  - Never written to disk
  - Never transmitted to any network endpoint
  - Discarded from memory immediately after the scan result is produced

This is the sole use of the Screen Recording permission. The app does not perform any background or continuous screen recording.

CAMERA PERMISSION (if requested):
The Camera permission is used only for the live barcode/QR scanning feature, which streams frames from the camera to Apple's AVFoundation/Vision pipeline on-device. No frames are saved or transmitted.

TEST ACCOUNT:
No account or login is required. All features are available immediately on launch.

NETWORK:
Byakugan Scan makes zero network requests. It is fully functional with network access disabled.

If you have any questions, please contact: aritrosaha2025@gmail.com
```

---

## Screenshot Descriptions

> Five ideal screenshots for the Mac App Store listing (2880×1800 px recommended for MacBook Pro 16" display).

### Screenshot 1 — Hero / Screen OCR in Action
**Title overlay:** "Capture Any Text, Instantly"  
**Scene:** The app's scan overlay is active, showing a translucent screen dimmed with a bright rectangular selection region around a block of code in a code editor. Below the selection, a native result panel shows the extracted text with a "Copy" button highlighted.  
**Purpose:** Immediately communicates the primary use case — screen OCR — to first-time visitors.

---

### Screenshot 2 — QR Code Scanning Result
**Title overlay:** "Decode Any QR Code or Barcode"  
**Scene:** The app's main window displays a successfully scanned QR code alongside its decoded URL. The URL is shown in a clean card with two action buttons: "Open in Browser" and "Copy." A badge in the corner shows the barcode type (QR Code).  
**Purpose:** Highlights the QR/barcode scanning capability with a clear CTA moment.

---

### Screenshot 3 — Scan History
**Title overlay:** "Your History, Always at Hand"  
**Scene:** The History panel is open, showing a list of past scans with timestamps, type badges (OCR / QR / Barcode), and short text previews. A search bar at the top is active with a sample query. One item is selected, showing a full result pane on the right.  
**Purpose:** Demonstrates the organizational value of the app beyond single scans.

---

### Screenshot 4 — Privacy Callout / No-Network Design
**Title overlay:** "100% On-Device. Zero Cloud."  
**Scene:** A split design — the left half shows the app processing a scan, and the right half shows a privacy guarantee card with icons: "No Servers," "No Accounts," "No Data Transmitted," "No Tracking." The macOS network activity indicator shows zero connections.  
**Purpose:** Directly addresses the privacy-conscious buyer and differentiates Byakugan Scan from cloud-based alternatives.

---

### Screenshot 5 — Keyboard Shortcuts & Preferences
**Title overlay:** "Built for Power Users"  
**Scene:** The app's Settings/Preferences window is shown, with the Keyboard Shortcuts tab active. A clean list shows all assignable global shortcuts (Screen OCR, Camera Scan, Open History, etc.) with their current key bindings displayed as native macOS key badge UI elements. Dark Mode is active.  
**Purpose:** Appeals to productivity-focused users who value keyboard-driven workflows.

---

## Promotional Text

> *(Optional — can be updated without a new app submission)*

```
🆕 Byakugan Scan 1.0 is here — capture text from anywhere on your screen, decode any QR or barcode, all 100% on-device. No cloud. No account. Just instant results.
```
