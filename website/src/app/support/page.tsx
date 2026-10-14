import type { Metadata } from "next";
import Link from "next/link";
import {
  ShieldCheck,
  Keyboard,
  ScanText,
  QrCode,
  Barcode,
  Clock,
  Wrench,
  Mail,
  Github,
  Terminal,
  Sparkles,
  CheckCircle2,
  ChevronDown,
  ExternalLink,
  HelpCircle,
} from "lucide-react";
import { APP_DOWNLOAD_URL, GITHUB_REPO_URL } from "@/constants/links";

export const metadata: Metadata = {
  title: "Support, Documentation & FAQ — Screen OCR, QR & Barcode Setup",
  description:
    "Documentation, troubleshooting guides, keyboard shortcuts, Screen Recording permission setup, and frequently asked questions for Byakugan Scan on macOS.",
  alternates: {
    canonical: "/support",
  },
  openGraph: {
    title: "Support & FAQ — Byakugan Scan for macOS",
    description:
      "Learn how to install via Homebrew, grant Screen Recording permissions, customize global shortcuts, and scan text, QR codes, and barcodes on macOS.",
    url: "https://byakugan-scan.aritro.cloud/support",
  },
};

const QUICK_SHORTCUTS = [
  {
    action: "Capture Text (OCR)",
    keys: ["⌘", "⇧", "2"],
    badge: "Default",
    description: "Interactive screen region selection for instant on-device Vision OCR.",
  },
  {
    action: "Scan QR Code",
    keys: ["⌘", "⇧", "3"],
    badge: "Default",
    description: "Decode URLs, Wi-Fi credentials, vCards, and 2D QR payloads on screen.",
  },
  {
    action: "Scan Barcode",
    keys: ["⌘", "⇧", "4"],
    badge: "Default",
    description: "Recognize EAN-13, UPC-E, Code 128, PDF417, Aztec, Data Matrix, and more.",
  },
  {
    action: "Cancel Selection",
    keys: ["Esc"],
    badge: "System",
    description: "Dismiss the active Byakugan reticle overlay without modifying the clipboard.",
  },
  {
    action: "Open Settings",
    keys: ["⌘", ","],
    badge: "Menu Bar",
    description: "Configure shortcuts, OCR languages, formatting, and reticle accent colors.",
  },
];

const BARCODE_FORMATS = [
  { format: "QR Code & MicroQR", type: "2D Matrix", useCase: "URLs, authentication, Wi-Fi, vCards, payment links" },
  { format: "Aztec Code", type: "2D Compact", useCase: "Airline boarding passes, rail & transit tickets" },
  { format: "PDF417 & MicroPDF417", type: "2D Stacked", useCase: "Driver licenses, ID cards, shipping manifests" },
  { format: "Data Matrix", type: "2D Industrial", useCase: "Electronics components, medical & pharmaceutical labels" },
  { format: "EAN-13 / EAN-8", type: "1D Retail", useCase: "International retail products, ISBN book codes" },
  { format: "UPC-E", type: "1D Retail", useCase: "Compact North American retail product packaging" },
  { format: "Code 128 / Code 39 / Code 93", type: "1D Logistics", useCase: "Supply chain, asset tracking, warehouse inventory" },
  { format: "ITF-14 / Interleaved 2 of 5", type: "1D Packaging", useCase: "Corrugated freight cartons and outer cases" },
];

const FAQ_ITEMS = [
  {
    category: "Installation & Updates",
    question: "How do I install or update Byakugan Scan on macOS?",
    answer:
      "You can install Byakugan Scan via Homebrew (`brew install --cask halcyon-past/tap/byakugan-scan`) or by downloading the universal `.dmg` installer directly from our website or GitHub Releases. To update via Homebrew, run `brew upgrade --cask byakugan-scan`.",
  },
  {
    category: "Privacy & Security",
    question: "Does Byakugan Scan ever upload my screenshots or text to the cloud?",
    answer:
      "Never. Byakugan Scan operates 100% offline and on-device using Apple's native Vision framework (`VNRecognizeTextRequest` and `VNDetectBarcodesRequest`). The app has zero network entitlements, zero analytics SDKs, and zero telemetry.",
  },
  {
    category: "Performance",
    question: "Why does Byakugan Scan feel so much faster than other screenshot OCR tools?",
    answer:
      "Traditional screen capture utilities write temporary `.png` files to `/tmp` on disk, which triggers macOS Spotlight (`mdwrite`) indexing and `MADService` media analysis stalls. Byakugan Scan captures your selected region directly into volatile RAM (`NSPasteboard`) and feeds the `CGImage` buffer straight into the Apple Neural Engine in under 50 milliseconds.",
  },
  {
    category: "Permissions",
    question: "Why does Byakugan Scan require macOS Screen Recording permission?",
    answer:
      "macOS protects screen pixels under the Screen Recording privacy gate. Byakugan Scan only captures the exact rectangular coordinates you drag-select when you invoke a scan — it never records your screen in the background. It also uses `CGPreflightScreenCaptureAccess()` for silent permission checks so you are never spammed by system dialogs.",
  },
  {
    category: "Permissions",
    question: "What should I do if Screen Recording permission is already toggled ON, but macOS still says permission is required?",
    answer:
      "If you rebuilt or replaced the app binary manually, macOS TCC may hold a stale signature entry. Open System Settings → Privacy & Security → Screen Recording, select Byakugan Scan, click the minus (–) button to remove it, and then re-add `/Applications/Byakugan Scan.app` (or run `tccutil reset ScreenCapture cloud.aritro.byakugan-scan` in Terminal) and relaunch.",
  },
  {
    category: "Customization",
    question: "How do I change the selection box color and backdrop dimming opacity?",
    answer:
      "Click the Byakugan eye icon in your macOS menu bar → Settings (⌘,) → Appearance. Choose from 5 signature accents (Byakugan Violet, Tenseigan Cyan, Sharingan Crimson, Sage Emerald, or Nine-Tails Amber) and adjust the Overlay Dimming slider. You can preview the reticle live or click 'Test Capture Overlay' right from Settings.",
  },
  {
    category: "Customization",
    question: "Can I customize the global keyboard shortcuts?",
    answer:
      "Yes! Open Settings (⌘,) → Shortcuts, click 'Record Shortcut' next to Capture Text, Scan QR Code, or Scan Barcode, and press any modifier combination (⌘, ⇧, ⌥, ⌃) plus a key. Press Escape while recording to cancel, or click the clear (×) button to unbind a shortcut.",
  },
  {
    category: "OCR & Formatting",
    question: "Which languages are supported for Text OCR, and how does line-break formatting work?",
    answer:
      "Byakugan Scan supports automatic language detection plus 13+ primary languages including English (US/UK), Japanese, Chinese (Simplified & Traditional), Korean, French, German, Spanish, Italian, Portuguese, Arabic, and Hindi. In Settings → OCR, you can toggle 'Trim Whitespace', 'Preserve Line Breaks', or 'Join Lines with Space' to copy multi-line paragraphs as clean single-line prose.",
  },
  {
    category: "History",
    question: "Where is my scan history stored, and how can I pin or clear items?",
    answer:
      "When enabled, scan history is saved locally in `~/Library/Application Support/ByakuganScan/history.json`. Open the menu bar popover and switch to the History tab to search past scans, filter by Text / QR / Barcode / Starred, star important clips, or delete entries. You can disable or clear history at any time from Settings → General.",
  },
];

const faqJsonLd = {
  "@context": "https://schema.org",
  "@type": "FAQPage",
  mainEntity: FAQ_ITEMS.map((item) => ({
    "@type": "Question",
    name: item.question,
    acceptedAnswer: {
      "@type": "Answer",
      text: item.answer,
    },
  })),
};

export default function SupportPage() {
  return (
    <div className="py-16 sm:py-24 px-6 max-w-6xl mx-auto">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(faqJsonLd) }}
      />
      {/* Hero Header */}
      <div className="max-w-3xl mb-14">
        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-pink-500/10 border border-pink-500/20 text-pink-300 text-xs font-mono mb-4">
          <Sparkles className="w-3.5 h-3.5" />
          <span>SUPPORT CENTER & DOCUMENTATION // v1.0.5</span>
        </div>
        <h1 className="text-4xl sm:text-5xl font-extrabold text-white tracking-tight mb-4">
          Support &amp; Frequently Asked Questions
        </h1>
        <p className="text-slate-300 text-base sm:text-lg leading-relaxed">
          Everything you need to configure permissions, master global shortcuts, customize the Byakugan reticle overlay, and troubleshoot on macOS 14+ Sonoma &amp; Sequoia.
        </p>
      </div>

      {/* Quick Navigation Pills */}
      <div className="flex flex-wrap gap-2.5 mb-14 pb-8 border-b border-white/[0.08]">
        {[
          { href: "#getting-started", label: "Getting Started" },
          { href: "#permissions", label: "Screen Recording Setup" },
          { href: "#shortcuts", label: "Keyboard Shortcuts" },
          { href: "#barcodes", label: "Supported Symbologies" },
          { href: "#faq", label: "Frequently Asked Questions" },
          { href: "#troubleshooting", label: "Troubleshooting" },
          { href: "#contact", label: "Contact Support" },
        ].map((item) => (
          <a
            key={item.href}
            href={item.href}
            className="px-3.5 py-1.5 rounded-lg bg-white/[0.04] hover:bg-white/[0.09] border border-white/10 hover:border-pink-500/40 text-xs font-mono text-slate-300 hover:text-white transition-all"
          >
            {item.label}
          </a>
        ))}
      </div>

      {/* Section 1: Getting Started & Installation */}
      <section id="getting-started" className="mb-16 scroll-mt-24">
        <div className="flex items-center gap-2.5 mb-6">
          <Terminal className="w-5 h-5 text-pink-400" />
          <h2 className="text-2xl font-bold text-white">1. Installation &amp; Quick Start</h2>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {/* Homebrew Card */}
          <div className="p-6 rounded-2xl bg-white/[0.03] border border-white/10 flex flex-col justify-between">
            <div>
              <div className="text-xs font-mono uppercase tracking-wider text-pink-300 mb-2">
                Recommended • Homebrew Cask
              </div>
              <h3 className="text-lg font-bold text-white mb-2">Install via Terminal</h3>
              <p className="text-sm text-slate-300 leading-relaxed mb-4">
                Install and receive seamless updates directly from the official Homebrew tap. Automatically removes macOS quarantine attributes during installation.
              </p>
            </div>
            <div className="bg-[#07080f] border border-white/10 rounded-xl p-3.5 font-mono text-xs text-emerald-300 overflow-x-auto">
              <code>brew install --cask halcyon-past/tap/byakugan-scan</code>
            </div>
          </div>

          {/* Direct DMG Card */}
          <div className="p-6 rounded-2xl bg-white/[0.03] border border-white/10 flex flex-col justify-between">
            <div>
              <div className="text-xs font-mono uppercase tracking-wider text-sky-300 mb-2">
                Standalone • Universal Binary
              </div>
              <h3 className="text-lg font-bold text-white mb-2">Direct DMG Installer</h3>
              <p className="text-sm text-slate-300 leading-relaxed mb-4">
                Download <code className="text-slate-200 font-mono text-xs">ByakuganScan.dmg</code>, drag <strong className="text-white">Byakugan Scan.app</strong> into your <strong className="text-white">/Applications</strong> folder, and launch it from Spotlight or Launchpad.
              </p>
            </div>
            <div className="flex flex-wrap items-center gap-3">
              <a
                href={APP_DOWNLOAD_URL}
                className="px-4 py-2 rounded-lg bg-gradient-to-r from-fuchsia-600 to-pink-600 hover:from-fuchsia-500 hover:to-pink-500 text-white text-xs font-semibold transition-all inline-flex items-center gap-1.5"
              >
                <span>Download Latest DMG (v1.0.5)</span>
                <ExternalLink className="w-3.5 h-3.5" />
              </a>
              <a
                href={`${GITHUB_REPO_URL}/releases`}
                target="_blank"
                rel="noopener noreferrer"
                className="px-3.5 py-2 rounded-lg bg-white/[0.05] hover:bg-white/[0.1] border border-white/10 text-slate-200 text-xs font-mono transition-all"
              >
                View Release Notes
              </a>
            </div>
          </div>
        </div>
      </section>

      {/* Section 2: Permissions & Scan Modes */}
      <section id="permissions" className="mb-16 scroll-mt-24">
        <div className="flex items-center gap-2.5 mb-6">
          <ShieldCheck className="w-5 h-5 text-emerald-400" />
          <h2 className="text-2xl font-bold text-white">2. Screen Recording Permission &amp; Scan Modes</h2>
        </div>

        <div className="p-6 sm:p-8 rounded-2xl bg-gradient-to-br from-white/[0.04] to-white/[0.01] border border-white/10 mb-8">
          <h3 className="text-lg font-bold text-white mb-3">
            Granting macOS Screen Recording Permission
          </h3>
          <p className="text-sm text-slate-300 leading-relaxed mb-5">
            macOS requires explicit authorization before any utility can read pixels from your display. Byakugan Scan checks permission status silently via <code className="text-pink-300 bg-white/[0.06] px-1.5 py-0.5 rounded font-mono text-xs">CGPreflightScreenCaptureAccess()</code> so you never encounter recurring permission popup loops.
          </p>
          <ol className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 text-sm">
            {[
              {
                step: "Step 01",
                title: "Open System Settings",
                detail: "Click the Apple () menu → System Settings → Privacy & Security.",
              },
              {
                step: "Step 02",
                title: "Select Screen Recording",
                detail: "Scroll down to 'Screen & System Audio Recording' and click to open.",
              },
              {
                step: "Step 03",
                title: "Enable Byakugan Scan",
                detail: "Find Byakugan Scan in the list and toggle the switch ON.",
              },
              {
                step: "Step 04",
                title: "Quit & Reopen",
                detail: "Confirm 'Quit & Reopen' if prompted—your status in Settings → Appearance will turn green.",
              },
            ].map((s) => (
              <li
                key={s.step}
                className="p-4 rounded-xl bg-[#07080f]/80 border border-white/[0.08]"
              >
                <div className="text-[11px] font-mono text-pink-400 mb-1">{s.step}</div>
                <div className="font-semibold text-white mb-1">{s.title}</div>
                <p className="text-xs text-slate-400 leading-relaxed">{s.detail}</p>
              </li>
            ))}
          </ol>
        </div>

        {/* Three Scan Pipelines */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="p-6 rounded-2xl bg-white/[0.03] border border-white/10">
            <ScanText className="w-6 h-6 text-indigo-400 mb-3" />
            <h3 className="text-base font-bold text-white mb-2">Instant Screen OCR</h3>
            <p className="text-xs sm:text-sm text-slate-300 leading-relaxed">
              Press <kbd className="px-1.5 py-0.5 rounded bg-white/10 font-mono text-xs text-white">⌘⇧2</kbd>, drag the custom-tinted Byakugan reticle around any unselectable text in videos, PDFs, slides, or images, and release. Extracted text is copied straight to your clipboard and shown in a floating HUD pill.
            </p>
          </div>

          <div className="p-6 rounded-2xl bg-white/[0.03] border border-white/10">
            <QrCode className="w-6 h-6 text-cyan-400 mb-3" />
            <h3 className="text-base font-bold text-white mb-2">QR Code Decoder</h3>
            <p className="text-xs sm:text-sm text-slate-300 leading-relaxed">
              Press <kbd className="px-1.5 py-0.5 rounded bg-white/10 font-mono text-xs text-white">⌘⇧3</kbd> and select any QR or MicroQR code on screen. URLs, emails, and phone numbers are automatically detected with one-click contextual actions in the menu bar popover.
            </p>
          </div>

          <div className="p-6 rounded-2xl bg-white/[0.03] border border-white/10">
            <Barcode className="w-6 h-6 text-amber-400 mb-3" />
            <h3 className="text-base font-bold text-white mb-2">Multi-Symbology Barcode</h3>
            <p className="text-xs sm:text-sm text-slate-300 leading-relaxed">
              Press <kbd className="px-1.5 py-0.5 rounded bg-white/10 font-mono text-xs text-white">⌘⇧4</kbd> to decode retail and industrial barcodes (EAN, UPC, Code 128, PDF417, Aztec, Data Matrix), complete with automatic symbology classification tags.
            </p>
          </div>
        </div>
      </section>

      {/* Section 3: Keyboard Shortcuts */}
      <section id="shortcuts" className="mb-16 scroll-mt-24">
        <div className="flex items-center gap-2.5 mb-6">
          <Keyboard className="w-5 h-5 text-pink-400" />
          <h2 className="text-2xl font-bold text-white">3. Global Keyboard Shortcuts</h2>
        </div>

        <div className="rounded-2xl border border-white/10 overflow-hidden bg-white/[0.02]">
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="border-b border-white/10 bg-white/[0.04] text-xs font-mono uppercase text-slate-400">
                  <th className="py-3.5 px-5">Action</th>
                  <th className="py-3.5 px-5">Default Shortcut</th>
                  <th className="py-3.5 px-5">Scope</th>
                  <th className="py-3.5 px-5">Description</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-white/[0.06] text-sm">
                {QUICK_SHORTCUTS.map((item) => (
                  <tr key={item.action} className="hover:bg-white/[0.02] transition-colors">
                    <td className="py-3.5 px-5 font-semibold text-white whitespace-nowrap">
                      {item.action}
                    </td>
                    <td className="py-3.5 px-5 whitespace-nowrap">
                      <div className="inline-flex items-center gap-1">
                        {item.keys.map((k) => (
                          <kbd
                            key={k}
                            className="px-2 py-0.5 rounded bg-white/[0.08] border border-white/15 font-mono text-xs text-pink-200 shadow-inner"
                          >
                            {k}
                          </kbd>
                        ))}
                      </div>
                    </td>
                    <td className="py-3.5 px-5 whitespace-nowrap">
                      <span className="px-2 py-0.5 rounded-full bg-white/[0.06] text-slate-300 font-mono text-[11px]">
                        {item.badge}
                      </span>
                    </td>
                    <td className="py-3.5 px-5 text-slate-300 text-xs sm:text-sm">
                      {item.description}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </section>

      {/* Section 4: Supported Barcode Symbologies */}
      <section id="barcodes" className="mb-16 scroll-mt-24">
        <div className="flex items-center gap-2.5 mb-6">
          <Barcode className="w-5 h-5 text-sky-400" />
          <h2 className="text-2xl font-bold text-white">4. Supported Barcode &amp; 2D Symbologies</h2>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          {BARCODE_FORMATS.map((b) => (
            <div
              key={b.format}
              className="p-4 rounded-xl bg-white/[0.03] border border-white/10 hover:border-white/20 transition-colors"
            >
              <div className="text-[11px] font-mono text-sky-300 mb-1">{b.type}</div>
              <div className="font-bold text-white text-sm mb-1.5">{b.format}</div>
              <p className="text-xs text-slate-400 leading-relaxed">{b.useCase}</p>
            </div>
          ))}
        </div>
      </section>

      {/* Section 5: Frequently Asked Questions (Native <details> disclosure group) */}
      <section id="faq" className="mb-16 scroll-mt-24">
        <div className="flex items-center gap-2.5 mb-6">
          <HelpCircle className="w-5 h-5 text-pink-400" />
          <h2 className="text-2xl font-bold text-white">5. Frequently Asked Questions</h2>
        </div>

        <div className="space-y-3">
          {FAQ_ITEMS.map((faq, idx) => (
            <details
              key={faq.question}
              name="byakugan-support-faq"
              open={idx === 0}
              className="group rounded-2xl bg-white/[0.03] border border-white/10 open:border-pink-500/40 open:bg-white/[0.05] transition-all"
            >
              <summary className="cursor-pointer list-none px-6 py-4 flex items-center justify-between gap-4 select-none">
                <div className="flex flex-col sm:flex-row sm:items-center gap-1.5 sm:gap-3 text-left">
                  <span className="w-fit px-2 py-0.5 rounded bg-pink-500/15 border border-pink-500/30 text-pink-300 font-mono text-[10px] uppercase tracking-wider">
                    {faq.category}
                  </span>
                  <span className="font-semibold text-white text-sm sm:text-base">
                    {faq.question}
                  </span>
                </div>
                <ChevronDown className="w-4 h-4 text-slate-400 shrink-0 transition-transform duration-200 group-open:rotate-180 group-open:text-pink-300" />
              </summary>
              <div className="px-6 pb-5 pt-1 text-sm text-slate-300 leading-relaxed border-t border-white/[0.06]">
                {faq.answer}
              </div>
            </details>
          ))}
        </div>
      </section>

      {/* Section 6: Troubleshooting */}
      <section id="troubleshooting" className="mb-16 scroll-mt-24">
        <div className="flex items-center gap-2.5 mb-6">
          <Wrench className="w-5 h-5 text-amber-400" />
          <h2 className="text-2xl font-bold text-white">6. Quick Troubleshooting Checklist</h2>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="p-6 rounded-2xl bg-white/[0.03] border border-white/10">
            <div className="flex items-center gap-2 text-emerald-400 text-xs font-mono mb-2">
              <CheckCircle2 className="w-4 h-4" />
              <span>OCR ACCURACY</span>
            </div>
            <h3 className="text-base font-bold text-white mb-2">
              Scan returns &quot;No text detected&quot;
            </h3>
            <ul className="text-xs sm:text-sm text-slate-300 space-y-2 list-disc pl-4 leading-relaxed">
              <li>Verify Screen Recording is <strong className="text-white">Granted</strong> in Settings → Appearance.</li>
              <li>Ensure Accuracy is set to <strong className="text-white">Accurate</strong> in Settings → OCR.</li>
              <li>Leave a small margin around the text when dragging the selection reticle.</li>
              <li>DRM-protected video streams (e.g., Apple TV+ / Netflix in Safari) blank out screen capture buffers at the OS level.</li>
            </ul>
          </div>

          <div className="p-6 rounded-2xl bg-white/[0.03] border border-white/10">
            <div className="flex items-center gap-2 text-emerald-400 text-xs font-mono mb-2">
              <CheckCircle2 className="w-4 h-4" />
              <span>PERMISSION RESET</span>
            </div>
            <h3 className="text-base font-bold text-white mb-2">
              Resetting Stale macOS TCC State
            </h3>
            <p className="text-xs sm:text-sm text-slate-300 leading-relaxed mb-3">
              If macOS Privacy Settings shows Byakugan Scan enabled but captures still prompt for permission, reset the TCC entry in Terminal:
            </p>
            <div className="bg-[#07080f] border border-white/10 rounded-lg p-2.5 font-mono text-[11px] text-pink-300 overflow-x-auto">
              <code>tccutil reset ScreenCapture cloud.aritro.byakugan-scan</code>
            </div>
          </div>

          <div className="p-6 rounded-2xl bg-white/[0.03] border border-white/10">
            <div className="flex items-center gap-2 text-emerald-400 text-xs font-mono mb-2">
              <Clock className="w-4 h-4" />
              <span>GATEKEEPER &amp; FIRST LAUNCH</span>
            </div>
            <h3 className="text-base font-bold text-white mb-2">
              Opening Unsigned / Local Builds
            </h3>
            <p className="text-xs sm:text-sm text-slate-300 leading-relaxed mb-3">
              If you downloaded the DMG directly from a browser and macOS Gatekeeper warns about an unverified developer, clear the quarantine flag:
            </p>
            <div className="bg-[#07080f] border border-white/10 rounded-lg p-2.5 font-mono text-[11px] text-emerald-300 overflow-x-auto">
              <code>xattr -cr &quot;/Applications/Byakugan Scan.app&quot;</code>
            </div>
          </div>
        </div>
      </section>

      {/* Section 7: Comparison Matrix (macOS Screen OCR Alternatives) */}
      <section id="comparison" className="mb-16 scroll-mt-24">
        <div className="flex items-center gap-2.5 mb-6">
          <Sparkles className="w-5 h-5 text-pink-400" />
          <h2 className="text-2xl font-bold text-white">
            7. How Byakugan Scan Compares to Other macOS OCR Tools
          </h2>
        </div>

        <div className="rounded-2xl border border-white/10 overflow-hidden bg-white/[0.02]">
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse text-xs sm:text-sm">
              <thead>
                <tr className="border-b border-white/10 bg-white/[0.04] font-mono text-[11px] uppercase text-slate-400">
                  <th className="py-3.5 px-5">Feature</th>
                  <th className="py-3.5 px-5 text-pink-300">Byakugan Scan</th>
                  <th className="py-3.5 px-5">TextSniper</th>
                  <th className="py-3.5 px-5">macOS Live Text</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-white/[0.06] text-slate-300">
                <tr>
                  <td className="py-3 px-5 font-semibold text-white">Price &amp; License</td>
                  <td className="py-3 px-5 text-emerald-300 font-semibold">100% Free &amp; Open Source (MIT)</td>
                  <td className="py-3 px-5">Paid (Proprietary)</td>
                  <td className="py-3 px-5">Built-in to macOS</td>
                </tr>
                <tr>
                  <td className="py-3 px-5 font-semibold text-white">Capture Architecture</td>
                  <td className="py-3 px-5 text-white">In-RAM Pasteboard Buffer (Zero Disk I/O)</td>
                  <td className="py-3 px-5">In-Memory</td>
                  <td className="py-3 px-5">Requires Screenshot / Preview file</td>
                </tr>
                <tr>
                  <td className="py-3 px-5 font-semibold text-white">QR &amp; 13+ Industrial Barcodes</td>
                  <td className="py-3 px-5 text-emerald-300 font-semibold">Yes (QR, Aztec, PDF417, Data Matrix, EAN, Code 128)</td>
                  <td className="py-3 px-5">QR &amp; standard barcodes</td>
                  <td className="py-3 px-5">QR in Safari/Preview only</td>
                </tr>
                <tr>
                  <td className="py-3 px-5 font-semibold text-white">Custom Reticle Colors &amp; Opacity</td>
                  <td className="py-3 px-5 text-emerald-300 font-semibold">5 Theme Accents + Opacity Slider</td>
                  <td className="py-3 px-5">Default macOS Grey Box</td>
                  <td className="py-3 px-5">Default macOS Grey Box</td>
                </tr>
                <tr>
                  <td className="py-3 px-5 font-semibold text-white">Searchable Scan History &amp; Pinning</td>
                  <td className="py-3 px-5 text-emerald-300 font-semibold">Built-in (Local JSON + Category Filters)</td>
                  <td className="py-3 px-5">Additive clipboard only</td>
                  <td className="py-3 px-5">None</td>
                </tr>
                <tr>
                  <td className="py-3 px-5 font-semibold text-white">Network Calls / Telemetry</td>
                  <td className="py-3 px-5 text-emerald-300 font-semibold">Zero (100% Offline)</td>
                  <td className="py-3 px-5">License verification</td>
                  <td className="py-3 px-5">System level</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </section>

      {/* Section 8: Contact & Bug Reports */}
      <section id="contact" className="scroll-mt-24">
        <div className="p-8 rounded-2xl bg-gradient-to-r from-fuchsia-950/40 via-[#0d0818] to-indigo-950/40 border border-pink-500/30 flex flex-col md:flex-row items-start md:items-center justify-between gap-6">
          <div className="max-w-xl">
            <div className="text-xs font-mono uppercase tracking-wider text-pink-300 mb-2">
              Direct Engineering Support
            </div>
            <h2 className="text-2xl font-bold text-white mb-2">
              Still running into an issue or have a feature request?
            </h2>
            <p className="text-sm text-slate-300 leading-relaxed">
              Include your macOS version and Byakugan Scan version (<strong className="text-white">v1.0.5</strong>). We respond to all support emails and GitHub issues within 2 business days.
            </p>
          </div>

          <div className="flex flex-wrap items-center gap-3 shrink-0">
            <a
              href="mailto:aritrosaha2025@gmail.com?subject=Byakugan%20Scan%20Support%20(v1.0.5)"
              className="px-4 py-2.5 rounded-xl bg-gradient-to-r from-fuchsia-600 to-pink-600 hover:from-fuchsia-500 hover:to-pink-500 text-white text-xs font-semibold transition-all inline-flex items-center gap-2 shadow-lg shadow-pink-600/20"
            >
              <Mail className="w-4 h-4" />
              <span>Email Support</span>
            </a>

            <a
              href={`${GITHUB_REPO_URL}/issues`}
              target="_blank"
              rel="noopener noreferrer"
              className="px-4 py-2.5 rounded-xl bg-white/[0.06] hover:bg-white/[0.12] border border-white/15 text-slate-100 text-xs font-semibold transition-all inline-flex items-center gap-2"
            >
              <Github className="w-4 h-4 text-pink-300" />
              <span>Open GitHub Issue</span>
            </a>

            <Link
              href="/privacy"
              className="px-3.5 py-2.5 rounded-xl bg-transparent hover:bg-white/[0.05] text-slate-300 hover:text-white text-xs font-medium transition-colors"
            >
              Privacy Policy →
            </Link>
          </div>
        </div>
      </section>
    </div>
  );
}
