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
      {/* Ambient Manga Grid Overlay */}
      <div className="absolute inset-0 manga-grid pointer-events-none opacity-40 z-0" />

      {/* ======================================================== */}
      {/* 1. HERO SECTION: ANIME CINEMATIC IMPACT */}
      {/* ======================================================== */}
      <section className="relative min-h-[92vh] flex flex-col justify-between pt-10 sm:pt-16 pb-16 px-6 max-w-7xl mx-auto hairline-b z-20">
        {/* Top Monospace Status Telemetry */}
        <div className="flex flex-wrap items-center justify-between gap-4 text-xs font-mono text-slate-300 uppercase tracking-widest hairline-b pb-4">
          <div className="flex items-center gap-2">
            <span className="w-2 h-2 rounded-full bg-pink-500 animate-pulse" />
            <span className="text-white font-bold">JUTSU PROTOCOL</span>
            <span className="text-pink-500/30">|</span>
            <span className="text-slate-200">APPLE SILICON NEURAL CORE</span>
          </div>
          <div className="flex items-center gap-2">
            <span className="text-slate-300">VISION ENGINE:</span>
            <span className="text-pink-300 font-bold">100% ON-DEVICE / OFFLINE</span>
          </div>
        </div>

        {/* Hero Central Focus */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 items-center my-auto py-10">
          {/* Left Column: Bold Manga Callout Typography */}
          <div className="lg:col-span-7 flex flex-col justify-center">
            {/* Japanese Kanji Eyebrow */}
            <div className="flex items-center gap-3 mb-4">
              <span className="text-sm font-kanji font-bold text-pink-400 tracking-widest uppercase">
                白眼の目覚め // ALL-SEEING VISION SYSTEM
              </span>
              <div className="h-[1px] w-16 bg-gradient-to-r from-pink-500 to-transparent" />
            </div>

            {/* Giant Monumental Headline */}
            <h1 className="font-manga text-5xl sm:text-7xl xl:text-8xl font-black uppercase text-white tracking-wide leading-[0.92] mb-6">
              SEES THROUGH <br />
              <span className="bg-gradient-to-r from-pink-400 via-fuchsia-300 to-rose-400 bg-clip-text text-transparent drop-shadow-sm">
                EVERY OBSTACLE.
              </span>
            </h1>

            {/* Lead Narrative */}
            <p className="text-slate-200 text-base sm:text-lg max-w-xl font-normal leading-relaxed mb-8">
              A bespoke macOS menu bar utility built for developers, designers, and researchers. Snatch unselectable text from video streams, protected portals, and images in 11 milliseconds. Decode QR codes and commercial barcodes with zero latency and complete privacy.
            </p>

            {/* Action Buttons */}
            <div className="flex flex-wrap items-center gap-4">
              <a
                href="https://github.com/halcyon-past/byakugan-scan"
                target="_blank"
                rel="noopener noreferrer"
                className="px-8 py-4 bg-gradient-to-r from-fuchsia-600 to-pink-600 hover:from-fuchsia-500 hover:to-pink-500 text-white text-xs font-bold font-mono uppercase tracking-wider rounded transition-all flex items-center gap-2 shadow-2xl shadow-pink-600/30 hover:scale-105 active:scale-95"
              >
                <span>Download Free (macOS)</span>
                <ArrowUpRight className="w-4 h-4" />
              </a>

              <a
                href="#capabilities"
                className="px-6 py-4 bg-pink-950/20 border border-pink-500/30 hover:border-pink-400 text-pink-200 hover:text-white text-xs font-bold font-mono uppercase tracking-wider rounded transition-all flex items-center gap-2"
              >
                <span>Explore Capabilities</span>
              </a>
            </div>
          </div>

          {/* Right Column: Visual Stage for 3D Follower Eye */}
          <div className="lg:col-span-5 hidden lg:flex items-center justify-center relative min-h-[420px] pointer-events-none">
            {/* Ambient magenta/plum atmospheric glow behind the 3D eye */}
            <div className="w-[340px] h-[340px] rounded-full bg-gradient-to-tr from-fuchsia-600/25 via-pink-600/15 to-rose-600/10 blur-3xl" />
          </div>
        </div>

        {/* Hero Bottom Bar */}
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 pt-6 hairline-t text-xs font-mono text-slate-300">
          <div className="flex flex-wrap items-center gap-3">
            <span className="text-slate-400 font-medium">QUICK SHORTCUTS:</span>
            <span className="bg-pink-950/40 border border-pink-500/30 px-2.5 py-1 rounded text-pink-200 font-semibold font-mono">⌘⇧2 Text</span>
            <span className="bg-fuchsia-950/40 border border-fuchsia-500/30 px-2.5 py-1 rounded text-fuchsia-200 font-semibold font-mono">⌘⇧3 QR</span>
            <span className="bg-amber-950/40 border border-amber-500/30 px-2.5 py-1 rounded text-amber-200 font-semibold font-mono">⌘⇧4 Barcode</span>
          </div>

          <div className="flex items-center gap-2 text-slate-300 font-medium">
            <span>SCROLL TO EXPLORE</span>
            <ArrowDown className="w-3.5 h-3.5 animate-bounce text-pink-400" />
          </div>
        </div>
      </section>

      {/* ======================================================== */}
      {/* 2. INFINITE JUTSU TICKER (Anime Speed Marquee) */}
      {/* ======================================================== */}
      <div className="w-full bg-[#0a030f] hairline-b py-3.5 overflow-hidden select-none z-20 relative">
        <div className="animate-ticker flex items-center gap-8 text-xs font-mono tracking-[0.25em] uppercase text-slate-300 font-medium">
          <span>// ALL-SEEING VISION SYSTEM</span>
          <span className="text-pink-500">◆</span>
          <span>APPLE NEURAL ENGINE CONCURRENCY</span>
          <span className="text-cyan-400">◆</span>
          <span>ZERO CLOUD TELEMETRY</span>
          <span className="text-amber-400">◆</span>
          <span>13+ INDUSTRIAL BARCODES</span>
          <span className="text-fuchsia-400">◆</span>
          <span>SUB-SECOND REGION OCR</span>
          <span className="text-pink-400">◆</span>
          <span>INVISIBLE MENUBAR UTILITY</span>
          <span className="text-cyan-400">◆</span>
          <span>// ALL-SEEING VISION SYSTEM</span>
          <span className="text-pink-500">◆</span>
          <span>APPLE NEURAL ENGINE CONCURRENCY</span>
          <span className="text-cyan-400">◆</span>
          <span>ZERO CLOUD TELEMETRY</span>
          <span className="text-amber-400">◆</span>
          <span>13+ INDUSTRIAL BARCODES</span>
          <span className="text-fuchsia-400">◆</span>
          <span>SUB-SECOND REGION OCR</span>
          <span className="text-pink-400">◆</span>
          <span>INVISIBLE MENUBAR UTILITY</span>
          <span className="text-cyan-400">◆</span>
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
            <span className="text-xs font-mono tracking-widest text-pink-400 font-semibold uppercase block mb-2">
              CORE CAPABILITIES
            </span>
            <h2 className="font-manga text-3xl sm:text-5xl font-black uppercase text-white leading-none">
              TACTICAL MODULES
            </h2>
          </div>

          <p className="text-slate-300 text-sm max-w-md font-mono">
            Replace sluggish screenshot workflows with single-keystroke neural intelligence.
          </p>
        </div>

        {/* 3 Large Showcase Editorial Cards */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Card 1: OCR */}
          <div className="anime-glass rounded-2xl p-8 flex flex-col justify-between anime-card-hover group">
            <div>
              <div className="flex items-center justify-between text-xs font-mono text-slate-300 mb-6 hairline-b pb-4">
                <span className="font-semibold text-slate-300">MODULE // OCR</span>
                <span className="text-pink-400 font-bold">VNRecognizeTextRequest</span>
              </div>
              <h3 className="font-manga text-2xl font-bold uppercase text-white mb-3">
                Sub-Second Text Extraction
              </h3>
              <p className="text-sm text-slate-200 leading-relaxed mb-6 font-normal">
                High-precision multi-script OCR covering Latin, Chinese (Simplified & Traditional), Japanese, Korean, Cyrillic, and Arabic. Smart paragraph synthesis with automatic line-break joining.
              </p>
            </div>

            <div className="pt-6 hairline-t flex items-center justify-between text-xs font-mono">
              <span className="text-slate-400 font-medium">DEFAULT KEYBIND</span>
              <span className="text-pink-200 font-bold bg-pink-950/50 border border-pink-500/40 px-2.5 py-1 rounded">⌘ + ⇧ + 2</span>
            </div>
          </div>

          {/* Card 2: QR */}
          <div className="anime-glass rounded-2xl p-8 flex flex-col justify-between anime-card-hover group">
            <div>
              <div className="flex items-center justify-between text-xs font-mono text-slate-300 mb-6 hairline-b pb-4">
                <span className="font-semibold text-slate-300">MODULE // QR MATRIX</span>
                <span className="text-cyan-400 font-bold">VNBarcodeSymbology.qr</span>
              </div>
              <h3 className="font-manga text-2xl font-bold uppercase text-white mb-3">
                Display QR Matrix Decoder
              </h3>
              <p className="text-sm text-slate-200 leading-relaxed mb-6 font-normal">
                Never grab your phone to scan a monitor code. Snaps QR codes shown in Zoom, Slack, or web pages straight into URLs, 2FA secret seeds, and Wi-Fi credentials.
              </p>
            </div>

            <div className="pt-6 hairline-t flex items-center justify-between text-xs font-mono">
              <span className="text-slate-400 font-medium">DEFAULT KEYBIND</span>
              <span className="text-cyan-200 font-bold bg-cyan-950/50 border border-cyan-500/40 px-2.5 py-1 rounded">⌘ + ⇧ + 3</span>
            </div>
          </div>

          {/* Card 3: Barcode */}
          <div className="anime-glass rounded-2xl p-8 flex flex-col justify-between anime-card-hover group">
            <div>
              <div className="flex items-center justify-between text-xs font-mono text-slate-300 mb-6 hairline-b pb-4">
                <span className="font-semibold text-slate-300">MODULE // BARCODE</span>
                <span className="text-amber-400 font-bold">13 SYMBOLOGIES</span>
              </div>
              <h3 className="font-manga text-2xl font-bold uppercase text-white mb-3">
                Industrial Barcodes
              </h3>
              <p className="text-sm text-slate-200 leading-relaxed mb-6 font-normal">
                Decodes EAN-13, UPC-E, Code 128, Code 39, Data Matrix, Aztec, and PDF417 format standards for logistics, retail, and hardware engineering.
              </p>
            </div>

            <div className="pt-6 hairline-t flex items-center justify-between text-xs font-mono">
              <span className="text-slate-400 font-medium">DEFAULT KEYBIND</span>
              <span className="text-amber-200 font-bold bg-amber-950/50 border border-amber-500/40 px-2.5 py-1 rounded">⌘ + ⇧ + 4</span>
            </div>
          </div>
        </div>
      </section>

      {/* ======================================================== */}
      {/* 5. TECHNICAL ARCHITECTURE SPECIFICATIONS */}
      {/* ======================================================== */}
      <section id="specs" className="py-24 px-6 max-w-7xl mx-auto hairline-b z-20 relative">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12">
          <div className="lg:col-span-4">
            <span className="text-xs font-mono tracking-widest text-pink-400 font-semibold uppercase block mb-2">
              HARDWARE PROFILE
            </span>
            <h2 className="font-manga text-3xl sm:text-5xl font-black uppercase text-white leading-none mb-6">
              SYSTEM SPECS
            </h2>
            <p className="text-slate-200 text-sm leading-relaxed mb-6 font-normal">
              Built natively with Swift 6 and Apple Vision to ensure negligible memory overhead and zero UI stuttering.
            </p>
            <div className="p-6 rounded-2xl bg-[#130719] border border-pink-500/20 font-mono text-xs text-slate-200 space-y-3.5 shadow-xl">
              <div className="flex justify-between items-center">
                <span className="text-slate-300 font-medium">SUPPORTED OS</span>
                <span className="text-white font-bold">macOS 14.0+</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-slate-300 font-medium">BINARY ARCH</span>
                <span className="text-white font-bold">Universal 2 (Apple Silicon & Intel)</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-slate-300 font-medium">OCR PIPELINE</span>
                <span className="text-white font-bold">Vision Framework Core ML</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-slate-300 font-medium">RAM USAGE</span>
                <span className="text-pink-300 font-bold">&lt; 14 MB Resident</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-slate-300 font-medium">SANDBOX</span>
                <span className="text-emerald-300 font-bold">No Network Entitlements</span>
              </div>
            </div>
          </div>

          <div className="lg:col-span-8 space-y-6">
            <div className="p-6 rounded-2xl bg-[#130719] border border-pink-500/20 shadow-xl">
              <h4 className="text-base font-bold text-white mb-2 font-manga tracking-wide">
                Why is Screen Recording permission required?
              </h4>
              <p className="text-sm text-slate-200 leading-relaxed font-normal">
                macOS mandates explicit authorization for utilities that sample display coordinates. Byakugan Scan only captures the exact rectangular frame defined by your interactive drag selection, processes pixels in RAM with Vision, and immediately purges them. No background screenshots or logs are ever created.
              </p>
            </div>

            <div className="p-6 rounded-2xl bg-[#130719] border border-pink-500/20 shadow-xl">
              <h4 className="text-base font-bold text-white mb-2 font-manga tracking-wide">
                Does Byakugan Scan transmit telemetry to external servers?
              </h4>
              <p className="text-sm text-slate-200 leading-relaxed font-normal">
                None. The app sandbox completely excludes network client entitlements (<code className="text-pink-200 font-mono bg-pink-950/60 px-1.5 py-0.5 rounded border border-pink-500/40">com.apple.security.network.client: false</code>). It cannot make outbound network connections. Your screen content is 100% private and offline.
              </p>
            </div>

            <div className="p-6 rounded-2xl bg-[#130719] border border-pink-500/20 shadow-xl">
              <h4 className="text-base font-bold text-white mb-2 font-manga tracking-wide">
                Can I customize the keyboard shortcuts?
              </h4>
              <p className="text-sm text-slate-200 leading-relaxed font-normal">
                Yes. Open Settings from the menu bar popover to remap any capture action to your preferred hotkeys.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* ======================================================== */}
      {/* 6. FINALE CALL TO ACTION */}
      {/* ======================================================== */}
      <section className="py-28 px-6 max-w-5xl mx-auto text-center z-20 relative">
        <span className="text-xs font-mono tracking-widest text-pink-400 font-semibold uppercase block mb-3">
          OPEN SOURCE MAC UTILITY // MIT LICENSE
        </span>
        <h2 className="font-manga text-5xl sm:text-7xl font-black uppercase text-white tracking-wider leading-none mb-6">
          ACTIVATE YOUR VISION.
        </h2>
        <p className="text-slate-200 text-base max-w-lg mx-auto mb-10 leading-relaxed font-normal">
          Experience frictionless screen capture on your Mac. Free to download, transparent, and completely offline.
        </p>

        <div className="flex flex-wrap items-center justify-center gap-4">
          <a
            href="https://github.com/halcyon-past/byakugan-scan"
            target="_blank"
            rel="noopener noreferrer"
            className="px-8 py-4 bg-gradient-to-r from-fuchsia-600 via-pink-600 to-rose-600 hover:from-fuchsia-500 hover:to-rose-500 text-white text-xs font-bold font-mono uppercase tracking-wider rounded transition-all flex items-center gap-2 shadow-2xl shadow-pink-600/30 hover:scale-105 active:scale-95"
          >
            <span>Download Byakugan Scan</span>
            <ArrowUpRight className="w-4 h-4" />
          </a>
        </div>
      </section>
    </div>
  );
}
