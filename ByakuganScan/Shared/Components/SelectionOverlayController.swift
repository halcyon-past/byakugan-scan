import AppKit
import QuartzCore

/// Custom borderless fullscreen window that can become key to receive Esc key and mouse events.
final class SelectionOverlayWindow: NSWindow {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}

/// Custom AppKit view that renders the themed Byakugan selection reticle, dimming backdrop,
/// corner brackets, and live pixel dimensions at 60/120Hz.
final class SelectionOverlayView: NSView {
    var accentColor: NSColor = ThemeAccent.byakuganChakra.nsColor
    var dimmingOpacity: CGFloat = 0.30
    
    var onSelectionComplete: ((NSRect) -> Void)?
    var onCancel: (() -> Void)?
    
    private var startPoint: NSPoint?
    private var currentPoint: NSPoint?
    private var hoverPoint: NSPoint?
    private var trackingArea: NSTrackingArea?
    
    override var acceptsFirstResponder: Bool { true }
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        true
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        if let existing = trackingArea {
            removeTrackingArea(existing)
        }
        let area = NSTrackingArea(
            rect: bounds,
            options: [.mouseMoved, .activeAlways, .inVisibleRect],
            owner: self,
            userInfo: nil
        )
        addTrackingArea(area)
        trackingArea = area
    }
    
    override func resetCursorRects() {
        addCursorRect(bounds, cursor: .crosshair)
    }
    
    // MARK: - Mouse & Keyboard Events
    
    override func mouseMoved(with event: NSEvent) {
        hoverPoint = convert(event.locationInWindow, from: nil)
        needsDisplay = true
    }
    
    override func mouseDown(with event: NSEvent) {
        let pt = convert(event.locationInWindow, from: nil)
        startPoint = pt
        currentPoint = pt
        hoverPoint = pt
        needsDisplay = true
    }
    
    override func mouseDragged(with event: NSEvent) {
        let pt = convert(event.locationInWindow, from: nil)
        currentPoint = pt
        hoverPoint = pt
        needsDisplay = true
    }
    
    override func mouseUp(with event: NSEvent) {
        let pt = convert(event.locationInWindow, from: nil)
        currentPoint = pt
        
        guard let rect = currentSelectionRect, rect.width >= 5, rect.height >= 5,
              let win = window else {
            onCancel?()
            return
        }
        
        let screenRect = win.convertToScreen(rect)
        onSelectionComplete?(screenRect)
    }
    
    override func rightMouseDown(with event: NSEvent) {
        onCancel?()
    }
    
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53 { // Escape key
            onCancel?()
        } else {
            super.keyDown(with: event)
        }
    }
    
    // MARK: - Geometry
    
    private var currentSelectionRect: NSRect? {
        guard let s = startPoint, let c = currentPoint else { return nil }
        let minX = min(s.x, c.x)
        let minY = min(s.y, c.y)
        let maxX = max(s.x, c.x)
        let maxY = max(s.y, c.y)
        return NSRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
    
    // MARK: - Drawing
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        guard let ctx = NSGraphicsContext.current?.cgContext else { return }
        ctx.saveGState()
        
        let clampedOpacity = max(0.05, min(0.80, dimmingOpacity))
        
        if let selRect = currentSelectionRect, selRect.width > 1, selRect.height > 1 {
            // 1. Draw dimming backdrop outside selection rectangle using Even-Odd fill rule
            let backdropPath = NSBezierPath(rect: bounds)
            backdropPath.append(NSBezierPath(rect: selRect))
            backdropPath.windingRule = .evenOdd
            NSColor.black.withAlphaComponent(clampedOpacity).setFill()
            backdropPath.fill()
            
            // 2. Subtle inner tint fill using user's chosen ThemeAccent
            accentColor.withAlphaComponent(0.14).setFill()
            NSBezierPath(rect: selRect).fill()
            
            // 3. Glowing main selection border
            ctx.saveGState()
            let glowShadow = NSShadow()
            glowShadow.shadowColor = accentColor.withAlphaComponent(0.65)
            glowShadow.shadowBlurRadius = 8
            glowShadow.shadowOffset = .zero
            glowShadow.set()
            
            let borderPath = NSBezierPath(rect: selRect.insetBy(dx: -1.0, dy: -1.0))
            borderPath.lineWidth = 2.0
            accentColor.setStroke()
            borderPath.stroke()
            ctx.restoreGState()
            
            // 4. Crisp corner reticle brackets
            drawCornerBrackets(around: selRect)
            
            // 5. Dimension pill badge ("W × H")
            drawDimensionsPill(for: selRect)
        } else {
            // Not dragging yet: draw full-screen dimming backdrop + crosshair guides + top hint banner
            NSColor.black.withAlphaComponent(clampedOpacity).setFill()
            bounds.fill()
            
            if let hover = hoverPoint {
                drawCrosshairGuides(at: hover)
            }
            
            drawTopHintBanner()
        }
        
        ctx.restoreGState()
    }
    
    private func drawCornerBrackets(around rect: NSRect) {
        let armLength: CGFloat = min(14.0, min(rect.width, rect.height) * 0.35)
        guard armLength >= 4 else { return }
        
        let path = NSBezierPath()
        path.lineWidth = 3.2
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        
        let r = rect.insetBy(dx: -1.0, dy: -1.0)
        
        // Top-left
        path.move(to: NSPoint(x: r.minX, y: r.maxY - armLength))
        path.line(to: NSPoint(x: r.minX, y: r.maxY))
        path.line(to: NSPoint(x: r.minX + armLength, y: r.maxY))
        
        // Top-right
        path.move(to: NSPoint(x: r.maxX - armLength, y: r.maxY))
        path.line(to: NSPoint(x: r.maxX, y: r.maxY))
        path.line(to: NSPoint(x: r.maxX, y: r.maxY - armLength))
        
        // Bottom-left
        path.move(to: NSPoint(x: r.minX, y: r.minY + armLength))
        path.line(to: NSPoint(x: r.minX, y: r.minY))
        path.line(to: NSPoint(x: r.minX + armLength, y: r.minY))
        
        // Bottom-right
        path.move(to: NSPoint(x: r.maxX - armLength, y: r.minY))
        path.line(to: NSPoint(x: r.maxX, y: r.minY))
        path.line(to: NSPoint(x: r.maxX, y: r.minY + armLength))
        
        accentColor.setStroke()
        path.stroke()
    }
    
    private func drawDimensionsPill(for rect: NSRect) {
        let w = Int(rect.width.rounded())
        let h = Int(rect.height.rounded())
        let label = "\(w) × \(h)"
        
        let attrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedDigitSystemFont(ofSize: 11, weight: .bold),
            .foregroundColor: NSColor.white
        ]
        let attrStr = NSAttributedString(string: label, attributes: attrs)
        let textSize = attrStr.size()
        
        let padX: CGFloat = 8
        let padY: CGFloat = 4
        let pillWidth = textSize.width + padX * 2
        let pillHeight = textSize.height + padY * 2
        
        var pillX = rect.maxX - pillWidth
        if pillX < rect.minX {
            pillX = rect.minX
        }
        var pillY = rect.minY - pillHeight - 8
        if pillY < 12 {
            pillY = rect.maxY + 8
        }
        
        let pillRect = NSRect(x: pillX, y: pillY, width: pillWidth, height: pillHeight)
        let pillPath = NSBezierPath(roundedRect: pillRect, xRadius: 6, yRadius: 6)
        
        accentColor.withAlphaComponent(0.92).setFill()
        pillPath.fill()
        
        attrStr.draw(at: NSPoint(x: pillRect.minX + padX, y: pillRect.minY + padY))
    }
    
    private func drawCrosshairGuides(at point: NSPoint) {
        let guidePath = NSBezierPath()
        guidePath.lineWidth = 1.0
        let dashPattern: [CGFloat] = [5.0, 4.0]
        guidePath.setLineDash(dashPattern, count: dashPattern.count, phase: 0)
        
        // Horizontal line
        guidePath.move(to: NSPoint(x: bounds.minX, y: point.y))
        guidePath.line(to: NSPoint(x: bounds.maxX, y: point.y))
        
        // Vertical line
        guidePath.move(to: NSPoint(x: point.x, y: bounds.minY))
        guidePath.line(to: NSPoint(x: point.x, y: bounds.maxY))
        
        accentColor.withAlphaComponent(0.45).setStroke()
        guidePath.stroke()
        
        // Target ring around cursor
        let ringRect = NSRect(x: point.x - 10, y: point.y - 10, width: 20, height: 20)
        let ringPath = NSBezierPath(ovalIn: ringRect)
        ringPath.lineWidth = 1.5
        accentColor.withAlphaComponent(0.85).setStroke()
        ringPath.stroke()
    }
    
    private func drawTopHintBanner() {
        let text = "Drag to select capture area  •  Press Esc to cancel"
        let attrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 12, weight: .semibold),
            .foregroundColor: NSColor.white
        ]
        let attrStr = NSAttributedString(string: text, attributes: attrs)
        let textSize = attrStr.size()
        
        let padX: CGFloat = 16
        let padY: CGFloat = 8
        let bannerWidth = textSize.width + padX * 2 + 14
        let bannerHeight = textSize.height + padY * 2
        let bannerRect = NSRect(
            x: (bounds.width - bannerWidth) / 2,
            y: bounds.height - bannerHeight - 48,
            width: bannerWidth,
            height: bannerHeight
        )
        
        let bgPath = NSBezierPath(roundedRect: bannerRect, xRadius: bannerHeight / 2, yRadius: bannerHeight / 2)
        NSColor(srgbRed: 0.08, green: 0.09, blue: 0.14, alpha: 0.88).setFill()
        bgPath.fill()
        
        bgPath.lineWidth = 1.5
        accentColor.withAlphaComponent(0.75).setStroke()
        bgPath.stroke()
        
        // Accent dot
        let dotRect = NSRect(x: bannerRect.minX + 14, y: bannerRect.midY - 4, width: 8, height: 8)
        accentColor.setFill()
        NSBezierPath(ovalIn: dotRect).fill()
        
        attrStr.draw(at: NSPoint(x: bannerRect.minX + 28, y: bannerRect.minY + padY))
    }
}

/// Coordinates the interactive custom-tinted selection overlay across all displays.
@MainActor
final class SelectionOverlayController {
    static let shared = SelectionOverlayController()
    
    private var windows: [SelectionOverlayWindow] = []
    private var localKeyMonitor: Any?
    private var globalKeyMonitor: Any?
    private var continuation: CheckedContinuation<NSRect, Error>?
    
    private init() {}
    
    /// Converts an AppKit global screen rectangle (origin at bottom-left of primary screen)
    /// into a Quartz global display rectangle (origin at top-left of primary screen) suitable for `screencapture -R`.
    nonisolated static func quartzRect(fromAppKitScreenRect rect: NSRect, primaryScreenHeight: CGFloat) -> CGRect {
        let qX = rect.origin.x.rounded()
        let qY = (primaryScreenHeight - rect.maxY).rounded()
        let qW = max(1.0, rect.width.rounded())
        let qH = max(1.0, rect.height.rounded())
        return CGRect(x: qX, y: qY, width: qW, height: qH)
    }
    
    /// Presents the custom-tinted interactive selection overlay and awaits the user's selected screen rectangle.
    func selectRegion() async throws -> NSRect {
        // Cancel any previous session if active
        cleanupOverlay()
        
        let settings = AppSettings.shared
        let accentNSColor = settings.themeAccent.nsColor
        let opacity = CGFloat(settings.overlayOpacity)
        
        return try await withCheckedThrowingContinuation { (cont: CheckedContinuation<NSRect, Error>) in
            self.continuation = cont
            
            let screens = NSScreen.screens
            guard !screens.isEmpty else {
                self.continuation = nil
                cont.resume(throwing: ScreenCaptureError.captureFailed)
                return
            }
            
            let mouseLoc = NSEvent.mouseLocation
            var activeWindow: SelectionOverlayWindow?
            
            for screen in screens {
                let win = SelectionOverlayWindow(
                    contentRect: screen.frame,
                    styleMask: [.borderless],
                    backing: .buffered,
                    defer: false
                )
                win.isOpaque = false
                win.backgroundColor = .clear
                win.hasShadow = false
                win.level = .screenSaver
                win.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .ignoresCycle]
                win.acceptsMouseMovedEvents = true
                win.isReleasedWhenClosed = false
                
                let overlayView = SelectionOverlayView(frame: NSRect(origin: .zero, size: screen.frame.size))
                overlayView.accentColor = accentNSColor
                overlayView.dimmingOpacity = opacity
                
                overlayView.onSelectionComplete = { [weak self] selectedScreenRect in
                    self?.completeSelection(with: selectedScreenRect)
                }
                
                overlayView.onCancel = { [weak self] in
                    self?.cancelSelection()
                }
                
                win.contentView = overlayView
                win.initialFirstResponder = overlayView
                windows.append(win)
                
                if NSMouseInRect(mouseLoc, screen.frame, false) {
                    activeWindow = win
                }
            }
            
            // Install Escape key & right-click monitors
            localKeyMonitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .rightMouseDown]) { [weak self] event in
                if event.type == .rightMouseDown || event.keyCode == 53 {
                    self?.cancelSelection()
                    return nil
                }
                return event
            }
            
            globalKeyMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.keyDown]) { [weak self] event in
                if event.keyCode == 53 {
                    Task { @MainActor [weak self] in
                        self?.cancelSelection()
                    }
                }
            }
            
            NSApp.activate(ignoringOtherApps: true)
            NSCursor.crosshair.push()
            
            for win in windows {
                win.orderFrontRegardless()
            }
            
            let keyWin = activeWindow ?? windows.first
            keyWin?.makeKeyAndOrderFront(nil)
            if let view = keyWin?.contentView {
                keyWin?.makeFirstResponder(view)
            }
        }
    }
    
    private func completeSelection(with screenRect: NSRect) {
        guard let cont = continuation else { return }
        continuation = nil
        cleanupOverlay()
        cont.resume(returning: screenRect)
    }
    
    private func cancelSelection() {
        guard let cont = continuation else { return }
        continuation = nil
        cleanupOverlay()
        cont.resume(throwing: ScreenCaptureError.selectionCancelled)
    }
    
    private func cleanupOverlay() {
        if let local = localKeyMonitor {
            NSEvent.removeMonitor(local)
            localKeyMonitor = nil
        }
        if let global = globalKeyMonitor {
            NSEvent.removeMonitor(global)
            globalKeyMonitor = nil
        }
        NSCursor.pop()
        for win in windows {
            win.alphaValue = 0.0
            win.orderOut(nil)
            win.close()
        }
        windows.removeAll()
        CATransaction.flush()
    }
}
