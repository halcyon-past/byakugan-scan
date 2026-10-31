"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import {
  ArrowDown,
  ArrowUpRight,
  Shield,
  Zap,
  Cpu,
  Eye,
  Terminal,
  Sparkles,
  Copy,
  Check,
  Download,
  ScanText,
  QrCode,
  Barcode,
  Table as TableIcon,
  Lock,
  Layers,
  Code2,
  FileText,
  UserCheck,
  ExternalLink,
  CheckCircle2,
  HelpCircle,
} from "lucide-react";
import MangaScrollSection from "@/components/MangaScrollSection";
import { APP_DOWNLOAD_URL } from "@/constants/links";

export default function AnimeMasterpieceHome() {
  const [installMethod, setInstallMethod] = useState<"brew" | "dmg">("brew");
  const [copiedBrew, setCopiedBrew] = useState(false);
  const [copiedSha, setCopiedSha] = useState(false);

  return (
    <div className="relative w-full overflow-hidden">
      {/* Soothing Atmospheric Radial Glow & Soft Ambient Grid */}
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_80%_60%_at_50%_-10%,rgba(217,70,239,0.12),transparent_70%)] pointer-events-none z-0" />
      <div className="absolute inset-0 manga-grid pointer-events-none opacity-20 z-0" />

      {/* ======================================================== */}
      {/* 1. HERO SECTION: SERENE EDITORIAL IMPACT */}
      {/* ======================================================== */}
      <section className="relative min-h-[85vh] flex flex-col justify-between pt-12 sm:pt-20 pb-12 px-6 max-w-7xl mx-auto hairline-b z-20">
        {/* Hero Central Focus */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 items-center my-auto py-8">
          {/* Left Column: Refined Typography & High Legibility */}
          <div className="lg:col-span-7 flex flex-col justify-center">
            {/* Japanese Kanji Eyebrow Badge */}
            <div className="flex items-center gap-2.5 mb-5">
              <span className="px-3 py-1 rounded-full bg-pink-500/10 border border-pink-500/20 text-xs font-medium text-pink-300">
                白眼の目覚め // macOS Screen OCR & Barcode Utility by Aritro Saha (@halcyon-past)
              </span>
            </div>

            {/* Monumental, Readable Headline */}
            <h1 className="text-4xl sm:text-6xl xl:text-7xl font-extrabold text-slate-100 tracking-tight leading-[1.08] mb-6">
              Instant Screen OCR,{" "}
              <span className="bg-gradient-to-r from-pink-400 via-fuchsia-300 to-rose-400 bg-clip-text text-transparent">
                QR & Barcode Scanner
              </span>{" "}
              for macOS.
            </h1>

            {/* Lead Narrative with High Utility Clarity */}
            <p className="text-slate-300 text-base sm:text-lg max-w-xl font-normal leading-relaxed mb-8">
              Sees through every obstacle on your screen. Snatch unselectable text from video streams, protected PDFs, and images in 11 milliseconds. Decode on-screen QR codes and 13+ industrial barcodes with zero disk latency and complete privacy. Handcrafted by{" "}
              <a
                href="https://www.aritro.cloud/"
                target="_blank"
                rel="author me noopener noreferrer"
                className="text-pink-300 font-semibold underline decoration-pink-500/40 hover:text-white transition-colors"
              >
                Aritro Saha (@halcyon-past)
              </a>
              .
            </p>

            {/* Professional Tabbed Installation Card */}
            <div className="w-full max-w-xl rounded-xl bg-slate-950/75 border border-white/10 backdrop-blur-xl overflow-hidden shadow-2xl shadow-black/50 mb-6">
              {/* Tab Header */}
              <div className="flex items-center justify-between px-3 pt-2.5 bg-white/[0.02] border-b border-white/[0.08]">
                <div className="flex items-center gap-1.5">
                  <button
                    type="button"
                    onClick={() => setInstallMethod("brew")}
                    className={`flex items-center gap-2 px-3.5 py-2 rounded-t-lg text-xs font-mono transition-all border-b-2 ${
                      installMethod === "brew"
                        ? "bg-white/[0.08] text-white border-pink-400 font-semibold shadow-sm"
                        : "text-slate-400 hover:text-slate-200 border-transparent hover:bg-white/[0.03]"
                    }`}
                  >
                    <Terminal className="w-3.5 h-3.5 text-pink-400" />
                    <span>Homebrew Cask</span>
                    <span className="px-1.5 py-0.5 rounded text-[10px] bg-pink-500/20 text-pink-300 font-medium font-sans">
                      Popular
                    </span>
                  </button>

                  <button
                    type="button"
                    onClick={() => setInstallMethod("dmg")}
                    className={`flex items-center gap-2 px-3.5 py-2 rounded-t-lg text-xs font-mono transition-all border-b-2 ${
                      installMethod === "dmg"
                        ? "bg-white/[0.08] text-white border-pink-400 font-semibold shadow-sm"
                        : "text-slate-400 hover:text-slate-200 border-transparent hover:bg-white/[0.03]"
                    }`}
                  >
                    <Download className="w-3.5 h-3.5 text-pink-400" />
                    <span>Direct DMG</span>
                    <span className="px-1.5 py-0.5 rounded text-[10px] bg-slate-800 text-slate-300 font-sans">
                      v1.0.14
                    </span>
                  </button>
                </div>

                <div className="hidden sm:flex items-center gap-1.5 pr-2 text-[11px] font-mono text-slate-400">
                  <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse" />
                  <span>Universal Binary</span>
                </div>
              </div>

              {/* Tab Content */}
              <div className="p-4 sm:p-5">
                {installMethod === "brew" ? (
                  <div className="space-y-3">
                    <div className="flex items-center justify-between gap-3 p-3 rounded-lg bg-black/60 border border-white/[0.08] font-mono text-xs text-slate-200 shadow-inner">
                      <div className="flex items-center gap-2.5 overflow-x-auto select-all">
                        <span className="text-pink-400 font-bold select-none">$</span>
                        <span className="text-slate-200 whitespace-nowrap">brew install --cask halcyon-past/tap/byakugan-scan</span>
                      </div>
                      <button
                        type="button"
                        onClick={() => {
                          navigator.clipboard.writeText("brew install --cask halcyon-past/tap/byakugan-scan");
                          setCopiedBrew(true);
                          setTimeout(() => setCopiedBrew(false), 2000);
                        }}
                        className="flex-shrink-0 flex items-center gap-1.5 px-2.5 py-1.5 rounded bg-white/[0.06] hover:bg-white/[0.12] border border-white/10 text-xs text-slate-300 hover:text-white transition-all active:scale-95"
                        title="Copy command"
                      >
                        {copiedBrew ? (
                          <>
                            <Check className="w-3.5 h-3.5 text-emerald-400" />
                            <span className="text-[11px] text-emerald-400 font-sans font-medium">Copied!</span>
                          </>
                        ) : (
                          <>
                            <Copy className="w-3.5 h-3.5 text-slate-400" />
                            <span className="text-[11px] font-sans font-medium">Copy</span>
                          </>
                        )}
                      </button>
                    </div>

                    <div className="flex flex-wrap items-center justify-between gap-2 text-xs text-slate-400 pt-0.5">
                      <div className="flex items-center gap-1.5">
                        <span className="text-emerald-400 font-semibold">✓</span>
                        <span>Official Tap: <code className="text-slate-300">halcyon-past/homebrew-tap</code></span>
                      </div>
                      <span className="text-[11px] font-mono text-slate-400">
                        Updates via <code className="text-pink-300">brew upgrade</code>
                      </span>
                    </div>
                  </div>
                ) : (
                  <div className="space-y-3">
                    <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 p-3 rounded-lg bg-black/60 border border-white/[0.08]">
                      <div>
                        <div className="text-sm font-semibold text-white flex items-center gap-2">
                          <span>ByakuganScan-v1.0.14.dmg</span>
                          <span className="text-[10px] px-1.5 py-0.5 rounded bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 font-mono">
                            3.2 MB
                          </span>
                        </div>
                        <p className="text-xs text-slate-400 mt-0.5">
                          Drag-and-drop installer for macOS 14.0 Sonoma or later.
                        </p>
                      </div>

                      <a
                        href={APP_DOWNLOAD_URL}
                        className="flex-shrink-0 inline-flex items-center justify-center gap-2 px-4 py-2.5 bg-gradient-to-r from-fuchsia-600 to-pink-600 hover:from-fuchsia-500 hover:to-pink-500 text-white text-xs font-bold rounded-lg shadow-md transition-all active:scale-95"
                      >
                        <Download className="w-3.5 h-3.5" />
                        <span>Download DMG</span>
                      </a>
                    </div>

                    <div className="flex flex-wrap items-center justify-between gap-2 text-[11px] font-mono text-slate-400 pt-0.5">
                      <div className="flex items-center gap-1.5">
                        <span className="text-slate-400">SHA-256:</span>
                        <span className="text-slate-300 select-all">3d6e9aa7...929e4</span>
                        <button
                          type="button"
                          onClick={() => {
                            navigator.clipboard.writeText("3d6e9aa79fe7dc7bd7c7d290002ccc2ef3d8983509b056507fd922e33f4929e4");
                            setCopiedSha(true);
                            setTimeout(() => setCopiedSha(false), 2000);
                          }}
                          className="ml-1 p-1 text-slate-400 hover:text-pink-300 transition-colors rounded hover:bg-white/5"
                          title="Copy full SHA-256 checksum"
                        >
                          {copiedSha ? <Check className="w-3 h-3 text-emerald-400" /> : <Copy className="w-3 h-3" />}
                        </button>
                      </div>

                      <a
                        href="https://github.com/halcyon-past/byakugan-scan/releases/latest"
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-pink-400 hover:underline inline-flex items-center gap-1"
                      >
                        <span>Release Assets</span>
                        <ArrowUpRight className="w-3 h-3" />
                      </a>
                    </div>
                  </div>
                )}
              </div>
            </div>

            {/* Quick Explore Link */}
            <div className="flex items-center gap-4">
              <a
                href="#solutions"
                className="px-5 py-2.5 bg-white/[0.04] border border-white/10 hover:border-pink-500/30 hover:bg-white/[0.07] text-slate-300 hover:text-white text-xs font-medium rounded-lg transition-all flex items-center gap-2"
              >
                <span>Explore Utility Solutions</span>
                <ArrowDown className="w-3.5 h-3.5 text-pink-400" />
              </a>
            </div>
          </div>

          {/* Right Column: Visual Stage for 3D Follower Eye */}
          <div className="lg:col-span-5 hidden lg:flex items-center justify-center relative min-h-[460px] pointer-events-none">
            {/* Ambient soft glow behind the 3D eye */}
            <div className="w-[340px] h-[340px] rounded-full bg-gradient-to-tr from-fuchsia-600/20 via-pink-600/10 to-transparent blur-3xl" />
          </div>
        </div>

        {/* Hero Bottom Bar */}
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 pt-6 hairline-t text-xs text-slate-400">
          <div className="flex flex-wrap items-center gap-3">
            <span className="text-slate-400 font-medium">Quick Shortcuts:</span>
            <span className="bg-white/[0.04] border border-white/10 px-2.5 py-1 rounded text-slate-200 font-mono text-xs">⌘⇧2 Text OCR</span>
            <span className="bg-white/[0.04] border border-white/10 px-2.5 py-1 rounded text-slate-200 font-mono text-xs">⌘⇧6 QR Scanner</span>
            <span className="bg-white/[0.04] border border-white/10 px-2.5 py-1 rounded text-slate-200 font-mono text-xs">⌘⇧7 Barcode Scanner</span>
          </div>

          <div className="flex items-center gap-2 text-slate-400 font-medium">
            <span>Scroll to explore</span>
            <ArrowDown className="w-3.5 h-3.5 animate-bounce text-pink-400" />
          </div>
        </div>
      </section>

      {/* ======================================================== */}
      {/* 2. INFINITE TICKER (Calm Ambient Cadence) */}
      {/* ======================================================== */}
      <div className="w-full bg-[#0d0e16] hairline-b py-3.5 overflow-hidden select-none z-20 relative">
        <div className="animate-ticker flex items-center gap-8 text-xs font-mono text-slate-400 font-medium tracking-wide">
          <span>// ALL-SEEING VISION SYSTEM</span>
          <span className="text-pink-400">•</span>
          <span>APPLE NEURAL ENGINE CONCURRENCY</span>
          <span className="text-sky-400">•</span>
          <span>ZERO CLOUD TELEMETRY</span>
          <span className="text-amber-400">•</span>
          <span>13+ INDUSTRIAL BARCODES</span>
          <span className="text-fuchsia-400">•</span>
          <span>SUB-SECOND REGION OCR</span>
          <span className="text-pink-400">•</span>
          <span>INVISIBLE MENUBAR UTILITY</span>
          <span className="text-sky-400">•</span>
          <span>CREATED BY ARITRO SAHA (@HALCYON-PAST)</span>
          <span className="text-pink-400">•</span>
          <span>APPLE NEURAL ENGINE CONCURRENCY</span>
          <span className="text-sky-400">•</span>
          <span>ZERO CLOUD TELEMETRY</span>
          <span className="text-amber-400">•</span>
          <span>13+ INDUSTRIAL BARCODES</span>
          <span className="text-fuchsia-400">•</span>
          <span>SUB-SECOND REGION OCR</span>
          <span className="text-pink-400">•</span>
          <span>INVISIBLE MENUBAR UTILITY</span>
          <span className="text-sky-400">•</span>
        </div>
      </div>

      {/* ======================================================== */}
      {/* 3. MANGA STORYBOARD PARALLAX LORE SECTION */}
      {/* ======================================================== */}
      <div id="philosophy">
        <MangaScrollSection />
      </div>

      {/* ======================================================== */}
      {/* 4. PRODUCT MATRIX: CAPABILITIES & SYMBOLOGY */}
      {/* ======================================================== */}
      <section id="capabilities" className="py-24 px-6 max-w-7xl mx-auto hairline-b z-20 relative">
        <div className="flex flex-col md:flex-row md:items-end justify-between mb-16 gap-6">
          <div>
            <span className="text-xs font-mono tracking-wider text-pink-400 font-semibold uppercase block mb-2">
              Core Capabilities
            </span>
            <h2 className="text-3xl sm:text-5xl font-extrabold text-slate-100 tracking-tight leading-tight">
              Tactical Modules
            </h2>
          </div>

          <p className="text-slate-300 text-sm max-w-md font-normal leading-relaxed">
            Replace sluggish screenshot workflows with single-keystroke neural intelligence directly from your menu bar.
          </p>
        </div>

        {/* 3 Large Showcase Editorial Cards */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Card 1: OCR */}
          <div className="anime-glass rounded-2xl p-8 flex flex-col justify-between anime-card-hover group">
            <div>
              <div className="flex items-center justify-between text-xs font-mono text-slate-400 mb-6 hairline-b pb-4">
                <span className="font-semibold text-slate-300">Module // OCR</span>
                <span className="text-pink-300 font-medium">VNRecognizeTextRequest</span>
              </div>
              <h3 className="text-xl font-bold text-slate-100 mb-3 tracking-tight">
                Sub-Second Text Extraction
              </h3>
              <p className="text-sm text-slate-300 leading-relaxed mb-6 font-normal">
                High-precision multi-script OCR covering Latin, Chinese (Simplified & Traditional), Japanese, Korean, Cyrillic, and Arabic. Smart paragraph synthesis with automatic line-break joining.
              </p>
            </div>

            <div className="pt-6 hairline-t flex items-center justify-between text-xs font-mono">
              <span className="text-slate-400 font-medium">Default Shortcut</span>
              <span className="text-slate-200 font-semibold bg-white/[0.06] border border-white/10 px-2.5 py-1 rounded">⌘ + ⇧ + 2</span>
            </div>
          </div>

          {/* Card 2: QR */}
          <div className="anime-glass rounded-2xl p-8 flex flex-col justify-between anime-card-hover group">
            <div>
              <div className="flex items-center justify-between text-xs font-mono text-slate-400 mb-6 hairline-b pb-4">
                <span className="font-semibold text-slate-300">Module // QR Matrix</span>
                <span className="text-sky-300 font-medium">VNBarcodeSymbology.qr</span>
              </div>
              <h3 className="text-xl font-bold text-slate-100 mb-3 tracking-tight">
                Display QR Matrix Decoder
              </h3>
              <p className="text-sm text-slate-300 leading-relaxed mb-6 font-normal">
                Never grab your phone to scan a monitor code. Snaps QR codes shown in Zoom, Slack, or web pages straight into URLs, 2FA secret seeds, and Wi-Fi credentials.
              </p>
            </div>

            <div className="pt-6 hairline-t flex items-center justify-between text-xs font-mono">
              <span className="text-slate-400 font-medium">Default Shortcut</span>
              <span className="text-slate-200 font-semibold bg-white/[0.06] border border-white/10 px-2.5 py-1 rounded">⌘ + ⇧ + 6</span>
            </div>
          </div>

          {/* Card 3: Barcode */}
          <div className="anime-glass rounded-2xl p-8 flex flex-col justify-between anime-card-hover group">
            <div>
              <div className="flex items-center justify-between text-xs font-mono text-slate-400 mb-6 hairline-b pb-4">
                <span className="font-semibold text-slate-300">Module // Barcode</span>
                <span className="text-amber-300 font-medium">13 Symbologies</span>
              </div>
              <h3 className="text-xl font-bold text-slate-100 mb-3 tracking-tight">
                Industrial Barcodes
              </h3>
              <p className="text-sm text-slate-300 leading-relaxed mb-6 font-normal">
                Decodes EAN-13, UPC-E, Code 128, Code 39, Data Matrix, Aztec, and PDF417 format standards for logistics, retail, and hardware engineering.
              </p>
            </div>

            <div className="pt-6 hairline-t flex items-center justify-between text-xs font-mono">
              <span className="text-slate-400 font-medium">Default Shortcut</span>
              <span className="text-slate-200 font-semibold bg-white/[0.06] border border-white/10 px-2.5 py-1 rounded">⌘ + ⇧ + 7</span>
            </div>
          </div>
        </div>
      </section>

      {/* ======================================================== */}
      {/* 5. SEARCH INTENT & REAL-WORLD UTILITY SOLUTIONS */}
      {/* ======================================================== */}
      <section id="solutions" className="py-24 px-6 max-w-7xl mx-auto hairline-b z-20 relative">
        <div className="flex flex-col md:flex-row md:items-end justify-between mb-16 gap-6">
          <div>
            <span className="text-xs font-mono tracking-wider text-pink-400 font-semibold uppercase block mb-2">
              Utility & Real-World Use Cases
            </span>
            <h2 className="text-3xl sm:text-5xl font-extrabold text-slate-100 tracking-tight leading-tight">
              Solving Your Everyday Screen Obstacles
            </h2>
          </div>

          <p className="text-slate-300 text-sm max-w-md font-normal leading-relaxed">
            People don’t search for app names — they search for solutions to friction. Byakugan Scan dissolves the barrier between visual pixels and actionable text.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {/* Use Case 1 */}
          <div className="p-7 rounded-2xl bg-[#0e101c] border border-white/[0.08] hover:border-pink-500/30 transition-all flex flex-col justify-between shadow-lg group">
            <div>
              <div className="w-10 h-10 rounded-xl bg-pink-500/10 border border-pink-500/20 flex items-center justify-center text-pink-400 mb-5">
                <Code2 className="w-5 h-5" />
              </div>
              <h3 className="text-lg font-bold text-white mb-2">
                Copy Code from Videos & Webinars
              </h3>
              <p className="text-sm text-slate-300 leading-relaxed font-normal">
                Pause a YouTube coding tutorial, Udemy course, or Zoom screen share. Press <code className="text-pink-300 font-mono text-xs bg-white/[0.06] px-1.5 py-0.5 rounded">⌘⇧2</code> and grab clean, unselectable code snippets straight into your clipboard in under 50ms without re-typing.
              </p>
            </div>
            <div className="mt-6 pt-4 border-t border-white/[0.06] flex items-center gap-2 text-xs font-mono text-slate-400">
              <span className="text-emerald-400">✓</span>
              <span>Sub-50ms Vision Neural Engine</span>
            </div>
          </div>

          {/* Use Case 2 */}
          <div className="p-7 rounded-2xl bg-[#0e101c] border border-white/[0.08] hover:border-sky-500/30 transition-all flex flex-col justify-between shadow-lg group">
            <div>
              <div className="w-10 h-10 rounded-xl bg-sky-500/10 border border-sky-500/20 flex items-center justify-center text-sky-400 mb-5">
                <QrCode className="w-5 h-5" />
              </div>
              <h3 className="text-lg font-bold text-white mb-2">
                Scan Monitor QR Codes Without a Phone
              </h3>
              <p className="text-sm text-slate-300 leading-relaxed font-normal">
                Stop awkwardly holding your smartphone up to your Mac display. Press <code className="text-sky-300 font-mono text-xs bg-white/[0.06] px-1.5 py-0.5 rounded">⌘⇧6</code> to snap any on-screen QR code into actionable links with 1-click Open URL, Compose Email, or Copy Secret actions.
              </p>
            </div>
            <div className="mt-6 pt-4 border-t border-white/[0.06] flex items-center gap-2 text-xs font-mono text-slate-400">
              <span className="text-sky-400">✓</span>
              <span>One-Click Contextual Actions</span>
            </div>
          </div>

          {/* Use Case 3 */}
          <div className="p-7 rounded-2xl bg-[#0e101c] border border-white/[0.08] hover:border-amber-500/30 transition-all flex flex-col justify-between shadow-lg group">
            <div>
              <div className="w-10 h-10 rounded-xl bg-amber-500/10 border border-amber-500/20 flex items-center justify-center text-amber-400 mb-5">
                <Barcode className="w-5 h-5" />
              </div>
              <h3 className="text-lg font-bold text-white mb-2">
                Industrial & Logistics Barcode Reader
              </h3>
              <p className="text-sm text-slate-300 leading-relaxed font-normal">
                Recognize 13+ standard retail and industrial symbologies directly from PDF invoices, packaging mockups, shipping manifests, and web shops with <code className="text-amber-300 font-mono text-xs bg-white/[0.06] px-1.5 py-0.5 rounded">⌘⇧7</code>.
              </p>
            </div>
            <div className="mt-6 pt-4 border-t border-white/[0.06] flex items-center gap-2 text-xs font-mono text-slate-400">
              <span className="text-amber-400">✓</span>
              <span>EAN, UPC, Code 128, PDF417, Aztec</span>
            </div>
          </div>

          {/* Use Case 4 */}
          <div className="p-7 rounded-2xl bg-[#0e101c] border border-white/[0.08] hover:border-fuchsia-500/30 transition-all flex flex-col justify-between shadow-lg group">
            <div>
              <div className="w-10 h-10 rounded-xl bg-fuchsia-500/10 border border-fuchsia-500/20 flex items-center justify-center text-fuchsia-400 mb-5">
                <TableIcon className="w-5 h-5" />
              </div>
              <h3 className="text-lg font-bold text-white mb-2">
                Convert Screen Tables to Markdown & CSV
              </h3>
              <p className="text-sm text-slate-300 leading-relaxed font-normal">
                Tired of messy unaligned multi-column data? Byakugan Scan features automatic spatial column analysis that formats tabular dashboard data straight into clean Markdown tables or CSV files in your clipboard.
              </p>
            </div>
            <div className="mt-6 pt-4 border-t border-white/[0.06] flex items-center gap-2 text-xs font-mono text-slate-400">
              <span className="text-fuchsia-400">✓</span>
              <span>Spatial Table Ordering & Escaped Pipes</span>
            </div>
          </div>

          {/* Use Case 5 */}
          <div className="p-7 rounded-2xl bg-[#0e101c] border border-white/[0.08] hover:border-emerald-500/30 transition-all flex flex-col justify-between shadow-lg group">
            <div>
              <div className="w-10 h-10 rounded-xl bg-emerald-500/10 border border-emerald-500/20 flex items-center justify-center text-emerald-400 mb-5">
                <Sparkles className="w-5 h-5" />
              </div>
              <h3 className="text-lg font-bold text-white mb-2">
                Free Open-Source TextSniper Alternative
              </h3>
              <p className="text-sm text-slate-300 leading-relaxed font-normal">
                Why pay $12 for proprietary OCR tools? Byakugan Scan is 100% free and open-source under the MIT license, delivering equal or faster performance with zero subscription fees, telemetry, or license verification stalls.
              </p>
            </div>
            <div className="mt-6 pt-4 border-t border-white/[0.06] flex items-center gap-2 text-xs font-mono text-slate-400">
              <span className="text-emerald-400">✓</span>
              <span>100% Free & MIT Licensed</span>
            </div>
          </div>

          {/* Use Case 6 */}
          <div className="p-7 rounded-2xl bg-[#0e101c] border border-white/[0.08] hover:border-purple-500/30 transition-all flex flex-col justify-between shadow-lg group">
            <div>
              <div className="w-10 h-10 rounded-xl bg-purple-500/10 border border-purple-500/20 flex items-center justify-center text-purple-400 mb-5">
                <Lock className="w-5 h-5" />
              </div>
              <h3 className="text-lg font-bold text-white mb-2">
                Zero Disk I/O & Complete Privacy
              </h3>
              <p className="text-sm text-slate-300 leading-relaxed font-normal">
                Captures pixels into volatile RAM (<code className="text-purple-300 font-mono text-xs bg-white/[0.06] px-1.5 py-0.5 rounded">NSPasteboard</code>) without writing temporary files to disk, eliminating Spotlight indexing hangs. Zero network entitlements guarantee no data ever leaves your Mac.
              </p>
            </div>
            <div className="mt-6 pt-4 border-t border-white/[0.06] flex items-center gap-2 text-xs font-mono text-slate-400">
              <span className="text-purple-400">✓</span>
              <span>Zero Network Entitlements</span>
            </div>
          </div>
        </div>
      </section>

      {/* ======================================================== */}
      {/* 6. TECHNICAL ARCHITECTURE SPECIFICATIONS & FAQS */}
      {/* ======================================================== */}
      <section id="specs" className="py-24 px-6 max-w-7xl mx-auto hairline-b z-20 relative">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12">
          {/* Left Column: Specs */}
          <div className="lg:col-span-5">
            <span className="text-xs font-mono tracking-wider text-pink-400 font-semibold uppercase block mb-2">
              Hardware Profile
            </span>
            <h2 className="text-3xl sm:text-5xl font-extrabold text-slate-100 tracking-tight leading-tight mb-6">
              System Specs
            </h2>
            <p className="text-slate-300 text-sm leading-relaxed mb-8 font-normal">
              Built natively with Swift 6 and Apple Vision to ensure negligible memory overhead and zero UI stuttering.
            </p>
            <div className="p-6 rounded-2xl bg-[#121422] border border-white/[0.08] font-mono text-xs text-slate-300 space-y-4 shadow-xl">
              <div className="flex justify-between items-center py-1 hairline-b">
                <span className="text-slate-400 font-medium">Supported OS</span>
                <span className="text-slate-100 font-semibold">macOS 14.0+ Sonoma / Sequoia</span>
              </div>
              <div className="flex justify-between items-center py-1 hairline-b">
                <span className="text-slate-400 font-medium">Binary Architecture</span>
                <span className="text-slate-100 font-semibold">Universal 2 (Apple Silicon & Intel)</span>
              </div>
              <div className="flex justify-between items-center py-1 hairline-b">
                <span className="text-slate-400 font-medium">OCR Pipeline</span>
                <span className="text-slate-100 font-semibold">Vision Framework Core ML</span>
              </div>
              <div className="flex justify-between items-center py-1 hairline-b">
                <span className="text-slate-400 font-medium">Resident RAM</span>
                <span className="text-pink-300 font-semibold">&lt; 14 MB (Idle)</span>
              </div>
              <div className="flex justify-between items-center py-1">
                <span className="text-slate-400 font-medium">App Sandbox</span>
                <span className="text-emerald-400 font-semibold">No Network Entitlements</span>
              </div>
            </div>
          </div>

          {/* Right Column: High-Intent FAQ List */}
          <div id="faq" className="lg:col-span-7 space-y-5">
            <h3 className="text-2xl font-bold text-slate-100 tracking-tight mb-2">
              Frequently Asked Questions
            </h3>

            <div className="p-6 rounded-2xl bg-[#121422] border border-white/[0.08] shadow-xl">
              <h4 className="text-base font-bold text-slate-100 mb-2 tracking-tight">
                How do I copy unselectable text from a video or protected PDF on Mac?
              </h4>
              <p className="text-sm text-slate-300 leading-relaxed font-normal">
                Press <code className="text-pink-300 font-mono text-xs bg-white/[0.06] px-1.5 py-0.5 rounded">⌘⇧2</code> to trigger Byakugan Scan’s interactive screen overlay, drag a selection box around the text in your paused video, PDF, or stream, and the text is recognized and copied to your clipboard in under 50ms using Apple’s native Vision Neural Engine.
              </p>
            </div>

            <div className="p-6 rounded-2xl bg-[#121422] border border-white/[0.08] shadow-xl">
              <h4 className="text-base font-bold text-slate-100 mb-2 tracking-tight">
                What is the best free and open-source alternative to TextSniper on macOS?
              </h4>
              <p className="text-sm text-slate-300 leading-relaxed font-normal">
                Byakugan Scan is a 100% free, open-source (MIT) TextSniper alternative. It processes captures in volatile RAM (<code className="text-slate-200 font-mono text-xs">NSPasteboard</code>) without writing temporary files, preventing Spotlight indexing lags. It also includes on-screen QR decoding and 13+ industrial barcode scanning.
              </p>
            </div>

            <div className="p-6 rounded-2xl bg-[#121422] border border-white/[0.08] shadow-xl">
              <h4 className="text-base font-bold text-slate-100 mb-2 tracking-tight">
                How do I scan a QR code displayed on my Mac screen without using my phone?
              </h4>
              <p className="text-sm text-slate-300 leading-relaxed font-normal">
                Press <code className="text-sky-300 font-mono text-xs bg-white/[0.06] px-1.5 py-0.5 rounded">⌘⇧6</code> to activate QR matrix mode and highlight the code on your display. Byakugan Scan decodes the payload and presents one-click buttons to Open URL, Compose Email, Call Phone Number, or Copy the secret.
              </p>
            </div>

            <div className="p-6 rounded-2xl bg-[#121422] border border-white/[0.08] shadow-xl">
              <h4 className="text-base font-bold text-slate-100 mb-2 tracking-tight">
                Can Byakugan Scan read industrial barcodes directly from my computer monitor?
              </h4>
              <p className="text-sm text-slate-300 leading-relaxed font-normal">
                Yes. Press <code className="text-amber-300 font-mono text-xs bg-white/[0.06] px-1.5 py-0.5 rounded">⌘⇧7</code> to scan over 13 commercial barcode symbologies including EAN-13, EAN-8, UPC-E, Code 128, Code 39, Code 93, PDF417, Aztec, Data Matrix, and ITF-14 directly from your display.
              </p>
            </div>

            <div className="p-6 rounded-2xl bg-[#121422] border border-white/[0.08] shadow-xl">
              <h4 className="text-base font-bold text-slate-100 mb-2 tracking-tight">
                Why is Screen Recording permission required, and is my data safe?
              </h4>
              <p className="text-sm text-slate-300 leading-relaxed font-normal">
                macOS mandates explicit authorization for any utility sampling display coordinates. Byakugan Scan only captures the exact rectangular frame defined by your drag selection, extracts content in RAM, and immediately purges the pixels. It excludes network entitlements (<code className="text-emerald-300 font-mono text-xs bg-white/[0.06] px-1.5 py-0.5 rounded">com.apple.security.network.client: false</code>), meaning zero telemetry or network calls.
              </p>
            </div>

            <div className="p-6 rounded-2xl bg-[#121422] border border-white/[0.08] shadow-xl">
              <h4 className="text-base font-bold text-slate-100 mb-2 tracking-tight">
                How do I install Byakugan Scan via Homebrew?
              </h4>
              <p className="text-sm text-slate-300 leading-relaxed font-normal">
                Run <code className="text-pink-300 font-mono text-xs bg-white/[0.06] px-1.5 py-0.5 rounded">brew install --cask halcyon-past/tap/byakugan-scan</code> in Terminal. You can update it anytime using <code className="text-slate-200 font-mono text-xs">brew upgrade</code>.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* ======================================================== */}
      {/* 7. CREATOR SPOTLIGHT: ARITRO SAHA (@HALCYON-PAST) */}
      {/* ======================================================== */}
      <section className="py-20 px-6 max-w-7xl mx-auto hairline-b z-20 relative">
        <div className="p-8 sm:p-10 rounded-2xl bg-gradient-to-br from-[#121324] via-[#0d0e1a] to-[#0a0b14] border border-white/10 shadow-2xl relative overflow-hidden">
          <div className="absolute top-0 right-0 w-96 h-96 bg-pink-500/5 rounded-full blur-3xl pointer-events-none" />

          <div className="flex flex-col lg:flex-row items-start lg:items-center justify-between gap-8 relative z-10">
            <div className="max-w-2xl">
              <div className="flex items-center gap-2 mb-3">
                <span className="px-2.5 py-0.5 rounded-full bg-pink-500/10 border border-pink-500/20 text-xs font-mono font-medium text-pink-300">
                  CREATOR // AUTHOR SPOTLIGHT
                </span>
                <span className="text-xs font-mono text-slate-500">Wikidata: Q141715213</span>
              </div>

              <h3 className="text-2xl sm:text-3xl font-extrabold text-white tracking-tight mb-3">
                Crafted by Aritro Saha (@halcyon-past)
              </h3>

              <p className="text-slate-300 text-sm sm:text-base leading-relaxed mb-6 font-normal">
                Byakugan Scan is engineered by{" "}
                <strong className="text-white">Aritro Saha</strong> (also known as <em className="text-pink-300 not-italic font-semibold">Megh</em> and <code className="text-pink-300 font-mono text-xs bg-white/[0.06] px-1.5 py-0.5 rounded">@halcyon-past</code>), Software Engineer 1 at Bristol Myers Squibb (BMS) and alumnus of Vellore Institute of Technology, Chennai. Built with a passion for ultra-fast, zero-telemetry native tools that put user privacy first.
              </p>

              <div className="flex flex-wrap items-center gap-4 text-xs font-medium">
                <a
                  href="https://www.aritro.cloud/"
                  target="_blank"
                  rel="author me noopener noreferrer"
                  className="px-4 py-2 rounded-lg bg-white/[0.06] hover:bg-white/[0.12] border border-white/10 text-white transition-all inline-flex items-center gap-1.5"
                >
                  <span>Official Website: aritro.cloud</span>
                  <ArrowUpRight className="w-3.5 h-3.5 text-pink-400" />
                </a>

                <a
                  href="https://github.com/halcyon-past"
                  target="_blank"
                  rel="me noopener noreferrer"
                  className="px-4 py-2 rounded-lg bg-white/[0.06] hover:bg-white/[0.12] border border-white/10 text-white transition-all inline-flex items-center gap-1.5"
                >
                  <Terminal className="w-3.5 h-3.5 text-pink-400" />
                  <span>GitHub: @halcyon-past</span>
                  <ArrowUpRight className="w-3.5 h-3.5 text-slate-400" />
                </a>

                <a
                  href="https://www.wikidata.org/wiki/Q141715213"
                  target="_blank"
                  rel="me noopener noreferrer"
                  className="px-4 py-2 rounded-lg bg-white/[0.06] hover:bg-white/[0.12] border border-white/10 text-slate-300 hover:text-white transition-all inline-flex items-center gap-1.5 font-mono"
                >
                  <span>Wikidata Q141715213</span>
                  <ExternalLink className="w-3 h-3 text-slate-400" />
                </a>
              </div>
            </div>

            <div className="w-full lg:w-auto p-5 rounded-xl bg-black/40 border border-white/10 font-mono text-xs text-slate-400 space-y-2">
              <div className="text-white font-semibold mb-1">Other Open-Source Tools:</div>
              <div>• <a href="https://siliconsync.aritro.cloud/" target="_blank" rel="noopener noreferrer" className="text-pink-300 hover:underline">SiliconSync</a> — Apple Silicon sync</div>
              <div>• <a href="https://quarantine-py.aritro.cloud/" target="_blank" rel="noopener noreferrer" className="text-sky-300 hover:underline">quarantine-py</a> — macOS security tool</div>
              <div>• <a href="https://openworld.aritro.cloud/" target="_blank" rel="noopener noreferrer" className="text-amber-300 hover:underline">OpenWorld</a> — Open game engine</div>
              <div>• <a href="https://structurify.aritro.cloud/" target="_blank" rel="noopener noreferrer" className="text-emerald-300 hover:underline">Structurify</a> — Architecture modeling</div>
            </div>
          </div>
        </div>
      </section>

      {/* ======================================================== */}
      {/* 8. FINALE CALL TO ACTION */}
      {/* ======================================================== */}
      <section className="py-28 px-6 max-w-5xl mx-auto text-center z-20 relative">
        <span className="text-xs font-mono tracking-wider text-pink-400 font-semibold uppercase block mb-3">
          Open Source Mac Utility // MIT License
        </span>
        <h2 className="text-4xl sm:text-6xl font-extrabold text-slate-100 tracking-tight leading-tight mb-6">
          Activate your vision.
        </h2>
        <p className="text-slate-300 text-base sm:text-lg max-w-lg mx-auto mb-10 leading-relaxed font-normal">
          Experience frictionless screen capture on your Mac. Free to download, transparent, and completely offline. Created by Aritro Saha (@halcyon-past).
        </p>

        <div className="flex flex-wrap items-center justify-center gap-4">
          <a
            href={APP_DOWNLOAD_URL}
            className="px-8 py-4 bg-gradient-to-r from-fuchsia-600 via-pink-600 to-rose-600 hover:from-fuchsia-500 hover:to-rose-500 text-white text-sm font-semibold rounded-lg transition-all flex items-center gap-2 shadow-xl shadow-pink-600/25 hover:scale-[1.02] active:scale-[0.98]"
          >
            <span>Download Byakugan Scan</span>
            <ArrowUpRight className="w-4 h-4" />
          </a>
        </div>
      </section>

      {/* ======================================================== */}
      {/* 9. PRE-RENDERED ACCESSIBLE FALLBACK FOR NON-JS CRAWLERS */}
      {/* ======================================================== */}
      <noscript>
        <div className="p-8 bg-black text-white border-t border-white/20">
          <h2>About Byakugan Scan — Free Mac Screen OCR, QR Code & Barcode Utility</h2>
          <p>
            Byakugan Scan is an open-source (MIT) macOS menu bar application developed by Aritro Saha (@halcyon-past). It enables instant on-device screen text OCR, on-screen QR code scanning, and 13+ industrial barcode recognition in volatile RAM with zero disk I/O and zero telemetry.
          </p>
          <h3>Installation:</h3>
          <ul>
            <li>Homebrew: <code>brew install --cask halcyon-past/tap/byakugan-scan</code></li>
            <li>Direct DMG: <a href="https://github.com/halcyon-past/byakugan-scan/releases/latest/download/ByakuganScan.dmg">Download ByakuganScan.dmg</a></li>
          </ul>
          <h3>Default Shortcuts:</h3>
          <ul>
            <li>⌘⇧2: Screen Text OCR</li>
            <li>⌘⇧6: Scan On-Screen QR Code</li>
            <li>⌘⇧7: Scan Industrial Barcode</li>
          </ul>
          <p>
            Documentation: <a href="/support">Support & FAQ</a> | <a href="/privacy">Privacy Policy</a> | <a href="/terms">Terms</a> | <a href="/llms.txt">llms.txt</a> | <a href="/index.md">index.md</a>
          </p>
        </div>
      </noscript>
    </div>
  );
}
