import type { Metadata, Viewport } from "next";
import "./globals.css";
import EditorialHeader from "@/components/EditorialHeader";
import Footer from "@/components/Footer";
import SmoothScrollProvider from "@/components/SmoothScrollProvider";
import ThreeScrollFollowerEye from "@/components/ThreeScrollFollowerEye";

const SITE_URL = "https://byakugan-scan.aritro.cloud";

export const viewport: Viewport = {
  themeColor: "#020307",
  colorScheme: "dark",
  width: "device-width",
  initialScale: 1,
};

export const metadata: Metadata = {
  metadataBase: new URL(SITE_URL),
  title: {
    default: "Byakugan Scan — Free & Open-Source Screen OCR, QR & Barcode Scanner for macOS",
    template: "%s | Byakugan Scan for macOS",
  },
  description:
    "Free, open-source macOS menu bar utility for instant in-memory screen OCR, QR code decoding, and barcode scanning. A fast, 100% offline TextSniper alternative powered by Apple Vision on Apple Silicon & Intel.",
  applicationName: "Byakugan Scan",
  authors: [{ name: "Aritro Saha", url: "https://aritro.cloud" }],
  creator: "Aritro Saha",
  publisher: "Aritro Saha",
  category: "Developer Tools & Productivity",
  keywords: [
    "Byakugan Scan",
    "macOS OCR app",
    "free TextSniper alternative",
    "open source TextSniper alternative",
    "copy text from screen Mac",
    "extract text from video Mac",
    "macOS screen OCR",
    "scan QR code on screen Mac",
    "macOS QR code reader",
    "macOS barcode scanner",
    "Apple Vision OCR utility",
    "menu bar OCR Mac",
    "in-memory screenshot OCR",
    "offline OCR macOS Sonoma Sequoia",
    "Homebrew OCR cask Mac",
  ],
  alternates: {
    canonical: "/",
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      "max-video-preview": -1,
      "max-image-preview": "large",
      "max-snippet": -1,
    },
  },
  openGraph: {
    type: "website",
    locale: "en_US",
    url: SITE_URL,
    siteName: "Byakugan Scan",
    title: "Byakugan Scan — Instant Screen OCR, QR & Barcode Scanner for macOS",
    description:
      "Extract unselectable text from videos, PDFs, and images or decode on-screen QR codes and barcodes in under 50ms. 100% offline, open-source, and free for macOS.",
  },
  twitter: {
    card: "summary_large_image",
    title: "Byakugan Scan — Free Open-Source Screen OCR & QR Scanner for macOS",
    description:
      "Snatch unselectable text, QR codes, and barcodes directly into your clipboard in under 50ms. Zero temporary files, 100% offline on Apple Silicon.",
    creator: "@halcyon_past",
  },
  icons: {
    icon: [
      { url: "/as-icon-dark.png", type: "image/png" },
    ],
    apple: [
      { url: "/as-icon-dark.png", type: "image/png" },
    ],
  },
};

const jsonLd = {
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "SoftwareApplication",
      "@id": `${SITE_URL}/#software`,
      name: "Byakugan Scan",
      operatingSystem: "macOS 14.0 or later (Apple Silicon & Intel)",
      applicationCategory: "UtilitiesApplication",
      applicationSubCategory: "Screen OCR, QR Code & Barcode Scanner",
      softwareVersion: "1.0.4",
      license: "https://opensource.org/licenses/MIT",
      url: SITE_URL,
      downloadUrl:
        "https://github.com/halcyon-past/byakugan-scan/releases/latest/download/ByakuganScan.dmg",
      installUrl: "https://github.com/halcyon-past/byakugan-scan/releases/latest",
      releaseNotes: "https://github.com/halcyon-past/byakugan-scan/releases/tag/v1.0.4",
      image: `${SITE_URL}/app-icon.jpg`,
      description:
        "A lightweight, 100% offline macOS menu bar utility for instant in-memory screen text OCR, QR code decoding, and commercial barcode recognition powered by Apple Vision.",
      featureList: [
        "Instant in-memory screen text OCR (<50ms on Apple Silicon)",
        "On-screen QR code and MicroQR decoding",
        "13+ industrial and retail barcode symbologies (EAN, UPC, Code 128, PDF417, Aztec, Data Matrix)",
        "100% offline on-device processing via Apple Vision framework",
        "Customizable Byakugan reticle overlay and global keyboard shortcuts",
        "Floating frosted-glass HUD toast with contextual actions",
        "Local searchable scan history and additive clipboard mode",
        "Automation deep links (byakugan://) for Raycast, Alfred, and Shortcuts",
      ],
      offers: {
        "@type": "Offer",
        price: "0",
        priceCurrency: "USD",
        availability: "https://schema.org/InStock",
      },
      author: {
        "@type": "Person",
        name: "Aritro Saha",
        url: "https://aritro.cloud",
      },
      sameAs: [
        "https://github.com/halcyon-past/byakugan-scan",
        "https://github.com/halcyon-past/homebrew-tap",
      ],
      subjectOf: [
        {
          "@type": "CreativeWork",
          name: "Byakugan Scan LLM Summary (llms.txt)",
          url: `${SITE_URL}/llms.txt`,
          encodingFormat: "text/plain",
        },
        {
          "@type": "CreativeWork",
          name: "Byakugan Scan Full Technical Knowledge Base (llms-full.txt)",
          url: `${SITE_URL}/llms-full.txt`,
          encodingFormat: "text/plain",
        },
      ],
    },
    {
      "@type": "WebSite",
      "@id": `${SITE_URL}/#website`,
      url: SITE_URL,
      name: "Byakugan Scan",
      description:
        "Official website and documentation for Byakugan Scan — the open-source macOS screen OCR, QR code, and barcode scanner.",
      publisher: {
        "@type": "Person",
        name: "Aritro Saha",
        url: "https://aritro.cloud",
      },
    },
  ],
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="dark scroll-smooth">
      <head>
        <link rel="alternate" type="text/plain" href="/llms.txt" title="LLM Summary (llms.txt)" />
        <link rel="alternate" type="text/plain" href="/llms-full.txt" title="LLM Full Knowledge Base (llms-full.txt)" />
      </head>
      <body className="min-h-screen flex flex-col bg-[#020307] text-slate-100 antialiased selection:bg-indigo-600 selection:text-white relative">
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
        />
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
