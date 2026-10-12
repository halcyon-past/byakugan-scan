import type { MetadataRoute } from "next";

export default function manifest(): MetadataRoute.Manifest {
  return {
    name: "Byakugan Scan — Screen OCR, QR & Barcode Utility for macOS",
    short_name: "Byakugan Scan",
    description:
      "Instant in-memory screen text OCR, QR code decoding, and barcode scanning for macOS. 100% offline & open-source.",
    start_url: "/",
    display: "standalone",
    background_color: "#020307",
    theme_color: "#d946ef",
    icons: [
      {
        src: "/as-icon-dark.png",
        sizes: "512x512",
        type: "image/png",
      },
      {
        src: "/app-icon.jpg",
        sizes: "1024x1024",
        type: "image/jpeg",
      },
    ],
  };
}
