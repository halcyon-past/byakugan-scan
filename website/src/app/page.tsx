"use client";

import { motion } from "framer-motion";
import {
  ArrowDown,
  ArrowUpRight,
  Scan,
  Shield,
  Zap,
  Cpu,
  Layers,
  Eye,
  CheckCircle2,
  Terminal,
  Sparkles,
  Command,
} from "lucide-react";
import InteractiveScanDemo from "@/components/InteractiveScanDemo";
import MangaScrollSection from "@/components/MangaScrollSection";

export default function AnimeMasterpieceHome() {
  return (
    <div className="relative w-full overflow-hidden">
      {/* Ambient Manga Grid & Chakra Dust Overlays */}
      <div className="absolute inset-0 manga-grid pointer-events-none opacity-40 z-0" />

      {/* ======================================================== */}
      {/* 1. HERO SECTION: ANIME CINEMATIC IMPACT */}
      {/* ======================================================== */}
      <section className="relative min-h-[95vh] flex flex-col justify-between pt-12 sm:pt-20 pb-16 px-6 max-w-7xl mx-auto hairline-b z-20">
        {/* Top Monospace Status Telemetry */}
        <div className="flex flex-wrap items-center justify-between gap-4 text-xs font-mono text-slate-500 uppercase tracking-widest hairline-b pb-4">
          <div className="flex items-center gap-2">
            <span className="w-2 h-2 rounded-full bg-indigo-500 animate-pulse" />
            <span className="text-white font-semibold">[01] // JUTSU INITIALIZATION</span>
            <span className="text-slate-700">|</span>
            <span>APPLE SILICON NEURAL ENGINE</span>
          </div>
          <div className="flex items-center gap-2">
            <span>CHAKRA FREQUENCY:</span>
            <span className="text-teal-400 font-semibold">100% PURIFIED / OFFLINE</span>
          </div>
        </div>

        {/* Hero Central Focus */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 items-center my-auto py-12">
          {/* Left Column: Bold Manga Callout Typography */}
          <div className="lg:col-span-7 flex flex-col justify-center">
            {/* Japanese Kanji Eyebrow */}
            <div className="flex items-center gap-3 mb-4">
              <span className="text-sm font-kanji font-bold text-indigo-400 tracking-widest uppercase">
                白眼の目覚め // ALL-SEEING VISION SYSTEM
              </span>
              <div className="h-[1px] w-16 bg-gradient-to-r from-indigo-500 to-transparent" />
            </div>

            {/* Giant Monumental Headline */}
            <h1 className="font-manga text-5xl sm:text-7xl xl:text-8xl font-black uppercase text-white tracking-wide leading-[0.92] mb-6">
              SEES THROUGH <br />
              <span className="bg-gradient-to-r from-indigo-300 via-teal-200 to-purple-300 bg-clip-text text-transparent">
                EVERY OBSTACLE.
              </span>
            </h1>

            {/* Lead Narrative */}
            <p className="text-slate-300 text-base sm:text-lg max-w-xl font-light leading-relaxed mb-8">
              A bespoke macOS menu bar utility built for developers, designers, and researchers. Snatch unselectable text from video streams, protected portals, and images in 11 milliseconds. Decode QR codes and commercial barcodes with zero latency and complete privacy.
            </p>

            {/* Action Buttons */}
            <div className="flex flex-wrap items-center gap-4">
              <a
                href="https://github.com/halcyon-past/byakugan-scan"
                target="_blank"
                rel="noopener noreferrer"
                className="px-8 py-4 bg-white text-black text-xs font-bold font-mono uppercase tracking-wider rounded hover:bg-slate-200 transition-all flex items-center gap-2 shadow-2xl hover:scale-105 active:scale-95"
              >
                <span>Get For Mac (Free)</span>
                <ArrowUpRight className="w-4 h-4" />
              </a>

              <a
                href="#interactive-hud"
                className="px-6 py-4 bg-transparent border border-white/20 text-white text-xs font-bold font-mono uppercase tracking-wider rounded hover:bg-white/10 transition-all flex items-center gap-2"
              >
                <span>Live Neural HUD</span>
                <Scan className="w-3.5 h-3.5 text-teal-400" />
              </a>
            </div>
          </div>

          {/* Right Column: Visual Stage for 3D Follower Eye */}
          <div className="lg:col-span-5 hidden lg:flex items-center justify-center relative min-h-[380px]">
            {/* Ambient HUD target frame that frames the 3D canvas floating above it */}
            <div className="w-[360px] h-[360px] rounded-3xl border border-dashed border-indigo-500/30 p-4 flex flex-col justify-between relative pointer-events-none">
              <div className="flex justify-between text-[10px] font-mono text-indigo-400">
                <span>[360° RETICLE]</span>
                <span>[M1-M4 ACCELERATED]</span>
              </div>
              <div className="text-center font-mono text-[10px] text-slate-500 tracking-widest uppercase">
                SCROLL TO TRACK THE EYE
              </div>
              <div className="flex justify-between text-[10px] font-mono text-teal-400">
                <span>[NEO-BYAKUGAN]</span>
                <span>[100% OFFLINE]</span>
              </div>
            </div>
          </div>
        </div>

        {/* Hero Bottom Bar */}
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 pt-6 hairline-t text-xs font-mono text-slate-400">
          <div className="flex items-center gap-6">
            <span>[⌘⇧2 TEXT OCR]</span>
            <span>[⌘⇧3 QR SCAN]</span>
            <span>[⌘⇧4 BARCODE]</span>
          </div>

          <div className="flex items-center gap-2 text-slate-500">
            <span>SCROLL DOWN FOR SPECIFICATIONS</span>
            <ArrowDown className="w-3.5 h-3.5 animate-bounce text-slate-400" />
          </div>
        </div>
      </section>

      {/* ======================================================== */}
      {/* 2. INFINITE JUTSU TICKER (Anime Speed Marquee) */}
      {/* ======================================================== */}
      <div className="w-full bg-[#030408] hairline-b py-3.5 overflow-hidden select-none z-20 relative">
        <div className="animate-ticker flex items-center gap-8 text-xs font-mono tracking-[0.25em] uppercase text-slate-400">
          <span>// ALL-SEEING VISION SYSTEM</span>
          <span className="text-indigo-400">◆</span>
          <span>APPLE NEURAL ENGINE CONCURRENCY</span>
          <span className="text-teal-400">◆</span>
          <span>ZERO CLOUD TELEMETRY</span>
          <span className="text-indigo-400">◆</span>
          <span>13+ INDUSTRIAL BARCODES</span>
          <span className="text-teal-400">◆</span>
          <span>SUB-SECOND REGION OCR</span>
          <span className="text-indigo-400">◆</span>
          <span>INVISIBLE MENUBAR UTILITY</span>
          <span className="text-teal-400">◆</span>
          <span>// ALL-SEEING VISION SYSTEM</span>
          <span className="text-indigo-400">◆</span>
          <span>APPLE NEURAL ENGINE CONCURRENCY</span>
          <span className="text-teal-400">◆</span>
          <span>ZERO CLOUD TELEMETRY</span>
          <span className="text-indigo-400">◆</span>
          <span>13+ INDUSTRIAL BARCODES</span>
          <span className="text-teal-400">◆</span>
          <span>SUB-SECOND REGION OCR</span>
          <span className="text-indigo-400">◆</span>
          <span>INVISIBLE MENUBAR UTILITY</span>
          <span className="text-teal-400">◆</span>
        </div>
      </div>

      {/* ======================================================== */}
      {/* 3. MANGA STORYBOARD PARALLAX LORE SECTION */}
      {/* ======================================================== */}
      <MangaScrollSection />

      {/* ======================================================== */}
      {/* 4. PRODUCT MATRIX: CAPABILITIES & SYMBOLOGY */}
      {/* ======================================================== */}
      <section id="features" className="py-28 px-6 max-w-7xl mx-auto hairline-b z-20 relative">
        <div className="flex flex-col md:flex-row md:items-end justify-between mb-16 gap-6">
          <div>
            <span className="text-xs font-mono tracking-widest text-indigo-400 uppercase block mb-2">
              02 // PRODUCT MATRIX
            </span>
            <h2 className="font-manga text-3xl sm:text-5xl font-black uppercase text-white leading-none">
              TACTICAL CAPABILITIES
            </h2>
          </div>

          <p className="text-slate-400 text-sm max-w-md font-mono">
            Replace sluggish screenshot workflows with single-keystroke neural intelligence.
          </p>
        </div>

        {/* 3 Large Showcase Editorial Cards */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Card 1: OCR */}
          <div className="anime-glass rounded-2xl p-8 flex flex-col justify-between anime-card-hover group">
            <div>
              <div className="flex items-center justify-between text-xs font-mono text-slate-500 mb-6 hairline-b pb-4">
                <span>MODULE // OCR-01</span>
                <span className="text-indigo-400">VNRecognizeTextRequest</span>
              </div>
              <h3 className="font-manga text-2xl font-bold uppercase text-white mb-3">
                Sub-Second Text Extraction
              </h3>
              <p className="text-sm text-slate-400 leading-relaxed mb-6 font-light">
                High-precision multi-script OCR covering Latin, Chinese (Simplified & Traditional), Japanese, Korean, Cyrillic, and Arabic. Smart paragraph synthesis with automatic line-break joining.
              </p>
            </div>

            <div className="pt-6 hairline-t flex items-center justify-between text-xs font-mono">
              <span className="text-slate-500">DEFAULT KEYBIND</span>
              <span className="text-white font-bold bg-white/10 px-2 py-1 rounded">⌘ + ⇧ + 2</span>
            </div>
          </div>

          {/* Card 2: QR */}
          <div className="anime-glass rounded-2xl p-8 flex flex-col justify-between anime-card-hover group">
            <div>
              <div className="flex items-center justify-between text-xs font-mono text-slate-500 mb-6 hairline-b pb-4">
                <span>MODULE // QR-02</span>
                <span className="text-teal-400">VNBarcodeSymbology.qr</span>
              </div>
              <h3 className="font-manga text-2xl font-bold uppercase text-white mb-3">
                Display QR Matrix Decoder
              </h3>
              <p className="text-sm text-slate-400 leading-relaxed mb-6 font-light">
                Never grab your phone to scan a monitor code. Snaps QR codes shown in Zoom, Slack, or web pages straight into URLs, 2FA secret seeds, and Wi-Fi credentials.
              </p>
            </div>

            <div className="pt-6 hairline-t flex items-center justify-between text-xs font-mono">
              <span className="text-slate-500">DEFAULT KEYBIND</span>
              <span className="text-white font-bold bg-white/10 px-2 py-1 rounded">⌘ + ⇧ + 3</span>
            </div>
          </div>

          {/* Card 3: Barcode */}
          <div className="anime-glass rounded-2xl p-8 flex flex-col justify-between anime-card-hover group">
            <div>
              <div className="flex items-center justify-between text-xs font-mono text-slate-500 mb-6 hairline-b pb-4">
                <span>MODULE // BARCODE-03</span>
                <span className="text-orange-400">13 SYMBOLOGIES</span>
              </div>
              <h3 className="font-manga text-2xl font-bold uppercase text-white mb-3">
                Industrial Commercial Barcodes
              </h3>
              <p className="text-sm text-slate-400 leading-relaxed mb-6 font-light">
                Decodes EAN-13, UPC-E, Code 128, Code 39, Data Matrix, Aztec, and PDF417 format standards for logistics, retail, and hardware engineering.
              </p>
            </div>

            <div className="pt-6 hairline-t flex items-center justify-between text-xs font-mono">
              <span className="text-slate-500">DEFAULT KEYBIND</span>
              <span className="text-white font-bold bg-white/10 px-2 py-1 rounded">⌘ + ⇧ + 4</span>
            </div>
          </div>
        </div>
      </section>

      {/* ======================================================== */}
      {/* 5. LIVE INTERACTIVE NEURAL HUD SIMULATOR */}
      {/* ======================================================== */}
      <section id="interactive-hud" className="py-28 px-6 max-w-7xl mx-auto hairline-b z-20 relative">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <span className="text-xs font-mono tracking-widest text-teal-400 uppercase block mb-2">
            03 // LIVE EXPERIMENTATION
          </span>
          <h2 className="font-manga text-3xl sm:text-5xl font-black uppercase text-white leading-none mb-4">
            TEST THE RETICLE
          </h2>
          <p className="text-slate-400 text-sm sm:text-base font-light">
            Test the live bounding-box laser simulator below to observe real-time OCR extraction and clipboard copying.
          </p>
        </div>

        <InteractiveScanDemo />
      </section>

      {/* ======================================================== */}
      {/* 6. TECHNICAL ARCHITECTURE SPECIFICATIONS */}
      {/* ======================================================== */}
      <section id="shortcuts" className="py-28 px-6 max-w-7xl mx-auto hairline-b z-20 relative">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12">
          <div className="lg:col-span-4">
            <span className="text-xs font-mono tracking-widest text-indigo-400 uppercase block mb-2">
              04 // HARDWARE PROFILE
            </span>
            <h2 className="font-manga text-3xl sm:text-5xl font-black uppercase text-white leading-none mb-6">
              SYSTEM SPECS
            </h2>
            <p className="text-slate-400 text-sm leading-relaxed mb-6 font-light">
              Built natively with Swift 6 and Apple Vision to ensure negligible memory overhead and zero UI stuttering.
            </p>
            <div className="p-5 rounded-xl bg-[#080a14] border border-white/10 font-mono text-xs text-slate-300 space-y-3">
              <div className="flex justify-between">
                <span className="text-slate-500">SUPPORTED OS</span>
                <span className="text-white font-semibold">macOS 14.0+</span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-500">BINARY ARCH</span>
                <span className="text-white font-semibold">Universal 2 (Apple Silicon & Intel)</span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-500">OCR PIPELINE</span>
                <span className="text-white font-semibold">Vision Framework Core ML</span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-500">RAM USAGE</span>
                <span className="text-teal-400 font-semibold">&lt; 14 MB Resident</span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-500">SANDBOX</span>
                <span className="text-emerald-400 font-semibold">No Network Entitlements</span>
              </div>
            </div>
          </div>

          <div className="lg:col-span-8 space-y-6">
            <div className="p-6 rounded-xl bg-[#080a14] border border-white/10">
              <h4 className="text-base font-bold text-white mb-2 font-manga">
                Why is Screen Recording permission required?
              </h4>
              <p className="text-sm text-slate-400 leading-relaxed font-light">
                macOS mandates explicit authorization for utilities that sample display coordinates. Byakugan Scan only captures the exact rectangular frame defined by your interactive drag selection, processes pixels in RAM with Vision, and immediately purges them. No background screenshots or logs are ever created.
              </p>
            </div>

            <div className="p-6 rounded-xl bg-[#080a14] border border-white/10">
              <h4 className="text-base font-bold text-white mb-2 font-manga">
                Does Byakugan Scan transmit telemetry to external servers?
              </h4>
              <p className="text-sm text-slate-400 leading-relaxed font-light">
                None. The app sandbox completely excludes network client entitlements (<code className="text-indigo-300 font-mono">com.apple.security.network.client: false</code>). It cannot make outbound network connections. Your screen content is 100% private and offline.
              </p>
            </div>

            <div className="p-6 rounded-xl bg-[#080a14] border border-white/10">
              <h4 className="text-base font-bold text-white mb-2 font-manga">
                Can I customize the keyboard shortcuts?
              </h4>
              <p className="text-sm text-slate-400 leading-relaxed font-light">
                Yes. Open Settings from the menu bar popover to remap any capture action to your preferred hotkeys.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* ======================================================== */}
      {/* 7. FINALE CALL TO ACTION */}
      {/* ======================================================== */}
      <section className="py-32 px-6 max-w-5xl mx-auto text-center z-20 relative">
        <span className="text-xs font-mono tracking-widest text-slate-500 uppercase block mb-3">
          OPEN SOURCE MAC UTILITY // MIT LICENSE
        </span>
        <h2 className="font-manga text-5xl sm:text-7xl font-black uppercase text-white tracking-wider leading-none mb-6">
          ACTIVATE YOUR VISION.
        </h2>
        <p className="text-slate-400 text-base max-w-lg mx-auto mb-10 leading-relaxed font-light">
          Experience frictionless screen capture on your Mac. Free to download, transparent, and completely offline.
        </p>

        <div className="flex flex-wrap items-center justify-center gap-4">
          <a
            href="https://github.com/halcyon-past/byakugan-scan"
            target="_blank"
            rel="noopener noreferrer"
            className="px-8 py-4 bg-white text-black text-xs font-bold font-mono uppercase tracking-wider rounded hover:bg-slate-200 transition-all flex items-center gap-2 shadow-2xl hover:scale-105 active:scale-95"
          >
            <span>Download Byakugan Scan</span>
            <ArrowUpRight className="w-4 h-4" />
          </a>
        </div>
      </section>
    </div>
  );
}
