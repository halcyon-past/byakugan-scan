"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import Image from "next/image";
import { Menu, X, ArrowUpRight, Terminal } from "lucide-react";

export default function EditorialHeader() {
  const [scrolled, setScrolled] = useState(false);
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [currentTime, setCurrentTime] = useState("");

  useEffect(() => {
    const handleScroll = () => {
      setScrolled(window.scrollY > 30);
    };
    window.addEventListener("scroll", handleScroll);

    // Live chronometer in user's local timezone (with graceful fallback to UTC)
    const updateTime = () => {
      const now = new Date();
      try {
        const formatter = new Intl.DateTimeFormat(undefined, {
          hour: "2-digit",
          minute: "2-digit",
          second: "2-digit",
          hour12: false,
          timeZoneName: "short",
        });
        const localFormatted = formatter.format(now);
        if (localFormatted) {
          setCurrentTime(localFormatted);
          return;
        }
      } catch {
        // Fall through to UTC fallback if local timezone detection fails
      }

      try {
        const utcHours = String(now.getUTCHours()).padStart(2, "0");
        const utcMinutes = String(now.getUTCMinutes()).padStart(2, "0");
        const utcSeconds = String(now.getUTCSeconds()).padStart(2, "0");
        setCurrentTime(`${utcHours}:${utcMinutes}:${utcSeconds} UTC`);
      } catch {
        setCurrentTime("12:00:00 UTC");
      }
    };
    updateTime();
    const interval = setInterval(updateTime, 1000);

    return () => {
      window.removeEventListener("scroll", handleScroll);
      clearInterval(interval);
    };
  }, []);

  return (
    <>
      {/* Top Editorial Ticker Bar (Halcyon Announcement Style) */}
      <div className="w-full bg-[#060814] hairline-b text-[11px] font-mono-tech tracking-wider text-slate-300 py-1.5 px-4 overflow-hidden z-50 relative select-none">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-3">
            <span className="inline-block w-1.5 h-1.5 rounded-full bg-teal-400 animate-ping" />
            <span className="text-white font-bold">NEO-VISION PROTOCOL 1.0</span>
            <span className="hidden sm:inline text-slate-600">/</span>
            <span className="hidden sm:inline text-slate-300 font-medium">ON-DEVICE OCR & BARCODE ENGINE</span>
          </div>

          <div className="flex items-center gap-4">
            <span className="text-slate-300 hidden md:inline font-mono">{currentTime}</span>
            <span className="text-slate-600 hidden md:inline">/</span>
            <span className="text-teal-300 font-bold">100% PRIVATE & OFFLINE</span>
          </div>
        </div>
      </div>

      {/* Main Sticky Navigation */}
      <header
        className={`sticky top-0 z-40 w-full transition-all duration-300 ${
          scrolled
            ? "bg-[#080a18]/95 backdrop-blur-md hairline-b py-3.5 shadow-2xl"
            : "bg-transparent hairline-b py-5"
        }`}
      >
        <div className="max-w-7xl mx-auto px-6 flex items-center justify-between">
          {/* Logo Lockup */}
          <Link href="/" className="flex items-center gap-3 group">
            <div className="w-8 h-8 rounded-lg overflow-hidden border border-white/20 group-hover:border-indigo-400/80 transition-colors bg-black flex items-center justify-center">
              <Image
                src="/as-icon-dark.png"
                alt="Byakugan Scan Monogram"
                width={28}
                height={28}
                className="w-7 h-7 object-contain group-hover:scale-105 transition-transform"
              />
            </div>
            <div className="flex flex-col">
              <span className="font-editorial-display text-2xl font-bold uppercase tracking-tight text-white leading-none">
                Byakugan Scan
              </span>
              <span className="text-[9px] font-mono-tech uppercase tracking-widest text-slate-300 font-semibold -mt-0.5">
                白眼 // All-Seeing Eye
              </span>
            </div>
          </Link>

          {/* Desktop Editorial Navigation Links */}
          <nav className="hidden lg:flex items-center gap-10 text-[13px] font-medium tracking-wide text-slate-200">
            <Link
              href="/#editorial-proof"
              className="hover:text-white transition-colors relative py-1"
            >
              01 // The Philosophy
            </Link>
            <Link
              href="/#features"
              className="hover:text-white transition-colors relative py-1"
            >
              02 // Capabilities
            </Link>
            <Link
              href="/#shortcuts"
              className="hover:text-white transition-colors relative py-1"
            >
              03 // Keybinds
            </Link>
            <Link
              href="/#interactive-hud"
              className="hover:text-white transition-colors relative py-1"
            >
              04 // Live Simulator
            </Link>
            <Link
              href="/privacy"
              className="hover:text-white transition-colors relative py-1 text-slate-300"
            >
              Privacy
            </Link>
            <Link
              href="/terms"
              className="hover:text-white transition-colors relative py-1 text-slate-300"
            >
              Terms
            </Link>
          </nav>

          {/* Actions & Download */}
          <div className="hidden sm:flex items-center gap-4">
            <a
              href="https://github.com/halcyon-past/byakugan-scan"
              target="_blank"
              rel="noopener noreferrer"
              className="text-xs font-mono-tech text-slate-300 hover:text-white transition-colors flex items-center gap-1"
            >
              <span>GitHub</span>
              <ArrowUpRight className="w-3.5 h-3.5" />
            </a>

            <a
              href="https://github.com/halcyon-past/byakugan-scan"
              target="_blank"
              rel="noopener noreferrer"
              className="px-4 py-2 text-xs font-bold uppercase tracking-wider text-black bg-white hover:bg-slate-100 rounded transition-all active:scale-95 shadow-md font-mono-tech"
            >
              Get For Mac
            </a>
          </div>

          {/* Mobile Menu Trigger */}
          <button
            onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
            className="lg:hidden p-2 text-slate-300 hover:text-white focus:outline-none"
            aria-label="Toggle Navigation"
          >
            {mobileMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
          </button>
        </div>

        {/* Mobile Navigation Drawer */}
        {mobileMenuOpen && (
          <div className="lg:hidden bg-[#07080d] hairline-b px-6 py-8 space-y-6">
            <div className="flex flex-col space-y-4 text-base font-medium text-slate-200">
              <Link
                href="/#editorial-proof"
                onClick={() => setMobileMenuOpen(false)}
                className="hover:text-white"
              >
                01 // The Philosophy
              </Link>
              <Link
                href="/#features"
                onClick={() => setMobileMenuOpen(false)}
                className="hover:text-white"
              >
                02 // Capabilities
              </Link>
              <Link
                href="/#shortcuts"
                onClick={() => setMobileMenuOpen(false)}
                className="hover:text-white"
              >
                03 // Keybinds
              </Link>
              <Link
                href="/#interactive-hud"
                onClick={() => setMobileMenuOpen(false)}
                className="hover:text-white"
              >
                04 // Live Simulator
              </Link>
              <Link
                href="/privacy"
                onClick={() => setMobileMenuOpen(false)}
                className="text-slate-400 hover:text-white"
              >
                Privacy Policy
              </Link>
              <Link
                href="/terms"
                onClick={() => setMobileMenuOpen(false)}
                className="text-slate-400 hover:text-white"
              >
                Terms of Service
              </Link>
            </div>

            <div className="pt-4 hairline-t flex flex-col gap-3">
              <a
                href="https://github.com/halcyon-past/byakugan-scan"
                target="_blank"
                rel="noopener noreferrer"
                className="w-full text-center py-3 text-xs font-semibold uppercase tracking-wider text-black bg-white rounded font-mono-tech"
              >
                Download Byakugan Scan
              </a>
            </div>
          </div>
        )}
      </header>
    </>
  );
}
