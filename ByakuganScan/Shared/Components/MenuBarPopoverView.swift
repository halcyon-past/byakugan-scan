import SwiftUI

/// The main popover view shown when clicking the menu bar icon.
struct MenuBarPopoverView: View {
    @EnvironmentObject private var settings: AppSettings
    @EnvironmentObject private var history: HistoryService
    @StateObject private var coordinator = ScanCoordinator.shared
    @State private var selectedTab: MenuBarTab = .scan
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerSection
            
            Divider()
            
            // Tab picker
            Picker("", selection: $selectedTab) {
                ForEach(MenuBarTab.allCases) { tab in
                    Text(tab.title).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            
            Divider()
            
            // Content
            switch selectedTab {
            case .scan:
                scanSection
            case .history:
                historySection
            }
            
            Divider()
            
            // Footer
            footerSection
        }
        .frame(width: 340)
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        HStack {
            Image(systemName: "eye.viewfinder")
                .font(.title2)
                .foregroundStyle(.indigo)
            VStack(alignment: .leading, spacing: 2) {
                Text("Byakugan Scan")
                    .font(.headline)
                Text("v\(AppConstants.App.version)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if coordinator.isScanning {
                ProgressView()
                    .scaleEffect(0.7)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    // MARK: - Scan Actions
    
    private var scanSection: some View {
        VStack(spacing: 8) {
            ScanActionButton(
                title: "Capture Text",
                subtitle: settings.textScanShortcut,
                icon: "text.viewfinder",
                color: .indigo
            ) {
                ScanCoordinator.shared.startTextScan()
            }
            
            ScanActionButton(
                title: "Scan QR Code",
                subtitle: settings.qrScanShortcut,
                icon: "qrcode.viewfinder",
                color: .teal
            ) {
                ScanCoordinator.shared.startQRScan()
            }
            
            ScanActionButton(
                title: "Scan Barcode",
                subtitle: settings.barcodeScanShortcut,
                icon: "barcode.viewfinder",
                color: .orange
            ) {
                ScanCoordinator.shared.startBarcodeScan()
            }
            
            if let error = coordinator.lastError {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 12)
                    .multilineTextAlignment(.center)
            }
            
            if let result = coordinator.lastResult {
                LastResultCard(result: result)
                    .padding(.horizontal, 12)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .frame(maxHeight: 300)
    }
    
    // MARK: - History
    
    private var historySection: some View {
        Group {
            if history.history.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("No scan history yet")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: 200)
            } else {
                List(history.history.prefix(20)) { item in
                    HistoryRowView(result: item)
                }
                .listStyle(.plain)
                .frame(maxHeight: 300)
            }
        }
    }
    
    // MARK: - Footer
    
    private var footerSection: some View {
        HStack {
            Button("Settings") {
                NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                NSApp.activate(ignoringOtherApps: true)
            }
            .buttonStyle(.plain)
            .font(.caption)
            
            Spacer()
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .font(.caption)
            .foregroundStyle(.red)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

// MARK: - Supporting Types & Views

enum MenuBarTab: String, CaseIterable, Identifiable {
    case scan, history
    var id: String { rawValue }
    var title: String {
        switch self {
        case .scan: return "Scan"
        case .history: return "History"
        }
    }
}

/// A prominent action button for triggering scans.
struct ScanActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(color)
                    .frame(width: 32)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.callout.weight(.medium))
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(color.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }
}

/// Displays the most recent scan result inline.
struct LastResultCard: View {
    let result: ScanResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label("Last Result", systemImage: result.type.systemImage)
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
            Text(result.content)
                .font(.caption)
                .lineLimit(3)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Spacer()
                Button {
                    ClipboardService.shared.copy(result.content)
                } label: {
                    Label("Copy Again", systemImage: "doc.on.doc")
                        .font(.caption2)
                }
            }
        }
        .padding(10)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
    }
}

/// A single row in the history list.
struct HistoryRowView: View {
    let result: ScanResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack {
                Label(result.type.displayName, systemImage: result.type.systemImage)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                Button {
                    ClipboardService.shared.copy(result.content)
                } label: {
                    Image(systemName: "doc.on.doc")
                        .font(.caption2)
                }
                .buttonStyle(.plain)
            }
            Text(result.content)
                .font(.caption)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }
}
