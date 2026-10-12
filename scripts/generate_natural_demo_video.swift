import Foundation
import AVFoundation
import CoreGraphics
import CoreText
import AppKit

// MARK: - Video Dimensions & Setup
let width = 1920
let height = 1080
let widthF = CGFloat(width)
let heightF = CGFloat(height)
let fps: Int32 = 30
let totalSeconds: Double = 15.0
let totalFrames = Int(totalSeconds * Double(fps)) // 450 frames

let projectDir = FileManager.default.currentDirectoryPath
let outputURL = URL(fileURLWithPath: "\(projectDir)/demo_byakugan_scan.mp4")
try? FileManager.default.removeItem(at: outputURL)

print("🎬 Initializing Natural macOS Screen Recording Generator (1080p @ 30fps)...")

// Load Assets
let iconPath = "\(projectDir)/ByakuganScan/Resources/Assets.xcassets/AppIcon.appiconset/icon_1024x1024.png"
let menuIconPath = "\(projectDir)/ByakuganScan/Resources/Assets.xcassets/MenuBarIcon.imageset/menubar_icon@3x.png"
let appIconImage = NSImage(contentsOfFile: iconPath)
let menuIconImage = NSImage(contentsOfFile: menuIconPath)

// MARK: - AVAssetWriter Setup
let writer = try AVAssetWriter(outputURL: outputURL, fileType: .mp4)
let videoSettings: [String: Any] = [
    AVVideoCodecKey: AVVideoCodecType.h264,
    AVVideoWidthKey: width,
    AVVideoHeightKey: height,
    AVVideoCompressionPropertiesKey: [
        AVVideoAverageBitRateKey: 10_000_000, // 10 Mbps crisp 1080p
        AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel
    ]
]

let writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
writerInput.expectsMediaDataInRealTime = false

let adaptor = AVAssetWriterInputPixelBufferAdaptor(
    assetWriterInput: writerInput,
    sourcePixelBufferAttributes: [
        kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
        kCVPixelBufferWidthKey as String: width,
        kCVPixelBufferHeightKey as String: height
    ]
)

writer.add(writerInput)
writer.startWriting()
writer.startSession(atSourceTime: .zero)

// MARK: - Core Graphics Drawing Helpers

func drawText(
    _ text: String,
    in ctx: CGContext,
    at point: CGPoint,
    fontSize: CGFloat,
    weight: NSFont.Weight = .regular,
    color: NSColor = .white,
    isMonospace: Bool = false
) {
    let font: NSFont = isMonospace ? .monospacedSystemFont(ofSize: fontSize, weight: weight) : .systemFont(ofSize: fontSize, weight: weight)
    let attrs: [NSAttributedString.Key: Any] = [
        .font: font,
        .foregroundColor: color
    ]
    let attrStr = NSAttributedString(string: text, attributes: attrs)
    let line = CTLineCreateWithAttributedString(attrStr)
    ctx.saveGState()
    ctx.textPosition = point
    CTLineDraw(line, ctx)
    ctx.restoreGState()
}

func drawWindowFrame(
    in ctx: CGContext,
    rect: CGRect,
    title: String,
    isActive: Bool = true,
    bgColor: CGColor = CGColor(red: 0.11, green: 0.12, blue: 0.16, alpha: 0.96)
) {
    ctx.saveGState()
    // Window Drop Shadow
    let shadowAlpha: CGFloat = isActive ? 0.6 : 0.35
    ctx.setShadow(offset: CGSize(width: 0, height: -14), blur: 34, color: CGColor(red: 0, green: 0, blue: 0, alpha: shadowAlpha))
    
    // Window Body
    let bodyPath = CGPath(roundedRect: rect, cornerWidth: 12, cornerHeight: 12, transform: nil)
    ctx.addPath(bodyPath)
    ctx.setFillColor(bgColor)
    ctx.fillPath()
    
    // Window Outline Border
    ctx.addPath(bodyPath)
    ctx.setStrokeColor(CGColor(red: 1, green: 1, blue: 1, alpha: isActive ? 0.18 : 0.08))
    ctx.setLineWidth(1.0)
    ctx.strokePath()
    ctx.restoreGState()
    
    // Titlebar
    let titlebarHeight: CGFloat = 38
    let titlebarRect = CGRect(x: rect.origin.x, y: rect.origin.y + rect.height - titlebarHeight, width: rect.width, height: titlebarHeight)
    
    // Traffic light buttons
    let buttonY = titlebarRect.midY - 6
    let startX = rect.origin.x + 16
    let colors = [
        CGColor(red: 1.0, green: 0.36, blue: 0.34, alpha: 1.0), // red
        CGColor(red: 1.0, green: 0.74, blue: 0.22, alpha: 1.0), // yellow
        CGColor(red: 0.18, green: 0.80, blue: 0.35, alpha: 1.0)  // green
    ]
    for (i, col) in colors.enumerated() {
        ctx.setFillColor(isActive ? col : CGColor(red: 0.3, green: 0.3, blue: 0.35, alpha: 1.0))
        ctx.fillEllipse(in: CGRect(x: startX + CGFloat(i * 18), y: buttonY, width: 12, height: 12))
    }
    
    // Window Title Text
    let titleColor = isActive ? NSColor(white: 0.85, alpha: 1.0) : NSColor(white: 0.5, alpha: 1.0)
    let titleFont = NSFont.systemFont(ofSize: 13, weight: .semibold)
    let titleWidth = (title as NSString).size(withAttributes: [.font: titleFont]).width
    drawText(title, in: ctx, at: CGPoint(x: rect.midX - titleWidth / 2, y: titlebarRect.midY - 5), fontSize: 13, weight: .semibold, color: titleColor)
    
    // Divider line under titlebar
    ctx.setStrokeColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.08))
    ctx.setLineWidth(1.0)
    ctx.strokeLineSegments(between: [
        CGPoint(x: rect.origin.x, y: titlebarRect.minY),
        CGPoint(x: rect.origin.x + rect.width, y: titlebarRect.minY)
    ])
}

// Draw macOS Menu Bar
func drawMenuBar(in ctx: CGContext) {
    let barHeight: CGFloat = 30
    let barRect = CGRect(x: 0, y: heightF - barHeight, width: widthF, height: barHeight)
    
    // Semi-transparent frosted glass menu bar
    ctx.setFillColor(CGColor(red: 0.08, green: 0.09, blue: 0.14, alpha: 0.85))
    ctx.fill(barRect)
    
    ctx.setStrokeColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.08))
    ctx.setLineWidth(1.0)
    ctx.strokeLineSegments(between: [CGPoint(x: 0, y: barRect.minY), CGPoint(x: widthF, y: barRect.minY)])
    
    // Apple Logo & App Menus
    drawText("", in: ctx, at: CGPoint(x: 20, y: heightF - 21), fontSize: 16, weight: .bold, color: .white)
    
    let menus = ["Code", "File", "Edit", "Selection", "View", "Go", "Run", "Terminal", "Window", "Help"]
    var menuX: CGFloat = 50
    for (i, m) in menus.enumerated() {
        let isBold = (i == 0)
        drawText(m, in: ctx, at: CGPoint(x: menuX, y: heightF - 20), fontSize: 13, weight: isBold ? .bold : .regular, color: NSColor(white: 0.85, alpha: 1.0))
        let width = (m as NSString).size(withAttributes: [.font: NSFont.systemFont(ofSize: 13)]).width
        menuX += width + 18
    }
    
    // Status Bar Items (Right Side)
    let rightItems = ["Tue Oct 13  12:45 AM", "100%", "Wi-Fi", "Control Center"]
    var rightX: CGFloat = widthF - 180
    drawText("Tue Oct 13  12:45 AM", in: ctx, at: CGPoint(x: rightX, y: heightF - 20), fontSize: 13, weight: .regular, color: NSColor(white: 0.85, alpha: 1.0))
    
    // Byakugan Scan Menu Bar Eye Icon
    let eyeRect = CGRect(x: widthF - 225, y: heightF - 24, width: 18, height: 18)
    if let icon = menuIconImage, let cgIcon = icon.cgImage(forProposedRect: nil, context: nil, hints: nil) {
        ctx.saveGState()
        ctx.draw(cgIcon, in: eyeRect)
        ctx.restoreGState()
    } else {
        drawText("👁", in: ctx, at: CGPoint(x: eyeRect.origin.x, y: eyeRect.origin.y), fontSize: 14)
    }
    
    // Menu bar icon highlight halo
    ctx.setFillColor(CGColor(red: 0.4, green: 0.5, blue: 1.0, alpha: 0.25))
    ctx.fillEllipse(in: eyeRect.insetBy(dx: -4, dy: -4))
}

// Draw macOS Floating Keystroke HUD
func drawKeystrokeHUD(in ctx: CGContext, keys: [String], alpha: CGFloat = 1.0) {
    guard alpha > 0.01 else { return }
    ctx.saveGState()
    ctx.setAlpha(alpha)
    
    let keyWidth: CGFloat = 46
    let keyGap: CGFloat = 10
    let totalKeysW = CGFloat(keys.count) * keyWidth + CGFloat(keys.count - 1) * keyGap
    let hudPadding: CGFloat = 14
    let hudW = totalKeysW + hudPadding * 2
    let hudH: CGFloat = 64
    let hudRect = CGRect(x: widthF / 2 - hudW / 2, y: 70, width: hudW, height: hudH)
    
    // Blur shadow
    ctx.setShadow(offset: CGSize(width: 0, height: 4), blur: 20, color: CGColor(red: 0, green: 0, blue: 0, alpha: 0.7))
    
    // Dark Capsule Body
    let pillPath = CGPath(roundedRect: hudRect, cornerWidth: 20, cornerHeight: 20, transform: nil)
    ctx.addPath(pillPath)
    ctx.setFillColor(CGColor(red: 0.08, green: 0.09, blue: 0.12, alpha: 0.92))
    ctx.fillPath()
    
    ctx.addPath(pillPath)
    ctx.setStrokeColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.2))
    ctx.setLineWidth(1.5)
    ctx.strokePath()
    
    // Draw Keycaps
    for (i, key) in keys.enumerated() {
        let keyX = hudRect.origin.x + hudPadding + CGFloat(i) * (keyWidth + keyGap)
        let keyRect = CGRect(x: keyX, y: hudRect.origin.y + 10, width: keyWidth, height: 44)
        
        let capPath = CGPath(roundedRect: keyRect, cornerWidth: 10, cornerHeight: 10, transform: nil)
        ctx.addPath(capPath)
        ctx.setFillColor(CGColor(red: 0.18, green: 0.2, blue: 0.28, alpha: 1.0))
        ctx.fillPath()
        
        ctx.addPath(capPath)
        ctx.setStrokeColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.25))
        ctx.setLineWidth(1.0)
        ctx.strokePath()
        
        let font = NSFont.systemFont(ofSize: 22, weight: .bold)
        let strWidth = (key as NSString).size(withAttributes: [.font: font]).width
        drawText(key, in: ctx, at: CGPoint(x: keyRect.midX - strWidth / 2, y: keyRect.midY - 9), fontSize: 22, weight: .bold, color: .white)
    }
    ctx.restoreGState()
}

// Draw macOS Native Notification Banner (Top Right)
func drawNotification(in ctx: CGContext, title: String, subtitle: String, progress: CGFloat) {
    guard progress > 0.01 else { return }
    ctx.saveGState()
    
    // Slide in from right (spring animation)
    let notifW: CGFloat = 380
    let notifH: CGFloat = 84
    let targetX = widthF - notifW - 24
    let startX = widthF + 20
    let currentX = startX + (targetX - startX) * progress
    let notifRect = CGRect(x: currentX, y: heightF - notifH - 44, width: notifW, height: notifH)
    
    // Drop shadow
    ctx.setShadow(offset: CGSize(width: 0, height: 8), blur: 24, color: CGColor(red: 0, green: 0, blue: 0, alpha: 0.6))
    
    // Glass Body
    let path = CGPath(roundedRect: notifRect, cornerWidth: 18, cornerHeight: 18, transform: nil)
    ctx.addPath(path)
    ctx.setFillColor(CGColor(red: 0.12, green: 0.14, blue: 0.20, alpha: 0.95))
    ctx.fillPath()
    
    ctx.addPath(path)
    ctx.setStrokeColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.18))
    ctx.setLineWidth(1.2)
    ctx.strokePath()
    
    // App Icon in notification
    let iconRect = CGRect(x: notifRect.origin.x + 16, y: notifRect.origin.y + notifH/2 - 20, width: 40, height: 40)
    if let icon = appIconImage, let cgIcon = icon.cgImage(forProposedRect: nil, context: nil, hints: nil) {
        ctx.saveGState()
        let ip = CGPath(roundedRect: iconRect, cornerWidth: 9, cornerHeight: 9, transform: nil)
        ctx.addPath(ip)
        ctx.clip()
        ctx.draw(cgIcon, in: iconRect)
        ctx.restoreGState()
    }
    
    // Text labels
    drawText(title, in: ctx, at: CGPoint(x: notifRect.origin.x + 68, y: notifRect.origin.y + 48), fontSize: 14, weight: .bold, color: .white)
    drawText(subtitle, in: ctx, at: CGPoint(x: notifRect.origin.x + 68, y: notifRect.origin.y + 26), fontSize: 13, weight: .regular, color: NSColor(red: 0.4, green: 0.9, blue: 0.6, alpha: 1.0))
    drawText("now", in: ctx, at: CGPoint(x: notifRect.origin.x + notifW - 48, y: notifRect.origin.y + 48), fontSize: 12, weight: .regular, color: NSColor(white: 0.5, alpha: 1.0))
    
    ctx.restoreGState()
}

// Draw macOS Native Cursor
func drawCursor(in ctx: CGContext, at point: CGPoint, isCrosshair: Bool = false) {
    ctx.saveGState()
    if isCrosshair {
        // macOS Screenshot Crosshairs (+)
        ctx.setStrokeColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.95))
        ctx.setLineWidth(1.8)
        let chSize: CGFloat = 14
        ctx.strokeLineSegments(between: [
            CGPoint(x: point.x - chSize, y: point.y),
            CGPoint(x: point.x + chSize, y: point.y)
        ])
        ctx.strokeLineSegments(between: [
            CGPoint(x: point.x, y: point.y - chSize),
            CGPoint(x: point.x, y: point.y + chSize)
        ])
        ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        ctx.fillEllipse(in: CGRect(x: point.x - 2, y: point.y - 2, width: 4, height: 4))
    } else {
        // Realistic macOS Arrow Cursor (black with crisp white border)
        let p = CGMutablePath()
        p.move(to: CGPoint(x: point.x, y: point.y))
        p.addLine(to: CGPoint(x: point.x + 13, y: point.y - 13))
        p.addLine(to: CGPoint(x: point.x + 6.5, y: point.y - 13.5))
        p.addLine(to: CGPoint(x: point.x + 10.5, y: point.y - 22.5))
        p.addLine(to: CGPoint(x: point.x + 6.5, y: point.y - 24.5))
        p.addLine(to: CGPoint(x: point.x + 2.5, y: point.y - 15.5))
        p.addLine(to: CGPoint(x: point.x, y: point.y - 18.0))
        p.closeSubpath()
        
        ctx.setShadow(offset: CGSize(width: 1, height: -2), blur: 5, color: CGColor(red: 0, green: 0, blue: 0, alpha: 0.45))
        ctx.addPath(p)
        ctx.setFillColor(CGColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0))
        ctx.fillPath()
        
        ctx.addPath(p)
        ctx.setStrokeColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        ctx.setLineWidth(1.5)
        ctx.strokePath()
    }
    ctx.restoreGState()
}

// MARK: - Frame Generation Loop

print("🎥 Rendering 450 photorealistic macOS screen recording frames...")

for frameIndex in 0..<totalFrames {
    let t = Double(frameIndex) / Double(fps)
    
    var pixelBuffer: CVPixelBuffer?
    let attrs = [
        kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
        kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
    ] as CFDictionary
    CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
    guard let pb = pixelBuffer else { continue }
    
    CVPixelBufferLockBaseAddress(pb, [])
    let ctx = CGContext(
        data: CVPixelBufferGetBaseAddress(pb),
        width: width,
        height: height,
        bitsPerComponent: 8,
        bytesPerRow: CVPixelBufferGetBytesPerRow(pb),
        space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
    )!
    
    // 1. Realistic macOS Sonoma / Sequoia Horizon Wallpaper
    let bgColors = [
        CGColor(red: 0.07, green: 0.08, blue: 0.14, alpha: 1.0),
        CGColor(red: 0.12, green: 0.10, blue: 0.22, alpha: 1.0),
        CGColor(red: 0.22, green: 0.12, blue: 0.28, alpha: 1.0),
        CGColor(red: 0.15, green: 0.08, blue: 0.20, alpha: 1.0)
    ] as CFArray
    let bgGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: bgColors, locations: [0.0, 0.4, 0.75, 1.0])!
    ctx.drawLinearGradient(bgGrad, start: CGPoint(x: 0, y: heightF), end: CGPoint(x: widthF, y: 0), options: [])
    
    // Subtle ambient organic radial lighting
    let ambGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        CGColor(red: 0.4, green: 0.2, blue: 0.7, alpha: 0.25),
        CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    ] as CFArray, locations: [0.0, 1.0])!
    ctx.drawRadialGradient(ambGrad, startCenter: CGPoint(x: widthF * 0.35, y: heightF * 0.6), startRadius: 0, endCenter: CGPoint(x: widthF * 0.35, y: heightF * 0.6), endRadius: 800, options: [])
    
    // -------------------------------------------------------------------------
    // WINDOW LAYOUT
    // Left: Video Tutorial Window with trapped code
    let win1Rect = CGRect(x: 80, y: 140, width: 840, height: 800)
    
    // Right: VS Code Editor Window
    let win2Rect = CGRect(x: 960, y: 140, width: 880, height: 800)
    // -------------------------------------------------------------------------
    
    // Draw Left Window: YouTube / Video Player with trapped code
    drawWindowFrame(in: ctx, rect: win1Rect, title: "YouTube — Advanced Rust Concurrency [1080p]", isActive: (t < 5.0))
    
    // Video viewport area
    let videoViewport = CGRect(x: win1Rect.origin.x + 20, y: win1Rect.origin.y + 60, width: win1Rect.width - 40, height: win1Rect.height - 110)
    ctx.setFillColor(CGColor(red: 0.06, green: 0.07, blue: 0.10, alpha: 1.0))
    ctx.fill(videoViewport)
    
    // Video player banner header
    drawText("▶️ Video Lecture • Slide 14/42 (Paused)", in: ctx, at: CGPoint(x: videoViewport.origin.x + 24, y: videoViewport.maxY - 44), fontSize: 14, weight: .semibold, color: NSColor(white: 0.6, alpha: 1.0))
    
    // The Trapped Code Lines in Video
    let snippetLines = [
        "// Trapped text inside a rasterized video slide:",
        "pub struct ThreadPool {",
        "    workers: Vec<Worker>,",
        "    sender: Option<mpsc::Sender<Job>>,",
        "}"
    ]
    
    let codeBaseY = videoViewport.maxY - 140
    for (idx, line) in snippetLines.enumerated() {
        let lineY = codeBaseY - CGFloat(idx * 52)
        let isComment = line.hasPrefix("//")
        let col = isComment ? NSColor(white: 0.5, alpha: 1.0) : (idx == 1 ? NSColor(red: 0.4, green: 0.85, blue: 1.0, alpha: 1.0) : NSColor(white: 0.92, alpha: 1.0))
        drawText(line, in: ctx, at: CGPoint(x: videoViewport.origin.x + 40, y: lineY), fontSize: 26, weight: .medium, color: col, isMonospace: true)
    }
    
    // Video scrubber bar at bottom of player
    let scrubY = videoViewport.origin.y + 20
    ctx.setFillColor(CGColor(red: 0.25, green: 0.25, blue: 0.32, alpha: 1.0))
    ctx.fill(CGRect(x: videoViewport.origin.x + 24, y: scrubY, width: videoViewport.width - 48, height: 5))
    ctx.setFillColor(CGColor(red: 1.0, green: 0.2, blue: 0.3, alpha: 1.0))
    ctx.fill(CGRect(x: videoViewport.origin.x + 24, y: scrubY, width: 320, height: 5))
    drawText("14:22 / 48:10", in: ctx, at: CGPoint(x: videoViewport.origin.x + 24, y: scrubY + 12), fontSize: 12, weight: .regular, color: NSColor(white: 0.6, alpha: 1.0))
    
    // Draw Right Window: VS Code / Rust Editor
    drawWindowFrame(in: ctx, rect: win2Rect, title: "src/main.rs — MyProject", isActive: (t >= 5.0), bgColor: CGColor(red: 0.09, green: 0.10, blue: 0.14, alpha: 0.98))
    
    // Line Numbers & Editor Canvas
    for lineNum in 1...14 {
        let lY = win2Rect.maxY - 70 - CGFloat(lineNum * 48)
        drawText("\(lineNum)", in: ctx, at: CGPoint(x: win2Rect.origin.x + 20, y: lY), fontSize: 16, weight: .regular, color: NSColor(white: 0.3, alpha: 1.0), isMonospace: true)
    }
    
    // If text has been pasted (after t = 6.2s)
    if t >= 6.2 {
        let pasteProgress = min(1.0, (t - 6.2) / 0.6)
        let linesToDraw = Int(ceil(Double(snippetLines.count) * pasteProgress))
        
        // Comment typed
        drawText("// Sniped from lecture via Byakugan Scan in 38ms ⚡", in: ctx, at: CGPoint(x: win2Rect.origin.x + 65, y: win2Rect.maxY - 118), fontSize: 20, weight: .regular, color: NSColor(red: 0.4, green: 0.75, blue: 0.5, alpha: 1.0), isMonospace: true)
        
        if linesToDraw > 1 {
            for idx in 1..<min(linesToDraw, snippetLines.count) {
                let lY = win2Rect.maxY - 118 - CGFloat(idx * 48)
                let line = snippetLines[idx]
                let col = idx == 1 ? NSColor(red: 0.4, green: 0.85, blue: 1.0, alpha: 1.0) : NSColor(white: 0.92, alpha: 1.0)
                drawText(line, in: ctx, at: CGPoint(x: win2Rect.origin.x + 65, y: lY), fontSize: 22, weight: .medium, color: col, isMonospace: true)
            }
        }
        
        // Blinking typing caret
        if Int(t * 3.0) % 2 == 0 {
            let caretY = win2Rect.maxY - 118 - CGFloat(linesToDraw * 48)
            ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.9))
            ctx.fill(CGRect(x: win2Rect.origin.x + 65, y: caretY, width: 2.5, height: 26))
        }
    }
    
    // -------------------------------------------------------------------------
    // ANIMATION CHOREOGRAPHY (CURSOR, HUD, SELECTION)
    // -------------------------------------------------------------------------
    
    var cursorPos = CGPoint(x: 500, y: 720)
    var isCrosshair = false
    var showKeystrokes: [String]? = nil
    var notifProgress: CGFloat = 0.0
    var notifTitle = ""
    var notifSub = ""
    
    if t < 1.0 {
        // Idle viewing
        cursorPos = CGPoint(x: 480 + CGFloat(sin(t * 2)) * 20, y: 680)
        
    } else if t < 2.0 {
        // 1. User presses ⌘⇧2 (Byakugan Screen Text Shortcut)
        showKeystrokes = ["⌘", "⇧", "2"]
        cursorPos = CGPoint(x: 480, y: 680)
        
    } else if t < 4.2 {
        // 2. Interactive Selection Drag
        isCrosshair = true
        showKeystrokes = ["⌘", "⇧", "2"]
        
        // Dim screen slightly with macOS native capture shade
        ctx.setFillColor(CGColor(red: 0, green: 0, blue: 0, alpha: 0.28))
        ctx.fill(CGRect(x: 0, y: 0, width: widthF, height: heightF))
        
        let dragProgress = min(1.0, max(0.0, (t - 2.0) / 1.6))
        
        let selStartX = videoViewport.origin.x + 30
        let selStartY = codeBaseY + 30
        let selEndW: CGFloat = 580
        let selEndH: CGFloat = 260
        
        let currentW = selEndW * CGFloat(dragProgress)
        let currentH = selEndH * CGFloat(dragProgress)
        let selRect = CGRect(x: selStartX, y: selStartY - currentH, width: currentW, height: currentH)
        
        // Redraw un-dimmed video content inside selection for authentic magnifying effect
        ctx.saveGState()
        ctx.addRect(selRect)
        ctx.clip()
        ctx.setFillColor(CGColor(red: 0.06, green: 0.07, blue: 0.10, alpha: 1.0))
        ctx.fill(videoViewport)
        for (idx, line) in snippetLines.enumerated() {
            let lineY = codeBaseY - CGFloat(idx * 52)
            let isComment = line.hasPrefix("//")
            let col = isComment ? NSColor(white: 0.5, alpha: 1.0) : (idx == 1 ? NSColor(red: 0.4, green: 0.85, blue: 1.0, alpha: 1.0) : NSColor(white: 0.92, alpha: 1.0))
            drawText(line, in: ctx, at: CGPoint(x: videoViewport.origin.x + 40, y: lineY), fontSize: 26, weight: .medium, color: col, isMonospace: true)
        }
        ctx.restoreGState()
        
        // Selection Neon Fill & Stroke
        ctx.setFillColor(CGColor(red: 0.3, green: 0.6, blue: 1.0, alpha: 0.15))
        ctx.fill(selRect)
        
        ctx.setStrokeColor(CGColor(red: 0.1, green: 0.8, blue: 1.0, alpha: 0.95))
        ctx.setLineWidth(2.0)
        ctx.stroke(selRect)
        
        // Dimensions tooltip badge (e.g. "580 × 260")
        if currentW > 100 {
            let dimText = "\(Int(currentW)) × \(Int(currentH))"
            let dimBadgeRect = CGRect(x: selRect.maxX - 95, y: selRect.minY - 30, width: 95, height: 24)
            let bp = CGPath(roundedRect: dimBadgeRect, cornerWidth: 5, cornerHeight: 5, transform: nil)
            ctx.addPath(bp)
            ctx.setFillColor(CGColor(red: 0.1, green: 0.1, blue: 0.15, alpha: 0.9))
            ctx.fillPath()
            drawText(dimText, in: ctx, at: CGPoint(x: dimBadgeRect.origin.x + 10, y: dimBadgeRect.origin.y + 5), fontSize: 13, weight: .bold, color: .white, isMonospace: true)
        }
        
        cursorPos = CGPoint(x: selRect.maxX, y: selRect.minY)
        
    } else if t < 5.0 {
        // 3. Capture Instant Flash & Notification Slide
        if t < 4.4 {
            // Instant flash
            ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: CGFloat((4.4 - t) * 1.5)))
            ctx.fill(CGRect(x: 0, y: 0, width: widthF, height: heightF))
        }
        
        notifProgress = min(1.0, CGFloat((t - 4.2) / 0.4))
        notifTitle = "Byakugan Scan"
        notifSub = "⚡ Copied 5 lines to clipboard (38ms)"
        
        // Cursor moving toward right window
        let moveProg = CGFloat((t - 4.2) / 0.8)
        cursorPos = CGPoint(x: 600 + (1100 - 600) * moveProg, y: 500 + (700 - 500) * moveProg)
        
    } else if t < 7.2 {
        // 4. Cursor clicks in VS Code, presses ⌘V
        notifProgress = max(0.0, 1.0 - CGFloat((t - 6.0) / 0.5))
        notifTitle = "Byakugan Scan"
        notifSub = "⚡ Copied 5 lines to clipboard (38ms)"
        
        cursorPos = CGPoint(x: win2Rect.origin.x + 120, y: win2Rect.maxY - 140)
        showKeystrokes = ["⌘", "V"]
        
    } else if t < 10.5 {
        // 5. QR Code Scanning Workflow (⌘⇧6)
        // Background turns to QR code browser view
        let qrWinRect = CGRect(x: 240, y: 220, width: 700, height: 640)
        drawWindowFrame(in: ctx, rect: qrWinRect, title: "QR Code — byakugan-scan.aritro.cloud", isActive: true)
        
        // Mock QR Code Box
        let qrBox = CGRect(x: qrWinRect.midX - 140, y: qrWinRect.midY - 140, width: 280, height: 280)
        ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        ctx.fill(qrBox)
        
        ctx.setFillColor(CGColor(red: 0, green: 0, blue: 0, alpha: 1.0))
        ctx.fill(CGRect(x: qrBox.minX + 24, y: qrBox.maxY - 80, width: 56, height: 56))
        ctx.fill(CGRect(x: qrBox.maxX - 80, y: qrBox.maxY - 80, width: 56, height: 56))
        ctx.fill(CGRect(x: qrBox.minX + 24, y: qrBox.minY + 24, width: 56, height: 56))
        ctx.fill(CGRect(x: qrBox.midX - 28, y: qrBox.midY - 28, width: 56, height: 56))
        
        if t < 8.2 {
            showKeystrokes = ["⌘", "⇧", "6"]
            cursorPos = CGPoint(x: qrBox.minX, y: qrBox.maxY)
        } else if t < 9.5 {
            // Dragging over QR
            isCrosshair = true
            showKeystrokes = ["⌘", "⇧", "6"]
            let qProgress = min(1.0, CGFloat((t - 8.2) / 1.0))
            let qSelRect = CGRect(x: qrBox.minX - 10, y: qrBox.maxY + 10 - 300 * qProgress, width: 300 * qProgress, height: 300 * qProgress)
            ctx.setStrokeColor(CGColor(red: 0.2, green: 1.0, blue: 0.8, alpha: 0.95))
            ctx.setLineWidth(2.0)
            ctx.stroke(qSelRect)
            cursorPos = CGPoint(x: qSelRect.maxX, y: qSelRect.minY)
        } else {
            // QR Notification pop
            notifProgress = min(1.0, CGFloat((t - 9.5) / 0.4))
            notifTitle = "QR Code Detected"
            notifSub = "🔗 Opened: byakugan-scan.aritro.cloud"
            cursorPos = CGPoint(x: qrBox.maxX + 40, y: qrBox.minY)
        }
        
    } else {
        // 6. Terminal One-Liner & Outro (t = 10.5s – 15.0s)
        let termRect = CGRect(x: widthF / 2 - 460, y: heightF / 2 - 180, width: 920, height: 360)
        drawWindowFrame(in: ctx, rect: termRect, title: "Terminal — zsh — 80×24", isActive: true, bgColor: CGColor(red: 0.07, green: 0.08, blue: 0.12, alpha: 0.98))
        
        let termX = termRect.origin.x + 36
        let termY = termRect.maxY - 80
        drawText("aritro@MacBook-Pro ~ %", in: ctx, at: CGPoint(x: termX, y: termY), fontSize: 18, weight: .bold, color: NSColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 1.0), isMonospace: true)
        
        let command = "brew install --cask halcyon-past/tap/byakugan-scan"
        let typeProgress = min(1.0, max(0.0, (t - 11.0) / 1.8))
        let charsToType = Int(Double(command.count) * typeProgress)
        let currentCommand = String(command.prefix(charsToType))
        
        drawText(currentCommand, in: ctx, at: CGPoint(x: termX + 230, y: termY), fontSize: 18, weight: .bold, color: NSColor(red: 0.2, green: 1.0, blue: 0.6, alpha: 1.0), isMonospace: true)
        
        if typeProgress >= 1.0 {
            drawText("==> Downloading ByakuganScan-v1.0.2.dmg... [100%]", in: ctx, at: CGPoint(x: termX, y: termY - 44), fontSize: 16, weight: .regular, color: NSColor(white: 0.7, alpha: 1.0), isMonospace: true)
            drawText("🍺 byakugan-scan was successfully installed!", in: ctx, at: CGPoint(x: termX, y: termY - 80), fontSize: 16, weight: .bold, color: NSColor(red: 0.3, green: 1.0, blue: 0.6, alpha: 1.0), isMonospace: true)
        }
        
        // Outro banner at bottom
        drawText("⭐ github.com/halcyon-past/byakugan-scan  •  100% Offline & Free", in: ctx, at: CGPoint(x: widthF / 2 - 340, y: 90), fontSize: 20, weight: .bold, color: NSColor(red: 1.0, green: 0.75, blue: 0.2, alpha: 1.0))
        
        cursorPos = CGPoint(x: termRect.maxX - 40, y: termRect.minY + 40)
    }
    
    // Draw Keystroke HUD (if active)
    if let keys = showKeystrokes {
        drawKeystrokeHUD(in: ctx, keys: keys, alpha: 1.0)
    }
    
    // Draw Notification Toast (if active)
    if notifProgress > 0.01 {
        drawNotification(in: ctx, title: notifTitle, subtitle: notifSub, progress: notifProgress)
    }
    
    // Draw Native Cursor
    drawCursor(in: ctx, at: cursorPos, isCrosshair: isCrosshair)
    
    // Draw Top Menu Bar (always visible on macOS)
    drawMenuBar(in: ctx)
    
    CVPixelBufferUnlockBaseAddress(pb, [])
    
    let presentationTime = CMTime(value: Int64(frameIndex), timescale: fps)
    while !writerInput.isReadyForMoreMediaData {
        Thread.sleep(forTimeInterval: 0.005)
    }
    adaptor.append(pb, withPresentationTime: presentationTime)
    
    if (frameIndex + 1) % 75 == 0 {
        let percent = Int(Double(frameIndex + 1) / Double(totalFrames) * 100.0)
        print("  ⏳ Progress: \(percent)% (\(frameIndex + 1)/\(totalFrames) frames)")
    }
}

writerInput.markAsFinished()

let group = DispatchGroup()
group.enter()
writer.finishWriting {
    group.leave()
}
group.wait()

print("✨ Natural macOS screen recording demo complete!")
print("📁 Output saved to: \(outputURL.path)")
