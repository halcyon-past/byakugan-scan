"use client";

import { motion } from "framer-motion";
import { Zap, Eye, QrCode, Barcode, Shield, Cpu, Sparkles } from "lucide-react";

export default function MangaScrollSection() {
  return (
    <section className="relative py-28 px-6 max-w-7xl mx-auto hairline-b overflow-hidden">
      {/* Background Japanese Watermark Character (白眼 - Byakugan) */}
      <div className="absolute right-0 top-1/2 -translate-y-1/2 text-[18vw] font-kanji text-white/[0.02] select-none pointer-events-none leading-none z-0">
        白眼
      </div>

      <div className="relative z-20 grid grid-cols-1 lg:grid-cols-12 gap-12 items-center">
        {/* Left Side: Empty space on desktop for 3D Follower Eye to nestle! */}
        <div className="hidden lg:block lg:col-span-5 h-[420px]" />

        {/* Right Side: Editorial Narrative with Soothing Rhythm */}
        <div className="lg:col-span-7 space-y-8">
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-pink-500/10 border border-pink-500/20 text-xs font-mono text-pink-300 font-medium mb-4">
              <Sparkles className="w-3.5 h-3.5 text-pink-400" />
              <span>All-Seeing Perception // 360° Screen Matrix</span>
            </div>
            <h2 className="text-3xl sm:text-5xl font-extrabold text-slate-100 tracking-tight leading-[1.12]">
              Penetrates every layer of your screen.
            </h2>
          </div>

          <p className="text-slate-300 text-base sm:text-lg leading-relaxed font-normal max-w-2xl">
            In ancient lore, the Byakugan granted its wielder the ability to perceive chakra pathways through solid barriers. On macOS, <span className="text-pink-300 font-medium">Byakugan Scan</span> cuts through canvas overlays, DRM protection, streamed presentations, and remote Citrix/VNC frames to extract pure character strings instantly.
          </p>

          {/* 3 Storyboard Feature Panels */}
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-5 pt-2">
            <motion.div
              whileHover={{ y: -3 }}
              className="p-6 rounded-2xl bg-[#121422] border border-white/[0.08] hover:border-pink-500/30 relative overflow-hidden group shadow-lg transition-all"
            >
              <div className="w-8 h-8 rounded-lg bg-pink-500/15 text-pink-400 flex items-center justify-center mb-3">
                <Eye className="w-4 h-4" />
              </div>
              <div className="text-xs font-mono text-slate-400 font-medium mb-1">01 // Clarity</div>
              <h4 className="font-bold text-slate-100 text-sm mb-1.5">Pixel Reconstruction</h4>
              <p className="text-xs text-slate-300 leading-relaxed font-normal">
                Restores degraded video frames and anti-aliased font edges in real-time.
              </p>
            </motion.div>

            <motion.div
              whileHover={{ y: -3 }}
              className="p-6 rounded-2xl bg-[#121422] border border-white/[0.08] hover:border-fuchsia-500/30 relative overflow-hidden group shadow-lg transition-all"
            >
              <div className="w-8 h-8 rounded-lg bg-fuchsia-500/15 text-fuchsia-400 flex items-center justify-center mb-3">
                <Cpu className="w-4 h-4" />
              </div>
              <div className="text-xs font-mono text-slate-400 font-medium mb-1">02 // Concurrency</div>
              <h4 className="font-bold text-slate-100 text-sm mb-1.5">Swift 6 Core</h4>
              <p className="text-xs text-slate-300 leading-relaxed font-normal">
                Strict actor isolation ensures 0% UI hitching during capture routines.
              </p>
            </motion.div>

            <motion.div
              whileHover={{ y: -3 }}
              className="p-6 rounded-2xl bg-[#121422] border border-white/[0.08] hover:border-amber-500/30 relative overflow-hidden group shadow-lg transition-all"
            >
              <div className="w-8 h-8 rounded-lg bg-amber-500/15 text-amber-400 flex items-center justify-center mb-3">
                <Shield className="w-4 h-4" />
              </div>
              <div className="text-xs font-mono text-slate-400 font-medium mb-1">03 // Vault</div>
              <h4 className="font-bold text-slate-100 text-sm mb-1.5">RAM-Only Buffer</h4>
              <p className="text-xs text-slate-300 leading-relaxed font-normal">
                Screen pixels never touch disk storage or external network interfaces.
              </p>
            </motion.div>
          </div>
        </div>
      </div>
    </section>
  );
}
