"use client";

import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Copy, Check, Eye, QrCode, Barcode, Play, Layers } from "lucide-react";
import confetti from "canvas-confetti";

interface ScanTab {
  id: "ocr" | "qr" | "barcode";
  title: string;
  icon: typeof Eye;
  previewHeading: string;
  previewDescription: string;
  sampleInput: string;
  output: string;
  shortcut: string;
}

const TABS: ScanTab[] = [
  {
    id: "ocr",
    title: "Text Extraction",
    icon: Eye,
    previewHeading: "Sample Document / Presentation Slide",
    previewDescription: "Non-selectable text inside an image, video, or remote window",
    sampleInput: `struct Jutsu {
  let name = "Gentle Fist: Sixty-Four Palms"
  let accuracy = 0.9998
  let latencyMs = 11
}`,
    output: `struct Jutsu {
  let name = "Gentle Fist: Sixty-Four Palms"
  let accuracy = 0.9998
  let latencyMs = 11
}`,
    shortcut: "⌘⇧2",
  },
  {
    id: "qr",
    title: "QR Code Reader",
    icon: QrCode,
    previewHeading: "On-Screen QR Code",
    previewDescription: "Wi-Fi setup, 2FA secret, or URL displayed on monitor",
    sampleInput: "WIFI:S:Konoha_Chakra_5G;T:WPA;P:byakugan-secure-2026;;",
    output: "WIFI:S:Konoha_Chakra_5G;T:WPA;P:byakugan-secure-2026;;",
    shortcut: "⌘⇧3",
  },
  {
    id: "barcode",
    title: "Barcode Scanner",
    icon: Barcode,
    previewHeading: "Retail & Hardware Packaging",
    previewDescription: "EAN-13, Code 128, or UPC displayed on screen",
    sampleInput: "[EAN-13] 8901030829145\n[SERIAL] BYK-ARM64-2026-X09",
    output: "[EAN-13] 8901030829145\n[SERIAL] BYK-ARM64-2026-X09",
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
        particleCount: 25,
        spread: 50,
        origin: { y: 0.8 },
        colors: ["#6366f1", "#a5b4fc", "#38bdf8"],
      });
    }, 550);
  };

  const handleCopy = () => {
    navigator.clipboard.writeText(currentTab.output);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className="w-full max-w-4xl mx-auto rounded-2xl bg-[#080a14] border border-white/10 p-6 sm:p-8 backdrop-blur-2xl relative overflow-hidden shadow-2xl">
      {/* Tab Selector Bar */}
      <div className="flex flex-wrap items-center justify-between gap-4 mb-6 pb-5 hairline-b">
        <div className="flex flex-wrap gap-2">
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
                className={`flex items-center gap-2 px-4 py-2 rounded-lg text-xs sm:text-sm font-semibold transition-all ${
                  isActive
                    ? "bg-white text-black shadow-md"
                    : "bg-white/5 text-slate-400 hover:text-white hover:bg-white/10"
                }`}
              >
                <Icon className="w-4 h-4" />
                <span>{tab.title}</span>
                <span className="font-mono text-[10px] opacity-60 ml-1">{tab.shortcut}</span>
              </button>
            );
          })}
        </div>

        <button
          onClick={triggerMockScan}
          disabled={isScanning}
          className="px-4 py-2 rounded-lg bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-semibold font-mono tracking-wider transition-all flex items-center gap-1.5 shadow-lg shadow-indigo-600/20 active:scale-95"
        >
          <Play className="w-3.5 h-3.5 fill-current" />
          <span>{isScanning ? "Scanning..." : "Test Capture"}</span>
        </button>
      </div>

      {/* Two-Pane Before / After Split */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6 items-stretch">
        {/* Left: What is on screen */}
        <div className="rounded-xl bg-[#04050a] border border-white/10 p-5 flex flex-col justify-between relative overflow-hidden min-h-[220px]">
          <div>
            <div className="text-[11px] font-mono text-slate-500 uppercase tracking-wider mb-2">
              Step 1: Drag over target
            </div>
            <div className="text-sm font-semibold text-white mb-1">
              {currentTab.previewHeading}
            </div>
            <div className="text-xs text-slate-400 mb-4">
              {currentTab.previewDescription}
            </div>

            {/* Simulated selected region */}
            <div className="p-3.5 rounded-lg bg-indigo-950/30 border border-indigo-500/40 font-mono text-xs text-slate-300 relative overflow-hidden">
              <pre className="whitespace-pre-wrap">{currentTab.sampleInput}</pre>

              {/* Animated scanning laser line */}
              <motion.div
                className="absolute left-0 right-0 h-[2px] bg-gradient-to-r from-transparent via-indigo-400 to-transparent shadow-[0_0_8px_#818cf8]"
                animate={{
                  top: ["0%", "100%", "0%"],
                }}
                transition={{
                  duration: 2.4,
                  repeat: Infinity,
                  ease: "easeInOut",
                }}
              />
            </div>
          </div>

          <div className="pt-3 hairline-t text-[11px] font-mono text-slate-500 flex justify-between">
            <span>Selection Box</span>
            <span className="text-teal-400">Ready</span>
          </div>
        </div>

        {/* Right: What gets copied to clipboard */}
        <div className="rounded-xl bg-[#04050a] border border-white/10 p-5 flex flex-col justify-between relative">
          <div>
            <div className="flex items-center justify-between text-[11px] font-mono text-slate-500 uppercase tracking-wider mb-2">
              <span>Step 2: Instant Clipboard</span>
              <button
                onClick={handleCopy}
                className="flex items-center gap-1 px-2.5 py-1 rounded bg-white/10 hover:bg-white/20 text-white text-xs font-semibold transition-all"
              >
                {copied ? <Check className="w-3 h-3 text-emerald-400" /> : <Copy className="w-3 h-3" />}
                <span>{copied ? "Copied" : "Copy"}</span>
              </button>
            </div>

            <div className="text-sm font-semibold text-white mb-3">
              Ready to paste (⌘ + V)
            </div>

            <AnimatePresence mode="wait">
              <motion.pre
                key={activeTab}
                initial={{ opacity: 0, y: 4 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: -4 }}
                transition={{ duration: 0.15 }}
                className="p-3.5 rounded-lg bg-black/60 border border-white/5 font-mono text-xs text-indigo-200 overflow-x-auto whitespace-pre-wrap leading-relaxed"
              >
                {currentTab.output}
              </motion.pre>
            </AnimatePresence>
          </div>

          <div className="pt-3 hairline-t text-[11px] font-mono text-slate-500 flex justify-between">
            <span>Audio Chime: Glass.aiff</span>
            <span className="text-emerald-400">✓ Auto-Copied</span>
          </div>
        </div>
      </div>
    </div>
  );
}
