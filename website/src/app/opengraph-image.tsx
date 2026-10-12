import { ImageResponse } from "next/og";

export const alt =
  "Byakugan Scan — Free & Open-Source Screen OCR, QR Code & Barcode Scanner for macOS";
export const size = {
  width: 1200,
  height: 630,
};
export const contentType = "image/png";

export default async function Image() {
  return new ImageResponse(
    (
      <div
        style={{
          width: "100%",
          height: "100%",
          display: "flex",
          flexDirection: "column",
          justifyContent: "space-between",
          padding: "64px 72px",
          background: "linear-gradient(135deg, #05050d 0%, #120924 55%, #1d0c30 100%)",
          color: "#f8fafc",
          fontFamily: "sans-serif",
        }}
      >
        {/* Top Badge */}
        <div
          style={{
            display: "flex",
            alignItems: "center",
            justifyContent: "space-between",
            width: "100%",
          }}
        >
          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: "12px",
              padding: "8px 18px",
              borderRadius: "9999px",
              background: "rgba(217, 70, 239, 0.14)",
              border: "1px solid rgba(217, 70, 239, 0.35)",
              color: "#f5d0fe",
              fontSize: "20px",
              fontWeight: 600,
            }}
          >
            <span>BYAKUGAN SCAN // MACOS MENU BAR UTILITY</span>
          </div>
          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: "10px",
              color: "#34d399",
              fontSize: "20px",
              fontWeight: 600,
            }}
          >
            <div
              style={{
                width: "10px",
                height: "10px",
                borderRadius: "9999px",
                background: "#34d399",
              }}
            />
            <span>100% Offline • Open Source (MIT)</span>
          </div>
        </div>

        {/* Center Title & Subtitle */}
        <div
          style={{
            display: "flex",
            flexDirection: "column",
            gap: "20px",
            maxWidth: "980px",
          }}
        >
          <div
            style={{
              fontSize: "68px",
              fontWeight: 800,
              lineHeight: 1.08,
              letterSpacing: "-0.03em",
              color: "#ffffff",
            }}
          >
            Instant Screen OCR, QR Code &amp; Barcode Scanner
          </div>
          <div
            style={{
              fontSize: "28px",
              lineHeight: 1.4,
              color: "#cbd5e1",
              fontWeight: 400,
            }}
          >
            Extract unselectable text from videos, PDFs, and slides directly into RAM in under 50ms. Zero temporary files. Zero network calls.
          </div>
        </div>

        {/* Bottom Install Bar */}
        <div
          style={{
            display: "flex",
            alignItems: "center",
            justifyContent: "space-between",
            width: "100%",
            paddingTop: "28px",
            borderTop: "1px solid rgba(255, 255, 255, 0.12)",
          }}
        >
          <div
            style={{
              display: "flex",
              alignItems: "center",
              padding: "14px 24px",
              borderRadius: "12px",
              background: "rgba(0, 0, 0, 0.65)",
              border: "1px solid rgba(244, 114, 182, 0.4)",
              color: "#f472b6",
              fontSize: "22px",
              fontFamily: "monospace",
            }}
          >
            $ brew install --cask halcyon-past/tap/byakugan-scan
          </div>
          <div
            style={{
              fontSize: "22px",
              color: "#94a3b8",
              fontWeight: 600,
            }}
          >
            byakugan-scan.aritro.cloud
          </div>
        </div>
      </div>
    ),
    {
      ...size,
    }
  );
}
