import SwiftUI

/// In-app privacy policy view.
struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Privacy Policy")
                    .font(.largeTitle.weight(.bold))
                Text("Effective Date: October 1, 2026  \nLast Updated: October 1, 2026")
                    .foregroundStyle(.secondary)
                
                PolicySection(title: "1. Overview") {
                    "Byakugan Scan (\"the App\", \"we\", \"our\") is a macOS utility developed by Aritro Saha. We are committed to protecting your privacy. This Privacy Policy explains what data we collect (if any), how we use it, and your rights."
                }
                
                PolicySection(title: "2. Data We Do NOT Collect") {
                    "Byakugan Scan operates entirely on-device. We do not collect, transmit, or store:\n\n• Any text you capture or scan\n• Images captured during scanning\n• Barcode or QR code contents\n• Usage analytics or telemetry\n• Personal identifiers\n• IP addresses"
                }
                
                PolicySection(title: "3. Local Storage") {
                    "The App stores scan history locally on your Mac in ~/Library/Application Support/ByakuganScan/. This data never leaves your device and is fully under your control. You can clear history at any time from Settings."
                }
                
                PolicySection(title: "4. App Settings") {
                    "User preferences are stored in macOS UserDefaults locally on your device. No settings are synced to any server."
                }
                
                PolicySection(title: "5. Screen Recording Permission") {
                    "The App requires macOS Screen Recording permission to capture screen regions. This permission is granted by you via macOS System Settings and is used exclusively for the screenshot capture functionality. Captured screenshots are processed locally and immediately discarded from memory after scanning."
                }
                
                PolicySection(title: "6. Third-Party Services") {
                    "The App does not use any third-party SDKs, analytics services, advertising networks, or cloud services. All processing uses Apple's built-in Vision and Core ML frameworks."
                }
                
                PolicySection(title: "7. App Store") {
                    "If you download Byakugan Scan from the Mac App Store, Apple may collect standard purchase and download information as described in Apple's Privacy Policy (https://apple.com/legal/privacy)."
                }
                
                PolicySection(title: "8. Children's Privacy") {
                    "Byakugan Scan is not directed at children under 13. We do not knowingly collect any personal information from children."
                }
                
                PolicySection(title: "9. Changes to This Policy") {
                    "We may update this Privacy Policy from time to time. Changes will be posted at https://byakugan-scan.aritro.cloud/privacy and the \"Last Updated\" date will be revised."
                }
                
                PolicySection(title: "10. Contact Us") {
                    "If you have any questions about this Privacy Policy, please contact us at:\n\naritrosaha2025@gmail.com\nhttps://byakugan-scan.aritro.cloud/support"
                }
            }
            .padding(40)
        }
        .navigationTitle("Privacy Policy")
    }
}

struct PolicySection<Content: StringProtocol>: View {
    let title: String
    let content: () -> Content
    
    init(title: String, content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(content())
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
