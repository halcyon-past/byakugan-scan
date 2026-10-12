import SwiftUI
import AppKit

/// Model representing a displayed item in the floating HUD.
struct FloatingHUDItem: Identifiable, Equatable {
    let id = UUID()
    let result: ScanResult
    
    var wordCount: Int {
        let words = result.content.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        return words.count
    }
    
    var characterCount: Int {
        result.content.count
    }
    
    var title: String {
        switch result.type {
        case .text:
            let w = wordCount
            let c = characterCount
            return "Copied \(w) \(w == 1 ? "word" : "words") (\(c) chars)"
        case .qrCode:
            if result.content.isURL {
                return "QR Code URL Detected"
            }
            return "QR Code Scanned"
        case .barcode:
            return "Barcode Scanned"
        }
    }
    
    var previewText: String {
        let firstLine = result.content.components(separatedBy: .newlines).first ?? result.content
        return firstLine.trimmingCharacters(in: .whitespaces)
    }
}

/// SwiftUI View rendering the sleek, modern frosted-glass HUD toast pill.
struct FloatingHUDView: View {
    let item: FloatingHUDItem
    let onDismiss: () -> Void
    
    @ObservedObject private var settings = AppSettings.shared
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Type reticle icon
            ZStack {
                Circle()
                    .fill(typeColor.opacity(0.20))
                    .frame(width: 34, height: 34)
                
                Image(systemName: item.result.type.systemImage)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(typeColor)
            }
            
            // Textual feedback
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.system(size: 12.5, weight: .bold))
                    .foregroundStyle(.white)
                
                Text(item.previewText)
                    .font(.system(size: 11, weight: .regular, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.72))
                    .lineLimit(1)
                    .frame(maxWidth: 240, alignment: .leading)
            }
            
            Spacer(minLength: 4)
            
            // Context action button
            if item.result.content.isURL, let url = URL(string: item.result.content.trimmingCharacters(in: .whitespacesAndNewlines)) {
                Button {
                    NSWorkspace.shared.open(url)
                    onDismiss()
                } label: {
                    HStack(spacing: 4) {
                        Text("Open")
                            .font(.system(size: 11, weight: .semibold))
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 9, weight: .bold))
                    }
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(typeColor.opacity(0.88), in: Capsule())
                    .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
            } else if item.result.content.isEmail {
                Button {
                    if let mailURL = URL(string: "mailto:\(item.result.content.trimmingCharacters(in: .whitespacesAndNewlines))") {
                        NSWorkspace.shared.open(mailURL)
                    }
                    onDismiss()
                } label: {
                    HStack(spacing: 4) {
                        Text("Email")
                            .font(.system(size: 11, weight: .semibold))
                        Image(systemName: "envelope.fill")
                            .font(.system(size: 9, weight: .bold))
                    }
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(typeColor.opacity(0.88), in: Capsule())
                    .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
            } else {
                HStack(spacing: 3) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                    Text("Copied")
                        .font(.system(size: 11, weight: .medium))
                }
                .foregroundStyle(typeColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(typeColor.opacity(0.16), in: Capsule())
            }
            
            // Close / Dismiss button
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(.white.opacity(0.45))
                    .padding(5)
                    .background(Circle().fill(Color.white.opacity(0.08)))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.ultraThinMaterial)
                
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(red: 0.08, green: 0.09, blue: 0.14).opacity(0.88))
                
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(typeColor.opacity(0.45), lineWidth: 1.2)
            }
        )
        .shadow(color: .black.opacity(0.45), radius: 16, x: 0, y: 8)
        .frame(minWidth: 320, maxWidth: 440)
        .onHover { isHovered = $0 }
    }
    
    private var typeColor: Color {
        settings.themeAccent.color
    }
}

/// Global controller managing the floating non-intrusive toast window.
@MainActor
final class FloatingHUDController: NSObject {
    static let shared = FloatingHUDController()
    
    private var panel: NSPanel?
    private var dismissTimer: Timer?
    private var currentItem: FloatingHUDItem?
    
    private override init() {
        super.init()
    }
    
    /// Displays a floating HUD toast for the given scan result.
    func show(result: ScanResult) {
        let item = FloatingHUDItem(result: result)
        self.currentItem = item
        
        // Invalidate any existing dismissal timer
        dismissTimer?.invalidate()
        
        if panel == nil {
            setupPanel()
        }
        
        guard let panel = panel else { return }
        
        let hostingView = NSHostingView(
            rootView: FloatingHUDView(item: item) { [weak self] in
                self?.dismiss()
            }
        )
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        
        panel.contentView = hostingView
        panel.layoutIfNeeded()
        
        // Position panel at top-right of active/main screen
        positionPanel()
        
        // Animate panel appearance
        panel.alphaValue = 0.0
        panel.orderFrontRegardless()
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.22
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            panel.animator().alphaValue = 1.0
        }
        
        // Auto-dismiss after 2.0s
        dismissTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.dismiss()
            }
        }
    }
    
    /// Smoothly dismisses the floating HUD toast.
    func dismiss() {
        dismissTimer?.invalidate()
        dismissTimer = nil
        
        guard let panel = panel, panel.isVisible else { return }
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.25
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)
            panel.animator().alphaValue = 0.0
        }, completionHandler: { [weak self] in
            Task { @MainActor [weak self] in
                self?.panel?.orderOut(nil)
            }
        })
    }
    
    private func setupPanel() {
        let newPanel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 380, height: 60),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        newPanel.isOpaque = false
        newPanel.backgroundColor = .clear
        newPanel.hasShadow = false
        newPanel.level = .floating
        newPanel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .transient]
        newPanel.isMovableByWindowBackground = true
        newPanel.hidesOnDeactivate = false
        
        self.panel = newPanel
    }
    
    private func positionPanel() {
        guard let panel = panel else { return }
        
        // Find screen containing mouse pointer, or fallback to main screen
        let mouseLocation = NSEvent.mouseLocation
        let targetScreen = NSScreen.screens.first(where: { NSMouseInRect(mouseLocation, $0.frame, false) }) ?? NSScreen.main ?? NSScreen.screens.first
        
        guard let screen = targetScreen else { return }
        
        let screenRect = screen.visibleFrame
        let fittingSize = panel.contentView?.fittingSize ?? NSSize(width: 380, height: 60)
        let finalWidth = max(fittingSize.width, 360)
        let finalHeight = max(fittingSize.height, 56)
        
        let x = screenRect.maxX - finalWidth - 24
        let y = screenRect.maxY - finalHeight - 16
        
        panel.setFrame(NSRect(x: x, y: y, width: finalWidth, height: finalHeight), display: true)
    }
}
