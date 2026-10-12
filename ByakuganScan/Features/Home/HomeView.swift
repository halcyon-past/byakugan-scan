import SwiftUI

/// Main home view (placeholder - will be redesigned for launch).
/// Accessible via the app's main window if opened.
struct HomeView: View {
    @StateObject private var coordinator = ScanCoordinator.shared
    @EnvironmentObject private var history: HistoryService
    @State private var showOnboarding = false
    
    var body: some View {
        NavigationSplitView {
            sidebar
                .navigationSplitViewColumnWidth(min: 200, ideal: 220, max: 260)
        } detail: {
            detailContent
        }
        .navigationTitle(AppConstants.App.name)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    ScanCoordinator.shared.startTextScan()
                } label: {
                    Label("Capture Text", systemImage: "text.viewfinder")
                }
                
                Button {
                    ScanCoordinator.shared.startQRScan()
                } label: {
                    Label("QR Code", systemImage: "qrcode.viewfinder")
                }
                
                Button {
                    ScanCoordinator.shared.startBarcodeScan()
                } label: {
                    Label("Barcode", systemImage: "barcode.viewfinder")
                }
            }
        }
    }
    
    // MARK: - Sidebar
    
    private var sidebar: some View {
        List {
            Section("Quick Actions") {
                Label("Capture Text", systemImage: "text.viewfinder")
                    .onTapGesture { ScanCoordinator.shared.startTextScan() }
                Label("Scan QR Code", systemImage: "qrcode.viewfinder")
                    .onTapGesture { ScanCoordinator.shared.startQRScan() }
                Label("Scan Barcode", systemImage: "barcode.viewfinder")
                    .onTapGesture { ScanCoordinator.shared.startBarcodeScan() }
            }
            
            Section("Recents") {
                ForEach(history.history.prefix(5)) { item in
                    HistoryRowView(result: item)
                }
            }
        }
    }
    
    // MARK: - Detail
    
    private var detailContent: some View {
        VStack(spacing: 0) {
            // Hero banner
            heroBanner
            
            Divider()
            
            // Feature grid
            featureGrid
        }
    }
    
    private var heroBanner: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.22, green: 0.18, blue: 0.55), Color(red: 0.08, green: 0.08, blue: 0.18)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 16) {
                Image(systemName: "eye.viewfinder")
                    .font(.system(size: 72))
                    .foregroundStyle(.white.opacity(0.9))
                
                VStack(spacing: 6) {
                    Text("Byakugan Scan")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)
                    Text("Instant OCR · QR Codes · Barcodes")
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.7))
                }
                
                Text("Click the eye icon in your menu bar or use keyboard shortcuts to capture text from anywhere on your screen.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.7))
                    .frame(maxWidth: 480)
            }
            .padding(60)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 300)
    }
    
    private var featureGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            FeatureCard(
                icon: "text.viewfinder",
                color: .indigo,
                title: "Text OCR",
                description: "Extract text from any screen region using Apple's powerful Vision framework."
            )
            FeatureCard(
                icon: "qrcode.viewfinder",
                color: .teal,
                title: "QR Codes",
                description: "Instantly decode QR codes from your screen — URLs, contacts, WiFi passwords and more."
            )
            FeatureCard(
                icon: "barcode.viewfinder",
                color: .orange,
                title: "Barcodes",
                description: "Supports EAN, UPC, Code 128, PDF417, Aztec and all major barcode formats."
            )
            FeatureCard(
                icon: "clock.arrow.circlepath",
                color: .purple,
                title: "History",
                description: "All your scans are saved locally. Copy, favorite and search past results."
            )
            FeatureCard(
                icon: "keyboard",
                color: .blue,
                title: "Shortcuts",
                description: "Fully configurable global keyboard shortcuts. Capture in an instant."
            )
            FeatureCard(
                icon: "lock.shield",
                color: .green,
                title: "Private",
                description: "All processing is done on-device. No data ever leaves your Mac."
            )
        }
        .padding(32)
    }
}

/// A feature card for the home page grid.
struct FeatureCard: View {
    let icon: String
    let color: Color
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.12), in: RoundedRectangle(cornerRadius: 10))
            
            Text(title)
                .font(.headline)
            
            Text(description)
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 16))
    }
}
