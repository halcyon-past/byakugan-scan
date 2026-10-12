"use client";

import { useRef } from "react";
import Image from "next/image";
import { motion, useScroll, useTransform } from "framer-motion";
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
} from "lucide-react";
import ThreeHeroEye from "@/components/ThreeHeroEye";
import InteractiveScanDemo from "@/components/InteractiveScanDemo";

export default function EditorialHome() {
  const containerRef = useRef<HTMLDivElement>(null);
  const { scrollYProgress } = useScroll({
    target: containerRef,
    offset: ["start start", "end end"],
  });

  const heroScale = useTransform(scrollYProgress, [0, 0.2], [1, 0.96]);
  const heroOpacity = useTransform(scrollYProgress, [0, 0.25], [1, 0.2]);

  return (
    <div ref={containerRef} className="relative w-full overflow-hidden bg-[#07080d]">
      {/* ======================================================== */}
      {/* 1. EDITORIAL HERO: CINEMATIC TYPOGRAPHY & 3D BYAKUGAN RETICLE */}
      {/* ======================================================== */}
      <section className="relative min-h-[92vh] flex flex-col justify-between pt-10 sm:pt-16 pb-12 px-6 max-w-7xl mx-auto hairline-b">
        {/* Subtle radial chakra ambient aura */}
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[700px] h-[700px] bg-indigo-900/10 blur-[180px] rounded-full pointer-events-none -z-10" />

        {/* Top Monospace Metadata Row */}
        <div className="flex flex-wrap items-center justify-between gap-4 text-xs font-mono-tech text-slate-500 uppercase tracking-widest hairline-b pb-4">
          <div className="flex items-center gap-2">
            <span className="text-white font-semibold">[01] // ARCHITECTURE</span>
            <span className="text-slate-700">|</span>
            <span>APPLE SILICON NEURAL PIPELINE</span>
          </div>
          <div className="flex items-center gap-2">
            <span>RELEASE STAGE:</span>
            <span className="text-teal-400 font-semibold">GA 1.0.0</span>
          </div>
        </div>

        {/* Hero Main Content */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 items-center my-auto py-8 sm:py-12">
          {/* Left Column: Monument Display Typography */}
          <div className="lg:col-span-7 flex flex-col justify-center">
            {/* Japanese Subtitle / Kanji */}
            <div className="flex items-center gap-3 mb-4">
              <span className="text-xs font-kanji font-bold text-indigo-400 tracking-widest uppercase">
                白眼の覚醒 // THE AWAKENED EYE
              </span>
              <div className="h-[1px] w-12 bg-indigo-500/40" />
            </div>

            {/* Giant Architectural Headline (Halcyon Style) */}
            <h1 className="font-editorial-display text-5xl sm:text-7xl xl:text-8xl font-black uppercase text-white tracking-tight leading-[0.92] mb-6">
              SEES WHAT CANNOT BE COPIED.
            </h1>

            {/* Editorial Lead Paragraph */}
            <p className="text-slate-300 text-base sm:text-lg max-w-xl font-normal leading-relaxed mb-8">
              Inspired by the all-seeing Byakugan eye. Snatch locked text from video frames, diagrams, and protected documents in 11 milliseconds. Decode QR codes and commercial barcodes straight from your monitor with zero cloud reliance.
            </p>

            {/* Call to Actions (Restrained luxury style) */}
            <div className="flex flex-wrap items-center gap-4">
              <a
                href="https://github.com/halcyon-past/byakugan-scan"
                target="_blank"
                rel="noopener noreferrer"
                className="px-8 py-3.5 bg-white text-black text-xs font-bold font-mono-tech uppercase tracking-wider rounded hover:bg-slate-200 transition-all flex items-center gap-2 shadow-lg hover:-translate-y-0.5 active:translate-y-0"
              >
                <span>Download For macOS</span>
                <ArrowUpRight className="w-4 h-4" />
              </a>

              <a
                href="#interactive-hud"
                className="px-6 py-3.5 bg-transparent border border-white/20 text-white text-xs font-bold font-mono-tech uppercase tracking-wider rounded hover:bg-white/5 transition-all flex items-center gap-2"
              >
                <span>Launch Live HUD</span>
                <Scan className="w-3.5 h-3.5 text-teal-400" />
              </a>
            </div>
          </div>

          {/* Right Column: 3D Holographic Byakugan Eye */}
          <div className="lg:col-span-5 flex items-center justify-center relative">
            <div className="w-full max-w-[420px] aspect-square rounded-2xl bg-[#090b14] border border-white/10 p-2 relative shadow-2xl overflow-hidden group">
              {/* Corner Coordinate HUD Marks */}
              <div className="absolute top-3 left-3 font-mono-tech text-[10px] text-slate-500">
                POS: 360° RETICLE
              </div>
              <div className="absolute top-3 right-3 font-mono-tech text-[10px] text-teal-400">
                ACTIVE
              </div>
              <div className="absolute bottom-3 left-3 font-mono-tech text-[10px] text-slate-500">
                VISION ENGINE
              </div>
              <div className="absolute bottom-3 right-3 font-mono-tech text-[10px] text-indigo-400">
                11MS LATENCY
              </div>

              {/* Three.js Canvas */}
              <ThreeHeroEye />
            </div>
          </div>
        </div>

        {/* Hero Bottom Bar */}
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 pt-6 hairline-t text-xs font-mono-tech text-slate-400">
          <div className="flex items-center gap-6">
            <span>KEYBINDS: [⌘⇧2 TEXT]</span>
            <span>[⌘⇧3 QR]</span>
            <span>[⌘⇧4 BARCODE]</span>
          </div>

          <div className="flex items-center gap-2 text-slate-500">
            <span>SCROLL TO EXPLORE SPECIFICATIONS</span>
            <ArrowDown className="w-3.5 h-3.5 animate-bounce text-slate-400" />
          </div>
        </div>
      </section>

      {/* ======================================================== */}
      {/* 2. INFINITE TICKER MARQUEE (Halcyon "Into The Light" Motif) */}
      {/* ======================================================== */}
      <div className="w-full bg-[#030408] hairline-b py-4 overflow-hidden select-none">
        <div className="animate-ticker flex items-center gap-8 text-xs font-mono-tech tracking-[0.25em] uppercase text-slate-400">
          <span>// ALL-SEEING VISION</span>
          <span className="text-indigo-400">◆</span>
          <span>APPLE NEURAL ENGINE</span>
          <span className="text-teal-400">◆</span>
          <span>ZERO CLOUD TELEMETRY</span>
          <span className="text-indigo-400">◆</span>
          <span>13+ INDUSTRIAL BARCODES</span>
          <span className="text-teal-400">◆</span>
          <span>SUB-SECOND REGION OCR</span>
          <span className="text-indigo-400">◆</span>
          <span>SEAMLESS MENUBAR COMPANION</span>
          <span className="text-teal-400">◆</span>
          <span>// ALL-SEEING VISION</span>
          <span className="text-indigo-400">◆</span>
          <span>APPLE NEURAL ENGINE</span>
          <span className="text-teal-400">◆</span>
          <span>ZERO CLOUD TELEMETRY</span>
          <span className="text-indigo-400">◆</span>
          <span>13+ INDUSTRIAL BARCODES</span>
          <span className="text-teal-400">◆</span>
          <span>SUB-SECOND REGION OCR</span>
          <span className="text-indigo-400">◆</span>
          <span>SEAMLESS MENUBAR COMPANION</span>
          <span className="text-teal-400">◆</span>
        </div>
      </div>

      {/* ======================================================== */}
      {/* 3. EDITORIAL PROOF & PHILOSOPHY (Halcyon "About" Section) */}
      {/* ======================================================== */}
      <section id="editorial-proof" className="py-24 px-6 max-w-7xl mx-auto hairline-b">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12">
          {/* Section Marker */}
          <div className="lg:col-span-3">
            <span className="text-xs font-mono-tech tracking-widest text-indigo-400 uppercase block mb-2">
              01 // PHILOSOPHY
            </span>
            <h2 className="font-editorial-display text-4xl sm:text-5xl font-black uppercase text-white leading-none">
              THE VISION IMPERATIVE
            </h2>
          </div>

          {/* Editorial Content */}
          <div className="lg:col-span-9 space-y-8">
            <p className="text-2xl sm:text-3xl font-light text-slate-200 leading-snug">
              Every day, engineers, designers, and researchers waste minutes retyping text locked inside video streams, remote desks, scanned blueprints, and stubborn web apps.
            </p>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-8 pt-6 hairline-t text-sm leading-relaxed text-slate-400">
              <div>
                <strong className="text-white block font-medium mb-2 text-base">
                  100% On-Device Neural Processing
                </strong>
                Unlike browser-based or SaaS utilities that ship your sensitive screen buffer over public webs, Byakugan Scan compiles Apple’s Vision model directly against your Mac’s local Unified Memory. No packets leave your device.
              </div>

              <div>
                <strong className="text-white block font-medium mb-2 text-base">
                  Instantaneous Crosshair Flow
                </strong>
                Activated by macOS global hotkeys, the screen selection tool activates with zero latency. Drag your reticle over any script, QR matrix, or barcode, and the structured result is waiting in your clipboard before your fingers lift.
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* ======================================================== */}
      {/* 4. PRODUCT MATRIX: CAPABILITIES (Halcyon "Collections" Grid) */}
      {/* ======================================================== */}
      <section id="features" className="py-24 px-6 max-w-7xl mx-auto hairline-b">
        <div className="flex flex-col md:flex-row md:items-end justify-between mb-16 gap-6">
          <div>
            <span className="text-xs font-mono-tech tracking-widest text-indigo-400 uppercase block mb-2">
              02 // PRODUCT MATRIX
            </span>
            <h2 className="font-editorial-display text-4xl sm:text-6xl font-black uppercase text-white leading-none">
              BUILT FOR INDUSTRIAL SPECIFICATION
            </h2>
          </div>

          <p className="text-slate-400 text-sm max-w-md font-mono-tech">
            Engineered to replace fragmented capture tools with a single, dedicated macOS menu bar utility.
          </p>
        </div>

        {/* 3 Large Showcase Editorial Cards */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Card 1: OCR */}
          <div className="shimmer-card rounded-xl p-8 flex flex-col justify-between group">
            <div>
              <div className="flex items-center justify-between text-xs font-mono-tech text-slate-500 mb-6 hairline-b pb-4">
                <span>MODULE: OCR-01</span>
                <span className="text-indigo-400">VNRecognizeText</span>
              </div>
              <h3 className="font-editorial-display text-3xl font-bold uppercase text-white mb-3">
                Sub-Second Text Extraction
              </h3>
              <p className="text-sm text-slate-400 leading-relaxed mb-6">
                Accurate multi-script recognition across Latin, CJK, Cyrillic, and Arabic languages. Automatic line joining, paragraph synthesis, and whitespace trimming.
              </p>
            </div>

            <div className="pt-6 hairline-t flex items-center justify-between text-xs font-mono-tech">
              <span className="text-slate-500">DEFAULT KEYBIND</span>
              <span className="text-white font-bold bg-white/10 px-2 py-1 rounded">⌘ + ⇧ + 2</span>
            </div>
          </div>

          {/* Card 2: QR */}
          <div className="shimmer-card rounded-xl p-8 flex flex-col justify-between group">
            <div>
              <div className="flex items-center justify-between text-xs font-mono-tech text-slate-500 mb-6 hairline-b pb-4">
                <span>MODULE: QR-02</span>
                <span className="text-teal-400">VNBarcodeSymbology.qr</span>
              </div>
              <h3 className="font-editorial-display text-3xl font-bold uppercase text-white mb-3">
                Display QR Matrix Decoder
              </h3>
              <p className="text-sm text-slate-400 leading-relaxed mb-6">
                Never pick up your phone to read an authentication or Wi-Fi QR code shown on your Mac. Decodes links, vCards, and OTP secrets directly to your clipboard.
              </p>
            </div>

            <div className="pt-6 hairline-t flex items-center justify-between text-xs font-mono-tech">
              <span className="text-slate-500">DEFAULT KEYBIND</span>
              <span className="text-white font-bold bg-white/10 px-2 py-1 rounded">⌘ + ⇧ + 3</span>
            </div>
          </div>

          {/* Card 3: Barcode */}
          <div className="shimmer-card rounded-xl p-8 flex flex-col justify-between group">
            <div>
              <div className="flex items-center justify-between text-xs font-mono-tech text-slate-500 mb-6 hairline-b pb-4">
                <span>MODULE: BARCODE-03</span>
                <span className="text-orange-400">13 SYMBOLOGIES</span>
              </div>
              <h3 className="font-editorial-display text-3xl font-bold uppercase text-white mb-3">
                Commercial Logistics Barcodes
              </h3>
              <p className="text-sm text-slate-400 leading-relaxed mb-6">
                Decodes EAN-13, UPC-E, Code 128, Code 39, Data Matrix, Aztec, and PDF417 format standards for inventory and hardware engineers.
              </p>
            </div>

            <div className="pt-6 hairline-t flex items-center justify-between text-xs font-mono-tech">
              <span className="text-slate-500">DEFAULT KEYBIND</span>
              <span className="text-white font-bold bg-white/10 px-2 py-1 rounded">⌘ + ⇧ + 4</span>
            </div>
          </div>
        </div>
      </section>

      {/* ======================================================== */}
      {/* 5. INTERACTIVE LIVE HUD SIMULATOR (Hands-on Product Proof) */}
      {/* ======================================================== */}
      <section id="interactive-hud" className="py-24 px-6 max-w-7xl mx-auto hairline-b">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <span className="text-xs font-mono-tech tracking-widest text-teal-400 uppercase block mb-2">
            04 // INTERACTIVE PROOF
          </span>
          <h2 className="font-editorial-display text-4xl sm:text-6xl font-black uppercase text-white leading-none mb-4">
            SIMULATE THE SCANNER
          </h2>
          <p className="text-slate-400 text-sm sm:text-base font-normal">
            Interact with the neural bounding box simulation below to inspect how screen coordinates convert into structured text output.
          </p>
        </div>

        <InteractiveScanDemo />
      </section>

      {/* ======================================================== */}
      {/* 6. TECHNICAL SPECIFICATIONS & FAQ TABLE (Halcyon Spec Style) */}
      {/* ======================================================== */}
      <section id="shortcuts" className="py-24 px-6 max-w-7xl mx-auto hairline-b">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12">
          <div className="lg:col-span-4">
            <span className="text-xs font-mono-tech tracking-widest text-indigo-400 uppercase block mb-2">
              05 // TECHNICAL SPECIFICATIONS
            </span>
            <h2 className="font-editorial-display text-4xl sm:text-5xl font-black uppercase text-white leading-none mb-6">
              SYSTEM PROFILE
            </h2>
            <p className="text-slate-400 text-sm leading-relaxed mb-6">
              Built in accordance with Apple Human Interface Guidelines and Mac App Store Sandboxing standards.
            </p>
            <div className="p-4 rounded bg-[#090b14] border border-white/10 font-mono-tech text-xs text-slate-300 space-y-2">
              <div className="flex justify-between">
                <span className="text-slate-500">TARGET OS</span>
                <span className="text-white">macOS 14.0+</span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-500">ARCHITECTURE</span>
                <span className="text-white">Universal 2 (ARM64 & x86_64)</span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-500">FRAMEWORK</span>
                <span className="text-white">Apple Vision, SwiftUI 6</span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-500">APP FOOTPRINT</span>
                <span className="text-teal-400">&lt; 14 MB RAM</span>
              </div>
            </div>
          </div>

          <div className="lg:col-span-8">
            <div className="space-y-6">
              <div className="p-6 rounded-lg bg-[#0a0c16] border border-white/10">
                <h4 className="text-base font-bold text-white mb-2">
                  Why does Byakugan Scan require Screen Recording permission?
                </h4>
                <p className="text-sm text-slate-400 leading-relaxed">
                  macOS requires explicit authorization for any utility that reads display coordinates. Byakugan Scan only captures the exact rectangular frame you drag your crosshair over, processes the pixels in memory using Apple Vision, and discards them immediately. No background recordings are ever made.
                </p>
              </div>

              <div className="p-6 rounded-lg bg-[#0a0c16] border border-white/10">
                <h4 className="text-base font-bold text-white mb-2">
                  Is there any internet requirement or background telemetry?
                </h4>
                <p className="text-sm text-slate-400 leading-relaxed">
                  None. The app sandbox completely excludes network client entitlements. It cannot communicate with any remote server. Your screen data is 100% private and offline.
                </p>
              </div>

              <div className="p-6 rounded-lg bg-[#0a0c16] border border-white/10">
                <h4 className="text-base font-bold text-white mb-2">
                  Can I remap the keyboard shortcuts?
                </h4>
                <p className="text-sm text-slate-400 leading-relaxed">
                  Yes. Open Settings from the menu bar popover to remap any scan action to your preferred key combinations.
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* ======================================================== */}
      {/* 7. CALL TO ACTION FINALE (Halcyon Minimalist Callout) */}
      {/* ======================================================== */}
      <section className="py-28 px-6 max-w-5xl mx-auto text-center">
        <span className="text-xs font-mono-tech tracking-widest text-slate-500 uppercase block mb-3">
          STANDALONE UTILITY // OPEN SOURCE
        </span>
        <h2 className="font-editorial-display text-5xl sm:text-7xl font-black uppercase text-white tracking-tight leading-none mb-6">
          AWAKEN YOUR WORKFLOW.
        </h2>
        <p className="text-slate-400 text-base max-w-lg mx-auto mb-10 leading-relaxed font-normal">
          Available free for macOS. Tested on Apple Silicon M1 through M4 and modern Intel Macs.
        </p>

        <div className="flex flex-wrap items-center justify-center gap-4">
          <a
            href="https://github.com/halcyon-past/byakugan-scan"
            target="_blank"
            rel="noopener noreferrer"
            className="px-8 py-4 bg-white text-black text-xs font-bold font-mono-tech uppercase tracking-wider rounded hover:bg-slate-200 transition-all flex items-center gap-2 shadow-2xl"
          >
            <span>Download Byakugan Scan</span>
            <ArrowUpRight className="w-4 h-4" />
          </a>
        </div>
      </section>
    </div>
  );
}
