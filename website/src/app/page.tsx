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
                白眼の目覚め // All-Seeing Vision Utility
              </span>
            </div>

            {/* Monumental, Readable Headline */}
            <h1 className="text-4xl sm:text-6xl xl:text-7xl font-extrabold text-slate-100 tracking-tight leading-[1.08] mb-6">
              Sees through{" "}
              <span className="bg-gradient-to-r from-pink-400 via-fuchsia-300 to-rose-400 bg-clip-text text-transparent">
                every obstacle
              </span>{" "}
              on your screen.
            </h1>

            {/* Lead Narrative with Soothing Contrast */}
            <p className="text-slate-300 text-base sm:text-lg max-w-xl font-normal leading-relaxed mb-8">
              A bespoke macOS menu bar utility built for developers, designers, and researchers. Snatch unselectable text from video streams, protected portals, and images in 11 milliseconds. Decode QR codes and commercial barcodes with zero latency and complete privacy.
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
                      v1.0.10
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
                          <span>ByakuganScan-v1.0.10.dmg</span>
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
                        <span className="text-slate-300 select-all">a3cf7227...70451</span>
                        <button
                          type="button"
                          onClick={() => {
                            navigator.clipboard.writeText("a3cf722795cce9bcaac72acfbad5fdb0ce8a500f62d982b4538378c342570451");
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
                href="#capabilities"
                className="px-5 py-2.5 bg-white/[0.04] border border-white/10 hover:border-pink-500/30 hover:bg-white/[0.07] text-slate-300 hover:text-white text-xs font-medium rounded-lg transition-all flex items-center gap-2"
              >
                <span>Explore Technical Capabilities</span>
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
            <span className="bg-white/[0.04] border border-white/10 px-2.5 py-1 rounded text-slate-200 font-mono text-xs">⌘⇧2 Text</span>
            <span className="bg-white/[0.04] border border-white/10 px-2.5 py-1 rounded text-slate-200 font-mono text-xs">⌘⇧6 QR</span>
            <span className="bg-white/[0.04] border border-white/10 px-2.5 py-1 rounded text-slate-200 font-mono text-xs">⌘⇧7 Barcode</span>
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
              <span className="text-slate-200 font-semibold bg-white/[0.06] border border-white/10 px-2.5 py-1 rounded">⌘ + ⇧ + 3</span>
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
              <span className="text-slate-200 font-semibold bg-white/[0.06] border border-white/10 px-2.5 py-1 rounded">⌘ + ⇧ + 4</span>
            </div>
          </div>
        </div>
      </section>

      {/* ======================================================== */}
      {/* 5. TECHNICAL ARCHITECTURE SPECIFICATIONS */}
      {/* ======================================================== */}
      <section id="specs" className="py-24 px-6 max-w-7xl mx-auto hairline-b z-20 relative">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12">
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

          <div className="lg:col-span-7 space-y-6">
            <div className="p-7 rounded-2xl bg-[#121422] border border-white/[0.08] shadow-xl">
              <h4 className="text-base font-bold text-slate-100 mb-2 tracking-tight">
                Why is Screen Recording permission required?
              </h4>
              <p className="text-sm text-slate-300 leading-relaxed font-normal">
                macOS mandates explicit user authorization for any utility sampling display coordinates. Byakugan Scan only captures the exact rectangular frame defined by your interactive drag selection, extracts content in RAM, and immediately purges the pixels. No background recordings, screenshots, or logs are ever stored.
              </p>
            </div>

            <div className="p-7 rounded-2xl bg-[#121422] border border-white/[0.08] shadow-xl">
              <h4 className="text-base font-bold text-slate-100 mb-2 tracking-tight">
                Does Byakugan Scan transmit telemetry to external servers?
              </h4>
              <p className="text-sm text-slate-300 leading-relaxed font-normal">
                Zero telemetry. The application sandbox completely excludes network client entitlements (<code className="text-pink-300 font-mono bg-white/[0.06] px-1.5 py-0.5 rounded border border-white/10 text-xs">com.apple.security.network.client: false</code>). It cannot make outbound network connections. Your screen content remains 100% private and on-device.
              </p>
            </div>

            <div className="p-7 rounded-2xl bg-[#121422] border border-white/[0.08] shadow-xl">
              <h4 className="text-base font-bold text-slate-100 mb-2 tracking-tight">
                Can I customize the keyboard shortcuts?
              </h4>
              <p className="text-sm text-slate-300 leading-relaxed font-normal">
                Yes. Click Settings in the menu bar popover or press <code className="text-slate-200 font-mono bg-white/[0.06] px-1.5 py-0.5 rounded text-xs">⌘,</code> to remap any capture action to your preferred hotkeys.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* ======================================================== */}
      {/* 6. FINALE CALL TO ACTION */}
      {/* ======================================================== */}
      <section className="py-28 px-6 max-w-5xl mx-auto text-center z-20 relative">
        <span className="text-xs font-mono tracking-wider text-pink-400 font-semibold uppercase block mb-3">
          Open Source Mac Utility // MIT License
        </span>
        <h2 className="text-4xl sm:text-6xl font-extrabold text-slate-100 tracking-tight leading-tight mb-6">
          Activate your vision.
        </h2>
        <p className="text-slate-300 text-base sm:text-lg max-w-lg mx-auto mb-10 leading-relaxed font-normal">
          Experience frictionless screen capture on your Mac. Free to download, transparent, and completely offline.
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
    </div>
  );
}
