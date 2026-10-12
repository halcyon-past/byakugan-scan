import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Privacy Policy — Byakugan Scan",
  description: "Byakugan Scan Privacy Policy. 100% on-device processing, zero telemetry.",
};

export default function PrivacyPage() {
  return (
    <div className="py-20 px-6 max-w-4xl mx-auto">
      <h1 className="text-4xl font-extrabold text-white mb-2">Privacy Policy</h1>
      <div className="text-sm text-slate-500 mb-10">Effective Date: October 1, 2026 | Last Updated: October 1, 2026</div>

      <div className="space-y-8 text-slate-300 text-sm sm:text-base leading-relaxed">
        <section>
          <h2 className="text-xl font-bold text-white mb-3">1. Overview</h2>
          <p>
            Byakugan Scan (&quot;the Application&quot;, &quot;we&quot;, &quot;our&quot;) is developed by Aritro Saha. We believe privacy is a fundamental human right. Byakugan Scan is engineered to run completely on-device without telemetry, tracking, or cloud processing.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-white mb-3">2. Information We Do NOT Collect</h2>
          <p className="mb-2">We do not collect, transmit, log, or sell any personal data. Specifically:</p>
          <ul className="list-disc pl-6 space-y-1.5 text-slate-400">
            <li><strong>No Captured Content:</strong> Extracted text, QR codes, and barcodes never leave your computer.</li>
            <li><strong>No Screenshots:</strong> Pixels are processed in volatile RAM and immediately discarded.</li>
            <li><strong>No Analytics or Crash Logs:</strong> We track zero usage metrics, IP addresses, or device identifiers.</li>
            <li><strong>No Network Entitlements:</strong> The app does not possess network client permissions.</li>
          </ul>
        </section>

        <section>
          <h2 className="text-xl font-bold text-white mb-3">3. Local Storage</h2>
          <p>
            The optional scan history is stored strictly on your local disk at <code className="text-indigo-300">~/Library/Application Support/ByakuganScan/</code>. This file is under your full control and can be cleared at any time from Settings.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-white mb-3">4. Screen Recording Permission</h2>
          <p>
            macOS requires authorization to read screen pixels. When granted, Byakugan Scan only reads the rectangular region you highlight with your cursor. No full-desktop recordings are ever made.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-white mb-3">5. Contact Information</h2>
          <p>
            For any privacy inquiries or questions, contact:<br />
            <strong>Aritro Saha</strong><br />
            Email: <a href="mailto:aritrosaha2025@gmail.com" className="text-indigo-400 underline">aritrosaha2025@gmail.com</a><br />
            Website: <a href="https://byakugan-scan.aritro.cloud" className="text-indigo-400 underline">https://byakugan-scan.aritro.cloud</a>
          </p>
        </section>
      </div>
    </div>
  );
}
