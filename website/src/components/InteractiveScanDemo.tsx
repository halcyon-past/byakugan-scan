"use client";

import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Copy, Check, Scan, Eye, QrCode, Barcode, Terminal } from "lucide-react";
import confetti from "canvas-confetti";

interface ScanTab {
  id: "ocr" | "qr" | "barcode";
  title: string;
  icon: typeof Eye;
  previewTitle: string;
  previewSubtitle: string;
  output: string;
  shortcut: string;
}

const TABS: ScanTab[] = [
  {
    id: "ocr",
    title: "Screen Text (OCR)",
    icon: Eye,
    previewTitle: "PDF Specification / Video Frame",
    previewSubtitle: "Targeting uncopyable technical copy",
    output: `// Extracted via Byakugan Scan (Vision OCR)
struct Jutsu {
  let name = "Gentle Fist: Eight Trigrams Sixty-Four Palms"
  let accuracy = 0.9998
  let latencyMs = 12
}`,
    shortcut: "⌘⇧2",
  },
  {
    id: "qr",
    title: "QR Scanner",
    icon: QrCode,
    previewTitle: "Display QR Matrix",
    previewSubtitle: "WiFi Network & Auth Payload",
    output: `WIFI:S:Konoha_Chakra_5G;T:WPA;P:byakugan-secure-2026;;`,
    shortcut: "⌘⇧3",
  },
  {
    id: "barcode",
    title: "1D/2D Barcodes",
    icon: Barcode,
    previewTitle: "Logistics EAN-13 / Code 128",
    previewSubtitle: "Hardware Serial & Inventory Tag",
    output: `[EAN-13] 8901030829145
[SERIAL] BYK-ARM64-2026-X09`,
    shortcut: "⌘⇧4",
  },
];

export default function InteractiveScanDemo() {
  const [activeTab, setActiveTab] = useState<"ocr" | "qr" | "barcode">("ocr");
  const [copied, setCopied] = useState(false);
  const [isScanning, setIsScanning] = useState(false);

  const currentTab = TABS.find((t) => t.id === activeTab)!;

  const triggerMockScan = () => {
    setIsScanning(true);
    setTimeout(() => {
      setIsScanning(false);
      confetti({
        particleCount: 35,
        spread: 60,
        origin: { y: 0.75 },
        colors: ["#6366f1", "#a5b4fc", "#38bdf8"],
      });
    }, 700);
  };

  const handleCopy = () => {
    navigator.clipboard.writeText(currentTab.output);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className="w-full max-w-4xl mx-auto rounded-2xl bg-[#0b0e1a]/90 chakra-border p-6 sm:p-8 backdrop-blur-xl relative overflow-hidden shadow-2xl">
      {/* Decorative HUD header */}
      <div className="flex items-center justify-between border-b border-indigo-900/40 pb-4 mb-6">
        <div className="flex items-center gap-2">
          <span className="w-2.5 h-2.5 rounded-full bg-indigo-500 animate-pulse" />
          <span className="font-mono text-xs text-indigo-300 font-semibold uppercase tracking-wider">
            Live Simulation // Interactive Neural HUD
          </span>
        </div>
        <div className="flex items-center gap-2 font-mono text-xs text-slate-400">
          <span>Vision Framework</span>
          <span className="text-emerald-400 font-semibold">● ACTIVE</span>
        </div>
      </div>

      {/* Mode Selectors */}
      <div className="flex flex-wrap gap-2.5 mb-6">
        {TABS.map((tab) => {
          const Icon = tab.icon;
          const isActive = activeTab === tab.id;
          return (
            <button
              key={tab.id}
              onClick={() => {
                setActiveTab(tab.id);
                setCopied(false);
              }}
              className={`flex items-center gap-2 px-4 py-2 rounded-xl text-xs sm:text-sm font-semibold transition-all ${
                isActive
                  ? "bg-indigo-600 text-white shadow-lg shadow-indigo-600/30 border border-indigo-400/30"
                  : "bg-slate-900/80 text-slate-400 hover:text-slate-200 border border-slate-800"
              }`}
            >
              <Icon className="w-4 h-4" />
              <span>{tab.title}</span>
              <kbd className="hidden sm:inline font-mono text-[10px] bg-black/30 px-1.5 py-0.5 rounded text-indigo-200">
                {tab.shortcut}
              </kbd>
            </button>
          );
        })}
      </div>

      {/* Interactive Scan Canvas & Output Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6 items-stretch">
        {/* Left: Simulated Screen Capture Viewport */}
        <div className="relative rounded-xl bg-[#05060c] border border-indigo-950 p-5 flex flex-col justify-between overflow-hidden min-h-[220px]">
          {/* Subtle Grid Lines */}
          <div className="absolute inset-0 bg-[linear-gradient(to_right,#1e1b4b15_1px,transparent_1px),linear-gradient(to_bottom,#1e1b4b15_1px,transparent_1px)] bg-[size:16px_16px] pointer-events-none" />

          {/* Interactive Crosshair Reticle Selection */}
          <div className="relative z-10 border border-dashed border-indigo-400/80 rounded-lg p-4 bg-indigo-950/20 backdrop-blur-sm">
            <div className="flex items-center justify-between text-[11px] font-mono text-indigo-300 mb-2">
              <span className="flex items-center gap-1">
                <Scan className="w-3.5 h-3.5 animate-spin text-teal-400" />
                <span>B-BOX: [840, 220, 420, 180]</span>
              </span>
              <span className="text-teal-300 font-bold">100% CONFIDENCE</span>
            </div>
            <div className="text-sm font-medium text-slate-200">{currentTab.previewTitle}</div>
            <div className="text-xs text-slate-400">{currentTab.previewSubtitle}</div>

            {/* Laser scanning beam animation */}
            <motion.div
              className="absolute left-0 right-0 h-[2px] bg-gradient-to-r from-transparent via-teal-400 to-transparent shadow-[0_0_8px_#2dd4bf]"
              animate={{
                top: ["5%", "95%", "5%"],
              }}
              transition={{
                duration: 2.2,
                repeat: Infinity,
                ease: "easeInOut",
              }}
            />
          </div>

          <div className="relative z-10 mt-4 flex items-center justify-between pt-3 border-t border-slate-900">
            <button
              onClick={triggerMockScan}
              disabled={isScanning}
              className="px-3.5 py-1.5 rounded-lg bg-indigo-600/30 hover:bg-indigo-600/50 border border-indigo-500/40 text-xs font-semibold text-indigo-200 transition-all flex items-center gap-1.5"
            >
              <Scan className="w-3.5 h-3.5" />
              <span>{isScanning ? "Scanning Target..." : "Simulate Capture"}</span>
            </button>
            <span className="text-[11px] font-mono text-slate-500">Latency: 11ms on M-Series</span>
          </div>
        </div>

        {/* Right: Extracted Result (Ready for Clipboard) */}
        <div className="rounded-xl bg-[#070913] border border-indigo-900/60 p-5 flex flex-col justify-between relative">
          <div>
            <div className="flex items-center justify-between mb-3 text-xs font-mono text-slate-400">
              <span className="flex items-center gap-1.5 text-indigo-300 font-semibold">
                <Terminal className="w-3.5 h-3.5" />
                <span>NSPasteboard Output</span>
              </span>
              <button
                onClick={handleCopy}
                className="flex items-center gap-1 px-2.5 py-1 rounded-md bg-indigo-950/80 hover:bg-indigo-900 border border-indigo-700/60 text-xs font-semibold text-indigo-200 transition-all"
              >
                {copied ? <Check className="w-3 h-3 text-emerald-400" /> : <Copy className="w-3 h-3" />}
                <span>{copied ? "Copied!" : "Copy"}</span>
              </button>
            </div>

            <AnimatePresence mode="wait">
              <motion.pre
                key={activeTab}
                initial={{ opacity: 0, y: 6 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: -6 }}
                transition={{ duration: 0.15 }}
                className="font-mono text-xs text-slate-200 bg-black/40 p-3.5 rounded-lg border border-indigo-950 overflow-x-auto whitespace-pre-wrap leading-relaxed"
              >
                {currentTab.output}
              </motion.pre>
            </AnimatePresence>
          </div>

          <div className="mt-4 pt-3 border-t border-slate-900/80 flex items-center justify-between text-[11px] text-slate-400 font-mono">
            <span>Sound Effect: Glass.aiff</span>
            <span className="text-emerald-400 font-semibold">✓ Auto-Copied</span>
          </div>
        </div>
      </div>
    </div>
  );
}
