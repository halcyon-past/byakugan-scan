import type { Metadata } from "next";
import "./globals.css";
import Navbar from "@/components/Navbar";
import Footer from "@/components/Footer";

export const metadata: Metadata = {
  title: "Byakugan Scan — Blazing Fast Text OCR, QR & Barcode Scanner for macOS",
  description: "Extract unselectable text, decode QR codes, and scan barcodes directly on your Mac screen. Powered by Apple Vision, 100% on-device and private.",
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
    <html lang="en">
      <body className="min-h-screen flex flex-col bg-[#0a0b12] text-slate-100 antialiased">
        <Navbar />
        <main className="flex-1">{children}</main>
        <Footer />
      </body>
    </html>
  );
}
