"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import Image from "next/image";
import { Menu, X, ArrowUpRight, Terminal, Star, GitFork, Github } from "lucide-react";
import { APP_DOWNLOAD_URL, GITHUB_REPO_URL } from "@/constants/links";

export default function EditorialHeader() {
  const [scrolled, setScrolled] = useState(false);
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [currentTime, setCurrentTime] = useState("");
  const [repoStats, setRepoStats] = useState<{ stars: number; forks: number } | null>(null);

  useEffect(() => {
    // Fetch repository stars and forks
    fetch("https://api.github.com/repos/halcyon-past/byakugan-scan", {
      headers: { Accept: "application/vnd.github.v3+json" },
    })
      .then((res) => (res.ok ? res.json() : null))
      .then((data) => {
        if (data && typeof data.stargazers_count === "number") {
          setRepoStats({
            stars: data.stargazers_count,
            forks: data.forks_count,
          });
        }
      })
      .catch(() => {
        // Fallback gracefully on rate limits or offline
      });
  }, []);

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
      {/* Top Editorial Ticker Bar (Calm Announcement Style) */}
      <div className="w-full bg-[#0a0b12] hairline-b text-xs font-mono text-slate-400 py-1.5 px-4 overflow-hidden z-50 relative select-none">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-3">
            <span className="inline-block w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse" />
            <span className="text-slate-200 font-medium">Native OCR & Barcode Utility</span>
            <span className="hidden sm:inline text-white/20">•</span>
            <span className="hidden sm:inline text-slate-400 font-normal">macOS 14+ Sonoma & Sequoia</span>
          </div>

          <div className="flex items-center gap-4">
            <span className="text-slate-400 hidden md:inline font-mono">{currentTime}</span>
            <span className="text-white/20 hidden md:inline">•</span>
            <span className="text-pink-300 font-medium">100% On-Device & Offline</span>
          </div>
        </div>
      </div>

      {/* Main Sticky Navigation */}
      <header
        className={`sticky top-0 z-40 w-full transition-all duration-300 ${
          scrolled
            ? "bg-[#0a0b12]/95 backdrop-blur-md hairline-b py-3 shadow-lg"
            : "bg-transparent hairline-b py-4"
        }`}
      >
        <div className="max-w-7xl mx-auto px-6 flex items-center justify-between">
          {/* Logo Lockup */}
          <Link href="/" className="flex items-center gap-3 group">
            <div className="w-8 h-8 rounded-lg overflow-hidden border border-white/10 group-hover:border-pink-500/40 transition-colors bg-black flex items-center justify-center">
              <Image
                src="/as-icon-dark.png"
                alt="Byakugan Scan Monogram"
                width={28}
                height={28}
                className="w-7 h-7 object-contain group-hover:scale-105 transition-transform"
              />
            </div>
            <div className="flex flex-col">
              <span className="text-lg font-bold text-slate-100 tracking-tight leading-tight">
                Byakugan Scan
              </span>
              <span className="text-[10px] text-pink-300 font-medium tracking-wide">
                白眼 // All-Seeing Vision
              </span>
            </div>
          </Link>

          {/* Clean, Spacious Navigation Links */}
          <nav className="hidden md:flex items-center gap-8 text-sm font-medium text-slate-300">
            <Link
              href="/#philosophy"
              className="hover:text-white transition-colors py-1"
            >
              Philosophy
            </Link>
            <Link
              href="/#capabilities"
              className="hover:text-white transition-colors py-1"
            >
              Capabilities
            </Link>
            <Link
              href="/#specs"
              className="hover:text-white transition-colors py-1"
            >
              Specs
            </Link>
            <Link
              href="/privacy"
              className="hover:text-white transition-colors py-1"
            >
              Privacy
            </Link>
            <Link
              href="/terms"
              className="hover:text-white transition-colors py-1"
            >
              Terms
            </Link>
          </nav>

          {/* Actions & Download */}
          <div className="hidden sm:flex items-center gap-3">
            <a
              href={GITHUB_REPO_URL}
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-2 px-3 py-1.5 rounded-lg bg-white/[0.04] hover:bg-white/[0.08] border border-white/10 hover:border-pink-500/30 text-xs font-mono text-slate-300 hover:text-white transition-all group shadow-sm"
              title="View Byakugan Scan on GitHub"
            >
              <Github className="w-3.5 h-3.5 text-slate-300 group-hover:text-pink-300 transition-colors" />
              <span className="font-semibold text-slate-200">GitHub</span>
              <div className="flex items-center gap-2 pl-2 border-l border-white/10 text-slate-400 group-hover:text-slate-300">
                <span className="inline-flex items-center gap-1 text-[11px]" title="Stars">
                  <Star className="w-3 h-3 text-amber-400 fill-amber-400/20" />
                  <span>{repoStats ? repoStats.stars : "—"}</span>
                </span>
                <span className="inline-flex items-center gap-1 text-[11px]" title="Forks">
                  <GitFork className="w-3 h-3 text-sky-400" />
                  <span>{repoStats ? repoStats.forks : "—"}</span>
                </span>
              </div>
            </a>

            <a
              href={APP_DOWNLOAD_URL}
              className="px-4 py-2 text-xs font-semibold text-white bg-gradient-to-r from-fuchsia-600 to-pink-600 hover:from-fuchsia-500 hover:to-pink-500 rounded-lg transition-all active:scale-95 shadow-md shadow-pink-600/20 flex items-center gap-1.5"
            >
              <span>Get For Mac</span>
              <ArrowUpRight className="w-3.5 h-3.5" />
            </a>
          </div>

          {/* Mobile Menu Trigger */}
          <button
            onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
            className="md:hidden p-2 text-slate-300 hover:text-white focus:outline-none"
            aria-label="Toggle Navigation"
          >
            {mobileMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6 text-pink-300" />}
          </button>
        </div>

        {/* Mobile Navigation Drawer */}
        {mobileMenuOpen && (
          <div className="md:hidden bg-[#0c0412] hairline-b px-6 py-6 space-y-5">
            <div className="flex flex-col space-y-3.5 text-base font-medium text-slate-200">
              <Link
                href="/#philosophy"
                onClick={() => setMobileMenuOpen(false)}
                className="hover:text-pink-300 transition-colors"
              >
                Philosophy
              </Link>
              <Link
                href="/#capabilities"
                onClick={() => setMobileMenuOpen(false)}
                className="hover:text-pink-300 transition-colors"
              >
                Capabilities
              </Link>
              <Link
                href="/#specs"
                onClick={() => setMobileMenuOpen(false)}
                onClickCapture={() => setMobileMenuOpen(false)}
                className="hover:text-pink-300 transition-colors"
              >
                Specs
              </Link>
              <Link
                href="/privacy"
                onClick={() => setMobileMenuOpen(false)}
                className="text-slate-300 hover:text-pink-300 transition-colors"
              >
                Privacy Policy
              </Link>
              <Link
                href="/terms"
                onClick={() => setMobileMenuOpen(false)}
                className="text-slate-300 hover:text-pink-300 transition-colors"
              >
                Terms of Service
              </Link>
            </div>

            <div className="pt-4 hairline-t flex flex-col gap-3">
              <a
                href={APP_DOWNLOAD_URL}
                className="w-full text-center py-2.5 text-xs font-bold uppercase tracking-wider text-white bg-gradient-to-r from-fuchsia-600 to-pink-600 rounded font-mono-tech shadow-md"
              >
                Download Byakugan Scan
              </a>

              <a
                href={GITHUB_REPO_URL}
                target="_blank"
                rel="noopener noreferrer"
                className="w-full flex items-center justify-center gap-3 py-2 px-3 rounded bg-white/[0.04] border border-white/10 text-xs font-mono text-slate-300 hover:text-white"
              >
                <Github className="w-3.5 h-3.5 text-pink-300" />
                <span className="font-semibold">GitHub</span>
                <div className="flex items-center gap-2 pl-2 border-l border-white/10 text-slate-400">
                  <span className="inline-flex items-center gap-1 text-[11px]">
                    <Star className="w-3 h-3 text-amber-400 fill-amber-400/20" />
                    <span>{repoStats ? repoStats.stars : "—"}</span>
                  </span>
                  <span className="inline-flex items-center gap-1 text-[11px]">
                    <GitFork className="w-3 h-3 text-sky-400" />
                    <span>{repoStats ? repoStats.forks : "—"}</span>
                  </span>
                </div>
              </a>
            </div>
          </div>
        )}
      </header>
    </>
  );
}
