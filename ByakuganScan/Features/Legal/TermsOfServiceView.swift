import SwiftUI

/// In-app Terms of Service view.
struct TermsOfServiceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Terms of Service")
                    .font(.largeTitle.weight(.bold))
                Text("Effective Date: October 1, 2026  \nLast Updated: October 1, 2026")
                    .foregroundStyle(.secondary)
                
                PolicySection(title: "1. Acceptance of Terms") {
                    "By downloading, installing, or using Byakugan Scan (\"the App\"), you agree to be bound by these Terms of Service. If you do not agree to these terms, do not use the App."
                }
                
                PolicySection(title: "2. License") {
                    "Aritro Saha grants you a limited, non-exclusive, non-transferable, revocable license to use Byakugan Scan on Apple-branded devices you own or control, subject to the Mac App Store Terms of Service and these Terms."
                }
                
                PolicySection(title: "3. Permitted Use") {
                    "You may use the App to:\n\n• Capture and extract text from your screen\n• Scan QR codes and barcodes displayed on your screen\n• Store scan history locally on your device\n• Configure the App to suit your workflow"
                }
                
                PolicySection(title: "4. Prohibited Use") {
                    "You may NOT use the App to:\n\n• Capture content you do not have the right to access\n• Extract text from copyrighted material for redistribution\n• Reverse engineer, decompile, or modify the App\n• Use the App in any unlawful manner or in violation of third-party rights"
                }
                
                PolicySection(title: "5. Intellectual Property") {
                    "The App, including its source code, design, graphics, and documentation, is the intellectual property of Aritro Saha. All rights not explicitly granted in these Terms are reserved."
                }
                
                PolicySection(title: "6. Disclaimer of Warranties") {
                    "THE APP IS PROVIDED \"AS IS\" WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED. WE DO NOT WARRANT THAT THE APP WILL BE ERROR-FREE, ACCURATE, OR UNINTERRUPTED."
                }
                
                PolicySection(title: "7. Limitation of Liability") {
                    "TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, ARITRO SAHA SHALL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES ARISING FROM YOUR USE OF THE APP."
                }
                
                PolicySection(title: "8. Privacy") {
                    "Your use of the App is also governed by our Privacy Policy, available at https://byakugan-scan.aritro.cloud/privacy."
                }
                
                PolicySection(title: "9. Updates & Changes") {
                    "We reserve the right to modify the App or these Terms at any time. Continued use of the App after changes constitutes acceptance of the new terms."
                }
                
                PolicySection(title: "10. Governing Law") {
                    "These Terms are governed by the laws of India. Any disputes shall be resolved through binding arbitration in accordance with applicable law."
                }
                
                PolicySection(title: "11. Contact") {
                    "For questions about these Terms:\n\naritrosaha2025@gmail.com\nhttps://byakugan-scan.aritro.cloud/support"
                }
            }
            .padding(40)
        }
        .navigationTitle("Terms of Service")
    }
}
