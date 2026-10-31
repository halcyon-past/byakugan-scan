import SwiftUI

/// Main settings window with comprehensive preferences matching gold-standard macOS utilities.
struct SettingsView: View {
    @EnvironmentObject private var settings: AppSettings
    @State private var selectedSection: SettingsSection = .general
    
    var body: some View {
        NavigationSplitView {
            List(SettingsSection.allCases, selection: $selectedSection) { section in
                Label(section.title, systemImage: section.systemImage)
                    .tag(section)
            }
            .navigationSplitViewColumnWidth(min: 175, ideal: 190, max: 215)
        } detail: {
            Group {
                switch selectedSection {
                case .general: GeneralSettingsView()
                case .shortcuts: ShortcutsSettingsView()
                case .ocr: OCRSettingsView()
                case .clipboard: ClipboardSettingsView()
                case .speech: SpeechSettingsView()
                case .appearance: AppearanceSettingsView()
                case .about: AboutSettingsView()
                }
            }
            .environmentObject(settings)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .tint(settings.themeAccent.color)
        .frame(
            minWidth: AppConstants.UI.settingsWindowWidth,
            minHeight: AppConstants.UI.settingsWindowHeight
        )
        .navigationTitle("\(AppConstants.App.name) Settings")
    }
}

// MARK: - Settings Sections

enum SettingsSection: String, CaseIterable, Identifiable, Hashable {
    case general, shortcuts, ocr, clipboard, speech, appearance, about
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .general: return "General"
        case .shortcuts: return "Shortcuts"
        case .ocr: return "Recognition"
        case .clipboard: return "Clipboard"
        case .speech: return "Text to Speech"
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
        case .speech: return "speaker.wave.2"
        case .appearance: return "paintpalette"
        case .about: return "info.circle"
        }
    }
}

// MARK: - 1. General Settings (Matches System in Screenshot 2)

struct GeneralSettingsView: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Form {
            Section("System") {
                Toggle("Launch at Login", isOn: $settings.launchAtLogin)
                Toggle("Show in Menu Bar", isOn: $settings.showInMenuBar)
                Text("To restore menu bar icon, relaunch Byakugan Scan from Applications or Finder.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                Toggle("Automatically Open Links", isOn: $settings.automaticallyOpenLinks)
                Toggle("Automatically Check for Updates on Launch", isOn: $settings.autoCheckForUpdates)
            }
            
            Section("Feedback & Audio") {
                Picker("Visual Feedback", selection: $settings.feedbackStyle) {
                    ForEach(FeedbackStyle.allCases) { style in
                        Label(style.displayName, systemImage: style.systemImage).tag(style)
                    }
                }
                
                Toggle("Play Sound on Capture", isOn: $settings.playSoundOnCapture)
                
                if settings.playSoundOnCapture {
                    HStack {
                        Picker("Sound Effect", selection: $settings.captureSoundEffect) {
                            ForEach(SoundEffect.allCases) { sound in
                                Label(sound.displayName, systemImage: sound.systemImage).tag(sound)
                            }
                        }
                        .onChange(of: settings.captureSoundEffect) { _, newSound in
                            if newSound != .none {
                                newSound.play()
                            }
                        }
                        
                        Button {
                            settings.captureSoundEffect.play()
                        } label: {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(settings.themeAccent.color)
                        }
                        .buttonStyle(.plain)
                        .help("Preview Sound Effect")
                    }
                }
            }
            
            Section("Screen Recording Permission") {
                HStack {
                    if ScreenCaptureService.shared.hasScreenRecordingPermission {
                        Label("Screen Recording: Granted", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else {
                        Label("Screen Recording: Not Granted", systemImage: "xmark.circle.fill")
                            .foregroundStyle(.red)
                        Spacer()
                        Button("Open Privacy Settings") {
                            ScreenCaptureService.shared.requestScreenRecordingPermission()
                        }
                    }
                }
            }
            
            Section("History") {
                Toggle("Enable Scan History", isOn: $settings.historyEnabled)
                if settings.historyEnabled {
                    Stepper("Max Stored Items: \(settings.maxHistoryItems)", value: $settings.maxHistoryItems, in: 10...500, step: 10)
                }
                Button("Clear All History", role: .destructive) {
                    HistoryService.shared.clearAll()
                }
            }
            
            Section {
                Button("Reset All Settings to Factory Defaults", role: .destructive) {
                    settings.resetToDefaults()
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle("General")
    }
}

// MARK: - 2. Shortcuts Settings (Matches Screenshot 1)

struct ShortcutsSettingsView: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Form {
            Section("Global Shortcuts") {
                LabeledContent("Capture Text") {
                    ShortcutField(shortcut: $settings.textScanShortcut, placeholder: "⌘⇧2")
                }
                LabeledContent("Capture Last Selection") {
                    ShortcutField(shortcut: $settings.captureLastSelectionShortcut, placeholder: "Record Shortcut")
                }
                LabeledContent("Capture Without Line Breaks") {
                    ShortcutField(shortcut: $settings.captureWithoutLineBreaksShortcut, placeholder: "Record Shortcut")
                }
                LabeledContent("Capture With Line Breaks") {
                    ShortcutField(shortcut: $settings.captureWithLineBreaksShortcut, placeholder: "Record Shortcut")
                }
                LabeledContent("Capture With Text to Speech") {
                    ShortcutField(shortcut: $settings.captureWithTTSShortcut, placeholder: "Record Shortcut")
                }
                LabeledContent("Read QR Code") {
                    ShortcutField(shortcut: $settings.qrScanShortcut, placeholder: "⌘⇧6")
                }
                LabeledContent("Scan Barcode") {
                    ShortcutField(shortcut: $settings.barcodeScanShortcut, placeholder: "⌘⇧7")
                }
                LabeledContent("Stop Speaking") {
                    ShortcutField(shortcut: $settings.stopSpeakingShortcut, placeholder: "Record Shortcut")
                }
                LabeledContent("Toggle Additive Clipboard") {
                    ShortcutField(shortcut: $settings.toggleAdditiveClipboardShortcut, placeholder: "Record Shortcut")
                }
                LabeledContent("Clear Additive History") {
                    ShortcutField(shortcut: $settings.clearAdditiveClipboardShortcut, placeholder: "Record Shortcut")
                }
            }
            
            Section("Capture Text Mode") {
                Text("Toggles preferences when Capture Text operation is active:")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                LabeledContent("Keep Line Breaks") {
                    Text("⌘L").font(.system(.body, design: .monospaced))
                }
                LabeledContent("Additive Clipboard") {
                    Text("⌘H").font(.system(.body, design: .monospaced))
                }
                LabeledContent("Text to Speech") {
                    Text("⌘S").font(.system(.body, design: .monospaced))
                }
            }
            
            Section {
                Button("Restore to Default") {
                    settings.resetShortcutsToDefaults()
                }
                .help("Reset all keyboard shortcuts to factory defaults")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Shortcuts")
    }
}

/// Central coordinator ensuring only one shortcut field records key events at any time,
/// with deterministic local event monitor registration and lifecycle cleanup.
@MainActor
final class ShortcutRecorderCoordinator: ObservableObject {
    static let shared = ShortcutRecorderCoordinator()
    
    @Published var activeFieldID: UUID? = nil
    private var monitor: Any? = nil
    private var onRecordCallback: ((String) -> Void)? = nil
    
    func startRecording(for id: UUID, onRecord: @escaping (String) -> Void) {
        stopRecording()
        activeFieldID = id
        onRecordCallback = onRecord
        
        monitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { [weak self] event in
            guard let self = self else { return event }
            
            // Handle Escape (53) -> Cancel recording
            if event.keyCode == 53 {
                DispatchQueue.main.async {
                    self.stopRecording()
                }
                return nil
            }
            
            // Handle Delete/Backspace (51) -> Clear shortcut
            if event.keyCode == 51 {
                let callback = self.onRecordCallback
                DispatchQueue.main.async {
                    self.stopRecording()
                    callback?("")
                }
                return nil
            }
            
            // Attempt to format shortcut from key code and modifier flags
            if let formatted = HotkeyService.formatShortcut(keyCode: event.keyCode, modifierFlags: event.modifierFlags) {
                let callback = self.onRecordCallback
                DispatchQueue.main.async {
                    self.stopRecording()
                    callback?(formatted)
                }
                return nil
            } else {
                // Key pressed without required primary modifiers (⌘, ⌥, ⌃)
                NSSound.beep()
                return nil
            }
        }
    }
    
    func stopRecording() {
        if let existing = monitor {
            NSEvent.removeMonitor(existing)
            monitor = nil
        }
        onRecordCallback = nil
        activeFieldID = nil
    }
    
    deinit {
        if let existing = monitor {
            NSEvent.removeMonitor(existing)
        }
    }
}

/// Shortcut input, recording, and display field with full native macOS key-event capture.
struct ShortcutField: View {
    @Binding var shortcut: String
    var placeholder: String = "Record Shortcut"
    
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject private var coordinator = ShortcutRecorderCoordinator.shared
    
    @State private var fieldID = UUID()
    @State private var isManualInputPresented = false
    @State private var manualInputText = ""
    
    private var isRecording: Bool {
        coordinator.activeFieldID == fieldID
    }
    
    var body: some View {
        HStack(spacing: 6) {
            if isRecording {
                // Active recording state indicator
                HStack(spacing: 5) {
                    Circle()
                        .fill(settings.themeAccent.color)
                        .frame(width: 7, height: 7)
                    Text("Press shortcut...")
                        .font(.system(.body, design: .monospaced))
                        .fontWeight(.medium)
                        .foregroundStyle(settings.themeAccent.color)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .strokeBorder(settings.themeAccent.color, lineWidth: 1.5)
                        .background(settings.themeAccent.color.opacity(0.12), in: RoundedRectangle(cornerRadius: 6))
                )
                
                Button("Cancel") {
                    stopRecording()
                }
                .buttonStyle(.borderless)
                .font(.caption)
            } else if shortcut.isEmpty {
                // Empty state: clickable pill or Record button
                Button {
                    startRecording()
                } label: {
                    Text(placeholder)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(.tertiary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.quaternary.opacity(0.5), in: RoundedRectangle(cornerRadius: 6))
                }
                .buttonStyle(.plain)
                .help("Click to record shortcut")
                
                Button("Record") {
                    startRecording()
                }
                .buttonStyle(.borderless)
                .font(.caption)
            } else {
                // Assigned shortcut state
                Button {
                    startRecording()
                } label: {
                    Text(shortcut)
                        .font(.system(.body, design: .monospaced))
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.quaternary, in: RoundedRectangle(cornerRadius: 6))
                }
                .buttonStyle(.plain)
                .help("Click to record new shortcut")
                
                Button {
                    shortcut = ""
                    notifySettingsChanged()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .help("Remove shortcut")
                
                Button("Record") {
                    startRecording()
                }
                .buttonStyle(.borderless)
                .font(.caption)
            }
        }
        .contextMenu {
            Button("Record Shortcut") {
                startRecording()
            }
            if !shortcut.isEmpty {
                Button("Clear Shortcut") {
                    shortcut = ""
                    notifySettingsChanged()
                }
            }
            Divider()
            Button("Enter Manually...") {
                manualInputText = shortcut
                isManualInputPresented = true
            }
        }
        .sheet(isPresented: $isManualInputPresented) {
            VStack(alignment: .leading, spacing: 14) {
                Text("Enter Keyboard Shortcut")
                    .font(.headline)
                Text("Type or paste a shortcut string (e.g., ⌘⇧2, ⌘⌥C):")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                TextField("Shortcut string", text: $manualInputText)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(.body, design: .monospaced))
                
                HStack {
                    Spacer()
                    Button("Cancel") {
                        isManualInputPresented = false
                    }
                    Button("Save") {
                        let trimmed = manualInputText.trimmingCharacters(in: .whitespacesAndNewlines)
                        shortcut = trimmed
                        notifySettingsChanged()
                        isManualInputPresented = false
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(20)
            .frame(width: 300)
        }
        .onDisappear {
            stopRecording()
        }
    }
    
    // MARK: - Recording Actions
    
    private func startRecording() {
        coordinator.startRecording(for: fieldID) { newShortcut in
            self.shortcut = newShortcut
            self.notifySettingsChanged()
        }
    }
    
    private func stopRecording() {
        if coordinator.activeFieldID == fieldID {
            coordinator.stopRecording()
        }
    }
    
    private func notifySettingsChanged() {
        NotificationCenter.default.post(
            name: NSNotification.Name(AppConstants.Notifications.settingsChanged),
            object: nil
        )
    }
}

// MARK: - 3. OCR Settings (Matches Recognition Language in Screenshot 2)

struct OCRSettingsView: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Form {
            Section("Recognition Language") {
                Picker("Primary Language", selection: $settings.ocrLanguage) {
                    Text("English").tag("en-US")
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
                
                Toggle("Automatically Detect Language", isOn: $settings.automaticallyDetectLanguage)
                Text("Note: Leaving this unchecked provides sub-15ms instant OCR on Apple Silicon.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            Section("Performance & Accuracy") {
                Picker("Recognition Engine", selection: $settings.ocrAccuracyLevel) {
                    ForEach(OCRAccuracyLevel.allCases, id: \.self) { level in
                        Text(level.displayName).tag(level)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Section("Text Formatting") {
                Toggle("Trim Whitespace", isOn: $settings.trimWhitespace)
                Toggle("Preserve Line Breaks", isOn: $settings.preserveLineBreaks)
                if settings.preserveLineBreaks {
                    Toggle("Join Lines with Space (instead of newline)", isOn: $settings.joinLineBreaksWithSpace)
                }
                Toggle("Smart De-Hyphenation (Rejoin split words across line breaks)", isOn: $settings.smartDehyphenation)
            }
            
            Section("Table & Grid Recognition") {
                Toggle("Detect Tables and Grids", isOn: $settings.detectTables)
                if settings.detectTables {
                    Picker("Table Format", selection: $settings.tableOutputFormat) {
                        ForEach(TableFormat.allCases) { format in
                            Text(format.displayName).tag(format)
                        }
                    }
                    Text("Automatically formats multi-column grids and spreadsheet tables into aligned Markdown or CSV.")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Recognition")
    }
}

// MARK: - 4. Additive Clipboard Settings (Matches Screenshot 2)

struct ClipboardSettingsView: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Form {
            Section("Additive Clipboard") {
                Toggle("Enable Additive Clipboard", isOn: $settings.additiveClipboard)
                Text("When enabled, consecutive captures are appended together rather than overwriting.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                Toggle("Clear Automatically", isOn: $settings.clearAdditiveClipboardAutomatically)
                Text("Additive Clipboard gets cleared automatically upon paste.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                Button("Clear Additive Clipboard Now") {
                    ClipboardService.shared.clear()
                }
            }
            
            Section("Current Clipboard Content") {
                if let content = ClipboardService.shared.currentContent, !content.isEmpty {
                    Text(content)
                        .font(.caption)
                        .lineLimit(6)
                        .foregroundStyle(.secondary)
                    Button("Clear Clipboard", role: .destructive) {
                        ClipboardService.shared.clear()
                    }
                } else {
                    Text("Clipboard is empty")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Clipboard")
    }
}

// MARK: - 5. Text to Speech Settings (Matches Screenshot 2)

struct SpeechSettingsView: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Form {
            Section("Text to Speech") {
                Toggle("Enable Speech on Capture", isOn: $settings.textToSpeechEnabled)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Speech Rate:")
                        Spacer()
                        Text("\(Int(settings.speechRate)) WPM")
                            .font(.system(.body, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                    Slider(value: $settings.speechRate, in: 90...300, step: 10)
                }
                .padding(.vertical, 4)
                
                HStack {
                    Button("Test Speech") {
                        SpeechService.shared.speak("Byakugan Scan is ready to capture text.", rate: settings.speechRate)
                    }
                    if SpeechService.shared.isSpeaking {
                        Button("Stop", role: .destructive) {
                            SpeechService.shared.stopSpeaking()
                        }
                    }
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Text to Speech")
    }
}

// MARK: - 6. Appearance Settings (Issue #6)

struct AppearanceSettingsView: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Form {
            Section("Theme & Accent Color") {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Customize your primary accent color for capture selection boxes, HUD toast highlights, and popover badges:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack(alignment: .top, spacing: 8) {
                        ForEach(ThemeAccent.allCases) { accent in
                            let isSelected = settings.themeAccent == accent
                            Button {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    settings.themeAccent = accent
                                }
                            } label: {
                                VStack(spacing: 7) {
                                    ZStack {
                                        Circle()
                                            .fill(accent.color)
                                            .frame(width: 36, height: 36)
                                            .overlay(
                                                Circle()
                                                    .strokeBorder(
                                                        isSelected ? Color.white : Color.white.opacity(0.18),
                                                        lineWidth: isSelected ? 2.5 : 1.0
                                                    )
                                            )
                                            .shadow(
                                                color: accent.color.opacity(isSelected ? 0.55 : 0.20),
                                                radius: isSelected ? 6 : 2,
                                                x: 0,
                                                y: 2
                                            )
                                        
                                        if isSelected {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 13, weight: .bold))
                                                .foregroundStyle(.white)
                                        }
                                    }
                                    
                                    Text(accent.shortDisplayName)
                                        .font(.system(size: 11, weight: isSelected ? .semibold : .regular))
                                        .foregroundStyle(isSelected ? .primary : .secondary)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(isSelected ? accent.color.opacity(0.12) : Color.clear)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(settings.themeAccent.color)
                            .frame(width: 8, height: 8)
                        Text("Active Theme: \(settings.themeAccent.displayName)")
                            .font(.caption.weight(.medium))
                        Spacer()
                        Text(settings.themeAccent.hexString.uppercased())
                            .font(.system(size: 11, weight: .medium, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 2)
                }
            }
            
            Section("Capture Selection Overlay") {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Overlay Dimming Opacity")
                        Spacer()
                        Text("\(Int((settings.overlayOpacity * 100).rounded()))%")
                            .font(.system(.body, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                    
                    Slider(value: $settings.overlayOpacity, in: 0.10...0.70, step: 0.05)
                        .tint(settings.themeAccent.color)
                    
                    // Live Interactive Selection Reticle Preview
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Live Selection Box Preview")
                                .font(.caption.weight(.medium))
                                .foregroundStyle(.secondary)
                            Spacer()
                            Button {
                                ScanCoordinator.shared.startTextScan()
                            } label: {
                                Label("Test Capture Overlay", systemImage: "viewfinder")
                                    .font(.caption.weight(.semibold))
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(settings.themeAccent.color)
                            .controlSize(.small)
                        }
                        
                        ZStack {
                            // Simulated desktop code background
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.14, green: 0.16, blue: 0.24),
                                            Color(red: 0.09, green: 0.10, blue: 0.16)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            // Simulated background lines
                            VStack(alignment: .leading, spacing: 6) {
                                Text("func recognizeText(in region: CGRect) async throws -> String")
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundStyle(.white.opacity(0.65))
                                Text("let request = VNRecognizeTextRequest()")
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundStyle(.white.opacity(0.92))
                                Text("request.recognitionLevel = .accurate")
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundStyle(.white.opacity(0.92))
                                Text("try handler.perform([request])")
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundStyle(.white.opacity(0.65))
                            }
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Dimming backdrop overlay
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.black.opacity(settings.overlayOpacity * 0.85))
                            
                            // Active selection box cutout + theme tint
                            ZStack(alignment: .bottomTrailing) {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(settings.themeAccent.color.opacity(0.16))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 3)
                                            .strokeBorder(settings.themeAccent.color, lineWidth: 2)
                                    )
                                    .shadow(color: settings.themeAccent.color.opacity(0.55), radius: 6)
                                    .frame(width: 240, height: 56)
                                
                                Text("240 × 56")
                                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(settings.themeAccent.color, in: RoundedRectangle(cornerRadius: 4))
                                    .offset(x: 0, y: 20)
                            }
                            .offset(y: -4)
                        }
                        .frame(height: 118)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .strokeBorder(Color.white.opacity(0.10), lineWidth: 1)
                        )
                    }
                    .padding(.top, 4)
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Appearance")
    }
}

// MARK: - 7. About Settings (Matches Screenshot 2)

struct AboutSettingsView: View {
    @ObservedObject private var updateService = UpdateService.shared
    @State private var isPerformingUpdate = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(nsImage: NSImage(named: "MenuBarIcon") ?? NSImage())
                    .resizable()
                    .frame(width: 80, height: 80)
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 18))
                
                VStack(spacing: 4) {
                    Text(AppConstants.App.name)
                        .font(.title2.weight(.bold))
                    Text("Version \(AppConstants.App.version) (\(AppConstants.App.build))")
                        .foregroundStyle(.secondary)
                }
                
                // In-App Update Engine Card
                updateSectionView
                
                Text("High-performance on-device screen text capture, QR code, and barcode scanner for macOS.")
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
                
                HStack {
                    Text("Send Feedback:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Link("aritrosaha2025@gmail.com", destination: URL(string: "mailto:aritrosaha2025@gmail.com")!)
                        .font(.caption)
                }
                
                Text("© 2026 Aritro Saha. All rights reserved.")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding(32)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    @ViewBuilder
    private var updateSectionView: some View {
        VStack(spacing: 10) {
            switch updateService.state {
            case .idle:
                Button {
                    Task { await updateService.checkForUpdates() }
                } label: {
                    Label("Check for Updates", systemImage: "arrow.triangle.2.circlepath")
                }
                .buttonStyle(.borderedProminent)
                
            case .checking:
                HStack(spacing: 8) {
                    ProgressView()
                        .scaleEffect(0.7)
                    Text("Checking for updates...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
                
            case .upToDate(let version):
                VStack(spacing: 6) {
                    Label("You're on the latest version (v\(version))", systemImage: "checkmark.circle.fill")
                        .font(.callout.weight(.medium))
                        .foregroundStyle(.green)
                    Button("Check Again") {
                        Task { await updateService.checkForUpdates() }
                    }
                    .font(.caption)
                    .buttonStyle(.link)
                }
                
            case .available(let version, let notes, _, _):
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Label("New Version Available: v\(version)", systemImage: "sparkles")
                            .font(.headline)
                            .foregroundStyle(.indigo)
                        Spacer()
                    }
                    
                    Text(notes)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(4)
                    
                    HStack(spacing: 12) {
                        Button {
                            isPerformingUpdate = true
                            Task {
                                do {
                                    try await updateService.downloadAndInstallUpdate()
                                } catch {
                                    isPerformingUpdate = false
                                }
                            }
                        } label: {
                            if isPerformingUpdate {
                                HStack(spacing: 6) {
                                    ProgressView().scaleEffect(0.6)
                                    Text("Updating...")
                                }
                            } else {
                                Text("Update & Relaunch")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(isPerformingUpdate)
                        
                        Link("Download DMG", destination: URL(string: "https://github.com/halcyon-past/byakugan-scan/releases/latest/download/ByakuganScan.dmg")!)
                            .font(.caption)
                    }
                }
                .padding(14)
                .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
                .frame(maxWidth: 380)
                
            case .downloading(let progress):
                VStack(spacing: 6) {
                    ProgressView(value: progress > 0 ? progress : nil)
                    Text("Downloading update...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: 240)
                
            case .installing:
                HStack(spacing: 8) {
                    ProgressView().scaleEffect(0.7)
                    Text("Installing update & relaunching...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
            case .error(let message):
                VStack(spacing: 6) {
                    Label(message, systemImage: "exclamationmark.triangle.fill")
                        .font(.caption)
                        .foregroundStyle(.red)
                    Button("Try Again") {
                        Task { await updateService.checkForUpdates() }
                    }
                    .font(.caption)
                    .buttonStyle(.link)
                }
            }
        }
    }
}
