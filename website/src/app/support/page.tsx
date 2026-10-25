import type { Metadata } from "next";
import Link from "next/link";
import {
  ShieldCheck,
  Keyboard,
  ScanText,
  QrCode,
  Barcode,
  Table as TableIcon,
  Palette,
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
  Layers,
  Cpu,
} from "lucide-react";
import { APP_DOWNLOAD_URL, GITHUB_REPO_URL } from "@/constants/links";

export const metadata: Metadata = {
  title: "Support & Documentation — Screen OCR, Table Extraction, QR & Barcode Setup",
  description:
    "Complete documentation, troubleshooting guides, table extraction setup, keyboard shortcuts, Screen Recording permission guide, and FAQs for Byakugan Scan on macOS.",
  alternates: {
    canonical: "/support",
  },
  openGraph: {
    title: "Support & Documentation — Byakugan Scan for macOS",
    description:
      "Learn how to install via Homebrew, extract tables to Markdown/CSV, customize animated reticle themes, grant Screen Recording permissions, and run Dev alongside Production on macOS.",
    url: "https://byakugan-scan.aritro.cloud/support",
  },
};

const QUICK_SHORTCUTS = [
  {
    action: "Capture Text (OCR)",
    keys: ["⌘", "⇧", "2"],
    badge: "Default",
    description: "Interactive screen region selection for instant on-device Vision OCR directly to clipboard.",
  },
  {
    action: "Scan QR Code",
    keys: ["⌘", "⇧", "6"],
    badge: "Default",
    description: "Decode URLs, Wi-Fi credentials, vCards, and 2D QR payloads with one-click actions.",
  },
  {
    action: "Scan Barcode",
    keys: ["⌘", "⇧", "7"],
    badge: "Default",
    description: "Recognize EAN-13, UPC-E, Code 128, PDF417, Aztec, Data Matrix, and industrial codes.",
  },
  {
    action: "Cancel Selection",
    keys: ["Esc"],
    badge: "System",
    description: "Dismiss the active animated Byakugan reticle overlay without modifying clipboard contents.",
  },
  {
    action: "Open Settings",
    keys: ["⌘", ","],
    badge: "Menu Bar",
    description: "Configure shortcuts, OCR languages, table extraction, and signature reticle themes.",
  },
];

const SIGNATURE_THEMES = [
  {
    name: "Byakugan Violet",
    color: "#a855f7",
    border: "border-purple-500/40",
    bg: "bg-purple-500/10",
    text: "text-purple-300",
    description: "Default ethereal lavender glow with gentle corner crosshair accents.",
  },
  {
    name: "Tenseigan Cyan",
    color: "#06b6d4",
    border: "border-cyan-500/40",
    bg: "bg-cyan-500/10",
    text: "text-cyan-300",
    description: "High-contrast crystalline cyan reticle optimized for dark mode monitors.",
  },
  {
    name: "Sharingan Crimson",
    color: "#ef4444",
    border: "border-rose-500/40",
    bg: "bg-rose-500/10",
    text: "text-rose-300",
    description: "Vibrant scarlet pulse border designed for maximum visibility on bright backgrounds.",
  },
  {
    name: "Sage Emerald",
    color: "#10b981",
    border: "border-emerald-500/40",
    bg: "bg-emerald-500/10",
    text: "text-emerald-300",
    description: "Calm, natural jade green with subtle corner bracket animations.",
  },
  {
    name: "Nine-Tails Amber",
    color: "#f59e0b",
    border: "border-amber-500/40",
    bg: "bg-amber-500/10",
    text: "text-amber-300",
    description: "Warm golden glow providing strong contrast across mixed light and dark windows.",
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
      "You can install Byakugan Scan via Homebrew (`brew install --cask halcyon-past/tap/byakugan-scan`) or by downloading the universal `.dmg` installer directly from GitHub Releases. To update via Homebrew, run `brew upgrade --cask byakugan-scan`. The app also includes automatic background update checks on launch.",
  },
  {
    category: "Table OCR & Formatting",
    question: "How does Table Extraction work, and how do I export to Markdown or CSV?",
    answer:
      "When scanning any tabular content (spreadsheets, database dumps, financial reports, or PDF tables), Byakugan Scan's spatial clustering engine analyzes 2D bounding boxes to group cells into rows and columns. It automatically reconstructs the layout into clean Markdown tables or CSV format directly in your clipboard, while intelligently ignoring non-table content like application menus, form fields, and prose paragraphs.",
  },
  {
    category: "Privacy & Security",
    question: "Does Byakugan Scan ever upload my screenshots, text, or tables to the cloud?",
    answer:
      "Never. Byakugan Scan operates 100% offline and strictly on-device using Apple's native Vision framework (`VNRecognizeTextRequest` and `VNDetectBarcodesRequest`). The utility contains zero network entitlements, zero third-party telemetry, and zero crash reporting SDKs.",
  },
  {
    category: "Performance & RAM Pipeline",
    question: "Why is Byakugan Scan so much faster than other screenshot OCR utilities?",
    answer:
      "Standard screen capture utilities write temporary screenshot files to disk (e.g., `/tmp/scan.png`), which immediately triggers macOS Spotlight (`mdwrite`) indexing and `MADService` media analysis, introducing 15–40 second latency spikes on macOS Sonoma & Sequoia. Byakugan Scan executes `/usr/sbin/screencapture -c -s -x` to copy pixels directly into volatile RAM (`NSPasteboard`), decoding the pixel buffer in memory in under 50ms with zero disk I/O.",
  },
  {
    category: "Dev vs. Production",
    question: "Can I run Byakugan Scan Dev alongside the Production version for testing?",
    answer:
      "Yes! Byakugan Scan provides a fully isolated Dev build (`ByakuganScan-Dev.dmg`) configured with a distinct bundle identifier (`cloud.aritro.byakugan-scan.dev`) and an orange 'DEV' menubar badge. Both versions can run simultaneously on the same Mac without colliding on preferences, history files, or macOS TCC permissions.",
  },
  {
    category: "Permissions",
    question: "Why does Byakugan Scan require macOS Screen Recording permission?",
    answer:
      "macOS protects screen pixels under the Screen Recording privacy gate. Byakugan Scan only reads the exact rectangular coordinates you drag-select when you trigger a scan—it never records your screen in the background. It also uses `CGPreflightScreenCaptureAccess()` for silent permission preflight so you are never spammed by system dialogs.",
  },
  {
    category: "Permissions",
    question: "What should I do if Screen Recording permission is ON, but macOS still prompts for permission?",
    answer:
      "If you manually replaced or rebuilt the application bundle, macOS TCC may hold a cached code signature. Open System Settings → Privacy & Security → Screen Recording, select Byakugan Scan, click the minus (–) button to remove it, and relaunch. Alternatively, run `tccutil reset ScreenCapture cloud.aritro.byakugan-scan` in Terminal.",
  },
  {
    category: "Customization",
    question: "How do I change the reticle theme, corner animations, and dimming opacity?",
    answer:
      "Click the Byakugan eye icon in your macOS menu bar → Settings (⌘,) → Appearance. Choose from 5 signature anime themes (Byakugan Violet, Tenseigan Cyan, Sharingan Crimson, Sage Emerald, or Nine-Tails Amber) and customize the background dimming opacity. Click 'Test Capture Overlay' to preview the animated corner brackets live on your screen.",
  },
  {
    category: "History & Pinning",
    question: "Where is my scan history stored, and can I pin or export clips?",
    answer:
      "Scan history is stored locally in `~/Library/Application Support/ByakuganScan/history.json`. Open the menu bar popover and switch to the History tab to search past captures, filter by Text / Table / QR / Barcode / Starred, star important clips, or clear entries. History can be paused or cleared anytime in Settings → General.",
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
        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-pink-500/15 border border-pink-500/30 text-pink-300 text-xs font-mono mb-4 shadow-sm backdrop-blur-md">
          <Sparkles className="w-3.5 h-3.5" />
          <span>OFFICIAL DOCUMENTATION // v1.0.13</span>
        </div>
        <h1 className="text-4xl sm:text-5xl font-extrabold text-white tracking-tight mb-4">
          Support &amp; User Guide
        </h1>
        <p className="text-slate-200 text-base sm:text-lg leading-relaxed">
          Comprehensive guides for configuring Screen Recording permissions, extracting structured tables, customizing animated reticle themes, and troubleshooting on macOS 14+ Sonoma &amp; Sequoia.
        </p>
      </div>

      {/* Quick Navigation Frosted Pills */}
      <div className="flex flex-wrap gap-2.5 mb-14 pb-8 border-b border-white/[0.1]">
        {[
          { href: "#getting-started", label: "Getting Started" },
          { href: "#permissions", label: "Permissions & Architecture" },
          { href: "#scan-modes", label: "Scan Modes & Table OCR" },
          { href: "#shortcuts", label: "Keyboard Shortcuts" },
          { href: "#themes", label: "Overlay & Reticle Themes" },
          { href: "#dev-testing", label: "Dev vs. Production" },
          { href: "#barcodes", label: "Barcode Symbologies" },
          { href: "#faq", label: "Frequently Asked Questions" },
          { href: "#troubleshooting", label: "Troubleshooting Checklist" },
          { href: "#comparison", label: "macOS OCR Matrix" },
          { href: "#contact", label: "Contact Engineering" },
        ].map((item) => (
          <a
            key={item.href}
            href={item.href}
            className="px-3.5 py-1.5 rounded-xl bg-[#0e101d]/85 backdrop-blur-md border border-white/[0.12] hover:border-pink-500/50 hover:bg-[#16182c]/90 text-xs font-mono text-slate-200 hover:text-white transition-all shadow-md"
          >
            {item.label}
          </a>
        ))}
      </div>

      {/* Section 1: Installation & Quick Start */}
      <section id="getting-started" className="mb-16 scroll-mt-24">
        <div className="flex items-center gap-2.5 mb-6">
          <Terminal className="w-5 h-5 text-pink-400" />
          <h2 className="text-2xl font-bold text-white">1. Installation &amp; Quick Start</h2>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {/* Homebrew Card */}
          <div className="p-7 rounded-2xl bg-[#0e101d]/90 backdrop-blur-2xl border border-white/[0.12] shadow-[0_16px_40px_-12px_rgba(0,0,0,0.6),0_0_24px_-8px_rgba(244,114,182,0.08)] flex flex-col justify-between">
            <div>
              <div className="inline-block px-2.5 py-0.5 rounded-md bg-pink-500/15 border border-pink-500/30 text-xs font-mono uppercase tracking-wider text-pink-300 mb-3">
                Recommended • Homebrew Cask
              </div>
              <h3 className="text-xl font-bold text-white mb-2">Install via Homebrew</h3>
              <p className="text-sm text-slate-200 leading-relaxed mb-5">
                Install and keep Byakugan Scan updated automatically using the official tap. Homebrew automatically removes macOS quarantine flags during installation.
              </p>
            </div>
            <div className="bg-[#05060d]/95 border border-white/[0.1] rounded-xl p-4 font-mono text-xs text-emerald-300 overflow-x-auto shadow-inner">
              <code>brew install --cask halcyon-past/tap/byakugan-scan</code>
            </div>
          </div>

          {/* Direct DMG Card */}
          <div className="p-7 rounded-2xl bg-[#0e101d]/90 backdrop-blur-2xl border border-white/[0.12] shadow-[0_16px_40px_-12px_rgba(0,0,0,0.6),0_0_24px_-8px_rgba(56,189,248,0.08)] flex flex-col justify-between">
            <div>
              <div className="inline-block px-2.5 py-0.5 rounded-md bg-sky-500/15 border border-sky-500/30 text-xs font-mono uppercase tracking-wider text-sky-300 mb-3">
                Standalone • Universal DMG
              </div>
              <h3 className="text-xl font-bold text-white mb-2">Direct DMG Installer</h3>
              <p className="text-sm text-slate-200 leading-relaxed mb-5">
                Download <code className="text-slate-100 font-mono text-xs bg-white/10 px-1 py-0.5 rounded">ByakuganScan.dmg</code> (v1.0.13), drag <strong className="text-white">Byakugan Scan.app</strong> into your <strong className="text-white">/Applications</strong> directory, and launch.
              </p>
            </div>
            <div className="flex flex-wrap items-center gap-3">
              <a
                href={APP_DOWNLOAD_URL}
                className="px-4 py-2.5 rounded-xl bg-gradient-to-r from-fuchsia-600 to-pink-600 hover:from-fuchsia-500 hover:to-pink-500 text-white text-xs font-semibold transition-all inline-flex items-center gap-1.5 shadow-lg shadow-pink-600/25"
              >
                <span>Download DMG (v1.0.13)</span>
                <ExternalLink className="w-3.5 h-3.5" />
              </a>
              <a
                href={`${GITHUB_REPO_URL}/releases`}
                target="_blank"
                rel="noopener noreferrer"
                className="px-3.5 py-2.5 rounded-xl bg-white/[0.08] hover:bg-white/[0.14] border border-white/15 text-slate-100 text-xs font-mono transition-all"
              >
                Release Notes
              </a>
            </div>
          </div>
        </div>
      </section>

      {/* Section 2: Permissions & In-Memory Architecture */}
      <section id="permissions" className="mb-16 scroll-mt-24">
        <div className="flex items-center gap-2.5 mb-6">
          <ShieldCheck className="w-5 h-5 text-emerald-400" />
          <h2 className="text-2xl font-bold text-white">2. Screen Recording Permission &amp; Architecture</h2>
        </div>

        <div className="p-7 sm:p-8 rounded-2xl bg-[#0e101d]/90 backdrop-blur-2xl border border-white/[0.12] shadow-[0_16px_40px_-12px_rgba(0,0,0,0.6)] mb-8">
          <div className="flex items-center gap-2 text-xs font-mono text-emerald-400 mb-2">
            <CheckCircle2 className="w-4 h-4" />
            <span>SILENT PREFLIGHT VERIFICATION</span>
          </div>
          <h3 className="text-xl font-bold text-white mb-3">
            Granting macOS Screen Recording Authorization
          </h3>
          <p className="text-sm text-slate-200 leading-relaxed mb-6">
            macOS requires authorization to read pixels from the display. Unlike tools that call <code className="text-rose-300 font-mono text-xs bg-rose-950/40 px-1 py-0.5 rounded">CGWindowListCreateImage</code> (which spams persistent dialog prompts), Byakugan Scan validates access silently via <code className="text-pink-300 font-mono text-xs bg-pink-950/40 px-1 py-0.5 rounded">CGPreflightScreenCaptureAccess()</code> and only accesses the specific rectangle you highlight.
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
                title: "Screen Recording",
                detail: "Scroll down to 'Screen & System Audio Recording' and click to open.",
              },
              {
                step: "Step 03",
                title: "Toggle Byakugan Scan",
                detail: "Find Byakugan Scan in the application list and toggle the switch ON.",
              },
              {
                step: "Step 04",
                title: "Quit & Reopen",
                detail: "Confirm 'Quit & Reopen'—the status in Settings → Appearance turns green.",
              },
            ].map((s) => (
              <li
                key={s.step}
                className="p-4 rounded-xl bg-[#05060d]/90 border border-white/[0.08] shadow-inner"
              >
                <div className="text-[11px] font-mono text-pink-400 mb-1">{s.step}</div>
                <div className="font-semibold text-white mb-1">{s.title}</div>
                <p className="text-xs text-slate-300 leading-relaxed">{s.detail}</p>
              </li>
            ))}
          </ol>
        </div>
      </section>

      {/* Section 3: Scan Modes & Table OCR */}
      <section id="scan-modes" className="mb-16 scroll-mt-24">
        <div className="flex items-center gap-2.5 mb-6">
          <ScanText className="w-5 h-5 text-indigo-400" />
          <h2 className="text-2xl font-bold text-white">3. Scan Modes &amp; Table Extraction</h2>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {/* Card 1: Text OCR */}
          <div className="p-6 rounded-2xl bg-[#0e101d]/90 backdrop-blur-2xl border border-white/[0.12] hover:border-indigo-500/40 transition-all shadow-xl flex flex-col justify-between">
            <div>
              <ScanText className="w-7 h-7 text-indigo-400 mb-3" />
              <h3 className="text-base font-bold text-white mb-2">Instant Text OCR</h3>
              <p className="text-xs sm:text-sm text-slate-200 leading-relaxed mb-4">
                Drag the reticle around unselectable text in videos, PDFs, slides, or images. Recognized text is formatted and copied to your clipboard in under 50ms.
              </p>
            </div>
            <div className="pt-3 border-t border-white/[0.08] flex items-center justify-between text-xs font-mono">
              <span className="text-slate-400">Default:</span>
              <kbd className="px-2 py-0.5 rounded bg-white/10 text-white font-mono">⌘⇧2</kbd>
            </div>
          </div>

          {/* Card 2: Table OCR */}
          <div className="p-6 rounded-2xl bg-[#0e101d]/90 backdrop-blur-2xl border border-white/[0.12] hover:border-pink-500/40 transition-all shadow-xl flex flex-col justify-between">
            <div>
              <TableIcon className="w-7 h-7 text-pink-400 mb-3" />
              <h3 className="text-base font-bold text-white mb-2">Structured Table OCR</h3>
              <p className="text-xs sm:text-sm text-slate-200 leading-relaxed mb-4">
                Select tabular rows and columns. Byakugan Scan clusters cell bounding boxes to export clean Markdown tables or CSVs directly into your spreadsheet.
              </p>
            </div>
            <div className="pt-3 border-t border-white/[0.08] flex items-center justify-between text-xs font-mono">
              <span className="text-slate-400">Export:</span>
              <span className="text-pink-300 font-semibold">Markdown / CSV</span>
            </div>
          </div>

          {/* Card 3: QR Decoder */}
          <div className="p-6 rounded-2xl bg-[#0e101d]/90 backdrop-blur-2xl border border-white/[0.12] hover:border-cyan-500/40 transition-all shadow-xl flex flex-col justify-between">
            <div>
              <QrCode className="w-7 h-7 text-cyan-400 mb-3" />
              <h3 className="text-base font-bold text-white mb-2">QR Code Decoder</h3>
              <p className="text-xs sm:text-sm text-slate-200 leading-relaxed mb-4">
                Scan QR and MicroQR codes on screen. URLs, emails, Wi-Fi networks, and phone numbers are parsed with one-click opening and dialing.
              </p>
            </div>
            <div className="pt-3 border-t border-white/[0.08] flex items-center justify-between text-xs font-mono">
              <span className="text-slate-400">Default:</span>
              <kbd className="px-2 py-0.5 rounded bg-white/10 text-white font-mono">⌘⇧6</kbd>
            </div>
          </div>

          {/* Card 4: Barcodes */}
          <div className="p-6 rounded-2xl bg-[#0e101d]/90 backdrop-blur-2xl border border-white/[0.12] hover:border-amber-500/40 transition-all shadow-xl flex flex-col justify-between">
            <div>
              <Barcode className="w-7 h-7 text-amber-400 mb-3" />
              <h3 className="text-base font-bold text-white mb-2">Industrial Barcodes</h3>
              <p className="text-xs sm:text-sm text-slate-200 leading-relaxed mb-4">
                Decode retail and industrial symbologies including EAN-13, UPC-E, Code 128, Aztec, PDF417, and Data Matrix with symbology classification tags.
              </p>
            </div>
            <div className="pt-3 border-t border-white/[0.08] flex items-center justify-between text-xs font-mono">
              <span className="text-slate-400">Default:</span>
              <kbd className="px-2 py-0.5 rounded bg-white/10 text-white font-mono">⌘⇧7</kbd>
            </div>
          </div>
        </div>
      </section>

      {/* Section 4: Global Keyboard Shortcuts */}
      <section id="shortcuts" className="mb-16 scroll-mt-24">
        <div className="flex items-center gap-2.5 mb-6">
          <Keyboard className="w-5 h-5 text-pink-400" />
          <h2 className="text-2xl font-bold text-white">4. Global Keyboard Shortcuts</h2>
        </div>

        <div className="rounded-2xl border border-white/[0.12] overflow-hidden bg-[#0e101d]/90 backdrop-blur-2xl shadow-2xl">
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="border-b border-white/[0.1] bg-white/[0.05] text-xs font-mono uppercase text-slate-300">
                  <th className="py-4 px-6">Action</th>
                  <th className="py-4 px-6">Default Shortcut</th>
                  <th className="py-4 px-6">Scope</th>
                  <th className="py-4 px-6">Description</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-white/[0.07] text-sm">
                {QUICK_SHORTCUTS.map((item) => (
                  <tr key={item.action} className="hover:bg-white/[0.03] transition-colors">
                    <td className="py-4 px-6 font-semibold text-white whitespace-nowrap">
                      {item.action}
                    </td>
                    <td className="py-4 px-6 whitespace-nowrap">
                      <div className="inline-flex items-center gap-1.5">
                        {item.keys.map((k) => (
                          <kbd
                            key={k}
                            className="px-2.5 py-1 rounded-md bg-white/[0.08] border border-white/15 font-mono text-xs text-pink-300 shadow-sm"
                          >
                            {k}
                          </kbd>
                        ))}
                      </div>
                    </td>
                    <td className="py-4 px-6 whitespace-nowrap">
                      <span className="px-2.5 py-1 rounded-full bg-white/[0.08] text-slate-200 font-mono text-[11px] border border-white/[0.08]">
                        {item.badge}
                      </span>
                    </td>
                    <td className="py-4 px-6 text-slate-200 text-xs sm:text-sm">
                      {item.description}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </section>

      {/* Section 5: Signature Animated Reticle Themes */}
      <section id="themes" className="mb-16 scroll-mt-24">
        <div className="flex items-center gap-2.5 mb-6">
          <Palette className="w-5 h-5 text-purple-400" />
          <h2 className="text-2xl font-bold text-white">5. Animated Reticle Themes &amp; Customization</h2>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
          {SIGNATURE_THEMES.map((theme) => (
            <div
              key={theme.name}
              className="p-6 rounded-2xl bg-[#0e101d]/90 backdrop-blur-2xl border border-white/[0.12] hover:border-white/25 transition-all shadow-xl flex flex-col justify-between"
            >
              <div>
                <div className="flex items-center justify-between mb-3">
                  <div className={`px-2.5 py-0.5 rounded-full ${theme.bg} border ${theme.border} ${theme.text} font-mono text-xs font-semibold`}>
                    {theme.name}
                  </div>
                  <div
                    className="w-3.5 h-3.5 rounded-full border border-white/20 shadow-sm"
                    style={{ backgroundColor: theme.color }}
                  />
                </div>
                <p className="text-xs sm:text-sm text-slate-200 leading-relaxed mb-4">
                  {theme.description}
                </p>
              </div>
              <div className="text-[11px] font-mono text-slate-400 pt-2 border-t border-white/[0.06]">
                Configure in Settings → Appearance
              </div>
            </div>
          ))}

          {/* Test Overlay Feature Card */}
          <div className="p-6 rounded-2xl bg-gradient-to-br from-purple-950/40 via-[#0e101d]/90 to-pink-950/40 backdrop-blur-2xl border border-pink-500/30 shadow-xl flex flex-col justify-between">
            <div>
              <div className="text-xs font-mono uppercase tracking-wider text-pink-300 mb-2">
                Live Calibration
              </div>
              <h3 className="text-base font-bold text-white mb-2">Instant Reticle Testing</h3>
              <p className="text-xs sm:text-sm text-slate-200 leading-relaxed mb-4">
                Test reticle animations, corner crosshairs, coordinate badges, and background dimming sliders directly from Settings without performing actual OCR.
              </p>
            </div>
            <div className="text-xs font-mono text-pink-300">
              Click &quot;Test Capture Overlay&quot; in Settings
            </div>
          </div>
        </div>
      </section>

      {/* Section 6: Dev vs. Production Environments */}
      <section id="dev-testing" className="mb-16 scroll-mt-24">
        <div className="flex items-center gap-2.5 mb-6">
          <Layers className="w-5 h-5 text-amber-400" />
          <h2 className="text-2xl font-bold text-white">6. Dev vs. Production Environments</h2>
        </div>

        <div className="p-7 sm:p-8 rounded-2xl bg-[#0e101d]/90 backdrop-blur-2xl border border-white/[0.12] shadow-2xl">
          <h3 className="text-lg font-bold text-white mb-3">
            Parallel Development &amp; Candidate Testing
          </h3>
          <p className="text-sm text-slate-200 leading-relaxed mb-6">
            Byakugan Scan is engineered with completely isolated Production and Development targets. You can install and run both versions simultaneously on macOS without configuration conflicts or permission resets.
          </p>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="p-5 rounded-xl bg-[#05060d]/90 border border-white/[0.1] shadow-inner">
              <div className="flex items-center justify-between mb-2">
                <span className="font-bold text-white text-base">Production Build</span>
                <span className="px-2 py-0.5 rounded text-[10px] font-mono bg-emerald-500/15 text-emerald-300 border border-emerald-500/30">Stable</span>
              </div>
              <ul className="text-xs text-slate-300 space-y-2 font-mono">
                <li>• App: <span className="text-white">Byakugan Scan.app</span></li>
                <li>• Bundle ID: <span className="text-pink-300">cloud.aritro.byakugan-scan</span></li>
                <li>• Icon: Classic Violet Menubar Eye</li>
                <li>• Distribution: Homebrew Tap &amp; Main DMG</li>
              </ul>
            </div>

            <div className="p-5 rounded-xl bg-[#05060d]/90 border border-amber-500/20 shadow-inner">
              <div className="flex items-center justify-between mb-2">
                <span className="font-bold text-white text-base">Development Build (Dev)</span>
                <span className="px-2 py-0.5 rounded text-[10px] font-mono bg-amber-500/15 text-amber-300 border border-amber-500/30">Testing</span>
              </div>
              <ul className="text-xs text-slate-300 space-y-2 font-mono">
                <li>• App: <span className="text-white">Byakugan Scan Dev.app</span></li>
                <li>• Bundle ID: <span className="text-amber-300">cloud.aritro.byakugan-scan.dev</span></li>
                <li>• Icon: Amber Eye with Distinct DEV Badge</li>
                <li>• Distribution: GitHub Releases (ByakuganScan-Dev.dmg)</li>
              </ul>
            </div>
          </div>
        </div>
      </section>

      {/* Section 7: Supported Barcode Symbologies */}
      <section id="barcodes" className="mb-16 scroll-mt-24">
        <div className="flex items-center gap-2.5 mb-6">
          <Barcode className="w-5 h-5 text-sky-400" />
          <h2 className="text-2xl font-bold text-white">7. Supported Barcode &amp; 2D Symbologies</h2>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          {BARCODE_FORMATS.map((b) => (
            <div
              key={b.format}
              className="p-5 rounded-2xl bg-[#0e101d]/90 backdrop-blur-2xl border border-white/[0.12] hover:border-sky-500/30 transition-all shadow-lg"
            >
              <div className="text-[11px] font-mono text-sky-300 mb-1">{b.type}</div>
              <div className="font-bold text-white text-sm mb-1.5">{b.format}</div>
              <p className="text-xs text-slate-300 leading-relaxed">{b.useCase}</p>
            </div>
          ))}
        </div>
      </section>

      {/* Section 8: Frequently Asked Questions */}
      <section id="faq" className="mb-16 scroll-mt-24">
        <div className="flex items-center gap-2.5 mb-6">
          <HelpCircle className="w-5 h-5 text-pink-400" />
          <h2 className="text-2xl font-bold text-white">8. Frequently Asked Questions</h2>
        </div>

        <div className="space-y-3.5">
          {FAQ_ITEMS.map((faq, idx) => (
            <details
              key={faq.question}
              name="byakugan-support-faq"
              open={idx === 0}
              className="group rounded-2xl bg-[#0e101d]/90 backdrop-blur-2xl border border-white/[0.12] open:border-pink-500/50 open:bg-[#131526]/95 transition-all shadow-xl"
            >
              <summary className="cursor-pointer list-none px-6 py-4.5 flex items-center justify-between gap-4 select-none">
                <div className="flex flex-col sm:flex-row sm:items-center gap-2 sm:gap-3.5 text-left">
                  <span className="w-fit px-2.5 py-0.5 rounded bg-pink-500/15 border border-pink-500/30 text-pink-300 font-mono text-[10px] uppercase tracking-wider">
                    {faq.category}
                  </span>
                  <span className="font-semibold text-white text-sm sm:text-base">
                    {faq.question}
                  </span>
                </div>
                <ChevronDown className="w-4 h-4 text-slate-300 shrink-0 transition-transform duration-200 group-open:rotate-180 group-open:text-pink-300" />
              </summary>
              <div className="px-6 pb-5 pt-2 text-sm text-slate-200 leading-relaxed border-t border-white/[0.08]">
                {faq.answer}
              </div>
            </details>
          ))}
        </div>
      </section>

      {/* Section 9: Troubleshooting Checklist */}
      <section id="troubleshooting" className="mb-16 scroll-mt-24">
        <div className="flex items-center gap-2.5 mb-6">
          <Wrench className="w-5 h-5 text-amber-400" />
          <h2 className="text-2xl font-bold text-white">9. Troubleshooting Checklist</h2>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="p-6 rounded-2xl bg-[#0e101d]/90 backdrop-blur-2xl border border-white/[0.12] shadow-xl">
            <div className="flex items-center gap-2 text-emerald-400 text-xs font-mono mb-2">
              <CheckCircle2 className="w-4 h-4" />
              <span>OCR ACCURACY</span>
            </div>
            <h3 className="text-base font-bold text-white mb-2">
              Scan returns &quot;No text detected&quot;
            </h3>
            <ul className="text-xs sm:text-sm text-slate-200 space-y-2 list-disc pl-4 leading-relaxed">
              <li>Verify Screen Recording is <strong className="text-white">Granted</strong> in Settings → Appearance.</li>
              <li>Ensure Accuracy is set to <strong className="text-white">Accurate</strong> in Settings → OCR.</li>
              <li>Leave a small margin around words when dragging the selection box.</li>
              <li>DRM-protected media streams (Apple TV+ / Netflix) blank out capture buffers at the macOS display compositor level.</li>
            </ul>
          </div>

          <div className="p-6 rounded-2xl bg-[#0e101d]/90 backdrop-blur-2xl border border-white/[0.12] shadow-xl">
            <div className="flex items-center gap-2 text-emerald-400 text-xs font-mono mb-2">
              <CheckCircle2 className="w-4 h-4" />
              <span>PERMISSION RESET</span>
            </div>
            <h3 className="text-base font-bold text-white mb-2">
              Resetting Stale macOS TCC State
            </h3>
            <p className="text-xs sm:text-sm text-slate-200 leading-relaxed mb-3">
              If macOS Privacy Settings shows Byakugan Scan enabled but the app still prompts for permission, reset the TCC entry in Terminal:
            </p>
            <div className="bg-[#05060d]/95 border border-white/[0.1] rounded-lg p-3 font-mono text-[11px] text-pink-300 overflow-x-auto shadow-inner">
              <code>tccutil reset ScreenCapture cloud.aritro.byakugan-scan</code>
            </div>
          </div>

          <div className="p-6 rounded-2xl bg-[#0e101d]/90 backdrop-blur-2xl border border-white/[0.12] shadow-xl">
            <div className="flex items-center gap-2 text-emerald-400 text-xs font-mono mb-2">
              <Clock className="w-4 h-4" />
              <span>GATEKEEPER VERIFICATION</span>
            </div>
            <h3 className="text-base font-bold text-white mb-2">
              Opening Unsigned / Local Builds
            </h3>
            <p className="text-xs sm:text-sm text-slate-200 leading-relaxed mb-3">
              If you downloaded the DMG directly from a browser and macOS Gatekeeper warns about an unverified developer, clear the quarantine attribute:
            </p>
            <div className="bg-[#05060d]/95 border border-white/[0.1] rounded-lg p-3 font-mono text-[11px] text-emerald-300 overflow-x-auto shadow-inner">
              <code>xattr -cr &quot;/Applications/Byakugan Scan.app&quot;</code>
            </div>
          </div>
        </div>
      </section>

      {/* Section 10: Comparison Matrix */}
      <section id="comparison" className="mb-16 scroll-mt-24">
        <div className="flex items-center gap-2.5 mb-6">
          <Sparkles className="w-5 h-5 text-pink-400" />
          <h2 className="text-2xl font-bold text-white">
            10. How Byakugan Scan Compares to Other Tools
          </h2>
        </div>

        <div className="rounded-2xl border border-white/[0.12] overflow-hidden bg-[#0e101d]/90 backdrop-blur-2xl shadow-2xl">
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse text-xs sm:text-sm">
              <thead>
                <tr className="border-b border-white/[0.1] bg-white/[0.05] font-mono text-[11px] uppercase text-slate-300">
                  <th className="py-4 px-6">Feature</th>
                  <th className="py-4 px-6 text-pink-300">Byakugan Scan</th>
                  <th className="py-4 px-6">TextSniper</th>
                  <th className="py-4 px-6">macOS Live Text</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-white/[0.07] text-slate-200">
                <tr>
                  <td className="py-3.5 px-6 font-semibold text-white">Price &amp; License</td>
                  <td className="py-3.5 px-6 text-emerald-300 font-semibold">100% Free &amp; Open Source (MIT)</td>
                  <td className="py-3.5 px-6">Paid (Proprietary)</td>
                  <td className="py-3.5 px-6">Built-in to macOS</td>
                </tr>
                <tr>
                  <td className="py-3.5 px-6 font-semibold text-white">Capture Pipeline</td>
                  <td className="py-3.5 px-6 text-white font-medium">In-RAM Pasteboard Buffer (Zero Disk I/O)</td>
                  <td className="py-3.5 px-6">In-Memory</td>
                  <td className="py-3.5 px-6">Requires Screenshot / Preview file</td>
                </tr>
                <tr>
                  <td className="py-3.5 px-6 font-semibold text-white">Structured Table OCR</td>
                  <td className="py-3.5 px-6 text-emerald-300 font-semibold">Built-in (Markdown &amp; CSV Bounding Box Clustering)</td>
                  <td className="py-3.5 px-6">Plain text only</td>
                  <td className="py-3.5 px-6">Manual line copy</td>
                </tr>
                <tr>
                  <td className="py-3.5 px-6 font-semibold text-white">QR &amp; 13+ Industrial Barcodes</td>
                  <td className="py-3.5 px-6 text-emerald-300 font-semibold">Yes (QR, Aztec, PDF417, Data Matrix, EAN, Code 128)</td>
                  <td className="py-3.5 px-6">QR &amp; standard barcodes</td>
                  <td className="py-3.5 px-6">QR in Safari/Preview only</td>
                </tr>
                <tr>
                  <td className="py-3.5 px-6 font-semibold text-white">Custom Reticle Themes &amp; Dimming</td>
                  <td className="py-3.5 px-6 text-emerald-300 font-semibold">5 Theme Accents + Animated Brackets</td>
                  <td className="py-3.5 px-6">Default macOS Grey Box</td>
                  <td className="py-3.5 px-6">Default macOS Grey Box</td>
                </tr>
                <tr>
                  <td className="py-3.5 px-6 font-semibold text-white">Searchable Scan History &amp; Pinning</td>
                  <td className="py-3.5 px-6 text-emerald-300 font-semibold">Built-in (Local JSON + Category Filters)</td>
                  <td className="py-3.5 px-6">Additive clipboard only</td>
                  <td className="py-3.5 px-6">None</td>
                </tr>
                <tr>
                  <td className="py-3.5 px-6 font-semibold text-white">Network &amp; Telemetry</td>
                  <td className="py-3.5 px-6 text-emerald-300 font-semibold">Zero (100% Offline &amp; Private)</td>
                  <td className="py-3.5 px-6">License verification</td>
                  <td className="py-3.5 px-6">System level</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </section>

      {/* Section 11: Contact & Support */}
      <section id="contact" className="scroll-mt-24">
        <div className="p-8 sm:p-9 rounded-2xl bg-gradient-to-r from-fuchsia-950/60 via-[#0d0a1c]/95 to-indigo-950/60 backdrop-blur-2xl border border-pink-500/35 shadow-[0_20px_50px_rgba(0,0,0,0.6)] flex flex-col md:flex-row items-start md:items-center justify-between gap-6">
          <div className="max-w-xl">
            <div className="text-xs font-mono uppercase tracking-wider text-pink-300 mb-2">
              Direct Engineering Support
            </div>
            <h2 className="text-2xl font-bold text-white mb-2">
              Have a question or run into an edge case?
            </h2>
            <p className="text-sm text-slate-200 leading-relaxed">
              Include your macOS version and Byakugan Scan version (<strong className="text-white">v1.0.13</strong>). We review and respond to all support emails and GitHub issues promptly.
            </p>
          </div>

          <div className="flex flex-wrap items-center gap-3 shrink-0">
            <a
              href="mailto:aritrosaha2025@gmail.com?subject=Byakugan%20Scan%20Support%20(v1.0.13)"
              className="px-4 py-2.5 rounded-xl bg-gradient-to-r from-fuchsia-600 to-pink-600 hover:from-fuchsia-500 hover:to-pink-500 text-white text-xs font-semibold transition-all inline-flex items-center gap-2 shadow-lg shadow-pink-600/30"
            >
              <Mail className="w-4 h-4" />
              <span>Email Support</span>
            </a>

            <a
              href={`${GITHUB_REPO_URL}/issues`}
              target="_blank"
              rel="noopener noreferrer"
              className="px-4 py-2.5 rounded-xl bg-white/[0.08] hover:bg-white/[0.14] border border-white/15 text-slate-100 text-xs font-semibold transition-all inline-flex items-center gap-2"
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
