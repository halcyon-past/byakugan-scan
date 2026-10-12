import Foundation
import AVFoundation
import CoreGraphics
import CoreText
import AppKit

// MARK: - Video Configuration
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

print("🎬 Initializing Byakugan Scan Demo Video Generator (1080p @ 30fps)...")

// Load App Icon
let iconPath = "\(projectDir)/ByakuganScan/Resources/Assets.xcassets/AppIcon.appiconset/icon_1024x1024.png"
let appIconImage = NSImage(contentsOfFile: iconPath)

// MARK: - AVAssetWriter Setup
let writer = try AVAssetWriter(outputURL: outputURL, fileType: .mp4)
let videoSettings: [String: Any] = [
    AVVideoCodecKey: AVVideoCodecType.h264,
    AVVideoWidthKey: width,
    AVVideoHeightKey: height,
    AVVideoCompressionPropertiesKey: [
        AVVideoAverageBitRateKey: 8_000_000, // 8 Mbps crisp 1080p
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

// MARK: - Drawing Helpers

func drawText(
    _ text: String,
    in ctx: CGContext,
    at point: CGPoint,
    fontSize: CGFloat,
    weight: NSFont.Weight = .regular,
    color: NSColor = .white,
    alignment: NSTextAlignment = .left,
    isMonospace: Bool = false
) {
    let font: NSFont
    if isMonospace {
        font = NSFont.monospacedSystemFont(ofSize: fontSize, weight: weight)
    } else {
        font = NSFont.systemFont(ofSize: fontSize, weight: weight)
    }
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = alignment
    
    let attrs: [NSAttributedString.Key: Any] = [
        .font: font,
        .foregroundColor: color,
        .paragraphStyle: paragraphStyle
    ]
    
    let attrStr = NSAttributedString(string: text, attributes: attrs)
    let line = CTLineCreateWithAttributedString(attrStr)
    
    ctx.saveGState()
    ctx.textPosition = point
    CTLineDraw(line, ctx)
    ctx.restoreGState()
}

func drawBadge(
    _ text: String,
    in ctx: CGContext,
    rect: CGRect,
    bgColor: CGColor,
    textColor: NSColor,
    borderColor: CGColor? = nil,
    fontSize: CGFloat = 18
) {
    ctx.saveGState()
    let path = CGPath(roundedRect: rect, cornerWidth: rect.height / 2, cornerHeight: rect.height / 2, transform: nil)
    ctx.addPath(path)
    ctx.setFillColor(bgColor)
    ctx.fillPath()
    
    if let borderColor = borderColor {
        ctx.addPath(path)
        ctx.setStrokeColor(borderColor)
        ctx.setLineWidth(1.5)
        ctx.strokePath()
    }
    
    let font = NSFont.monospacedSystemFont(ofSize: fontSize, weight: .bold)
    let attrs: [NSAttributedString.Key: Any] = [
        .font: font,
        .foregroundColor: textColor
    ]
    let attrStr = NSAttributedString(string: text, attributes: attrs)
    let line = CTLineCreateWithAttributedString(attrStr)
    let bounds = CTLineGetBoundsWithOptions(line, [])
    
    let textX = rect.midX - bounds.width / 2
    let textY = rect.midY - bounds.height / 2 - 2
    ctx.textPosition = CGPoint(x: textX, y: textY)
    CTLineDraw(line, ctx)
    ctx.restoreGState()
}

func drawWindow(in ctx: CGContext, rect: CGRect, title: String) {
    ctx.saveGState()
    // Window Shadow
    ctx.setShadow(offset: CGSize(width: 0, height: -12), blur: 30, color: CGColor(red: 0, green: 0, blue: 0, alpha: 0.6))
    
    // Window Body
    let bodyPath = CGPath(roundedRect: rect, cornerWidth: 16, cornerHeight: 16, transform: nil)
    ctx.addPath(bodyPath)
    ctx.setFillColor(CGColor(red: 0.07, green: 0.08, blue: 0.12, alpha: 0.95))
    ctx.fillPath()
    
    // Window Border
    ctx.addPath(bodyPath)
    ctx.setStrokeColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.15))
    ctx.setLineWidth(1.5)
    ctx.strokePath()
    ctx.restoreGState()
    
    // Window Titlebar
    let titlebarRect = CGRect(x: rect.origin.x, y: rect.origin.y + rect.height - 48, width: rect.width, height: 48)
    ctx.saveGState()
    ctx.setFillColor(CGColor(red: 0.11, green: 0.12, blue: 0.18, alpha: 1.0))
    let titlebarPath = CGPath(roundedRect: titlebarRect, cornerWidth: 16, cornerHeight: 16, transform: nil)
    ctx.addPath(titlebarPath)
    ctx.fillPath()
    
    // Traffic light buttons
    let buttonY = titlebarRect.midY - 6
    let startX = rect.origin.x + 20
    let colors = [
        CGColor(red: 1.0, green: 0.36, blue: 0.34, alpha: 1.0), // red
        CGColor(red: 1.0, green: 0.74, blue: 0.22, alpha: 1.0), // yellow
        CGColor(red: 0.18, green: 0.80, blue: 0.35, alpha: 1.0)  // green
    ]
    for (i, col) in colors.enumerated() {
        ctx.setFillColor(col)
        ctx.fillEllipse(in: CGRect(x: startX + CGFloat(i * 20), y: buttonY, width: 12, height: 12))
    }
    
    // Title text
    drawText(title, in: ctx, at: CGPoint(x: rect.midX - 70, y: titlebarRect.midY - 6), fontSize: 14, weight: .semibold, color: NSColor(white: 0.8, alpha: 1.0))
    ctx.restoreGState()
}

// MARK: - Frame Rendering Loop

print("🎥 Rendering 450 frames...")

for frameIndex in 0..<totalFrames {
    let t = Double(frameIndex) / Double(fps)
    
    // Create Pixel Buffer
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
    
    // Flip coordinate system for macOS standard rendering
    ctx.scaleBy(x: 1.0, y: 1.0)
    
    // 1. Draw Deep Sleek Background with Radial Glows
    ctx.setFillColor(CGColor(red: 0.04, green: 0.05, blue: 0.08, alpha: 1.0))
    ctx.fill(CGRect(x: 0, y: 0, width: width, height: height))
    
    // Atmospheric ambient glow
    let glowCenter = CGPoint(x: CGFloat(width) / 2, y: CGFloat(height) / 2)
    let glowRadius: CGFloat = 650.0
    let glowGradient = CGGradient(
        colorsSpace: CGColorSpaceCreateDeviceRGB(),
        colors: [
            CGColor(red: 0.36, green: 0.15, blue: 0.75, alpha: 0.35),
            CGColor(red: 0.85, green: 0.12, blue: 0.45, alpha: 0.15),
            CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        ] as CFArray,
        locations: [0.0, 0.45, 1.0]
    )!
    ctx.drawRadialGradient(glowGradient, startCenter: glowCenter, startRadius: 0, endCenter: glowCenter, endRadius: glowRadius, options: [])
    
    // 2. Render Scenes based on timeline
    if t < 3.2 {
        // SCENE 1: Brand Reveal (0.0s – 3.2s)
        let alpha = min(1.0, t * 1.5)
        ctx.saveGState()
        ctx.setAlpha(alpha)
        
        // Animated icon pulse
        let iconScale: CGFloat = 1.0 + 0.04 * CGFloat(sin(t * 3.0))
        let iconSize: CGFloat = 180 * iconScale
        let iconRect = CGRect(x: CGFloat(width)/2 - iconSize/2, y: CGFloat(height)/2 + 40 - iconSize/2, width: iconSize, height: iconSize)
        
        // Concentric radar halo
        ctx.setStrokeColor(CGColor(red: 0.38, green: 0.35, blue: 0.95, alpha: 0.3 + 0.15 * CGFloat(sin(t * 4.0))))
        ctx.setLineWidth(3.0)
        ctx.strokeEllipse(in: iconRect.insetBy(dx: -25, dy: -25))
        ctx.strokeEllipse(in: iconRect.insetBy(dx: -50, dy: -50))
        
        if let icon = appIconImage, let cgIcon = icon.cgImage(forProposedRect: nil, context: nil, hints: nil) {
            ctx.saveGState()
            let iconPath = CGPath(roundedRect: iconRect, cornerWidth: 38, cornerHeight: 38, transform: nil)
            ctx.addPath(iconPath)
            ctx.clip()
            ctx.draw(cgIcon, in: iconRect)
            ctx.restoreGState()
        }
        
        // Titles
        drawText("BYAKUGAN SCAN", in: ctx, at: CGPoint(x: CGFloat(width)/2 - 250, y: CGFloat(height)/2 - 120), fontSize: 56, weight: .black, color: .white)
        drawText("Sub-100ms On-Device Screen OCR for macOS", in: ctx, at: CGPoint(x: CGFloat(width)/2 - 265, y: CGFloat(height)/2 - 165), fontSize: 24, weight: .medium, color: NSColor(red: 0.7, green: 0.75, blue: 0.85, alpha: 1.0))
        
        // Feature Pills
        let pillY = CGFloat(height)/2 - 240
        drawBadge("⚡ Pure In-Memory", in: ctx, rect: CGRect(x: CGFloat(width)/2 - 340, y: pillY, width: 210, height: 42), bgColor: CGColor(red: 0.36, green: 0.18, blue: 0.85, alpha: 0.3), textColor: NSColor(red: 0.7, green: 0.6, blue: 1.0, alpha: 1.0), borderColor: CGColor(red: 0.5, green: 0.3, blue: 1.0, alpha: 0.5))
        drawBadge("🧠 Neural Engine", in: ctx, rect: CGRect(x: CGFloat(width)/2 - 110, y: pillY, width: 210, height: 42), bgColor: CGColor(red: 0.85, green: 0.18, blue: 0.5, alpha: 0.3), textColor: NSColor(red: 1.0, green: 0.6, blue: 0.8, alpha: 1.0), borderColor: CGColor(red: 1.0, green: 0.3, blue: 0.6, alpha: 0.5))
        drawBadge("🔒 100% Offline", in: ctx, rect: CGRect(x: CGFloat(width)/2 + 120, y: pillY, width: 210, height: 42), bgColor: CGColor(red: 0.1, green: 0.6, blue: 0.4, alpha: 0.3), textColor: NSColor(red: 0.4, green: 1.0, blue: 0.7, alpha: 1.0), borderColor: CGColor(red: 0.2, green: 0.8, blue: 0.5, alpha: 0.5))
        
        ctx.restoreGState()
        
    } else if t < 7.5 {
        // SCENE 2: Instant Text OCR Simulation (3.2s – 7.5s)
        let sceneT = t - 3.2
        
        // Header
        drawText("1. INSTANT TEXT RECOGNITION (⌘⇧2)", in: ctx, at: CGPoint(x: 180, y: heightF - 120), fontSize: 32, weight: .bold, color: NSColor(red: 0.4, green: 0.7, blue: 1.0, alpha: 1.0))
        drawText("Extract unselectable text from images, locked PDFs, mockups, or videos in 40ms.", in: ctx, at: CGPoint(x: 180, y: heightF - 155), fontSize: 20, weight: .regular, color: NSColor(white: 0.65, alpha: 1.0))
        
        // Code Window
        let winRect = CGRect(x: 180, y: 180, width: 950, height: 650)
        drawWindow(in: ctx, rect: winRect, title: "Unselectable_Code_Snippet.png — Preview")
        
        // Window code content
        let codeLines = [
            "// Trapped text inside a rasterized graphic",
            "import Vision",
            "import AppKit",
            "",
            "final class NeuralTextEngine {",
            "    let model = VNRecognizeTextRequest()",
            "    let latencyMs: Double = 42.0",
            "    let privacyGuaranteed: Bool = true",
            "    let status = \"Instant In-Memory OCR Active\"",
            "}"
        ]
        
        for (idx, line) in codeLines.enumerated() {
            let lineY = winRect.origin.y + winRect.height - 110 - CGFloat(idx * 44)
            let isComment = line.hasPrefix("//")
            let textColor = isComment ? NSColor(white: 0.5, alpha: 1.0) : NSColor(red: 0.85, green: 0.9, blue: 1.0, alpha: 1.0)
            drawText(line, in: ctx, at: CGPoint(x: winRect.origin.x + 40, y: lineY), fontSize: 22, weight: .medium, color: textColor, isMonospace: true)
        }
        
        // Animated Crosshair & Selection Box
        let selectionProgress = min(1.0, max(0.0, (sceneT - 0.8) / 1.4))
        if selectionProgress > 0.0 {
            let selStart = CGPoint(x: winRect.origin.x + 30, y: winRect.origin.y + winRect.height - 230)
            let selW = 680 * CGFloat(selectionProgress)
            let selH = 260 * CGFloat(selectionProgress)
            let selRect = CGRect(x: selStart.x, y: selStart.y - selH, width: selW, height: selH)
            
            // Neon Selection Fill
            ctx.setFillColor(CGColor(red: 0.2, green: 0.5, blue: 1.0, alpha: 0.18))
            ctx.fill(selRect)
            
            // Neon Glowing Outline
            ctx.setStrokeColor(CGColor(red: 0.0, green: 0.85, blue: 1.0, alpha: 0.9))
            ctx.setLineWidth(2.5)
            ctx.stroke(selRect)
            
            // Corner Grips
            let gripSize: CGFloat = 10.0
            ctx.setFillColor(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            ctx.fill(CGRect(x: selRect.minX - gripSize/2, y: selRect.minY - gripSize/2, width: gripSize, height: gripSize))
            ctx.fill(CGRect(x: selRect.maxX - gripSize/2, y: selRect.minY - gripSize/2, width: gripSize, height: gripSize))
            ctx.fill(CGRect(x: selRect.minX - gripSize/2, y: selRect.maxY - gripSize/2, width: gripSize, height: gripSize))
            ctx.fill(CGRect(x: selRect.maxX - gripSize/2, y: selRect.maxY - gripSize/2, width: gripSize, height: gripSize))
        }
        
        // Capture Complete Event (after 2.3s in scene)
        if sceneT > 2.3 {
            // Flash effect
            let flashAlpha = max(0.0, 1.0 - (sceneT - 2.3) * 3.0)
            if flashAlpha > 0.0 {
                ctx.setFillColor(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: CGFloat(flashAlpha * 0.4)))
                ctx.fill(CGRect(x: 0, y: 0, width: width, height: height))
            }
            
            // Floating Success HUD Pill
            let hudRect = CGRect(x: 1200, y: 520, width: 540, height: 180)
            ctx.saveGState()
            ctx.setShadow(offset: CGSize(width: 0, height: -10), blur: 25, color: CGColor(red: 0, green: 0, blue: 0, alpha: 0.6))
            let hudPath = CGPath(roundedRect: hudRect, cornerWidth: 20, cornerHeight: 20, transform: nil)
            ctx.addPath(hudPath)
            ctx.setFillColor(CGColor(red: 0.1, green: 0.12, blue: 0.2, alpha: 0.95))
            ctx.fillPath()
            ctx.addPath(hudPath)
            ctx.setStrokeColor(CGColor(red: 0.2, green: 0.8, blue: 0.5, alpha: 0.6))
            ctx.setLineWidth(2.0)
            ctx.strokePath()
            ctx.restoreGState()
            
            drawText("⚡ Extracted in 42ms", in: ctx, at: CGPoint(x: hudRect.origin.x + 30, y: hudRect.origin.y + hudRect.height - 50), fontSize: 24, weight: .bold, color: NSColor(red: 0.3, green: 1.0, blue: 0.6, alpha: 1.0))
            drawText("Copied directly to clipboard!", in: ctx, at: CGPoint(x: hudRect.origin.x + 30, y: hudRect.origin.y + hudRect.height - 85), fontSize: 18, weight: .medium, color: NSColor(white: 0.8, alpha: 1.0))
            drawText("let latencyMs: Double = 42.0...", in: ctx, at: CGPoint(x: hudRect.origin.x + 30, y: hudRect.origin.y + hudRect.height - 125), fontSize: 16, weight: .regular, color: NSColor(red: 0.7, green: 0.85, blue: 1.0, alpha: 1.0), isMonospace: true)
            
            // Audio Feedback Pill
            drawBadge("🔊 Speech Audio Available (⌘S)", in: ctx, rect: CGRect(x: 1200, y: 440, width: 360, height: 42), bgColor: CGColor(red: 0.3, green: 0.2, blue: 0.7, alpha: 0.4), textColor: NSColor(red: 0.8, green: 0.7, blue: 1.0, alpha: 1.0))
        }
        
    } else if t < 11.2 {
        // SCENE 3: QR Code & Commercial Barcodes (7.5s – 11.2s)
        let sceneT = t - 7.5
        
        drawText("2. INSTANT QR & BARCODE DECODING (⌘⇧6 / ⌘⇧7)", in: ctx, at: CGPoint(x: 180, y: heightF - 120), fontSize: 32, weight: .bold, color: NSColor(red: 0.2, green: 0.9, blue: 0.8, alpha: 1.0))
        drawText("Point, select, and decode. Links automatically open in your default browser.", in: ctx, at: CGPoint(x: 180, y: heightF - 155), fontSize: 20, weight: .regular, color: NSColor(white: 0.65, alpha: 1.0))
        
        // Left Card: QR Code Simulation
        let qrCardRect = CGRect(x: 180, y: 240, width: 440, height: 540)
        drawWindow(in: ctx, rect: qrCardRect, title: "QR Code Viewfinder")
        
        // Draw Mock QR Grid
        let qrCenter = CGPoint(x: qrCardRect.midX, y: qrCardRect.midY - 20)
        let qrBoxSize: CGFloat = 260
        let qrRect = CGRect(x: qrCenter.x - qrBoxSize/2, y: qrCenter.y - qrBoxSize/2, width: qrBoxSize, height: qrBoxSize)
        ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        ctx.fill(qrRect)
        
        // QR corner locator markers
        ctx.setFillColor(CGColor(red: 0, green: 0, blue: 0, alpha: 1.0))
        ctx.fill(CGRect(x: qrRect.minX + 20, y: qrRect.maxY - 70, width: 50, height: 50))
        ctx.fill(CGRect(x: qrRect.maxX - 70, y: qrRect.maxY - 70, width: 50, height: 50))
        ctx.fill(CGRect(x: qrRect.minX + 20, y: qrRect.minY + 20, width: 50, height: 50))
        
        // Draw Scan laser sweeping down
        let laserProgress = CGFloat((sceneT * 1.5).truncatingRemainder(dividingBy: 1.0))
        let laserY = qrRect.maxY - (qrBoxSize * laserProgress)
        ctx.setStrokeColor(CGColor(red: 0.0, green: 1.0, blue: 0.7, alpha: 0.8))
        ctx.setLineWidth(4.0)
        ctx.strokeLineSegments(between: [CGPoint(x: qrRect.minX, y: laserY), CGPoint(x: qrRect.maxX, y: laserY)])
        
        // Right Card: Result Showcase
        let resCardRect = CGRect(x: 680, y: 240, width: 1060, height: 540)
        drawWindow(in: ctx, rect: resCardRect, title: "Byakugan Scan Result")
        
        drawText("✅ QR CODE DECODED INSTANTLY", in: ctx, at: CGPoint(x: resCardRect.origin.x + 50, y: resCardRect.origin.y + resCardRect.height - 120), fontSize: 26, weight: .bold, color: NSColor(red: 0.2, green: 0.9, blue: 0.6, alpha: 1.0))
        
        let urlPillRect = CGRect(x: resCardRect.origin.x + 50, y: resCardRect.origin.y + resCardRect.height - 210, width: 780, height: 60)
        drawBadge("https://byakugan-scan.aritro.cloud", in: ctx, rect: urlPillRect, bgColor: CGColor(red: 0.05, green: 0.15, blue: 0.25, alpha: 1.0), textColor: NSColor(red: 0.3, green: 0.8, blue: 1.0, alpha: 1.0), borderColor: CGColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 0.5), fontSize: 22)
        
        drawText("🌐 Action: Auto-opened in default web browser", in: ctx, at: CGPoint(x: resCardRect.origin.x + 50, y: resCardRect.origin.y + resCardRect.height - 260), fontSize: 20, weight: .medium, color: NSColor(white: 0.85, alpha: 1.0))
        
        // Barcode Symbologies
        drawText("Universal Barcode Support:", in: ctx, at: CGPoint(x: resCardRect.origin.x + 50, y: resCardRect.origin.y + resCardRect.height - 330), fontSize: 20, weight: .bold, color: .white)
        drawText("EAN-13  •  UPC-E  •  Code 128  •  Data Matrix  •  Aztec  •  PDF417  •  Code 39", in: ctx, at: CGPoint(x: resCardRect.origin.x + 50, y: resCardRect.origin.y + resCardRect.height - 370), fontSize: 18, weight: .regular, color: NSColor(red: 1.0, green: 0.7, blue: 0.3, alpha: 1.0), isMonospace: true)
        
        drawBadge("Copied to History", in: ctx, rect: CGRect(x: resCardRect.origin.x + 50, y: resCardRect.origin.y + 60, width: 220, height: 44), bgColor: CGColor(red: 0.2, green: 0.1, blue: 0.4, alpha: 0.5), textColor: NSColor(red: 0.8, green: 0.6, blue: 1.0, alpha: 1.0))
        
    } else {
        // SCENE 4: Developer Ecosystem & Outro (11.2s – 15.0s)
        let sceneT = t - 11.2
        
        drawText("BUILT FOR POWER USERS & DEVELOPERS", in: ctx, at: CGPoint(x: widthF/2 - 340, y: heightF - 140), fontSize: 36, weight: .black, color: .white)
        drawText("Integrate seamlessly with Raycast, Alfred, Stream Deck, and macOS Shortcuts.", in: ctx, at: CGPoint(x: widthF/2 - 360, y: heightF - 180), fontSize: 20, weight: .regular, color: NSColor(white: 0.7, alpha: 1.0))
        
        // Deep Link Box
        let deepLinkRect = CGRect(x: widthF/2 - 420, y: heightF - 320, width: 840, height: 80)
        drawBadge("byakugan://scan?mode=text", in: ctx, rect: deepLinkRect, bgColor: CGColor(red: 0.08, green: 0.1, blue: 0.18, alpha: 1.0), textColor: NSColor(red: 0.4, green: 0.9, blue: 1.0, alpha: 1.0), borderColor: CGColor(red: 0.3, green: 0.6, blue: 1.0, alpha: 0.6), fontSize: 28)
        
        // Terminal Installation Box
        let termRect = CGRect(x: widthF/2 - 480, y: 220, width: 960, height: 180)
        drawWindow(in: ctx, rect: termRect, title: "Terminal — Install via Homebrew")
        
        drawText("$ brew install --cask halcyon-past/tap/byakugan-scan", in: ctx, at: CGPoint(x: termRect.origin.x + 40, y: termRect.origin.y + 70), fontSize: 26, weight: .bold, color: NSColor(red: 0.2, green: 1.0, blue: 0.6, alpha: 1.0), isMonospace: true)
        
        // Outro CTA
        drawText("⭐ Open Source on GitHub: github.com/halcyon-past/byakugan-scan", in: ctx, at: CGPoint(x: widthF/2 - 360, y: 120), fontSize: 22, weight: .bold, color: NSColor(red: 1.0, green: 0.75, blue: 0.2, alpha: 1.0))
        drawText("🌐 Official Website: byakugan-scan.aritro.cloud", in: ctx, at: CGPoint(x: widthF/2 - 240, y: 80), fontSize: 18, weight: .medium, color: NSColor(white: 0.8, alpha: 1.0))
    }
    
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

print("✨ Video rendering complete!")
print("📁 Output saved to: \(outputURL.path)")
