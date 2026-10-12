# Byakugan Scan — Support & FAQ

**App:** Byakugan Scan  
**Support Email:** [aritrosaha2025@gmail.com](mailto:aritrosaha2025@gmail.com)  
**Website:** [https://byakugan-scan.aritro.cloud/support](https://byakugan-scan.aritro.cloud/support)

---

## Getting Started

### How do I install Byakugan Scan?

Download Byakugan Scan from the **Mac App Store**. Once installed, launch the app from your Applications folder or Launchpad. On first launch, the app will walk you through granting the necessary permissions.

---

## Permissions

### How do I grant Screen Recording permission?

Screen Recording permission is required for the **screen-region OCR** and **screen-capture QR/barcode scan** features. Without it, those modes will be unavailable (camera scanning still works without this permission).

**To grant permission:**

1. Open **System Settings** (Apple menu → System Settings)
2. Click **Privacy & Security** in the sidebar
3. Scroll down and click **Screen Recording**
4. Find **Byakugan Scan** in the list and toggle it **ON**
5. You may be prompted to quit and relaunch the app — click **Quit & Reopen**

> **Note:** If Byakugan Scan does not appear in the Screen Recording list, launch the app and trigger a screen scan. macOS will prompt you to grant permission automatically.

**To revoke permission** (if you change your mind):

Follow the same steps above and toggle the switch **OFF**. Screen OCR and screen-capture QR scanning will be disabled, but camera-based scanning will continue to work.

---

### How do I grant Camera permission?

Camera permission is required for the **live camera QR/barcode scanning** feature.

1. Open **System Settings → Privacy & Security → Camera**
2. Find **Byakugan Scan** and toggle it **ON**

Alternatively, simply activate camera scan mode in the app — macOS will display a permission prompt automatically on first use.

---

## Using Byakugan Scan

### How do I perform a Screen OCR scan?

1. Press the **global keyboard shortcut** for Screen OCR (default: see Keyboard Shortcuts below), or click the **Screen OCR** button in the app's toolbar
2. Your screen will dim and a crosshair cursor will appear
3. **Click and drag** to draw a rectangle around the text you want to capture
4. Release the mouse button — Byakugan Scan will instantly extract all text from the selected region
5. The result appears in the app window, ready to copy or share

---

### How do I scan a QR code or barcode from my screen?

1. Press the **global keyboard shortcut** for Screen QR Scan, or click the **Screen QR/Barcode** button in the toolbar
2. Click and drag to select the area of your screen that contains the QR code or barcode
3. Byakugan Scan will decode the code and display the result (URL, text, product code, etc.)
4. Click **Open in Browser** to follow a URL, or **Copy** to copy the result to your clipboard

---

### How do I use the live camera scanner?

1. Click the **Camera Scan** button in the toolbar, or use its keyboard shortcut
2. Grant Camera permission if prompted
3. Point your Mac's camera (or a connected external camera) at the QR code or barcode
4. Byakugan Scan will automatically detect and decode the code in real time
5. When a code is detected, it will be highlighted and the result shown — click to copy or act on it

---

## How OCR Works

Byakugan Scan uses **Apple's Vision framework** (`VNRecognizeTextRequest`) to perform Optical Character Recognition entirely on your device. Here is what happens when you perform a screen OCR scan:

1. **Capture** — The app captures a screenshot of only the region you selected (using macOS Screen Recording APIs)
2. **Pre-processing** — The image is passed to the Vision framework in-memory (it is never saved to disk)
3. **Recognition** — Apple's on-device OCR model analyzes the image and identifies text, returning bounding boxes and recognized strings
4. **Presentation** — The recognized text is assembled in reading order and presented in the result panel
5. **Cleanup** — The captured image is released from memory immediately after recognition is complete

**Accuracy tips:**
- Higher contrast text (dark text on light background) produces the best results
- Avoid very small text (below ~10pt on screen) for best accuracy
- For non-English text, ensure the text is in a supported language (Vision supports dozens of languages)
- Scaling up your display resolution can improve recognition of small text

**Supported OCR languages:** All languages supported by Apple's Vision framework, including English, French, German, Italian, Portuguese, Spanish, Chinese (Simplified & Traditional), Japanese, Korean, Russian, Arabic, and many more.

---

## Supported Barcode & QR Code Types

Byakugan Scan supports all barcode formats provided by Apple's Vision and AVFoundation frameworks:

| Format | Description | Common Use |
|---|---|---|
| **QR Code** | 2D matrix code | URLs, contact info, Wi-Fi credentials |
| **Aztec Code** | 2D compact matrix | Boarding passes, transit tickets |
| **PDF417** | 2D stacked barcode | IDs, shipping labels, boarding passes |
| **Data Matrix** | 2D matrix code | Industrial, pharmaceutical |
| **Code 128** | 1D linear barcode | Shipping, general merchandise |
| **Code 39** | 1D linear barcode | Automotive, defense, healthcare |
| **Code 93** | 1D linear barcode | Inventory, logistics |
| **EAN-13** | 1D linear barcode | Retail products (international) |
| **EAN-8** | 1D linear barcode | Small retail products |
| **UPC-A** | 1D linear barcode | Retail products (North America) |
| **UPC-E** | 1D linear barcode | Small retail products (North America) |
| **Interleaved 2 of 5** | 1D linear barcode | Cartons, warehouse |
| **ITF-14** | 1D linear barcode | Carton packaging |
| **GS1 DataBar** | 1D linear barcode | Fresh food, coupons |
| **CodaBar** | 1D linear barcode | Libraries, blood banks |
| **MicroQR** | Compact 2D code | Small items |
| **MicroPDF417** | Compact 2D code | Small labels |

---

## Scan History

### How does scan history work?

Every successful scan is automatically saved to your **local scan history**. History is stored in the app's sandboxed container on your Mac and never leaves your device.

### How do I search my history?

Click on the **History** tab in the sidebar, then type in the search bar at the top to filter results by their content.

### How do I delete a history item?

Right-click (or Control-click) any history item and select **Delete** from the context menu. You can also select an item and press the **Delete** key.

### How do I clear all history?

In the app's menu bar, go to **Byakugan Scan → Clear All History**, or find the "Clear All" button in the History panel. You will be asked to confirm before history is deleted.

---

## Keyboard Shortcuts

### What are the default keyboard shortcuts?

| Action | Default Shortcut |
|---|---|
| Screen Region OCR | ⌃⌥⌘T |
| Screen QR / Barcode Scan | ⌃⌥⌘Q |
| Open Camera Scanner | ⌃⌥⌘C |
| Open / Show App | ⌃⌥⌘B |
| Open History | ⌘H |
| Copy Last Result | ⌘C (when result is focused) |
| Clear History | ⌥⌘⌫ |
| Close Window | ⌘W |
| Preferences / Settings | ⌘, |

### How do I change keyboard shortcuts?

1. Open Byakugan Scan
2. Go to **Byakugan Scan → Settings** (or press ⌘,)
3. Click the **Shortcuts** tab
4. Click the shortcut you want to change and press your desired key combination

> **Tip:** Global shortcuts work even when Byakugan Scan is not the frontmost app, letting you trigger a scan from anywhere in your workflow.

---

## Troubleshooting

### The screen OCR scan returns no text / blank result

- Make sure **Screen Recording** permission is granted (see above)
- Check that the text is legible and high-contrast
- Try selecting a slightly larger area to include the full text
- Some DRM-protected content (e.g., Netflix streams) may not be capturable by any app due to macOS restrictions

### The camera scanner is not detecting codes

- Ensure good lighting and hold the camera steady
- Make sure **Camera** permission is granted
- For small barcodes, move the camera closer
- Ensure the barcode is not damaged or obscured

### The app crashes on launch

- Make sure you are running macOS 14 (Sonoma) or later
- Try reinstalling the app from the Mac App Store
- Contact support if the issue persists: [aritrosaha2025@gmail.com](mailto:aritrosaha2025@gmail.com)

### Screen Recording permission keeps getting reset

This is a known macOS behavior for sandboxed apps in some cases. Go to **System Settings → Privacy & Security → Screen Recording** and re-enable the toggle. If you experience this repeatedly, please reach out to support.

---

## Contact & Feedback

We'd love to hear from you — bug reports, feature requests, and positive feedback are all welcome.

**Email:** [aritrosaha2025@gmail.com](mailto:aritrosaha2025@gmail.com)  
**Website:** [https://byakugan-scan.aritro.cloud/support](https://byakugan-scan.aritro.cloud/support)

Please include your macOS version and app version (found in **Byakugan Scan → About Byakugan Scan**) when reporting bugs. We aim to respond to all support queries within 2 business days.
