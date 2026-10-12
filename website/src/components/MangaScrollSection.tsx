"use client";

import { motion } from "framer-motion";
import { Zap, Eye, QrCode, Barcode, Shield, Cpu, Sparkles } from "lucide-react";

export default function MangaScrollSection() {
  return (
    <section className="relative py-28 px-6 max-w-7xl mx-auto hairline-b overflow-hidden">
      {/* Background Japanese Watermark Character (白眼 - Byakugan) */}
      <div className="absolute right-0 top-1/2 -translate-y-1/2 text-[18vw] font-kanji text-pink-500/[0.03] select-none pointer-events-none leading-none z-0">
        白眼
      </div>

      <div className="relative z-20 grid grid-cols-1 lg:grid-cols-12 gap-12 items-center">
        {/* Left Side: Empty space on desktop for 3D Follower Eye to nestle! */}
        <div className="hidden lg:block lg:col-span-5 h-[420px]" />

        {/* Right Side: Editorial Manga Storyboard Narrative */}
        <div className="lg:col-span-7 space-y-10">
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded bg-pink-950/60 border border-pink-500/40 text-[11px] font-mono text-pink-200 font-semibold uppercase tracking-widest mb-4">
              <Sparkles className="w-3.5 h-3.5 text-pink-400" />
              <span>THE ALL-SEEING JUTSU // 360° DISPLAY PERCEPTION</span>
            </div>
            <h2 className="font-manga text-3xl sm:text-5xl font-black uppercase text-white tracking-wider leading-[1.05]">
              PENETRATES EVERY LAYER OF YOUR SCREEN.
            </h2>
          </div>

          <p className="text-slate-200 text-base sm:text-lg leading-relaxed font-normal">
            In ancient lore, the Byakugan granted its wielder the ability to perceive chakra pathways through solid barriers. On macOS, <span className="text-pink-300 font-semibold">Byakugan Scan</span> cuts through canvas overlays, DRM protection, streamed presentations, and remote Citrix/VNC frames to extract pure character strings instantly.
          </p>

          {/* 3 Storyboard Feature Panels (Manga Grid Style) */}
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 pt-4">
            <motion.div
              whileHover={{ y: -4 }}
              className="p-5 rounded-xl bg-[#130719] border border-pink-500/20 relative overflow-hidden group shadow-lg hover:border-pink-500/50 transition-all"
            >
              <div className="w-8 h-8 rounded bg-pink-500/20 text-pink-400 flex items-center justify-center mb-3">
                <Eye className="w-4 h-4" />
              </div>
              <div className="text-xs font-mono text-pink-300 font-semibold mb-1">01 // CLARITY</div>
              <h4 className="font-bold text-white text-sm mb-1.5">Pixel Reconstruction</h4>
              <p className="text-xs text-slate-200 leading-relaxed font-normal">
                Restores degraded video frames and anti-aliased font edges.
              </p>
            </motion.div>

            <motion.div
              whileHover={{ y: -4 }}
              className="p-5 rounded-xl bg-[#130719] border border-fuchsia-500/20 relative overflow-hidden group shadow-lg hover:border-fuchsia-500/50 transition-all"
            >
              <div className="w-8 h-8 rounded bg-fuchsia-500/20 text-fuchsia-400 flex items-center justify-center mb-3">
                <Cpu className="w-4 h-4" />
              </div>
              <div className="text-xs font-mono text-fuchsia-300 font-semibold mb-1">02 // CONCURRENCY</div>
              <h4 className="font-bold text-white text-sm mb-1.5">Swift 6 Core</h4>
              <p className="text-xs text-slate-200 leading-relaxed font-normal">
                Strict actor isolation ensures 0% UI hitching during capture.
              </p>
            </motion.div>

            <motion.div
              whileHover={{ y: -4 }}
              className="p-5 rounded-xl bg-[#130719] border border-amber-500/20 relative overflow-hidden group shadow-lg hover:border-amber-500/50 transition-all"
            >
              <div className="w-8 h-8 rounded bg-amber-500/20 text-amber-400 flex items-center justify-center mb-3">
                <Shield className="w-4 h-4" />
              </div>
              <div className="text-xs font-mono text-amber-300 font-semibold mb-1">03 // VAULT</div>
              <h4 className="font-bold text-white text-sm mb-1.5">RAM-Only Buffer</h4>
              <p className="text-xs text-slate-200 leading-relaxed font-normal">
                Screen pixels never touch disk or external networks.
              </p>
            </motion.div>
          </div>
        </div>
      </div>
    </section>
  );
}
