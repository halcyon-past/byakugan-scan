"use client";

import Image from "next/image";
import Link from "next/link";
import { motion } from "framer-motion";
import {
  Eye,
  QrCode,
  Barcode,
  Clipboard,
  Clock,
  ShieldCheck,
  Zap,
  ArrowRight,
  Download,
  Terminal,
  Layers,
  Sparkles,
} from "lucide-react";
import ThreeHeroEye from "@/components/ThreeHeroEye";
import InteractiveScanDemo from "@/components/InteractiveScanDemo";

export default function Home() {
  return (
    <div className="relative overflow-hidden">
      {/* Background Anime Chakra Grid & Ambient Glows */}
      <div className="absolute top-10 left-1/2 -translate-x-1/2 w-[900px] h-[500px] bg-indigo-600/15 blur-[160px] rounded-full -z-10 pointer-events-none" />
      <div className="absolute top-[800px] right-0 w-[500px] h-[500px] bg-purple-600/10 blur-[140px] rounded-full -z-10 pointer-events-none" />
      <div className="absolute top-[1600px] left-0 w-[600px] h-[600px] bg-teal-500/10 blur-[150px] rounded-full -z-10 pointer-events-none" />

      {/* HERO SECTION */}
      <section className="pt-16 pb-20 px-6 max-w-7xl mx-auto">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 items-center">
          {/* Left Column: Typography & CTAs */}
          <motion.div
            initial={{ opacity: 0, y: 24 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, ease: [0.16, 1, 0.3, 1] }}
            className="lg:col-span-7 text-left"
          >
            {/* Top Eyebrow Badge */}
            <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-indigo-950/70 border border-indigo-500/40 text-indigo-300 text-xs font-mono font-medium mb-6">
              <Sparkles className="w-3.5 h-3.5 text-indigo-400 animate-pulse" />
              <span>THE ALL-SEEING EYE // BYAKUGAN SCAN v1.0</span>
            </div>

            <h1 className="text-4xl sm:text-6xl xl:text-7xl font-extrabold tracking-tight text-white mb-6 leading-[1.08]">
              Snatch Uncopyable Text & Codes{" "}
              <span className="bg-gradient-to-r from-indigo-300 via-purple-300 to-teal-200 bg-clip-text text-transparent">
                At The Speed of Thought.
              </span>
            </h1>

            <p className="text-base sm:text-lg text-slate-300 max-w-xl mb-8 leading-relaxed font-normal">
              A high-precision macOS menu bar utility powered entirely by Apple&apos;s native Vision Neural Engine. Extract locked text, decode QR payloads, and read industrial barcodes from any screen area in single-digit milliseconds.
            </p>

            <div className="flex flex-wrap items-center gap-4 mb-10">
              <a
                href="https://github.com/halcyon-past/byakugan-scan"
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center gap-2.5 px-6 py-3.5 rounded-full font-semibold text-white bg-indigo-600 hover:bg-indigo-500 shadow-xl shadow-indigo-600/35 transition-all hover:scale-105 active:scale-95 text-sm"
              >
                <Download className="w-4 h-4" />
                <span>Download for macOS</span>
              </a>

              <a
                href="#demo"
                className="inline-flex items-center gap-2 px-6 py-3.5 rounded-full font-semibold text-slate-300 bg-slate-900/90 border border-slate-700 hover:bg-slate-800 hover:text-white transition-all text-sm"
              >
                <span>Live Interactive Demo</span>
                <ArrowRight className="w-4 h-4" />
              </a>
            </div>

            {/* Micro specs badge */}
            <div className="flex flex-wrap items-center gap-6 pt-6 border-t border-indigo-950/80 text-xs font-mono text-slate-400">
              <div className="flex items-center gap-1.5">
                <span className="text-teal-400 font-bold">●</span>
                <span>Zero Cloud / 100% Offline</span>
              </div>
              <div className="flex items-center gap-1.5">
                <span className="text-indigo-400 font-bold">●</span>
                <span>Native Swift 6 & Vision</span>
              </div>
              <div className="flex items-center gap-1.5">
                <span className="text-purple-400 font-bold">●</span>
                <span>Sonoma & Sequoia</span>
              </div>
            </div>
          </motion.div>

          {/* Right Column: 3D Holographic Byakugan Eye */}
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.8, delay: 0.1, ease: [0.16, 1, 0.3, 1] }}
            className="lg:col-span-5 relative flex items-center justify-center"
          >
            <div className="w-full max-w-[460px] aspect-square rounded-3xl bg-gradient-to-b from-indigo-950/40 to-transparent p-1 chakra-border relative">
              {/* Corner reticle decorations */}
              <div className="absolute top-3 left-3 font-mono text-[9px] text-indigo-400/80">
                [RADAR: 360° RANGE]
              </div>
              <div className="absolute bottom-3 right-3 font-mono text-[9px] text-teal-400/80">
                [TRACKING: ACTIVE]
              </div>

              {/* The 3D Three.js Component */}
              <ThreeHeroEye />
            </div>
          </motion.div>
        </div>
      </section>

      {/* INTERACTIVE LIVE SCAN SIMULATION SECTION */}
      <section id="demo" className="py-20 px-6 max-w-6xl mx-auto scroll-mt-20">
        <div className="text-center mb-12">
          <div className="inline-flex items-center gap-1.5 text-xs font-mono uppercase tracking-widest text-indigo-400 mb-2">
            <Terminal className="w-3.5 h-3.5" />
            <span>Interactive Neural Sandbox</span>
          </div>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-white">
            Experience Byakugan In Action
          </h2>
          <p className="text-slate-400 text-sm sm:text-base max-w-xl mx-auto mt-2">
            Switch between scan modes and test how instantaneous region capture transforms pixels into structured clipboard text.
          </p>
        </div>

        <InteractiveScanDemo />
      </section>

      {/* ARCHITECTURAL ADVANTAGES / CAPABILITIES */}
      <section id="features" className="py-24 px-6 max-w-6xl mx-auto">
        <div className="text-center mb-16">
          <div className="text-xs font-mono uppercase tracking-widest text-indigo-400 mb-2">
            Architecture // Capabilities
          </div>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-white">
            Engineered For Frictionless Capture
          </h2>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div className="glass-card rounded-2xl p-8 hover:-translate-y-1 transition-all border border-indigo-900/40">
            <div className="w-12 h-12 rounded-xl bg-indigo-500/10 flex items-center justify-center text-indigo-400 mb-5">
              <Eye className="w-6 h-6" />
            </div>
            <h3 className="text-lg font-bold text-white mb-2">Multi-Script Neural OCR</h3>
            <p className="text-slate-400 text-sm leading-relaxed">
              Recognizes Latin, CJK (Chinese, Japanese, Korean), Cyrillic, and Arabic text with punctuation restoration and line break intelligence.
            </p>
          </div>

          <div className="glass-card rounded-2xl p-8 hover:-translate-y-1 transition-all border border-indigo-900/40">
            <div className="w-12 h-12 rounded-xl bg-teal-500/10 flex items-center justify-center text-teal-400 mb-5">
              <QrCode className="w-6 h-6" />
            </div>
            <h3 className="text-lg font-bold text-white mb-2">Instant QR Matrix Decoder</h3>
            <p className="text-slate-400 text-sm leading-relaxed">
              Never pull out your smartphone to read a screen code. Snaps QR codes directly into URLs, contact cards, and Wi-Fi tokens.
            </p>
          </div>

          <div className="glass-card rounded-2xl p-8 hover:-translate-y-1 transition-all border border-indigo-900/40">
            <div className="w-12 h-12 rounded-xl bg-orange-500/10 flex items-center justify-center text-orange-400 mb-5">
              <Barcode className="w-6 h-6" />
            </div>
            <h3 className="text-lg font-bold text-white mb-2">13 Industrial Barcodes</h3>
            <p className="text-slate-400 text-sm leading-relaxed">
              Decodes retail EAN-13, logistics Code 128, Code 39, Data Matrix, Aztec, PDF417, and UPC formats with full checksum verification.
            </p>
          </div>

          <div className="glass-card rounded-2xl p-8 hover:-translate-y-1 transition-all border border-indigo-900/40">
            <div className="w-12 h-12 rounded-xl bg-purple-500/10 flex items-center justify-center text-purple-400 mb-5">
              <Clipboard className="w-6 h-6" />
            </div>
            <h3 className="text-lg font-bold text-white mb-2">Smart Clipboard Pipeline</h3>
            <p className="text-slate-400 text-sm leading-relaxed">
              Auto-copies extracted content instantly with audio feedback. Options to join wrapped lines with spaces or preserve exact breaks.
            </p>
          </div>

          <div className="glass-card rounded-2xl p-8 hover:-translate-y-1 transition-all border border-indigo-900/40">
            <div className="w-12 h-12 rounded-xl bg-blue-500/10 flex items-center justify-center text-blue-400 mb-5">
              <Clock className="w-6 h-6" />
            </div>
            <h3 className="text-lg font-bold text-white mb-2">Local History & Vault</h3>
            <p className="text-slate-400 text-sm leading-relaxed">
              Stores recent extractions safely in local JSON. Re-copy, favorite, or clear past entries at any time right from the menu bar.
            </p>
          </div>

          <div className="glass-card rounded-2xl p-8 hover:-translate-y-1 transition-all border border-indigo-900/40">
            <div className="w-12 h-12 rounded-xl bg-emerald-500/10 flex items-center justify-center text-emerald-400 mb-5">
              <ShieldCheck className="w-6 h-6" />
            </div>
            <h3 className="text-lg font-bold text-white mb-2">Zero Network Permissions</h3>
            <p className="text-slate-400 text-sm leading-relaxed">
              Guaranteed by Apple Sandbox. No outbound sockets, no telemetry, no analytics. Pixels reside strictly in volatile RAM.
            </p>
          </div>
        </div>
      </section>

      {/* SHORTCUTS / WORKFLOW SHOWCASE */}
      <section id="shortcuts" className="py-20 px-6 border-y border-indigo-950/70 bg-[#070912]">
        <div className="max-w-4xl mx-auto">
          <div className="text-center mb-12">
            <div className="text-xs font-mono uppercase tracking-widest text-indigo-400 mb-2">
              Hotkeys // Flow
            </div>
            <h2 className="text-3xl font-extrabold text-white">Default Global Hotkeys</h2>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
            <div className="p-6 rounded-2xl bg-[#0b0e1b] border border-indigo-900/50 text-center">
              <div className="font-mono text-2xl font-extrabold text-indigo-400 mb-3">⌘ ⇧ 2</div>
              <div className="font-bold text-white text-base mb-1">Capture Text (OCR)</div>
              <div className="text-xs text-slate-400">Snaps unselectable text from any dragged region</div>
            </div>

            <div className="p-6 rounded-2xl bg-[#0b0e1b] border border-teal-900/50 text-center">
              <div className="font-mono text-2xl font-extrabold text-teal-400 mb-3">⌘ ⇧ 3</div>
              <div className="font-bold text-white text-base mb-1">Scan QR Code</div>
              <div className="text-xs text-slate-400">Decodes QR payloads directly from your screen</div>
            </div>

            <div className="p-6 rounded-2xl bg-[#0b0e1b] border border-orange-900/50 text-center">
              <div className="font-mono text-2xl font-extrabold text-orange-400 mb-3">⌘ ⇧ 4</div>
              <div className="font-bold text-white text-base mb-1">Scan Barcode</div>
              <div className="text-xs text-slate-400">Reads 1D and 2D industrial barcode types</div>
            </div>
          </div>
        </div>
      </section>

      {/* FAQ SECTION */}
      <section id="faq" className="py-24 px-6 max-w-4xl mx-auto">
        <div className="text-center mb-14">
          <div className="text-xs font-mono uppercase tracking-widest text-indigo-400 mb-2">FAQ</div>
          <h2 className="text-3xl font-extrabold text-white">Frequently Asked Questions</h2>
        </div>

        <div className="space-y-6">
          <div className="glass-card rounded-xl p-6">
            <h4 className="text-base font-bold text-white mb-2">
              Why does macOS ask for Screen Recording permission?
            </h4>
            <p className="text-slate-400 text-sm leading-relaxed">
              macOS requires explicit authorization for any utility that samples screen coordinates. Byakugan Scan only reads the exact rectangular box you drag your crosshair over, processes the pixels in memory using Apple Vision, and discards them immediately.
            </p>
          </div>

          <div className="glass-card rounded-xl p-6">
            <h4 className="text-base font-bold text-white mb-2">
              Does Byakugan Scan work offline?
            </h4>
            <p className="text-slate-400 text-sm leading-relaxed">
              Yes, 100% offline. The application has zero outbound network capabilities. All OCR, QR, and barcode recognition models run locally on your Mac&apos;s Neural Engine.
            </p>
          </div>

          <div className="glass-card rounded-xl p-6">
            <h4 className="text-base font-bold text-white mb-2">
              Can I customize the keyboard shortcuts?
            </h4>
            <p className="text-slate-400 text-sm leading-relaxed">
              Yes. Open the Settings window from the menu bar popover to remap any scan action to your preferred key combinations.
            </p>
          </div>
        </div>
      </section>
    </div>
  );
}
