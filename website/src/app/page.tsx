import Image from "next/image";
import Link from "next/link";
import { Eye, QrCode, Barcode, Clipboard, Clock, ShieldCheck, Zap, Keyboard, ArrowRight } from "lucide-react";

export default function Home() {
  return (
    <div className="relative overflow-hidden">
      {/* Background glow effects */}
      <div className="absolute top-20 left-1/2 -translate-x-1/2 w-[700px] h-[350px] bg-indigo-600/20 blur-[130px] rounded-full -z-10 pointer-events-none" />

      {/* Hero Section */}
      <section className="pt-24 pb-16 px-6 text-center max-w-5xl mx-auto">
        <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-indigo-950/60 border border-indigo-500/30 text-indigo-300 text-xs font-semibold mb-8">
          <Zap className="w-3.5 h-3.5 text-indigo-400" />
          <span>Designed for macOS 14+ Sonoma & Sequoia</span>
        </div>

        <h1 className="text-4xl sm:text-6xl md:text-7xl font-extrabold tracking-tight text-white mb-6 leading-[1.1]">
          The All-Seeing Eye for<br />
          <span className="bg-gradient-to-r from-indigo-400 via-purple-300 to-indigo-200 bg-clip-text text-transparent">
            Text & Codes on Your Mac
          </span>
        </h1>

        <p className="text-lg sm:text-xl text-slate-400 max-w-2xl mx-auto mb-10 leading-relaxed font-normal">
          Extract unselectable text from images, YouTube videos, slide decks, and locked PDFs in milliseconds. Decode QR codes and barcodes straight from your display with a single hotkey.
        </p>

        <div className="flex flex-wrap items-center justify-center gap-4 mb-16">
          <a
            href="https://github.com/halcyon-past/byakugan-scan"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-2 px-6 py-3.5 rounded-full font-semibold text-white bg-indigo-600 hover:bg-indigo-500 shadow-xl shadow-indigo-600/30 transition-all hover:-translate-y-0.5"
          >
            Download for macOS
            <ArrowRight className="w-4 h-4" />
          </a>
          <a
            href="https://github.com/halcyon-past/byakugan-scan"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-2 px-6 py-3.5 rounded-full font-semibold text-slate-300 bg-slate-900 border border-slate-800 hover:bg-slate-800 hover:text-white transition-all"
          >
            View on GitHub
          </a>
        </div>

        {/* App Preview Card */}
        <div className="glass-card rounded-2xl p-6 sm:p-10 max-w-4xl mx-auto shadow-2xl text-left border border-indigo-500/20">
          <div className="grid grid-cols-1 md:grid-cols-[140px_1fr] gap-8 items-center">
            <div className="flex flex-col items-center">
              <Image
                src="/app-icon.jpg"
                alt="Byakugan Scan App Icon"
                width={130}
                height={130}
                className="w-28 h-28 sm:w-32 sm:h-32 rounded-3xl shadow-2xl shadow-indigo-900/50 object-cover"
              />
              <div className="mt-3 flex items-center gap-1.5 text-xs text-slate-400">
                <Image src="/as-icon-dark.png" alt="AS Icon" width={14} height={14} />
                <span>Menu Bar Utility</span>
              </div>
            </div>

            <div>
              <h3 className="text-xl sm:text-2xl font-bold text-white mb-2">
                Lightweight. Instant. 100% On-Device.
              </h3>
              <p className="text-slate-400 text-sm sm:text-base leading-relaxed mb-5">
                Byakugan Scan sits discretely in your macOS menu bar with zero dock clutter. Press your global hotkey, drag the crosshair over any screen region, and paste the extracted content anywhere in seconds.
              </p>
              <div className="flex flex-wrap gap-2.5">
                <span className="px-3 py-1 rounded-lg bg-slate-800/80 border border-slate-700/60 font-mono text-xs text-indigo-300 font-bold">
                  ⌘⇧2 Text OCR
                </span>
                <span className="px-3 py-1 rounded-lg bg-slate-800/80 border border-slate-700/60 font-mono text-xs text-teal-300 font-bold">
                  ⌘⇧3 QR Code
                </span>
                <span className="px-3 py-1 rounded-lg bg-slate-800/80 border border-slate-700/60 font-mono text-xs text-orange-300 font-bold">
                  ⌘⇧4 Barcode
                </span>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="py-24 px-6 max-w-6xl mx-auto">
        <div className="text-center mb-16">
          <div className="text-xs font-bold uppercase tracking-widest text-indigo-400 mb-2">Features</div>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-white">Everything you need to capture your screen</h2>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div className="glass-card rounded-xl p-8 hover:-translate-y-1 transition-all">
            <div className="w-12 h-12 rounded-xl bg-indigo-500/10 flex items-center justify-center text-indigo-400 mb-5">
              <Eye className="w-6 h-6" />
            </div>
            <h3 className="text-lg font-bold text-white mb-2">High-Precision Text OCR</h3>
            <p className="text-slate-400 text-sm leading-relaxed">
              Extract uncopyable text from images, video frames, presentations, and remote sessions with Apple Vision neural models.
            </p>
          </div>

          <div className="glass-card rounded-xl p-8 hover:-translate-y-1 transition-all">
            <div className="w-12 h-12 rounded-xl bg-teal-500/10 flex items-center justify-center text-teal-400 mb-5">
              <QrCode className="w-6 h-6" />
            </div>
            <h3 className="text-lg font-bold text-white mb-2">Instant QR Code Scanner</h3>
            <p className="text-slate-400 text-sm leading-relaxed">
              Read any QR code visible on your screen directly into URLs, contact info, 2FA setup codes, or Wi-Fi credentials.
            </p>
          </div>

          <div className="glass-card rounded-xl p-8 hover:-translate-y-1 transition-all">
            <div className="w-12 h-12 rounded-xl bg-orange-500/10 flex items-center justify-center text-orange-400 mb-5">
              <Barcode className="w-6 h-6" />
            </div>
            <h3 className="text-lg font-bold text-white mb-2">13+ Barcode Formats</h3>
            <p className="text-slate-400 text-sm leading-relaxed">
              Decode commercial and industrial barcodes: EAN-13, UPC-E, Code 128, Code 39, Data Matrix, Aztec, PDF417, and more.
            </p>
          </div>

          <div className="glass-card rounded-xl p-8 hover:-translate-y-1 transition-all">
            <div className="w-12 h-12 rounded-xl bg-purple-500/10 flex items-center justify-center text-purple-400 mb-5">
              <Clipboard className="w-6 h-6" />
            </div>
            <h3 className="text-lg font-bold text-white mb-2">Clipboard Automation</h3>
            <p className="text-slate-400 text-sm leading-relaxed">
              Auto-copies extracted text directly with audio confirmation. Configure smart whitespace trimming and line joining.
            </p>
          </div>

          <div className="glass-card rounded-xl p-8 hover:-translate-y-1 transition-all">
            <div className="w-12 h-12 rounded-xl bg-blue-500/10 flex items-center justify-center text-blue-400 mb-5">
              <Clock className="w-6 h-6" />
            </div>
            <h3 className="text-lg font-bold text-white mb-2">Local History & Favorites</h3>
            <p className="text-slate-400 text-sm leading-relaxed">
              All scans are saved strictly locally. Search, favorite, and copy past items right from the menu bar popover.
            </p>
          </div>

          <div className="glass-card rounded-xl p-8 hover:-translate-y-1 transition-all">
            <div className="w-12 h-12 rounded-xl bg-emerald-500/10 flex items-center justify-center text-emerald-400 mb-5">
              <ShieldCheck className="w-6 h-6" />
            </div>
            <h3 className="text-lg font-bold text-white mb-2">Zero Telemetry & 100% Offline</h3>
            <p className="text-slate-400 text-sm leading-relaxed">
              Your screen pixels never leave your Mac. No network requests, no remote servers, no analytics, and no tracking.
            </p>
          </div>
        </div>
      </section>

      {/* Shortcuts Section */}
      <section id="shortcuts" className="py-20 px-6 border-y border-indigo-950/60 bg-[#0d0f1a]">
        <div className="max-w-4xl mx-auto">
          <div className="text-center mb-12">
            <div className="text-xs font-bold uppercase tracking-widest text-indigo-400 mb-2">Global Hotkeys</div>
            <h2 className="text-3xl font-extrabold text-white">Work at the speed of thought</h2>
          </div>

          <div className="space-y-4">
            <div className="flex items-center justify-between p-5 rounded-xl bg-[#0a0b12] border border-indigo-900/40">
              <div>
                <div className="font-semibold text-white">Capture Text (OCR)</div>
                <div className="text-xs text-slate-400">Extract unselectable text from any dragged region</div>
              </div>
              <span className="font-mono text-sm font-bold text-indigo-300 px-3 py-1.5 bg-indigo-950/60 border border-indigo-700/50 rounded-lg">
                ⌘ + Shift + 2
              </span>
            </div>

            <div className="flex items-center justify-between p-5 rounded-xl bg-[#0a0b12] border border-indigo-900/40">
              <div>
                <div className="font-semibold text-white">Scan QR Code</div>
                <div className="text-xs text-slate-400">Decode QR codes directly from your display</div>
              </div>
              <span className="font-mono text-sm font-bold text-teal-300 px-3 py-1.5 bg-teal-950/60 border border-teal-700/50 rounded-lg">
                ⌘ + Shift + 3
              </span>
            </div>

            <div className="flex items-center justify-between p-5 rounded-xl bg-[#0a0b12] border border-indigo-900/40">
              <div>
                <div className="font-semibold text-white">Scan Barcode</div>
                <div className="text-xs text-slate-400">Read 1D and 2D industrial barcode types</div>
              </div>
              <span className="font-mono text-sm font-bold text-orange-300 px-3 py-1.5 bg-orange-950/60 border border-orange-700/50 rounded-lg">
                ⌘ + Shift + 4
              </span>
            </div>
          </div>
        </div>
      </section>

      {/* How It Works Section */}
      <section id="how-it-works" className="py-24 px-6 max-w-5xl mx-auto text-center">
        <div className="mb-16">
          <div className="text-xs font-bold uppercase tracking-widest text-indigo-400 mb-2">Workflow</div>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-white">3 Steps to Instant Capture</h2>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div className="glass-card rounded-2xl p-8">
            <div className="w-10 h-10 rounded-full bg-indigo-600 text-white font-bold flex items-center justify-center mx-auto mb-4">
              1
            </div>
            <h3 className="font-bold text-lg text-white mb-2">Press Shortcut</h3>
            <p className="text-slate-400 text-sm">
              Press ⌘⇧2 or click the Byakugan eye icon in your menu bar to trigger interactive selection.
            </p>
          </div>

          <div className="glass-card rounded-2xl p-8">
            <div className="w-10 h-10 rounded-full bg-indigo-600 text-white font-bold flex items-center justify-center mx-auto mb-4">
              2
            </div>
            <h3 className="font-bold text-lg text-white mb-2">Select Region</h3>
            <p className="text-slate-400 text-sm">
              Click and drag the crosshairs over any text, QR code, or barcode on your monitor.
            </p>
          </div>

          <div className="glass-card rounded-2xl p-8">
            <div className="w-10 h-10 rounded-full bg-indigo-600 text-white font-bold flex items-center justify-center mx-auto mb-4">
              3
            </div>
            <h3 className="font-bold text-lg text-white mb-2">Paste Anywhere</h3>
            <p className="text-slate-400 text-sm">
              Text or decoded data is instantly placed in your clipboard. Hit ⌘V to paste!
            </p>
          </div>
        </div>
      </section>

      {/* FAQ Section */}
      <section id="faq" className="py-20 px-6 max-w-4xl mx-auto">
        <div className="text-center mb-16">
          <div className="text-xs font-bold uppercase tracking-widest text-indigo-400 mb-2">FAQ</div>
          <h2 className="text-3xl font-extrabold text-white">Frequently Asked Questions</h2>
        </div>

        <div className="space-y-6">
          <div className="border-b border-indigo-950/80 pb-6">
            <h4 className="text-lg font-semibold text-white mb-2">Why is Screen Recording permission required?</h4>
            <p className="text-slate-400 text-sm leading-relaxed">
              macOS requires this permission for any application that reads pixels on your screen. Byakugan Scan only captures the exact rectangular coordinate box you drag your crosshair over, processes the pixels in RAM with Apple Vision, and discards them immediately.
            </p>
          </div>

          <div className="border-b border-indigo-950/80 pb-6">
            <h4 className="text-lg font-semibold text-white mb-2">Does Byakugan Scan work offline?</h4>
            <p className="text-slate-400 text-sm leading-relaxed">
              Yes, 100% offline. The app contains no networking capabilities. All OCR, QR, and barcode recognition runs locally via Apple's Vision framework and Neural Engine.
            </p>
          </div>

          <div className="border-b border-indigo-950/80 pb-6">
            <h4 className="text-lg font-semibold text-white mb-2">Can I remap the keyboard shortcuts?</h4>
            <p className="text-slate-400 text-sm leading-relaxed">
              Yes. Open the Settings window from the menu bar popover to configure custom shortcut keys for text, QR, and barcode scanning.
            </p>
          </div>
        </div>
      </section>
    </div>
  );
}
