import type { Metadata, Viewport } from "next";
import "./globals.css";
import EditorialHeader from "@/components/EditorialHeader";
import Footer from "@/components/Footer";
import SmoothScrollProvider from "@/components/SmoothScrollProvider";
import ThreeScrollFollowerEye from "@/components/ThreeScrollFollowerEye";

const SITE_URL = "https://byakugan-scan.aritro.cloud";
const PERSON_ID = "https://www.aritro.cloud/#person";

export const viewport: Viewport = {
  themeColor: "#020307",
  colorScheme: "dark",
  width: "device-width",
  initialScale: 1,
};

export const metadata: Metadata = {
  metadataBase: new URL(SITE_URL),
  title: {
    default: "Free Mac Screen OCR, QR Code & Barcode Scanner (Instant & Offline) — Byakugan Scan",
    template: "%s | Free Mac Screen OCR, QR & Barcode Scanner",
  },
  description:
    "Free, open-source macOS menu bar utility by Aritro Saha for instant in-memory screen OCR, QR code decoding, and industrial barcode scanning. Snatch unselectable text from videos, PDFs, and images in under 50ms. 100% offline, privacy-first TextSniper alternative powered by Apple Vision on Apple Silicon & Intel.",
  applicationName: "Byakugan Scan",
  authors: [{ name: "Aritro Saha", url: "https://www.aritro.cloud/" }],
  creator: "Aritro Saha",
  publisher: "Aritro Saha",
  category: "Utilities & Productivity",
  keywords: [
    "mac screen ocr",
    "macOS screen OCR",
    "free TextSniper alternative",
    "open source TextSniper alternative",
    "copy text from screen Mac",
    "extract text from video Mac",
    "copy unselectable text Mac",
    "scan QR code on screen Mac",
    "macOS QR code reader",
    "macOS barcode scanner",
    "read barcode on Mac display",
    "Apple Vision OCR utility",
    "menu bar OCR Mac",
    "in-memory screenshot OCR",
    "sub-second screen text grabber",
    "extract table from image Mac",
    "table to markdown mac",
    "offline OCR macOS Sonoma Sequoia",
    "Homebrew OCR cask Mac",
    "copy text from YouTube video Mac",
    "screen to text Mac shortcut",
    "privacy first Mac OCR",
    "Shottr OCR alternative",
    "Apple Silicon OCR M1 M2 M3 M4",
    "EAN UPC barcode reader Mac",
    "Code 128 scanner Mac",
    "Byakugan Scan",
    "Aritro Saha",
    "halcyon-past",
    "Q141715213",
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
    siteName: "Byakugan Scan — Instant Mac Screen OCR & QR Scanner",
    title: "Free Mac Screen OCR, QR Code & Barcode Scanner (Instant & Offline)",
    description:
      "Snatch unselectable text from videos, PDFs, and images or decode on-screen QR codes and barcodes in under 50ms. 100% offline, open-source, and free for macOS. Created by Aritro Saha.",
  },
  twitter: {
    card: "summary_large_image",
    title: "Free Mac Screen OCR, QR & Barcode Scanner — Byakugan Scan",
    description:
      "Snatch unselectable text, QR codes, and 13+ barcodes directly into your clipboard in under 50ms. Zero temporary files, 100% offline on Apple Silicon.",
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
  other: {
    "content-signal": "search=yes, ai-train=yes, ai-input=yes",
    "rating": "general",
    "revisit-after": "7 days",
  },
};

const jsonLd = {
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "Person",
      "@id": PERSON_ID,
      name: "Aritro Saha",
      alternateName: ["Megh", "halcyon-past"],
      url: "https://www.aritro.cloud/",
      jobTitle: "Software Engineer 1",
      worksFor: {
        "@type": "Organization",
        name: "Bristol Myers Squibb",
        alternateName: "BMS",
        url: "https://www.bms.com/",
      },
      alumniOf: {
        "@type": "CollegeOrUniversity",
        name: "Vellore Institute of Technology, Chennai",
      },
      sameAs: [
        "https://www.wikidata.org/wiki/Q141715213",
        "https://www.wikidata.org/entity/Q141715213",
        "https://www.aritro.cloud/",
        "https://github.com/halcyon-past",
        "https://dev.to/halcyonpast",
        "https://linkedin.com/in/aritro-saha",
        "https://pypi.org/project/quarantine-py/",
        "https://leetcode.com/u/AritroSaha/",
        "https://www.youtube.com/@veripyed",
        "https://instagram.com/halcyon-past",
        "https://siliconsync.aritro.cloud/",
        "https://openworld.aritro.cloud/",
        "https://byakugan-scan.aritro.cloud/",
        "https://quarantine-py.aritro.cloud/",
        "https://structurify.aritro.cloud/",
      ],
    },
    {
      "@type": ["SoftwareApplication", "SoftwareSourceCode"],
      "@id": `${SITE_URL}/#software`,
      name: "Byakugan Scan",
      operatingSystem: "macOS 14.0 or later (Sonoma, Sequoia)",
      applicationCategory: "UtilitiesApplication, ProductivityApplication",
      applicationSubCategory: "Screen OCR, QR Code Reader, Industrial Barcode Scanner, Table Extractor",
      softwareVersion: "1.0.14",
      license: "https://opensource.org/licenses/MIT",
      url: SITE_URL,
      downloadUrl:
        "https://github.com/halcyon-past/byakugan-scan/releases/latest/download/ByakuganScan.dmg",
      codeRepository: "https://github.com/halcyon-past/byakugan-scan",
      programmingLanguage: "Swift 6.0",
      installUrl: "https://github.com/halcyon-past/byakugan-scan/releases/latest",
      releaseNotes: "https://github.com/halcyon-past/byakugan-scan/releases/tag/v1.0.14",
      image: `${SITE_URL}/app-icon.jpg`,
      screenshot: `${SITE_URL}/opengraph-image`,
      description:
        "A lightweight, 100% offline macOS menu bar utility for instant in-memory screen text OCR, on-screen QR code decoding, and commercial barcode recognition powered by Apple Vision.",
      featureList: [
        "Instant in-memory screen text OCR (<50ms on Apple Silicon)",
        "On-screen QR code and MicroQR decoding with 1-click actions",
        "13+ industrial and retail barcode symbologies (EAN, UPC, Code 128, PDF417, Aztec, Data Matrix)",
        "Spatial table OCR with automatic Markdown and CSV formatting",
        "100% offline on-device processing via Apple Vision framework",
        "Zero temporary disk files to eliminate Spotlight mdwrite and MADService latency stalls",
        "Customizable Byakugan reticle overlay and global keyboard shortcuts (⌘⇧2, ⌘⇧6, ⌘⇧7)",
        "Floating frosted-glass HUD toast with live word and character counts",
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
        "@id": PERSON_ID,
      },
      creator: {
        "@id": PERSON_ID,
      },
      publisher: {
        "@id": PERSON_ID,
      },
      maintainer: {
        "@id": PERSON_ID,
      },
      subjectOf: [
        {
          "@type": "TechArticle",
          name: "Why Most Mac OCR Apps Feel Sluggish (And How Byakugan Scan Fixes It in RAM)",
          url: "https://dev.to/halcyonpast/why-most-mac-ocr-apps-feel-sluggish-and-how-byakugan-scan-fixes-it-in-ram-3dn8",
          headline: "Why Most Mac OCR Apps Feel Sluggish (And How Byakugan Scan Fixes It in RAM)",
          author: {
            "@id": PERSON_ID,
          },
        },
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
        {
          "@type": "CreativeWork",
          name: "Byakugan Scan Markdown Documentation (index.md)",
          url: `${SITE_URL}/index.md`,
          encodingFormat: "text/markdown",
        },
        {
          "@type": "CreativeWork",
          name: "Byakugan Scan AI Scraper & Training Policy (ai.txt)",
          url: `${SITE_URL}/ai.txt`,
          encodingFormat: "text/plain",
        },
      ],
      sameAs: [
        "https://github.com/halcyon-past/byakugan-scan",
        "https://github.com/halcyon-past/homebrew-tap",
      ],
    },
    {
      "@type": "FAQPage",
      "@id": `${SITE_URL}/#faq`,
      mainEntity: [
        {
          "@type": "Question",
          name: "How do I copy unselectable text from a video or protected PDF on Mac?",
          acceptedAnswer: {
            "@type": "Answer",
            text: "Press ⌘⇧2 to trigger Byakugan Scan's interactive screen overlay, drag a selection rectangle over the target video, slide, or PDF, and the unselectable text is immediately recognized via Apple Vision Neural Engine and copied straight to your clipboard in under 50 milliseconds without creating temporary screenshot files.",
          },
        },
        {
          "@type": "Question",
          name: "What is the best free and open-source alternative to TextSniper on macOS?",
          acceptedAnswer: {
            "@type": "Answer",
            text: "Byakugan Scan is a 100% free, open-source (MIT) alternative to TextSniper. It captures screen pixels directly into volatile RAM (NSPasteboard) to avoid macOS Spotlight indexing stalls, operates 100% offline with zero telemetry, and includes on-screen QR decoding and 13+ industrial barcode scanning.",
          },
        },
        {
          "@type": "Question",
          name: "How do I scan a QR code displayed on my Mac screen without using my phone?",
          acceptedAnswer: {
            "@type": "Answer",
            text: "Press ⌘⇧6 to activate Byakugan Scan's QR matrix mode and highlight the QR code shown on your display (in Zoom, Slack, or a browser). The utility instantly decodes the payload and provides one-click actions to Open URL, Compose Email, Call Phone Number, or Copy the raw content.",
          },
        },
        {
          "@type": "Question",
          name: "Can Byakugan Scan read industrial barcodes directly from my computer monitor?",
          acceptedAnswer: {
            "@type": "Answer",
            text: "Yes. Press ⌘⇧7 to scan over 13 retail and industrial barcode symbologies including EAN-13, EAN-8, UPC-E, Code 128, Code 39, Code 93, PDF417, Aztec, Data Matrix, and ITF-14 directly from your screen into your clipboard.",
          },
        },
        {
          "@type": "Question",
          name: "Is Byakugan Scan safe for confidential enterprise and personal screen data?",
          acceptedAnswer: {
            "@type": "Answer",
            text: "Yes. Byakugan Scan is strictly sandboxed with zero network client entitlements (com.apple.security.network.client: false). It has zero analytics SDKs, zero telemetry, and zero cloud endpoints. All image and OCR processing takes place 100% locally on your device.",
          },
        },
        {
          "@type": "Question",
          name: "How do I install Byakugan Scan via Homebrew?",
          acceptedAnswer: {
            "@type": "Answer",
            text: "You can install Byakugan Scan in Terminal with one command: 'brew install --cask halcyon-past/tap/byakugan-scan'. Updates can be applied effortlessly using 'brew upgrade'.",
          },
        },
      ],
    },
    {
      "@type": "HowTo",
      "@id": `${SITE_URL}/#howto`,
      name: "How to Copy Unselectable Text from Any Mac Screen Region",
      description: "Quick 3-step guide to extract unselectable text from videos, images, slides, and protected documents on macOS.",
      step: [
        {
          "@type": "HowToStep",
          name: "Trigger the Capture Shortcut",
          text: "Press ⌘⇧2 (Cmd + Shift + 2) anywhere on macOS to open the animated Byakugan selection overlay.",
          position: 1,
        },
        {
          "@type": "HowToStep",
          name: "Highlight the Target Text",
          text: "Drag your cursor across the unselectable text, code block, or subtitle you want to grab.",
          position: 2,
        },
        {
          "@type": "HowToStep",
          name: "Paste Instantly",
          text: "Release your cursor. The extracted text is automatically placed in your macOS clipboard in under 50ms, ready to paste with ⌘V.",
          position: 3,
        },
      ],
    },
    {
      "@type": "WebSite",
      "@id": `${SITE_URL}/#website`,
      url: SITE_URL,
      name: "Byakugan Scan",
      description:
        "Official website and documentation for Byakugan Scan — the open-source macOS screen OCR, QR code, and barcode scanner by Aritro Saha.",
      author: {
        "@id": PERSON_ID,
      },
      creator: {
        "@id": PERSON_ID,
      },
      publisher: {
        "@id": PERSON_ID,
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
        <link rel="author" href="https://www.aritro.cloud/" />
        <link rel="me" href="https://www.aritro.cloud/" />
        <link rel="me" href="https://www.wikidata.org/wiki/Q141715213" />
        <link rel="me" href="https://github.com/halcyon-past" />
        <link rel="me" href="https://dev.to/halcyonpast" />
        <link rel="me" href="https://linkedin.com/in/aritro-saha" />
        <link rel="alternate" type="text/markdown" href="/index.md" title="Markdown Documentation" />
        <link rel="alternate" type="text/plain" href="/ai.txt" title="AI Scraper Policy" />
        <link rel="alternate" type="text/plain" href="/llms.txt" title="LLM Context Summary (llms.txt)" />
        <link rel="alternate" type="text/plain" href="/llms-full.txt" title="LLM Full Knowledge Base (llms-full.txt)" />
        <meta name="content-signal" content="search=yes, ai-train=yes, ai-input=yes" />
        <meta name="rating" content="general" />
        <meta name="revisit-after" content="7 days" />
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
        />
      </head>
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
