import SwiftUI

/// Main settings window with tabbed sections.
struct SettingsView: View {
    @EnvironmentObject private var settings: AppSettings
    @State private var selectedSection: SettingsSection = .general
    
    var body: some View {
        NavigationSplitView {
            List(SettingsSection.allCases, selection: $selectedSection) { section in
                Label(section.title, systemImage: section.systemImage)
                    .tag(section)
            }
            .navigationSplitViewColumnWidth(180)
        } detail: {
            Group {
                switch selectedSection {
                case .general: GeneralSettingsView()
                case .shortcuts: ShortcutsSettingsView()
                case .ocr: OCRSettingsView()
                case .clipboard: ClipboardSettingsView()
                case .appearance: AppearanceSettingsView()
                case .about: AboutSettingsView()
                }
            }
            .environmentObject(settings)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .navigationTitle("Settings")
    }
}

// MARK: - Settings Sections

enum SettingsSection: String, CaseIterable, Identifiable, Hashable {
    case general, shortcuts, ocr, clipboard, appearance, about
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .general: return "General"
        case .shortcuts: return "Shortcuts"
        case .ocr: return "OCR"
        case .clipboard: return "Clipboard"
        case .appearance: return "Appearance"
        case .about: return "About"
        }
    }
    
    var systemImage: String {
        switch self {
        case .general: return "gearshape"
        case .shortcuts: return "keyboard"
        case .ocr: return "text.viewfinder"
        case .clipboard: return "doc.on.clipboard"
        case .appearance: return "paintpalette"
        case .about: return "info.circle"
        }
    }
}

// MARK: - General Settings

struct GeneralSettingsView: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Form {
            Section("App Behaviour") {
                Toggle("Launch at Login", isOn: $settings.launchAtLogin)
                Toggle("Show in Menu Bar", isOn: $settings.showInMenuBar)
                Toggle("Play Sound on Capture", isOn: $settings.playSoundOnCapture)
                Toggle("Show Notification on Capture", isOn: $settings.showNotificationOnCapture)
            }
            
            Section("History") {
                Toggle("Enable Scan History", isOn: $settings.historyEnabled)
                if settings.historyEnabled {
                    Stepper("Max Items: \(settings.maxHistoryItems)", value: $settings.maxHistoryItems, in: 10...500, step: 10)
                }
                Button("Clear All History", role: .destructive) {
                    HistoryService.shared.clearAll()
                }
            }
            
            Section {
                Button("Reset All Settings to Defaults", role: .destructive) {
                    settings.resetToDefaults()
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle("General")
        .padding()
    }
}

// MARK: - Shortcuts Settings

struct ShortcutsSettingsView: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Form {
            Section("Keyboard Shortcuts") {
                LabeledContent("Capture Text") {
                    ShortcutField(shortcut: $settings.textScanShortcut)
                }
                LabeledContent("Scan QR Code") {
                    ShortcutField(shortcut: $settings.qrScanShortcut)
                }
                LabeledContent("Scan Barcode") {
                    ShortcutField(shortcut: $settings.barcodeScanShortcut)
                }
            }
            
            Section {
                Text("Note: After changing shortcuts, they will apply immediately. Conflicting shortcuts with other apps may not work.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Shortcuts")
        .padding()
    }
}

/// Simple shortcut display field (editable text for shortcut string).
struct ShortcutField: View {
    @Binding var shortcut: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            Text(shortcut)
                .font(.system(.body, design: .monospaced))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.quaternary, in: RoundedRectangle(cornerRadius: 6))
            Button(isEditing ? "Done" : "Edit") {
                isEditing.toggle()
                if !isEditing {
                    NotificationCenter.default.post(
                        name: NSNotification.Name(AppConstants.Notifications.settingsChanged),
                        object: nil
                    )
                }
            }
            .buttonStyle(.borderless)
        }
    }
}

// MARK: - OCR Settings

struct OCRSettingsView: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Form {
            Section("Recognition") {
                Picker("Accuracy", selection: $settings.ocrAccuracyLevel) {
                    ForEach(OCRAccuracyLevel.allCases, id: \.self) { level in
                        Text(level.displayName).tag(level)
                    }
                }
                .pickerStyle(.segmented)
                
                Picker("Primary Language", selection: $settings.ocrLanguage) {
                    Text("English (US)").tag("en-US")
                    Text("English (UK)").tag("en-GB")
                    Text("French").tag("fr-FR")
                    Text("German").tag("de-DE")
                    Text("Spanish").tag("es-ES")
                    Text("Italian").tag("it-IT")
                    Text("Portuguese").tag("pt-BR")
                    Text("Japanese").tag("ja-JP")
                    Text("Chinese (Simplified)").tag("zh-Hans")
                    Text("Chinese (Traditional)").tag("zh-Hant")
                    Text("Korean").tag("ko-KR")
                    Text("Arabic").tag("ar-SA")
                    Text("Hindi").tag("hi-IN")
                }
            }
            
            Section("Text Formatting") {
                Toggle("Trim Whitespace", isOn: $settings.trimWhitespace)
                Toggle("Preserve Line Breaks", isOn: $settings.preserveLineBreaks)
                if settings.preserveLineBreaks {
                    Toggle("Join Lines with Space (instead of newline)", isOn: $settings.joinLineBreaksWithSpace)
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle("OCR")
        .padding()
    }
}

// MARK: - Clipboard Settings

struct ClipboardSettingsView: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Form {
            Section("Clipboard Behaviour") {
                Toggle("Auto Copy to Clipboard", isOn: $settings.autoCopyToClipboard)
            }
            
            Section("Current Clipboard") {
                if let content = ClipboardService.shared.currentContent {
                    Text(content)
                        .font(.caption)
                        .lineLimit(5)
                        .foregroundStyle(.secondary)
                    Button("Clear Clipboard") {
                        ClipboardService.shared.clear()
                    }
                    .buttonStyle(.borderless)
                    .foregroundStyle(.red)
                } else {
                    Text("Clipboard is empty")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Clipboard")
        .padding()
    }
}

// MARK: - Appearance Settings

struct AppearanceSettingsView: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Form {
            Section("Overlay") {
                HStack {
                    Text("Overlay Opacity")
                    Slider(value: $settings.overlayOpacity, in: 0.1...0.8, step: 0.05)
                    Text(String(format: "%.0f%%", settings.overlayOpacity * 100))
                        .monospacedDigit()
                        .frame(width: 40)
                }
            }
            
            Section("Screen Capture Permission") {
                if ScreenCaptureService.shared.hasScreenRecordingPermission {
                    Label("Screen Recording: Granted", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                } else {
                    Label("Screen Recording: Not Granted", systemImage: "xmark.circle.fill")
                        .foregroundStyle(.red)
                    Button("Open Privacy Settings") {
                        ScreenCaptureService.shared.requestScreenRecordingPermission()
                    }
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Appearance")
        .padding()
    }
}

// MARK: - About Settings

struct AboutSettingsView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image("AppIcon")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 22))
            
            VStack(spacing: 4) {
                Text(AppConstants.App.name)
                    .font(.largeTitle.weight(.bold))
                Text("Version \(AppConstants.App.version) (\(AppConstants.App.build))")
                    .foregroundStyle(.secondary)
            }
            
            Text("A powerful screen text capture, QR code, and barcode scanner for macOS. Built with love using Apple's Vision framework.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .frame(maxWidth: 360)
            
            HStack(spacing: 16) {
                Link("Website", destination: AppConstants.App.websiteURL)
                Link("Privacy Policy", destination: AppConstants.App.privacyURL)
                Link("Terms of Service", destination: AppConstants.App.termsURL)
                Link("Support", destination: AppConstants.App.supportURL)
            }
            .font(.callout)
            
            Divider()
            
            Text("© 2026 Aritro Saha. All rights reserved.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
