# Security Policy 🛡️

## Supported Versions

We take security seriously. We provide security patches for the following versions of Byakugan Scan:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

---

## On-Device Architecture & Privacy Model

Byakugan Scan is intentionally architected to be completely offline and on-device:
- **No Network Permissions:** The application sandbox does not request or possess outbound network client entitlements.
- **Volatile Image Buffers:** Pixel data captured during region selection is held strictly in volatile RAM while Apple's Vision framework performs recognition, then immediately released.
- **Local Persistence Only:** User settings and optional history logs are stored exclusively in the user's local macOS Library directory.

---

## Reporting a Vulnerability

If you discover a potential security vulnerability in Byakugan Scan, please **do not open a public GitHub issue**.

Instead, please report the vulnerability confidentially via email:
- **Email:** **[aritrosaha2025@gmail.com](mailto:aritrosaha2025@gmail.com)**
- **Subject Line:** `[SECURITY] Byakugan Scan Vulnerability Report`

### What to Include in Your Report
1. A clear description of the vulnerability and its potential impact.
2. Step-by-step instructions or proof-of-concept (PoC) code to reproduce the issue.
3. Your macOS version and device architecture (Apple Silicon / Intel).
4. Any proposed fixes or mitigations, if known.

### Response Timeline
- We will acknowledge receipt of your report within **48 hours**.
- We will provide an assessment and status update within **7 days**.
- If confirmed, we will coordinate a responsible disclosure timeline and release a patch as quickly as possible.
