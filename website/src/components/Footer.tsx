import Link from "next/link";
import Image from "next/image";
import { ArrowUpRight, Github, Mail, ShieldCheck, Heart } from "lucide-react";

export default function Footer() {
  return (
    <footer className="border-t border-indigo-950/70 bg-[#04050a] text-slate-400 text-sm py-16 relative overflow-hidden">
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
              <span className="font-bold text-lg text-white tracking-tight">Byakugan Scan</span>
            </Link>
            <p className="text-slate-400 text-sm max-w-md leading-relaxed mb-6">
              The high-performance screen text capture, QR code, and barcode scanning utility engineered natively for macOS. Powered exclusively on-device by Apple Vision.
            </p>

            <div className="flex items-center gap-2 text-xs font-mono text-slate-500">
              <span className="w-2 h-2 rounded-full bg-emerald-500" />
              <span>Production Version 1.0.0 (Apple Silicon & Intel)</span>
            </div>
          </div>

          {/* Product Links */}
          <div>
            <div className="text-xs font-bold uppercase tracking-wider text-slate-200 mb-4 font-mono">
              Product
            </div>
            <ul className="space-y-2.5 text-sm">
              <li>
                <Link href="/#features" className="hover:text-indigo-300 transition-colors">
                  Core Capabilities
                </Link>
              </li>
              <li>
                <Link href="/#shortcuts" className="hover:text-indigo-300 transition-colors">
                  Global Shortcuts
                </Link>
              </li>
              <li>
                <Link href="/#how-it-works" className="hover:text-indigo-300 transition-colors">
                  Workflow
                </Link>
              </li>
              <li>
                <Link href="/#faq" className="hover:text-indigo-300 transition-colors">
                  FAQ & Permissions
                </Link>
              </li>
            </ul>
          </div>

          {/* Legal & Author */}
          <div>
            <div className="text-xs font-bold uppercase tracking-wider text-slate-200 mb-4 font-mono">
              Legal & Creator
            </div>
            <ul className="space-y-2.5 text-sm">
              <li>
                <Link href="/privacy" className="hover:text-indigo-300 transition-colors">
                  Privacy Policy
                </Link>
              </li>
              <li>
                <Link href="/terms" className="hover:text-indigo-300 transition-colors">
                  Terms of Service
                </Link>
              </li>
              <li>
                <a
                  href="mailto:aritrosaha2025@gmail.com"
                  className="hover:text-indigo-300 transition-colors inline-flex items-center gap-1"
                >
                  <Mail className="w-3.5 h-3.5" />
                  <span>Support Email</span>
                </a>
              </li>
              <li>
                <a
                  href="https://github.com/halcyon-past/byakugan-scan"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="hover:text-indigo-300 transition-colors inline-flex items-center gap-1"
                >
                  <Github className="w-3.5 h-3.5" />
                  <span>GitHub Repository</span>
                </a>
              </li>
            </ul>
          </div>
        </div>

        {/* Bottom Attribution Bar */}
        <div className="pt-8 border-t border-slate-900 flex flex-col sm:flex-row items-center justify-between gap-4 text-xs text-slate-500">
          <div className="flex items-center gap-2">
            <span>© 2026 Byakugan Scan. Built with precision.</span>
          </div>

          {/* Explicit Creator Attribution */}
          <div className="flex items-center gap-1.5 text-slate-400">
            <span>Created by</span>
            <a
              href="https://aritro.cloud"
              target="_blank"
              rel="noopener noreferrer"
              className="font-semibold text-indigo-400 hover:text-indigo-300 transition-colors inline-flex items-center gap-0.5 underline decoration-indigo-500/50 underline-offset-4"
            >
              <span>Aritro Saha</span>
              <ArrowUpRight className="w-3.5 h-3.5" />
            </a>
            <span className="text-slate-600">|</span>
            <a
              href="https://aritro.cloud"
              target="_blank"
              rel="noopener noreferrer"
              className="text-slate-400 hover:text-white transition-colors"
            >
              aritro.cloud
            </a>
          </div>
        </div>
      </div>
    </footer>
  );
}
