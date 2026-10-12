"use client";

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
} from "lucide-react";
import MangaScrollSection from "@/components/MangaScrollSection";

export default function AnimeMasterpieceHome() {
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

            {/* Action Buttons */}
            <div className="flex flex-wrap items-center gap-4">
              <a
                href="https://github.com/halcyon-past/byakugan-scan"
                target="_blank"
                rel="noopener noreferrer"
                className="px-7 py-3.5 bg-gradient-to-r from-fuchsia-600 to-pink-600 hover:from-fuchsia-500 hover:to-pink-500 text-white text-sm font-semibold rounded-lg transition-all flex items-center gap-2 shadow-lg shadow-pink-600/20 hover:scale-[1.02] active:scale-[0.98]"
              >
                <span>Download Free (macOS)</span>
                <ArrowUpRight className="w-4 h-4" />
              </a>

              <a
                href="#capabilities"
                className="px-6 py-3.5 bg-white/[0.04] border border-white/10 hover:border-pink-500/30 hover:bg-white/[0.07] text-slate-200 hover:text-white text-sm font-medium rounded-lg transition-all flex items-center gap-2"
              >
                <span>Explore Capabilities</span>
              </a>
            </div>
          </div>

          {/* Right Column: Visual Stage for 3D Follower Eye */}
          <div className="lg:col-span-5 hidden lg:flex items-center justify-center relative min-h-[420px] pointer-events-none">
            {/* Ambient soft glow behind the 3D eye */}
            <div className="w-[320px] h-[320px] rounded-full bg-gradient-to-tr from-fuchsia-600/20 via-pink-600/10 to-transparent blur-3xl" />
          </div>
        </div>

        {/* Hero Bottom Bar */}
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 pt-6 hairline-t text-xs text-slate-400">
          <div className="flex flex-wrap items-center gap-3">
            <span className="text-slate-400 font-medium">Quick Shortcuts:</span>
            <span className="bg-white/[0.04] border border-white/10 px-2.5 py-1 rounded text-slate-200 font-mono text-xs">⌘⇧2 Text</span>
            <span className="bg-white/[0.04] border border-white/10 px-2.5 py-1 rounded text-slate-200 font-mono text-xs">⌘⇧3 QR</span>
            <span className="bg-white/[0.04] border border-white/10 px-2.5 py-1 rounded text-slate-200 font-mono text-xs">⌘⇧4 Barcode</span>
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
            href="https://github.com/halcyon-past/byakugan-scan"
            target="_blank"
            rel="noopener noreferrer"
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
