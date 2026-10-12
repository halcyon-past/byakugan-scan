import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Terms of Service",
  description:
    "Terms of Service and open-source MIT license details for the Byakugan Scan macOS screen OCR, QR code, and barcode utility.",
  alternates: {
    canonical: "/terms",
  },
};

export default function TermsPage() {
  return (
    <div className="py-20 px-6 max-w-4xl mx-auto">
      <h1 className="text-4xl font-extrabold text-white mb-2">Terms of Service</h1>
      <div className="text-sm text-slate-300 mb-10 font-mono">Effective Date: October 1, 2026 | Last Updated: October 1, 2026</div>

      <div className="space-y-8 text-slate-200 text-sm sm:text-base leading-relaxed font-normal">
        <section>
          <h2 className="text-xl font-bold text-white mb-3">1. Acceptance of Terms</h2>
          <p>
            By downloading, installing, or using Byakugan Scan (&quot;the Software&quot;), you agree to be bound by these Terms of Service. If you do not agree to these terms, do not install or use the Software.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-white mb-3">2. License Grant</h2>
          <p>
            Aritro Saha grants you a personal, non-exclusive, revocable license to use Byakugan Scan on any macOS computer you own or control, in accordance with applicable open-source and App Store license terms.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-white mb-3">3. Acceptable Use</h2>
          <p>
            You agree to use Byakugan Scan strictly for lawful purposes. You may not use the app to intercept or capture content in violation of third-party copyrights, confidentiality agreements, or privacy laws.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-white mb-3">4. Disclaimer of Warranties</h2>
          <p>
            The Software is provided &quot;AS IS&quot; and &quot;AS AVAILABLE&quot; without warranties of any kind, either express or implied, including warranties of merchantability, fitness for a particular purpose, or non-infringement.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-white mb-3">5. Limitation of Liability</h2>
          <p>
            In no event shall Aritro Saha be liable for any direct, indirect, incidental, or consequential damages resulting from the use or inability to use the Software.
          </p>
        </section>

        <section>
          <h2 className="text-xl font-bold text-white mb-3">6. Contact Information</h2>
          <p>
            For questions regarding these Terms, contact:<br />
            <strong className="text-white">Aritro Saha</strong><br />
            Email: <a href="mailto:aritrosaha2025@gmail.com" className="text-pink-300 hover:text-white underline font-semibold transition-colors">aritrosaha2025@gmail.com</a><br />
            Website: <a href="https://byakugan-scan.aritro.cloud" className="text-pink-300 hover:text-white underline font-semibold transition-colors">https://byakugan-scan.aritro.cloud</a>
          </p>
        </section>
      </div>
    </div>
  );
}
