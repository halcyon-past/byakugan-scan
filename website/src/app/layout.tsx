import type { Metadata } from "next";
import "./globals.css";
import EditorialHeader from "@/components/EditorialHeader";
import Footer from "@/components/Footer";

export const metadata: Metadata = {
  title: "Byakugan Scan | Precision Screen OCR, QR & Barcode Intelligence for macOS",
  description: "Inspired by the all-seeing Byakugan eye. Extract uncopyable text, decode QR codes, and scan industrial barcodes directly from any display. 100% on-device Vision engine.",
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
      <body className="min-h-screen flex flex-col bg-[#07080d] text-slate-100 antialiased selection:bg-indigo-600 selection:text-white">
        <EditorialHeader />
        <main className="flex-1 w-full">{children}</main>
        <Footer />
      </body>
    </html>
  );
}
