import Foundation
import AVFoundation
import CoreGraphics
import CoreText
import AppKit
import AudioToolbox

// MARK: - Video Dimensions & Setup
let width = 1920
let height = 1080
let widthF = CGFloat(width)
let heightF = CGFloat(height)
let fps: Int32 = 60
let totalSeconds: Double = 15.0
let totalFrames = Int(totalSeconds * Double(fps)) // 900 frames at 60fps

let projectDir = FileManager.default.currentDirectoryPath
let outputURL = URL(fileURLWithPath: "\(projectDir)/demo_byakugan_scan.mp4")
try? FileManager.default.removeItem(at: outputURL)

print("🎬 Initializing High-Fidelity 60 FPS Cinematic Demo Generator...")
print("🎯 Target: 1080p @ 60fps (900 frames) with Multiplexed Lo-Fi Music & Foley SFX")

// Load App Assets
let iconPath = "\(projectDir)/ByakuganScan/Resources/Assets.xcassets/AppIcon.appiconset/icon_1024x1024.png"
let menuIconPath = "\(projectDir)/ByakuganScan/Resources/Assets.xcassets/MenuBarIcon.imageset/menubar_icon@3x.png"
let appIconImage = NSImage(contentsOfFile: iconPath)
let menuIconImage = NSImage(contentsOfFile: menuIconPath)

// MARK: - Audio Track Synthesis (Lo-Fi Tech Groove + Foley SFX)
let sampleRate: Double = 44100.0
let totalAudioSamples = Int(totalSeconds * sampleRate)
var audioBuffer = [Float](repeating: 0.0, count: totalAudioSamples * 2)

func mixSample(at sampleIdx: Int, left: Float, right: Float) {
    guard sampleIdx >= 0 && sampleIdx < totalAudioSamples else { return }
    audioBuffer[sampleIdx * 2] += left
    audioBuffer[sampleIdx * 2 + 1] += right
}

// 1. Kick Drum (Deep sub sweep)
func addKick(at t: Double, volume: Float = 0.38) {
    let startIdx = Int(t * sampleRate)
    let durSamples = Int(0.18 * sampleRate)
    for i in 0..<durSamples {
        let p = Double(i) / Double(durSamples)
        let freq = 135.0 * exp(-16.0 * p) + 38.0
        let env = Float(exp(-10.0 * p))
        let sample = Float(sin(2.0 * .pi * freq * Double(i) / sampleRate)) * env * volume
        mixSample(at: startIdx + i, left: sample, right: sample)
    }
}

// 2. Snare / Rimshot (Layered noise + body)
func addSnare(at t: Double, volume: Float = 0.22) {
    let startIdx = Int(t * sampleRate)
    let durSamples = Int(0.12 * sampleRate)
    for i in 0..<durSamples {
        let p = Double(i) / Double(durSamples)
        let noise = Float.random(in: -1.0...1.0)
        let tone = Float(sin(2.0 * .pi * 215.0 * Double(i) / sampleRate)) * 0.35
        let env = Float(exp(-16.0 * p))
        let sample = (noise * 0.75 + tone * 0.25) * env * volume
        mixSample(at: startIdx + i, left: sample, right: sample)
    }
}

// 3. Hi-Hat (Delicate stereo tick)
func addHiHat(at t: Double, volume: Float = 0.09) {
    let startIdx = Int(t * sampleRate)
    let durSamples = Int(0.035 * sampleRate)
    for i in 0..<durSamples {
        let p = Double(i) / Double(durSamples)
        let noise = Float.random(in: -1.0...1.0)
        let env = Float(exp(-45.0 * p))
        let sample = noise * env * volume
        mixSample(at: startIdx + i, left: sample * 0.85, right: sample * 1.15)
    }
}

// 4. Synth Chord Pad (Warm, ambient detuned sines)
func addChord(at t: Double, freqs: [Double], duration: Double, volume: Float = 0.14) {
    let startIdx = Int(t * sampleRate)
    let durSamples = Int(duration * sampleRate)
    for i in 0..<durSamples {
        let curT = Double(i) / sampleRate
        let env: Float
        if curT < 0.08 {
            env = Float(curT / 0.08)
        } else {
            env = Float(exp(-1.2 * (curT - 0.08)))
        }
        var sample: Float = 0.0
        for (idx, f) in freqs.enumerated() {
            let detune = (idx % 2 == 0 ? 0.4 : -0.4)
            sample += Float(sin(2.0 * .pi * (f + detune) * curT)) * 0.22
            // Subtle 2nd harmonic
            sample += Float(sin(4.0 * .pi * (f + detune) * curT)) * 0.05
        }
        let finalS = sample * env * volume
        mixSample(at: startIdx + i, left: finalS * 0.95, right: finalS * 1.05)
    }
}

// 5. Mechanical Keystroke Click SFX
func addMechanicalClick(at t: Double, volume: Float = 0.55) {
    let startIdx = Int(t * sampleRate)
    let durSamples = Int(0.035 * sampleRate)
    for i in 0..<durSamples {
        let curT = Double(i) / sampleRate
        let env = Float(exp(-110.0 * curT))
        let click = (Float.random(in: -1.0...1.0) * 0.6 + Float(sin(2.0 * .pi * 2800.0 * curT)) * 0.4) * env * volume
        mixSample(at: startIdx + i, left: click, right: click)
    }
}

// 6. Camera Shutter SFX (Double mechanical latch)
func addCameraShutter(at t: Double, volume: Float = 0.65) {
    addMechanicalClick(at: t, volume: volume)
    addMechanicalClick(at: t + 0.055, volume: volume * 0.85)
}

// 7. macOS Glass Chime Notification SFX
func addGlassChime(at t: Double, volume: Float = 0.45) {
    let startIdx = Int(t * sampleRate)
    let durSamples = Int(0.65 * sampleRate)
    for i in 0..<durSamples {
        let curT = Double(i) / sampleRate
        let env = Float(exp(-5.5 * curT))
        let tone1 = Float(sin(2.0 * .pi * 1567.98 * curT)) * 0.45 // G6
        let tone2 = Float(sin(2.0 * .pi * 2093.00 * curT)) * 0.45 // C7
        let sample = (tone1 + tone2) * env * volume
        mixSample(at: startIdx + i, left: sample, right: sample)
    }
}

// 8. Terminal Typing Clatter (Series of micro clicks)
func addTypingClatter(from startT: Double, to endT: Double, count: Int, volume: Float = 0.35) {
    let dt = (endT - startT) / Double(count)
    for i in 0..<count {
        let clickT = startT + Double(i) * dt + Double.random(in: -0.015...0.015)
        addMechanicalClick(at: clickT, volume: volume * Float.random(in: 0.7...1.1))
    }
}

print("🎵 Synthesizing procedural lo-fi soundtrack and synchronized sound effects...")

// Generate Lo-Fi Music (115 BPM)
let bpm: Double = 115.0
let beatDur = 60.0 / bpm
var beat = 0.0
while beat * beatDur < totalSeconds - 0.4 {
    let beatTime = beat * beatDur
    let beatInBar = Int(beat) % 4
    
    // Rhythm
    if beatInBar == 0 || beatInBar == 2 {
        addKick(at: beatTime, volume: 0.34)
    }
    if beatInBar == 1 || beatInBar == 3 {
        addSnare(at: beatTime, volume: 0.22)
    }
    addHiHat(at: beatTime, volume: 0.08)
    addHiHat(at: beatTime + beatDur * 0.5, volume: 0.07)
    
    // Lo-Fi Chords
    if beatInBar == 0 {
        let bar = Int(beat / 4) % 4
        switch bar {
        case 0: addChord(at: beatTime, freqs: [164.81, 196.00, 246.94, 293.66], duration: beatDur * 3.6, volume: 0.15) // Em7
        case 1: addChord(at: beatTime, freqs: [130.81, 164.81, 196.00, 246.94], duration: beatDur * 3.6, volume: 0.15) // Cmaj7
        case 2: addChord(at: beatTime, freqs: [196.00, 246.94, 293.66, 369.99], duration: beatDur * 3.6, volume: 0.15) // Gmaj7
        case 3: addChord(at: beatTime, freqs: [146.83, 220.00, 293.66, 369.99], duration: beatDur * 3.6, volume: 0.15) // Dsus4
        default: break
        }
    }
    beat += 1.0
}

// Foley SFX Cue List (Exact timestamps synced with visuals)
addMechanicalClick(at: 2.05, volume: 0.6)  // ⌘⇧2 pressed
addCameraShutter(at: 3.75, volume: 0.7)    // Selection released
addGlassChime(at: 3.95, volume: 0.5)      // OCR notification ping
addMechanicalClick(at: 5.60, volume: 0.6)  // ⌘V pressed
addMechanicalClick(at: 7.75, volume: 0.6)  // ⌘⇧6 pressed
addCameraShutter(at: 9.15, volume: 0.7)    // QR scan capture
addGlassChime(at: 9.35, volume: 0.5)      // QR detected ping
addTypingClatter(from: 10.9, to: 12.8, count: 42, volume: 0.38) // Terminal typing brew install
addGlassChime(at: 13.0, volume: 0.5)      // Installation complete chime

// Normalize Audio Buffer to prevent any clipping
let maxAudioVal = audioBuffer.map { abs($0) }.max() ?? 1.0
if maxAudioVal > 0.95 {
    let scale = 0.95 / maxAudioVal
    for i in 0..<audioBuffer.count { audioBuffer[i] *= scale }
}

// MARK: - AVAssetWriter Multiplexing Setup
let writer = try AVAssetWriter(outputURL: outputURL, fileType: .mp4)

// Video Input
let videoSettings: [String: Any] = [
    AVVideoCodecKey: AVVideoCodecType.h264,
    AVVideoWidthKey: width,
    AVVideoHeightKey: height,
    AVVideoCompressionPropertiesKey: [
        AVVideoAverageBitRateKey: 12_000_000, // 12 Mbps crystal crisp 1080p
        AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel
    ]
]
let videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
videoInput.expectsMediaDataInRealTime = false

let adaptor = AVAssetWriterInputPixelBufferAdaptor(
    assetWriterInput: videoInput,
    sourcePixelBufferAttributes: [
        kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
        kCVPixelBufferWidthKey as String: width,
        kCVPixelBufferHeightKey as String: height
    ]
)
writer.add(videoInput)

// Audio Input (AAC 44.1kHz Stereo 128kbps)
let audioSettings: [String: Any] = [
    AVFormatIDKey: kAudioFormatMPEG4AAC,
    AVNumberOfChannelsKey: 2,
    AVSampleRateKey: sampleRate,
    AVEncoderBitRateKey: 128000
]
let audioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSettings)
audioInput.expectsMediaDataInRealTime = false
writer.add(audioInput)

writer.startWriting()
writer.startSession(atSourceTime: .zero)

// Write Audio Track
var asbd = AudioStreamBasicDescription(
    mSampleRate: sampleRate,
    mFormatID: kAudioFormatLinearPCM,
    mFormatFlags: kAudioFormatFlagIsFloat | kAudioFormatFlagIsPacked,
    mBytesPerPacket: 8,
    mFramesPerPacket: 1,
    mBytesPerFrame: 8,
    mChannelsPerFrame: 2,
    mBitsPerChannel: 32,
    mReserved: 0
)

var formatDesc: CMAudioFormatDescription?
CMAudioFormatDescriptionCreate(
    allocator: kCFAllocatorDefault,
    asbd: &asbd,
    layoutSize: 0,
    layout: nil,
    magicCookieSize: 0,
    magicCookie: nil,
    extensions: nil,
    formatDescriptionOut: &formatDesc
)

let audioDataSize = totalAudioSamples * 8
var blockBuffer: CMBlockBuffer?
CMBlockBufferCreateWithMemoryBlock(
    allocator: kCFAllocatorDefault,
    memoryBlock: nil,
    blockLength: audioDataSize,
    blockAllocator: nil,
    customBlockSource: nil,
    offsetToData: 0,
    dataLength: audioDataSize,
    flags: 0,
    blockBufferOut: &blockBuffer
)

_ = audioBuffer.withUnsafeBytes { rawPtr in
    CMBlockBufferReplaceDataBytes(
        with: rawPtr.baseAddress!,
        blockBuffer: blockBuffer!,
        offsetIntoDestination: 0,
        dataLength: audioDataSize
    )
}

var audioSampleBuffer: CMSampleBuffer?
var audioTiming = CMSampleTimingInfo(
    duration: CMTime(value: 1, timescale: Int32(sampleRate)),
    presentationTimeStamp: .zero,
    decodeTimeStamp: .invalid
)

CMSampleBufferCreate(
    allocator: kCFAllocatorDefault,
    dataBuffer: blockBuffer,
    dataReady: true,
    makeDataReadyCallback: nil,
    refcon: nil,
    formatDescription: formatDesc,
    sampleCount: CMItemCount(totalAudioSamples),
    sampleTimingEntryCount: 1,
    sampleTimingArray: &audioTiming,
    sampleSizeEntryCount: 0,
    sampleSizeArray: nil,
    sampleBufferOut: &audioSampleBuffer
)

while !audioInput.isReadyForMoreMediaData { usleep(1000) }
audioInput.append(audioSampleBuffer!)
audioInput.markAsFinished()
print("✅ Audio track multiplexed successfully into asset writer!")

// MARK: - Mathematical Easing Functions
func easeInOutCubic(_ t: CGFloat) -> CGFloat {
    return t < 0.5 ? 4.0 * t * t * t : 1.0 - pow(-2.0 * t + 2.0, 3) / 2.0
}

func easeOutBack(_ t: CGFloat) -> CGFloat {
    let c1: CGFloat = 1.70158
    let c3 = c1 + 1.0
    return 1.0 + c3 * pow(t - 1.0, 3) + c1 * pow(t - 1.0, 2)
}

func smoothPoint(from p0: CGPoint, to p1: CGPoint, progress: CGFloat) -> CGPoint {
    let ease = easeInOutCubic(progress)
    return CGPoint(x: p0.x + (p1.x - p0.x) * ease, y: p0.y + (p1.y - p0.y) * ease)
}

// MARK: - Core Graphics Vector Drawing Functions
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

// Desktop Wallpaper (Rich macOS Sequoia Radiance)
func drawDesktopBackground(in ctx: CGContext) {
    let colors = [
        CGColor(red: 0.05, green: 0.06, blue: 0.12, alpha: 1.0),
        CGColor(red: 0.10, green: 0.08, blue: 0.22, alpha: 1.0),
        CGColor(red: 0.04, green: 0.05, blue: 0.10, alpha: 1.0)
    ] as CFArray
    let locations: [CGFloat] = [0.0, 0.55, 1.0]
    guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: locations) else { return }
    
    ctx.drawLinearGradient(gradient, start: CGPoint(x: 0, y: heightF), end: CGPoint(x: widthF, y: 0), options: [])
    
    // Soft subtle radial glow in upper right and center
    let radialColors = [
        CGColor(red: 0.35, green: 0.25, blue: 0.70, alpha: 0.18),
        CGColor(red: 0.10, green: 0.15, blue: 0.40, alpha: 0.0)
    ] as CFArray
    if let radialGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: radialColors, locations: [0.0, 1.0]) {
        ctx.drawRadialGradient(radialGrad, startCenter: CGPoint(x: widthF * 0.7, y: heightF * 0.7), startRadius: 20, endCenter: CGPoint(x: widthF * 0.7, y: heightF * 0.7), endRadius: 700, options: [])
    }
}

// Authentic macOS Menu Bar
func drawMenuBar(in ctx: CGContext, iconPulse: CGFloat = 0.0) {
    let barHeight: CGFloat = 32
    let barRect = CGRect(x: 0, y: heightF - barHeight, width: widthF, height: barHeight)
    
    // Translucent glass strip
    ctx.setFillColor(CGColor(red: 0.08, green: 0.09, blue: 0.15, alpha: 0.88))
    ctx.fill(barRect)
    
    ctx.setStrokeColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.10))
    ctx.setLineWidth(1.0)
    ctx.strokeLineSegments(between: [CGPoint(x: 0, y: barRect.minY), CGPoint(x: widthF, y: barRect.minY)])
    
    // Apple Logo & Menu Items
    drawText("", in: ctx, at: CGPoint(x: 22, y: heightF - 22), fontSize: 16, weight: .bold, color: .white)
    
    let menus = ["Byakugan", "File", "Edit", "View", "Capture", "Window", "Help"]
    var curX: CGFloat = 52
    for (idx, m) in menus.enumerated() {
        let isBold = (idx == 0)
        drawText(m, in: ctx, at: CGPoint(x: curX, y: heightF - 21), fontSize: 13, weight: isBold ? .bold : .regular, color: NSColor(white: 0.88, alpha: 1.0))
        let w = (m as NSString).size(withAttributes: [.font: NSFont.systemFont(ofSize: 13)]).width
        curX += w + 20
    }
    
    // Right Side: Date, Battery, Wi-Fi & Byakugan Icon
    drawText("Tue Oct 13  12:45 AM", in: ctx, at: CGPoint(x: widthF - 180, y: heightF - 21), fontSize: 13, weight: .regular, color: NSColor(white: 0.85, alpha: 1.0))
    
    let eyeRect = CGRect(x: widthF - 220, y: heightF - 25, width: 18, height: 18)
    if let icon = menuIconImage, let cgIcon = icon.cgImage(forProposedRect: nil, context: nil, hints: nil) {
        ctx.saveGState()
        ctx.draw(cgIcon, in: eyeRect)
        ctx.restoreGState()
    } else {
        drawText("👁", in: ctx, at: CGPoint(x: eyeRect.origin.x, y: eyeRect.origin.y), fontSize: 13)
    }
    
    // Activity pulse when hotkey is fired
    if iconPulse > 0.01 {
        let pulseR = 12.0 + 8.0 * iconPulse
        let pulseCenter = CGPoint(x: eyeRect.midX, y: eyeRect.midY)
        ctx.saveGState()
        ctx.setStrokeColor(CGColor(red: 0.3, green: 0.8, blue: 1.0, alpha: 1.0 - iconPulse))
        ctx.setLineWidth(2.0)
        ctx.strokeEllipse(in: CGRect(x: pulseCenter.x - pulseR, y: pulseCenter.y - pulseR, width: pulseR * 2, height: pulseR * 2))
        ctx.restoreGState()
    }
}

// Window Chrome Frame
func drawWindowFrame(
    in ctx: CGContext,
    rect: CGRect,
    title: String,
    isActive: Bool = true,
    bgColor: CGColor = CGColor(red: 0.11, green: 0.12, blue: 0.17, alpha: 0.96)
) {
    ctx.saveGState()
    // Drop shadow
    ctx.setShadow(offset: CGSize(width: 0, height: -12), blur: 32, color: CGColor(red: 0, green: 0, blue: 0, alpha: isActive ? 0.6 : 0.3))
    
    let bodyPath = CGPath(roundedRect: rect, cornerWidth: 12, cornerHeight: 12, transform: nil)
    ctx.addPath(bodyPath)
    ctx.setFillColor(bgColor)
    ctx.fillPath()
    
    ctx.addPath(bodyPath)
    ctx.setStrokeColor(CGColor(red: 1, green: 1, blue: 1, alpha: isActive ? 0.18 : 0.08))
    ctx.setLineWidth(1.0)
    ctx.strokePath()
    ctx.restoreGState()
    
    // Titlebar
    let titlebarHeight: CGFloat = 38
    let titlebarRect = CGRect(x: rect.origin.x, y: rect.origin.y + rect.height - titlebarHeight, width: rect.width, height: titlebarHeight)
    
    // Traffic buttons
    let buttonY = titlebarRect.midY - 6
    let startX = rect.origin.x + 16
    let colors = [
        CGColor(red: 1.0, green: 0.36, blue: 0.34, alpha: 1.0),
        CGColor(red: 1.0, green: 0.74, blue: 0.22, alpha: 1.0),
        CGColor(red: 0.18, green: 0.80, blue: 0.35, alpha: 1.0)
    ]
    for (i, col) in colors.enumerated() {
        ctx.setFillColor(isActive ? col : CGColor(red: 0.3, green: 0.3, blue: 0.35, alpha: 1.0))
        ctx.fillEllipse(in: CGRect(x: startX + CGFloat(i * 18), y: buttonY, width: 12, height: 12))
    }
    
    // Title text
    let titleColor = isActive ? NSColor(white: 0.88, alpha: 1.0) : NSColor(white: 0.5, alpha: 1.0)
    let titleFont = NSFont.systemFont(ofSize: 13, weight: .semibold)
    let titleWidth = (title as NSString).size(withAttributes: [.font: titleFont]).width
    drawText(title, in: ctx, at: CGPoint(x: rect.midX - titleWidth / 2, y: titlebarRect.midY - 5), fontSize: 13, weight: .semibold, color: titleColor)
    
    // Titlebar bottom hairline
    ctx.setStrokeColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.08))
    ctx.setLineWidth(1.0)
    ctx.strokeLineSegments(between: [
        CGPoint(x: rect.origin.x, y: titlebarRect.minY),
        CGPoint(x: rect.origin.x + rect.width, y: titlebarRect.minY)
    ])
}

// Sleek Director Context Card / Narrative Pill (Eliminates confusion and explains every step)
func drawContextPill(
    in ctx: CGContext,
    stepBadge: String,
    badgeColor: NSColor,
    title: String,
    description: String,
    techTag: String
) {
    let pillW: CGFloat = 860
    let pillH: CGFloat = 58
    let pillRect = CGRect(x: widthF / 2 - pillW / 2, y: heightF - 32 - pillH - 12, width: pillW, height: pillH)
    
    ctx.saveGState()
    ctx.setShadow(offset: CGSize(width: 0, height: 4), blur: 18, color: CGColor(red: 0, green: 0, blue: 0, alpha: 0.55))
    
    // Glass capsule background
    let path = CGPath(roundedRect: pillRect, cornerWidth: 16, cornerHeight: 16, transform: nil)
    ctx.addPath(path)
    ctx.setFillColor(CGColor(red: 0.08, green: 0.09, blue: 0.15, alpha: 0.94))
    ctx.fillPath()
    
    ctx.addPath(path)
    ctx.setStrokeColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.15))
    ctx.setLineWidth(1.2)
    ctx.strokePath()
    
    // Dynamic Step Badge Capsule based on text length
    let badgeFont = NSFont.systemFont(ofSize: 11, weight: .bold)
    let badgeTextW = (stepBadge as NSString).size(withAttributes: [.font: badgeFont]).width
    let badgeW: CGFloat = badgeTextW + 24
    let badgeH: CGFloat = 26
    let badgeRect = CGRect(x: pillRect.minX + 16, y: pillRect.midY - badgeH / 2, width: badgeW, height: badgeH)
    let bPath = CGPath(roundedRect: badgeRect, cornerWidth: 8, cornerHeight: 8, transform: nil)
    ctx.addPath(bPath)
    ctx.setFillColor(badgeColor.withAlphaComponent(0.18).cgColor)
    ctx.fillPath()
    ctx.addPath(bPath)
    ctx.setStrokeColor(badgeColor.withAlphaComponent(0.4).cgColor)
    ctx.setLineWidth(1.0)
    ctx.strokePath()
    
    drawText(stepBadge, in: ctx, at: CGPoint(x: badgeRect.minX + 12, y: badgeRect.minY + 6), fontSize: 11, weight: .bold, color: badgeColor)
    
    // Title & Description
    let textX = badgeRect.maxX + 14
    drawText(title, in: ctx, at: CGPoint(x: textX, y: pillRect.midY + 2), fontSize: 14, weight: .bold, color: .white)
    drawText(description, in: ctx, at: CGPoint(x: textX, y: pillRect.midY - 16), fontSize: 12, weight: .regular, color: NSColor(white: 0.72, alpha: 1.0))
    
    // Tech Tag on Far Right
    let tagFont = NSFont.monospacedSystemFont(ofSize: 11, weight: .semibold)
    let tagTextW = (techTag as NSString).size(withAttributes: [.font: tagFont]).width
    let tagW: CGFloat = tagTextW + 20
    let tagH: CGFloat = 24
    let tagRect = CGRect(x: pillRect.maxX - tagW - 16, y: pillRect.midY - tagH / 2, width: tagW, height: tagH)
    let tPath = CGPath(roundedRect: tagRect, cornerWidth: 6, cornerHeight: 6, transform: nil)
    ctx.addPath(tPath)
    ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.08))
    ctx.fillPath()
    drawText(techTag, in: ctx, at: CGPoint(x: tagRect.minX + 10, y: tagRect.minY + 5), fontSize: 11, weight: .semibold, color: NSColor(red: 0.4, green: 0.85, blue: 1.0, alpha: 1.0), isMonospace: true)
    
    ctx.restoreGState()
}

// Keystroke HUD (macOS Style Keycaps)
func drawKeystrokeHUD(in ctx: CGContext, keys: [String]) {
    let keyWidth: CGFloat = 50
    let keyGap: CGFloat = 10
    let totalKeysW = CGFloat(keys.count) * keyWidth + CGFloat(keys.count - 1) * keyGap
    let hudPadding: CGFloat = 16
    let hudW = totalKeysW + hudPadding * 2
    let hudH: CGFloat = 68
    let hudRect = CGRect(x: widthF / 2 - hudW / 2, y: 70, width: hudW, height: hudH)
    
    ctx.saveGState()
    ctx.setShadow(offset: CGSize(width: 0, height: 6), blur: 22, color: CGColor(red: 0, green: 0, blue: 0, alpha: 0.7))
    
    let pillPath = CGPath(roundedRect: hudRect, cornerWidth: 20, cornerHeight: 20, transform: nil)
    ctx.addPath(pillPath)
    ctx.setFillColor(CGColor(red: 0.07, green: 0.08, blue: 0.12, alpha: 0.94))
    ctx.fillPath()
    
    ctx.addPath(pillPath)
    ctx.setStrokeColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.22))
    ctx.setLineWidth(1.5)
    ctx.strokePath()
    
    for (i, key) in keys.enumerated() {
        let keyX = hudRect.origin.x + hudPadding + CGFloat(i) * (keyWidth + keyGap)
        let keyRect = CGRect(x: keyX, y: hudRect.origin.y + 11, width: keyWidth, height: 46)
        
        let capPath = CGPath(roundedRect: keyRect, cornerWidth: 10, cornerHeight: 10, transform: nil)
        ctx.addPath(capPath)
        ctx.setFillColor(CGColor(red: 0.18, green: 0.20, blue: 0.28, alpha: 1.0))
        ctx.fillPath()
        
        ctx.addPath(capPath)
        ctx.setStrokeColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.28))
        ctx.setLineWidth(1.0)
        ctx.strokePath()
        
        let font = NSFont.systemFont(ofSize: 22, weight: .bold)
        let strWidth = (key as NSString).size(withAttributes: [.font: font]).width
        drawText(key, in: ctx, at: CGPoint(x: keyRect.midX - strWidth / 2, y: keyRect.midY - 9), fontSize: 22, weight: .bold, color: .white)
    }
    ctx.restoreGState()
}

// Native macOS Notification Banner
func drawNotification(in ctx: CGContext, title: String, subtitle: String, progress: CGFloat) {
    guard progress > 0.01 else { return }
    ctx.saveGState()
    
    let notifW: CGFloat = 380
    let notifH: CGFloat = 82
    let targetX = widthF - notifW - 24
    let startX = widthF + 20
    let currentX = startX + (targetX - startX) * progress
    let notifRect = CGRect(x: currentX, y: heightF - notifH - 44, width: notifW, height: notifH)
    
    ctx.setShadow(offset: CGSize(width: 0, height: 8), blur: 26, color: CGColor(red: 0, green: 0, blue: 0, alpha: 0.6))
    
    let path = CGPath(roundedRect: notifRect, cornerWidth: 18, cornerHeight: 18, transform: nil)
    ctx.addPath(path)
    ctx.setFillColor(CGColor(red: 0.12, green: 0.13, blue: 0.20, alpha: 0.95))
    ctx.fillPath()
    
    ctx.addPath(path)
    ctx.setStrokeColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.22))
    ctx.setLineWidth(1.2)
    ctx.strokePath()
    
    // App Icon in notification
    let iconBox = CGRect(x: notifRect.origin.x + 16, y: notifRect.midY - 22, width: 44, height: 44)
    if let icon = appIconImage, let cg = icon.cgImage(forProposedRect: nil, context: nil, hints: nil) {
        ctx.saveGState()
        let ip = CGPath(roundedRect: iconBox, cornerWidth: 10, cornerHeight: 10, transform: nil)
        ctx.addPath(ip)
        ctx.clip()
        ctx.draw(cg, in: iconBox)
        ctx.restoreGState()
    }
    
    let textX = iconBox.maxX + 14
    drawText(title, in: ctx, at: CGPoint(x: textX, y: notifRect.midY + 6), fontSize: 14, weight: .bold, color: .white)
    drawText(subtitle, in: ctx, at: CGPoint(x: textX, y: notifRect.midY - 14), fontSize: 12, weight: .medium, color: NSColor(red: 0.3, green: 1.0, blue: 0.7, alpha: 1.0))
    drawText("now", in: ctx, at: CGPoint(x: notifRect.maxX - 44, y: notifRect.midY + 6), fontSize: 11, weight: .regular, color: NSColor(white: 0.6, alpha: 1.0))
    
    ctx.restoreGState()
}

// Smooth Native Cursor with Click Ripple
func drawCursor(in ctx: CGContext, at point: CGPoint, isCrosshair: Bool, clickRipple: CGFloat = 0.0) {
    ctx.saveGState()
    
    // Draw click ripple ring
    if clickRipple > 0.01 && clickRipple < 1.0 {
        let r = 8.0 + 26.0 * clickRipple
        let alpha = (1.0 - clickRipple) * 0.7
        ctx.setStrokeColor(CGColor(red: 0.3, green: 0.75, blue: 1.0, alpha: alpha))
        ctx.setLineWidth(2.5)
        ctx.strokeEllipse(in: CGRect(x: point.x - r, y: point.y - r, width: r * 2, height: r * 2))
    }
    
    if isCrosshair {
        // macOS Interactive screencapture crosshair
        ctx.setShadow(offset: CGSize(width: 0, height: 1), blur: 3, color: CGColor(red: 0, green: 0, blue: 0, alpha: 0.8))
        
        ctx.setStrokeColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        ctx.setLineWidth(1.8)
        let arm: CGFloat = 11
        ctx.strokeLineSegments(between: [
            CGPoint(x: point.x - arm, y: point.y), CGPoint(x: point.x + arm, y: point.y),
            CGPoint(x: point.x, y: point.y - arm), CGPoint(x: point.x, y: point.y + arm)
        ])
        ctx.strokeEllipse(in: CGRect(x: point.x - 4, y: point.y - 4, width: 8, height: 8))
        
    } else {
        // High fidelity macOS arrow pointer
        ctx.setShadow(offset: CGSize(width: 1, height: -2), blur: 5, color: CGColor(red: 0, green: 0, blue: 0, alpha: 0.55))
        
        let path = CGMutablePath()
        path.move(to: point)
        path.addLine(to: CGPoint(x: point.x + 13, y: point.y - 13))
        path.addLine(to: CGPoint(x: point.x + 6, y: point.y - 13))
        path.addLine(to: CGPoint(x: point.x + 9, y: point.y - 20))
        path.addLine(to: CGPoint(x: point.x + 5, y: point.y - 22))
        path.addLine(to: CGPoint(x: point.x + 2, y: point.y - 15))
        path.addLine(to: CGPoint(x: point.x, y: point.y - 18))
        path.closeSubpath()
        
        ctx.addPath(path)
        ctx.setFillColor(CGColor(red: 0, green: 0, blue: 0, alpha: 1.0))
        ctx.fillPath()
        
        // Inner white body
        let innerPath = CGMutablePath()
        innerPath.move(to: CGPoint(x: point.x + 1, y: point.y - 2))
        innerPath.addLine(to: CGPoint(x: point.x + 11, y: point.y - 12))
        innerPath.addLine(to: CGPoint(x: point.x + 5, y: point.y - 12))
        innerPath.addLine(to: CGPoint(x: point.x + 7.5, y: point.y - 18))
        innerPath.addLine(to: CGPoint(x: point.x + 5.5, y: point.y - 19))
        innerPath.addLine(to: CGPoint(x: point.x + 3, y: point.y - 13))
        innerPath.addLine(to: CGPoint(x: point.x + 1, y: point.y - 15))
        innerPath.closeSubpath()
        
        ctx.addPath(innerPath)
        ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        ctx.fillPath()
    }
    
    ctx.restoreGState()
}

// MARK: - Frame Rendering Loop (60 FPS = 900 Frames)
print("🚀 Beginning 60 FPS frame synthesis (900 frames total)...")

for frameIndex in 0..<totalFrames {
    let t = Double(frameIndex) / Double(fps)
    
    guard let pool = adaptor.pixelBufferPool else { fatalError("Pixel buffer pool missing") }
    var pbOpt: CVPixelBuffer?
    let status = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pool, &pbOpt)
    guard status == kCVReturnSuccess, let pb = pbOpt else { fatalError("Cannot create pixel buffer") }
    
    CVPixelBufferLockBaseAddress(pb, [])
    let pixelData = CVPixelBufferGetBaseAddress(pb)
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    
    guard let ctx = CGContext(
        data: pixelData,
        width: width,
        height: height,
        bitsPerComponent: 8,
        bytesPerRow: CVPixelBufferGetBytesPerRow(pb),
        space: rgbColorSpace,
        bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
    ) else {
        fatalError("Failed to create CGContext")
    }
    
    // 1. Draw Desktop Wallpaper
    drawDesktopBackground(in: ctx)
    
    // Window Coordinates
    let win1Rect = CGRect(x: 70, y: 150, width: 840, height: 750)  // Left: Video Lecture with locked text
    let win2Rect = CGRect(x: 950, y: 150, width: 900, height: 750) // Right: VS Code Editor
    
    // Track cursor and UI states
    var cursorPos = CGPoint(x: 400, y: 550)
    var isCrosshair = false
    var clickRipple: CGFloat = 0.0
    var iconPulse: CGFloat = 0.0
    var activeKeystrokes: [String]? = nil
    var notifProgress: CGFloat = 0.0
    var notifTitle = ""
    var notifSub = ""
    
    // SCENE TIMELINE (0.0s – 15.0s)
    if t < 7.5 {
        // ==========================================
        // SCENE 1: Instant OCR Extraction & Pasting
        // ==========================================
        
        // Window 1: Video Lecture Slide (Left)
        drawWindowFrame(in: ctx, rect: win1Rect, title: "Video Player — MIT 6.824 Distributed Systems Lecture.mp4", isActive: t < 4.2)
        
        // Video Player UI inside Window 1
        let vidArea = CGRect(x: win1Rect.origin.x + 20, y: win1Rect.origin.y + 60, width: win1Rect.width - 40, height: win1Rect.height - 110)
        ctx.setFillColor(CGColor(red: 0.06, green: 0.07, blue: 0.11, alpha: 1.0))
        ctx.fill(vidArea)
        
        // Slide Title inside video
        drawText("Slide 14: Raft Consensus RPC Definition", in: ctx, at: CGPoint(x: vidArea.minX + 30, y: vidArea.maxY - 45), fontSize: 18, weight: .bold, color: NSColor(red: 0.9, green: 0.8, blue: 0.4, alpha: 1.0))
        
        // Non-selectable locked code inside video slide
        let slideCodeX = vidArea.minX + 30
        let slideCodeY = vidArea.maxY - 110
        let slideCodeLines = [
            "// Trapped inside video frame (cannot highlight or copy)",
            "type RequestVoteArgs struct {",
            "    Term         int       // Candidate election term",
            "    CandidateId  int       // Candidate requesting vote",
            "    LastLogIndex int       // Index of candidate's last log entry",
            "    LastLogTerm  int       // Term of candidate's last log entry",
            "}"
        ]
        for (i, line) in slideCodeLines.enumerated() {
            let color: NSColor = i == 0 ? NSColor(white: 0.5, alpha: 1.0) : (i == 1 || i == 6 ? NSColor(red: 0.8, green: 0.5, blue: 0.9, alpha: 1.0) : NSColor(white: 0.9, alpha: 1.0))
            drawText(line, in: ctx, at: CGPoint(x: slideCodeX, y: slideCodeY - CGFloat(i * 26)), fontSize: 16, weight: .medium, color: color, isMonospace: true)
        }
        
        // Video Progress Scrubber Bar at bottom
        let scrubY = vidArea.minY + 20
        ctx.setStrokeColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.2))
        ctx.setLineWidth(4.0)
        ctx.strokeLineSegments(between: [CGPoint(x: vidArea.minX + 30, y: scrubY), CGPoint(x: vidArea.maxX - 30, y: scrubY)])
        ctx.setStrokeColor(CGColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0))
        ctx.strokeLineSegments(between: [CGPoint(x: vidArea.minX + 30, y: scrubY), CGPoint(x: vidArea.minX + 240, y: scrubY)])
        drawText("▶ 14:22 / 52:10 • [Cannot Select Video Text]", in: ctx, at: CGPoint(x: vidArea.minX + 30, y: scrubY + 12), fontSize: 12, weight: .regular, color: NSColor(white: 0.6, alpha: 1.0))
        
        // Window 2: VS Code Editor (Right)
        drawWindowFrame(in: ctx, rect: win2Rect, title: "Visual Studio Code — raft_node.go", isActive: t >= 4.2)
        
        // Activity bar on left of VS Code
        let actW: CGFloat = 46
        let actRect = CGRect(x: win2Rect.minX, y: win2Rect.minY, width: actW, height: win2Rect.height - 38)
        ctx.setFillColor(CGColor(red: 0.08, green: 0.08, blue: 0.12, alpha: 1.0))
        ctx.fill(actRect)
        
        let editorArea = CGRect(x: win2Rect.minX + actW, y: win2Rect.minY, width: win2Rect.width - actW, height: win2Rect.height - 38)
        ctx.setFillColor(CGColor(red: 0.11, green: 0.12, blue: 0.16, alpha: 1.0))
        ctx.fill(editorArea)
        
        // VS Code Tab Bar
        let tabRect = CGRect(x: editorArea.minX, y: editorArea.maxY - 34, width: 140, height: 34)
        ctx.setFillColor(CGColor(red: 0.13, green: 0.14, blue: 0.19, alpha: 1.0))
        ctx.fill(tabRect)
        drawText("raft_node.go ×", in: ctx, at: CGPoint(x: tabRect.minX + 16, y: tabRect.minY + 10), fontSize: 12, weight: .medium, color: .white)
        
        // Pre-existing code lines in VS Code
        let codeStartX = editorArea.minX + 20
        let codeStartY = editorArea.maxY - 70
        let baseLines = [
            "package raft",
            "",
            "import \"sync\"",
            "",
            "type Raft struct {",
            "    mu        sync.Mutex",
            "    peers     []*RaftClient",
            "    me        int",
            "    currentTerm int",
            "}",
            ""
        ]
        for (i, line) in baseLines.enumerated() {
            drawText("\(i + 1)", in: ctx, at: CGPoint(x: codeStartX, y: codeStartY - CGFloat(i * 24)), fontSize: 14, weight: .regular, color: NSColor(white: 0.35, alpha: 1.0), isMonospace: true)
            drawText(line, in: ctx, at: CGPoint(x: codeStartX + 36, y: codeStartY - CGFloat(i * 24)), fontSize: 14, weight: .regular, color: NSColor(red: 0.6, green: 0.8, blue: 1.0, alpha: 1.0), isMonospace: true)
        }
        
        // Code Pasted into VS Code after t >= 5.6s
        if t >= 5.6 {
            let pastedLines = [
                "type RequestVoteArgs struct {",
                "    Term         int",
                "    CandidateId  int",
                "    LastLogIndex int",
                "    LastLogTerm  int",
                "}"
            ]
            let pasteStartY = codeStartY - CGFloat(baseLines.count * 24)
            for (i, pl) in pastedLines.enumerated() {
                let lineNum = baseLines.count + i + 1
                drawText("\(lineNum)", in: ctx, at: CGPoint(x: codeStartX, y: pasteStartY - CGFloat(i * 24)), fontSize: 14, weight: .regular, color: NSColor(white: 0.35, alpha: 1.0), isMonospace: true)
                drawText(pl, in: ctx, at: CGPoint(x: codeStartX + 36, y: pasteStartY - CGFloat(i * 24)), fontSize: 14, weight: .semibold, color: NSColor(red: 0.3, green: 0.95, blue: 0.65, alpha: 1.0), isMonospace: true)
            }
        }
        
        // Time Segments within Scene 1:
        if t < 2.0 {
            // Context Pill: Explain the problem
            drawContextPill(
                in: ctx,
                stepBadge: "SCENARIO 1",
                badgeColor: NSColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0),
                title: "Trapped Text Inside Video Lecture",
                description: "Text is inside a paused video frame. macOS cannot highlight or copy it.",
                techTag: "LOCKED CONTENT"
            )
            // Cursor moving naturally over the video code
            let p = CGFloat(t / 2.0)
            cursorPos = smoothPoint(from: CGPoint(x: 200, y: 700), to: CGPoint(x: slideCodeX + 180, y: slideCodeY - 60), progress: p)
            
        } else if t < 3.8 {
            // Action: ⌘⇧2 Hotkey pressed, interactive sniper crosshair captures
            activeKeystrokes = ["⌘", "⇧", "2"]
            iconPulse = CGFloat(min(1.0, (t - 2.05) / 0.5))
            
            drawContextPill(
                in: ctx,
                stepBadge: "SNIPE ⌘⇧2",
                badgeColor: NSColor(red: 0.3, green: 0.8, blue: 1.0, alpha: 1.0),
                title: "Instant RAM Capture (Zero Disk I/O)",
                description: "Press ⌘⇧2. Screen pixels stream directly into memory without disk delays.",
                techTag: "SUB-100MS LATENCY"
            )
            
            isCrosshair = true
            let selStart = CGPoint(x: slideCodeX - 8, y: slideCodeY - 12)
            let selEnd = CGPoint(x: slideCodeX + 540, y: slideCodeY - 182)
            
            let dragProg = easeInOutCubic(CGFloat(min(1.0, max(0.0, (t - 2.2) / 1.4))))
            let curBoxW = (selEnd.x - selStart.x) * dragProg
            let curBoxH = (selStart.y - selEnd.y) * dragProg
            let curBox = CGRect(x: selStart.x, y: selStart.y - curBoxH, width: curBoxW, height: curBoxH)
            
            // Translucent cyan selection fill
            ctx.setFillColor(CGColor(red: 0.1, green: 0.6, blue: 1.0, alpha: 0.24))
            ctx.fill(curBox)
            
            // Sharp border
            ctx.setStrokeColor(CGColor(red: 0.2, green: 0.85, blue: 1.0, alpha: 0.95))
            ctx.setLineWidth(2.0)
            ctx.stroke(curBox)
            
            // Selection dimension badge (placed cleanly above selection box)
            if curBoxW > 60 {
                let dimText = "\(Int(curBoxW)) × \(Int(curBoxH))"
                let dimRect = CGRect(x: curBox.maxX - 95, y: curBox.maxY + 6, width: 95, height: 22)
                let dp = CGPath(roundedRect: dimRect, cornerWidth: 5, cornerHeight: 5, transform: nil)
                ctx.addPath(dp)
                ctx.setFillColor(CGColor(red: 0.08, green: 0.09, blue: 0.14, alpha: 0.92))
                ctx.fillPath()
                ctx.addPath(dp)
                ctx.setStrokeColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.2))
                ctx.setLineWidth(1.0)
                ctx.strokePath()
                drawText(dimText, in: ctx, at: CGPoint(x: dimRect.minX + 10, y: dimRect.minY + 4), fontSize: 12, weight: .bold, color: .white, isMonospace: true)
            }
            
            cursorPos = CGPoint(x: curBox.maxX, y: curBox.minY)
            
        } else if t < 5.5 {
            // Capture complete, flash ripple, notification appears, glide cursor to VS Code
            drawContextPill(
                in: ctx,
                stepBadge: "APPLE VISION",
                badgeColor: NSColor(red: 0.3, green: 0.95, blue: 0.6, alpha: 1.0),
                title: "100% On-Device Neural Engine OCR",
                description: "Extracted 6 lines of Go code in 38ms. Copied instantly to clipboard.",
                techTag: "38MS RECOGNITION"
            )
            
            // Shutter flash fading out
            if t < 4.1 {
                let flashAlpha = CGFloat((4.1 - t) / 0.35) * 0.4
                ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: flashAlpha))
                ctx.fill(CGRect(x: 0, y: 0, width: widthF, height: heightF))
            }
            
            // Notification slide in
            notifProgress = easeOutBack(CGFloat(min(1.0, (t - 3.9) / 0.5)))
            notifTitle = "Byakugan Scan"
            notifSub = "⚡ Copied 6 lines to clipboard (38ms)"
            
            // Smooth glide cursor to VS Code line 12
            let p = easeInOutCubic(CGFloat(min(1.0, max(0.0, (t - 4.2) / 1.1))))
            cursorPos = smoothPoint(from: CGPoint(x: 650, y: 550), to: CGPoint(x: codeStartX + 120, y: codeStartY - 240), progress: p)
            
        } else {
            // t = 5.5s – 7.5s: Click inside VS Code and press ⌘V
            drawContextPill(
                in: ctx,
                stepBadge: "INSTANT PASTE",
                badgeColor: NSColor(red: 0.4, green: 0.7, blue: 1.0, alpha: 1.0),
                title: "Paste with Perfect Formatting (⌘V)",
                description: "Clean syntax, indentations, and line breaks are fully preserved.",
                techTag: "CLIPBOARD READY"
            )
            
            activeKeystrokes = ["⌘", "V"]
            
            // Dismiss notification
            if t > 6.4 {
                notifProgress = max(0.0, 1.0 - CGFloat((t - 6.4) / 0.5))
            } else {
                notifProgress = 1.0
            }
            notifTitle = "Byakugan Scan"
            notifSub = "⚡ Copied 6 lines to clipboard (38ms)"
            
            cursorPos = CGPoint(x: codeStartX + 140, y: codeStartY - 240)
            
            if t >= 5.58 && t <= 5.85 {
                clickRipple = CGFloat((t - 5.58) / 0.27)
            }
        }
        
    } else if t < 10.5 {
        // ==========================================
        // SCENE 2: On-Screen QR Code Scanning (⌘⇧6)
        // ==========================================
        
        drawContextPill(
            in: ctx,
            stepBadge: "QR SCAN ⌘⇧6",
            badgeColor: NSColor(red: 0.9, green: 0.6, blue: 1.0, alpha: 1.0),
            title: "Instant QR & Barcode Recognition",
            description: "Press ⌘⇧6 to scan QR codes on web pages, PDFs, or slides.",
            techTag: "12+ SYMBOLOGIES"
        )
        
        // Single focused Safari browser window with QR Code
        let qrWinRect = CGRect(x: 460, y: 160, width: 1000, height: 720)
        drawWindowFrame(in: ctx, rect: qrWinRect, title: "Safari — Byakugan Scan Official Repository", isActive: true)
        
        // Webpage Content Area
        let pageArea = CGRect(x: qrWinRect.minX, y: qrWinRect.minY, width: qrWinRect.width, height: qrWinRect.height - 38)
        ctx.setFillColor(CGColor(red: 0.09, green: 0.10, blue: 0.15, alpha: 1.0))
        ctx.fill(pageArea)
        
        // Safari URL bar
        let urlBarRect = CGRect(x: qrWinRect.midX - 240, y: qrWinRect.maxY - 72, width: 480, height: 26)
        let up = CGPath(roundedRect: urlBarRect, cornerWidth: 6, cornerHeight: 6, transform: nil)
        ctx.addPath(up)
        ctx.setFillColor(CGColor(red: 0.15, green: 0.16, blue: 0.24, alpha: 1.0))
        ctx.fillPath()
        drawText("🔒 github.com/halcyon-past/byakugan-scan", in: ctx, at: CGPoint(x: urlBarRect.minX + 16, y: urlBarRect.minY + 6), fontSize: 12, weight: .regular, color: NSColor(white: 0.8, alpha: 1.0))
        
        // QR Card on page
        let qrCardRect = CGRect(x: qrWinRect.midX - 200, y: qrWinRect.midY - 170, width: 400, height: 380)
        let qcp = CGPath(roundedRect: qrCardRect, cornerWidth: 16, cornerHeight: 16, transform: nil)
        ctx.addPath(qcp)
        ctx.setFillColor(CGColor(red: 0.14, green: 0.15, blue: 0.22, alpha: 1.0))
        ctx.fillPath()
        ctx.addPath(qcp)
        ctx.setStrokeColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.1))
        ctx.setLineWidth(1.0)
        ctx.strokePath()
        
        drawText("Scan to Clone Repository", in: ctx, at: CGPoint(x: qrCardRect.midX - 100, y: qrCardRect.maxY - 36), fontSize: 16, weight: .bold, color: .white)
        
        // QR Code Matrix
        let qrBox = CGRect(x: qrCardRect.midX - 120, y: qrCardRect.minY + 40, width: 240, height: 240)
        ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        ctx.fill(qrBox)
        
        // Authentic QR corner finder patterns
        ctx.setFillColor(CGColor(red: 0, green: 0, blue: 0, alpha: 1.0))
        // Top Left finder
        ctx.fill(CGRect(x: qrBox.minX + 20, y: qrBox.maxY - 70, width: 50, height: 50))
        ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        ctx.fill(CGRect(x: qrBox.minX + 30, y: qrBox.maxY - 60, width: 30, height: 30))
        ctx.setFillColor(CGColor(red: 0, green: 0, blue: 0, alpha: 1.0))
        ctx.fill(CGRect(x: qrBox.minX + 37, y: qrBox.maxY - 53, width: 16, height: 16))
        
        // Top Right finder
        ctx.fill(CGRect(x: qrBox.maxX - 70, y: qrBox.maxY - 70, width: 50, height: 50))
        ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        ctx.fill(CGRect(x: qrBox.maxX - 60, y: qrBox.maxY - 60, width: 30, height: 30))
        ctx.setFillColor(CGColor(red: 0, green: 0, blue: 0, alpha: 1.0))
        ctx.fill(CGRect(x: qrBox.maxX - 53, y: qrBox.maxY - 53, width: 16, height: 16))
        
        // Bottom Left finder
        ctx.fill(CGRect(x: qrBox.minX + 20, y: qrBox.minY + 20, width: 50, height: 50))
        ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1.0))
        ctx.fill(CGRect(x: qrBox.minX + 30, y: qrBox.minY + 30, width: 30, height: 30))
        ctx.setFillColor(CGColor(red: 0, green: 0, blue: 0, alpha: 1.0))
        ctx.fill(CGRect(x: qrBox.minX + 37, y: qrBox.minY + 37, width: 16, height: 16))
        
        // Center alignment pattern & data dots
        ctx.fill(CGRect(x: qrBox.midX - 16, y: qrBox.midY - 16, width: 32, height: 32))
        ctx.fill(CGRect(x: qrBox.minX + 80, y: qrBox.maxY - 40, width: 12, height: 24))
        ctx.fill(CGRect(x: qrBox.maxX - 100, y: qrBox.minY + 30, width: 28, height: 14))
        ctx.fill(CGRect(x: qrBox.midX + 24, y: qrBox.midY + 24, width: 20, height: 20))
        
        if t < 7.7 {
            // Glide cursor toward QR code
            let p = easeInOutCubic(CGFloat((t - 7.5) / 0.2))
            cursorPos = smoothPoint(from: CGPoint(x: 950, y: 350), to: CGPoint(x: qrBox.minX - 10, y: qrBox.maxY + 10), progress: p)
            
        } else if t < 9.2 {
            // ⌘⇧6 hotkey and sniper selection over QR
            activeKeystrokes = ["⌘", "⇧", "6"]
            isCrosshair = true
            
            let qDrag = easeInOutCubic(CGFloat(min(1.0, (t - 7.75) / 1.3)))
            let qBoxW = (qrBox.width + 20) * qDrag
            let qBoxH = (qrBox.height + 20) * qDrag
            let qSel = CGRect(x: qrBox.minX - 10, y: qrBox.maxY + 10 - qBoxH, width: qBoxW, height: qBoxH)
            
            ctx.setFillColor(CGColor(red: 0.2, green: 1.0, blue: 0.8, alpha: 0.22))
            ctx.fill(qSel)
            ctx.setStrokeColor(CGColor(red: 0.3, green: 1.0, blue: 0.85, alpha: 0.95))
            ctx.setLineWidth(2.0)
            ctx.stroke(qSel)
            
            cursorPos = CGPoint(x: qSel.maxX, y: qSel.minY)
            
        } else {
            // QR detected notification
            notifProgress = easeOutBack(CGFloat(min(1.0, (t - 9.3) / 0.45)))
            notifTitle = "QR Code Detected"
            notifSub = "🔗 https://github.com/halcyon-past/byakugan-scan"
            cursorPos = CGPoint(x: qrBox.maxX + 30, y: qrBox.minY)
        }
        
    } else {
        // ==========================================
        // SCENE 3: Homebrew Install & Outro
        // ==========================================
        
        drawContextPill(
            in: ctx,
            stepBadge: "INSTALL",
            badgeColor: NSColor(red: 0.3, green: 1.0, blue: 0.6, alpha: 1.0),
            title: "Install in Seconds via Homebrew",
            description: "Zero external dependencies. 100% On-Device & Open Source.",
            techTag: "BREW TAP"
        )
        
        // Terminal Window centered smoothly
        let termRect = CGRect(x: widthF / 2 - 470, y: heightF / 2 - 210, width: 940, height: 420)
        drawWindowFrame(in: ctx, rect: termRect, title: "Terminal — zsh — 80×24", isActive: true, bgColor: CGColor(red: 0.07, green: 0.08, blue: 0.12, alpha: 0.98))
        
        let termX = termRect.origin.x + 36
        let termY = termRect.maxY - 84
        drawText("aritro@MacBook-Pro ~ %", in: ctx, at: CGPoint(x: termX, y: termY), fontSize: 18, weight: .bold, color: NSColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 1.0), isMonospace: true)
        
        let command = "brew install --cask halcyon-past/tap/byakugan-scan"
        let typeProgress = min(1.0, max(0.0, (t - 10.9) / 1.9))
        let charsToType = Int(Double(command.count) * typeProgress)
        let currentCommand = String(command.prefix(charsToType))
        
        drawText(currentCommand, in: ctx, at: CGPoint(x: termX + 265, y: termY), fontSize: 18, weight: .bold, color: NSColor(red: 0.3, green: 1.0, blue: 0.65, alpha: 1.0), isMonospace: true)
        
        if typeProgress >= 1.0 {
            drawText("==> Downloading ByakuganScan-v1.0.2.dmg... [100%]", in: ctx, at: CGPoint(x: termX, y: termY - 44), fontSize: 16, weight: .regular, color: NSColor(white: 0.72, alpha: 1.0), isMonospace: true)
            drawText("🍺 byakugan-scan was successfully installed!", in: ctx, at: CGPoint(x: termX, y: termY - 82), fontSize: 16, weight: .bold, color: NSColor(red: 0.35, green: 1.0, blue: 0.65, alpha: 1.0), isMonospace: true)
            drawText("==> Run 'byakugan://scan?mode=text' or use menu bar icon.", in: ctx, at: CGPoint(x: termX, y: termY - 118), fontSize: 15, weight: .regular, color: NSColor(white: 0.6, alpha: 1.0), isMonospace: true)
        }
        
        // Outro Call-To-Action Pill at bottom
        let outroW: CGFloat = 800
        let outroH: CGFloat = 52
        let outroRect = CGRect(x: widthF / 2 - outroW / 2, y: 70, width: outroW, height: outroH)
        let op = CGPath(roundedRect: outroRect, cornerWidth: 14, cornerHeight: 14, transform: nil)
        ctx.addPath(op)
        ctx.setFillColor(CGColor(red: 0.10, green: 0.11, blue: 0.18, alpha: 0.95))
        ctx.fillPath()
        ctx.addPath(op)
        ctx.setStrokeColor(CGColor(red: 1.0, green: 0.75, blue: 0.2, alpha: 0.5))
        ctx.setLineWidth(1.5)
        ctx.strokePath()
        
        drawText("⭐ Star on GitHub: github.com/halcyon-past/byakugan-scan  •  MIT License", in: ctx, at: CGPoint(x: outroRect.midX - 310, y: outroRect.midY - 7), fontSize: 16, weight: .bold, color: NSColor(red: 1.0, green: 0.85, blue: 0.3, alpha: 1.0))
        
        cursorPos = CGPoint(x: termRect.maxX - 40, y: termRect.minY + 50)
    }
    
    // Draw Keystroke HUD (if active)
    if let keys = activeKeystrokes {
        drawKeystrokeHUD(in: ctx, keys: keys)
    }
    
    // Draw Notification Toast (if active)
    if notifProgress > 0.01 {
        drawNotification(in: ctx, title: notifTitle, subtitle: notifSub, progress: notifProgress)
    }
    
    // Draw Cursor
    drawCursor(in: ctx, at: cursorPos, isCrosshair: isCrosshair, clickRipple: clickRipple)
    
    // Draw Top Menu Bar (always visible)
    drawMenuBar(in: ctx, iconPulse: iconPulse)
    
    CVPixelBufferUnlockBaseAddress(pb, [])
    
    let presentationTime = CMTime(value: Int64(frameIndex), timescale: fps)
    while !videoInput.isReadyForMoreMediaData {
        usleep(1000)
    }
    adaptor.append(pb, withPresentationTime: presentationTime)
    
    if (frameIndex + 1) % 150 == 0 {
        let pct = Int(Double(frameIndex + 1) / Double(totalFrames) * 100.0)
        print("  ⏳ Rendered \(frameIndex + 1)/\(totalFrames) frames (\(pct)%)...")
    }
}

videoInput.markAsFinished()

let sema = DispatchSemaphore(value: 0)
writer.finishWriting {
    sema.signal()
}
sema.wait()

print("🎉 High-Fidelity 60 FPS Cinematic Demo Render Complete!")
print("📁 Saved output to: \(outputURL.path)")

// Copy to Desktop
let desktopURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop/ByakuganScan_Demo.mp4")
try? FileManager.default.removeItem(at: desktopURL)
try? FileManager.default.copyItem(at: outputURL, to: desktopURL)
print("🚀 Copied demo video to user desktop: \(desktopURL.path)")
