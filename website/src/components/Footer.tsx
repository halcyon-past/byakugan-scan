import Link from "next/link";
import Image from "next/image";
import { ArrowUpRight, Github, Mail } from "lucide-react";

export default function Footer() {
  return (
    <footer className="border-t border-white/[0.08] bg-[#0a0b12] text-slate-300 text-sm py-16 relative overflow-hidden">
      <div className="max-w-6xl mx-auto px-6">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-10 mb-12">
          {/* Brand Col */}
          <div className="md:col-span-2">
            <Link href="/" className="inline-flex items-center gap-3 mb-4">
              <Image
                src="/as-icon-dark.png"
                alt="Byakugan Scan"
                width={36}
                height={36}
                className="w-9 h-9"
              />
              <span className="font-bold text-xl text-slate-100 tracking-tight">Byakugan Scan</span>
            </Link>
            <p className="text-slate-300 text-sm max-w-md leading-relaxed mb-6 font-normal">
              The high-performance screen text capture, QR code, and barcode scanning utility engineered natively for macOS. Powered exclusively on-device by Apple Vision.
            </p>

            <div className="flex items-center gap-2 text-xs font-mono text-slate-400">
              <span className="w-2 h-2 rounded-full bg-emerald-400" />
              <span>Production Version 1.0.9 (Universal Apple Silicon & Intel)</span>
            </div>
          </div>

          {/* Product Links */}
          <div>
            <div className="text-xs font-semibold uppercase tracking-wider text-slate-400 mb-4 font-mono">
              Product
            </div>
            <ul className="space-y-2.5 text-sm">
              <li>
                <Link href="/#philosophy" className="text-slate-300 hover:text-white transition-colors">
                  The Philosophy
                </Link>
              </li>
              <li>
                <Link href="/#capabilities" className="text-slate-300 hover:text-white transition-colors">
                  Capabilities
                </Link>
              </li>
              <li>
                <Link href="/#specs" className="text-slate-300 hover:text-white transition-colors">
                  Specs & Permissions
                </Link>
              </li>
              <li>
                <Link href="/support" className="text-slate-300 hover:text-white transition-colors">
                  Support & FAQ
                </Link>
              </li>
            </ul>
          </div>

          {/* Legal & Author */}
          <div>
            <div className="text-xs font-semibold uppercase tracking-wider text-slate-400 mb-4 font-mono">
              Legal & Creator
            </div>
            <ul className="space-y-2.5 text-sm">
              <li>
                <Link href="/support" className="text-slate-300 hover:text-white transition-colors">
                  Help Center & FAQ
                </Link>
              </li>
              <li>
                <Link href="/privacy" className="text-slate-300 hover:text-white transition-colors">
                  Privacy Policy
                </Link>
              </li>
              <li>
                <Link href="/terms" className="text-slate-300 hover:text-white transition-colors">
                  Terms of Service
                </Link>
              </li>
              <li>
                <a
                  href="mailto:aritrosaha2025@gmail.com"
                  className="text-slate-300 hover:text-white transition-colors inline-flex items-center gap-1.5"
                >
                  <Mail className="w-3.5 h-3.5 text-pink-400" />
                  <span>Support Email</span>
                </a>
              </li>
              <li>
                <a
                  href="https://github.com/halcyon-past/byakugan-scan"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-slate-300 hover:text-white transition-colors inline-flex items-center gap-1.5"
                >
                  <Github className="w-3.5 h-3.5 text-pink-400" />
                  <span>GitHub Repository</span>
                </a>
              </li>
              <li>
                <a
                  href="/llms.txt"
                  className="text-slate-400 hover:text-pink-300 transition-colors font-mono text-xs"
                >
                  llms.txt (AI / LLM Index)
                </a>
              </li>
            </ul>
          </div>
        </div>

        {/* Bottom Attribution Bar */}
        <div className="pt-8 border-t border-white/[0.08] flex flex-col sm:flex-row items-center justify-between gap-4 text-xs text-slate-400">
          <div className="flex items-center gap-2">
            <span>© 2026 Byakugan Scan. All rights reserved.</span>
          </div>

          {/* Explicit Creator Attribution */}
          <div className="flex flex-wrap items-center gap-1.5 text-slate-400 font-medium">
            <span>Created by</span>
            <a
              href="https://www.aritro.cloud/"
              target="_blank"
              rel="author me noopener noreferrer"
              className="font-bold text-pink-300 hover:text-white transition-colors inline-flex items-center gap-0.5 underline decoration-pink-500/40 underline-offset-4"
            >
              <span>Aritro Saha</span>
              <ArrowUpRight className="w-3.5 h-3.5" />
            </a>
            <span className="text-slate-600">|</span>
            <a
              href="https://www.aritro.cloud/"
              target="_blank"
              rel="noopener noreferrer"
              className="text-slate-400 hover:text-white transition-colors"
            >
              aritro.cloud
            </a>
            <span className="text-slate-600">|</span>
            <a
              href="https://www.wikidata.org/wiki/Q141715213"
              target="_blank"
              rel="me noopener noreferrer"
              className="text-slate-500 hover:text-pink-300 transition-colors font-mono text-[11px]"
              title="Aritro Saha — Wikidata Q141715213"
            >
              Q141715213
            </a>
          </div>
        </div>
      </div>
    </footer>
  );
}
