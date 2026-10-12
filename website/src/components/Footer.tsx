import Link from "next/link";
import Image from "next/image";
import { ArrowUpRight, Github, Mail, ShieldCheck, Heart } from "lucide-react";

export default function Footer() {
  return (
    <footer className="border-t border-white/10 bg-[#060814] text-slate-300 text-sm py-16 relative overflow-hidden">
      {/* Subtle background chakra line */}
      <div className="absolute top-0 left-0 right-0 h-[1px] bg-gradient-to-r from-transparent via-indigo-500/40 to-transparent" />

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
              <span className="font-bold text-xl text-white tracking-tight">Byakugan Scan</span>
            </Link>
            <p className="text-slate-200 text-sm max-w-md leading-relaxed mb-6 font-normal">
              The high-performance screen text capture, QR code, and barcode scanning utility engineered natively for macOS. Powered exclusively on-device by Apple Vision.
            </p>

            <div className="flex items-center gap-2 text-xs font-mono text-slate-300">
              <span className="w-2 h-2 rounded-full bg-emerald-400" />
              <span>Production Version 1.0.0 (Apple Silicon & Intel)</span>
            </div>
          </div>

          {/* Product Links */}
          <div>
            <div className="text-xs font-bold uppercase tracking-wider text-white mb-4 font-mono">
              Product
            </div>
            <ul className="space-y-2.5 text-sm">
              <li>
                <Link href="/#features" className="text-slate-200 hover:text-white transition-colors">
                  Core Capabilities
                </Link>
              </li>
              <li>
                <Link href="/#shortcuts" className="text-slate-200 hover:text-white transition-colors">
                  Global Shortcuts
                </Link>
              </li>
              <li>
                <Link href="/#interactive-hud" className="text-slate-200 hover:text-white transition-colors">
                  Workflow
                </Link>
              </li>
              <li>
                <Link href="/#shortcuts" className="text-slate-200 hover:text-white transition-colors">
                  FAQ & Permissions
                </Link>
              </li>
            </ul>
          </div>

          {/* Legal & Author */}
          <div>
            <div className="text-xs font-bold uppercase tracking-wider text-white mb-4 font-mono">
              Legal & Creator
            </div>
            <ul className="space-y-2.5 text-sm">
              <li>
                <Link href="/privacy" className="text-slate-200 hover:text-white transition-colors">
                  Privacy Policy
                </Link>
              </li>
              <li>
                <Link href="/terms" className="text-slate-200 hover:text-white transition-colors">
                  Terms of Service
                </Link>
              </li>
              <li>
                <a
                  href="mailto:aritrosaha2025@gmail.com"
                  className="text-slate-200 hover:text-white transition-colors inline-flex items-center gap-1.5"
                >
                  <Mail className="w-3.5 h-3.5 text-indigo-300" />
                  <span>Support Email</span>
                </a>
              </li>
              <li>
                <a
                  href="https://github.com/halcyon-past/byakugan-scan"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-slate-200 hover:text-white transition-colors inline-flex items-center gap-1.5"
                >
                  <Github className="w-3.5 h-3.5 text-indigo-300" />
                  <span>GitHub Repository</span>
                </a>
              </li>
            </ul>
          </div>
        </div>

        {/* Bottom Attribution Bar */}
        <div className="pt-8 border-t border-white/10 flex flex-col sm:flex-row items-center justify-between gap-4 text-xs text-slate-300">
          <div className="flex items-center gap-2">
            <span>© 2026 Byakugan Scan. All rights reserved.</span>
          </div>

          {/* Explicit Creator Attribution */}
          <div className="flex items-center gap-1.5 text-slate-300 font-medium">
            <span>Created by</span>
            <a
              href="https://aritro.cloud"
              target="_blank"
              rel="noopener noreferrer"
              className="font-bold text-indigo-300 hover:text-white transition-colors inline-flex items-center gap-0.5 underline decoration-indigo-400/60 underline-offset-4"
            >
              <span>Aritro Saha</span>
              <ArrowUpRight className="w-3.5 h-3.5" />
            </a>
            <span className="text-slate-600">|</span>
            <a
              href="https://aritro.cloud"
              target="_blank"
              rel="noopener noreferrer"
              className="text-slate-300 hover:text-white transition-colors font-medium"
            >
              aritro.cloud
            </a>
          </div>
        </div>
      </div>
    </footer>
  );
}
