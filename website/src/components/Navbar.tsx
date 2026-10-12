import Link from "next/link";
import Image from "next/image";

export default function Navbar() {
  return (
    <header className="sticky top-0 z-50 glass-nav">
      <div className="max-w-6xl mx-auto px-6 h-18 py-4 flex items-center justify-between">
        <Link href="/" className="flex items-center gap-3">
          <Image
            src="/as-icon-dark.png"
            alt="Byakugan Scan Logo"
            width={32}
            height={32}
            className="w-8 h-8 rounded-lg"
          />
          <span className="font-bold text-lg tracking-tight text-white">Byakugan Scan</span>
        </Link>

        <nav className="hidden md:flex items-center gap-8 text-sm font-medium text-slate-400">
          <Link href="/#features" className="hover:text-white transition-colors">Features</Link>
          <Link href="/#shortcuts" className="hover:text-white transition-colors">Shortcuts</Link>
          <Link href="/#how-it-works" className="hover:text-white transition-colors">How It Works</Link>
          <Link href="/#faq" className="hover:text-white transition-colors">FAQ</Link>
          <Link href="/privacy" className="hover:text-white transition-colors">Privacy</Link>
          <Link href="/terms" className="hover:text-white transition-colors">Terms</Link>
        </nav>

        <div className="flex items-center gap-4">
          <a
            href="https://github.com/halcyon-past/byakugan-scan"
            target="_blank"
            rel="noopener noreferrer"
            className="px-4 py-2 text-sm font-semibold text-white bg-indigo-600 hover:bg-indigo-500 rounded-full shadow-lg shadow-indigo-600/30 transition-all hover:scale-105 active:scale-95"
          >
            Download Free
          </a>
        </div>
      </div>
    </header>
  );
}
