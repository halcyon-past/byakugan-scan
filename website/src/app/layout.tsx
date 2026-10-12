import type { Metadata } from "next";
import "./globals.css";
import EditorialHeader from "@/components/EditorialHeader";
import Footer from "@/components/Footer";
import SmoothScrollProvider from "@/components/SmoothScrollProvider";
import ThreeScrollFollowerEye from "@/components/ThreeScrollFollowerEye";

export const metadata: Metadata = {
  title: "Byakugan Scan | The All-Seeing Screen Intelligence for macOS",
  description: "An anime-inspired precision utility for macOS. Snatch unselectable text, decode QR codes, and scan industrial barcodes at the speed of thought. Powered 100% on-device by Apple Vision.",
  metadataBase: new URL("https://byakugan-scan.aritro.cloud"),
  icons: {
    icon: "/as-icon-dark.png",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="dark scroll-smooth">
      <body className="min-h-screen flex flex-col bg-[#020307] text-slate-100 antialiased selection:bg-indigo-600 selection:text-white relative">
        <SmoothScrollProvider>
          {/* Global Floating 3D Follower Byakugan Eye */}
          <ThreeScrollFollowerEye />

          {/* Sticky Editorial Header */}
          <EditorialHeader />

          {/* Main Website Flow */}
          <main className="flex-1 w-full relative z-20">{children}</main>

          {/* Footer with Creator Attribution */}
          <Footer />
        </SmoothScrollProvider>
      </body>
    </html>
  );
}
