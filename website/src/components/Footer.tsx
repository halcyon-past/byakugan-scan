import Link from "next/link";
import Image from "next/image";

export default function Footer() {
  return (
    <footer className="border-t border-indigo-950/60 bg-[#07080e] py-12 text-sm text-slate-500">
      <div className="max-w-6xl mx-auto px-6 flex flex-col md:flex-row items-center justify-between gap-6">
        <div className="flex items-center gap-3">
          <Image
            src="/as-icon-dark.png"
            alt="Byakugan Scan"
            width={20}
            height={20}
            className="w-5 h-5"
          />
          <span>Byakugan Scan © 2026 Aritro Saha. All rights reserved.</span>
        </div>

        <div className="flex items-center gap-6">
          <Link href="/privacy" className="hover:text-slate-300 transition-colors">Privacy Policy</Link>
          <Link href="/terms" className="hover:text-slate-300 transition-colors">Terms of Service</Link>
          <a href="mailto:aritrosaha2025@gmail.com" className="hover:text-slate-300 transition-colors">Support</a>
          <a
            href="https://github.com/halcyon-past/byakugan-scan"
            target="_blank"
            rel="noopener noreferrer"
            className="hover:text-slate-300 transition-colors"
          >
            GitHub
          </a>
        </div>
      </div>
    </footer>
  );
}
