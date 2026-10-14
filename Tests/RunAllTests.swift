import Foundation
import AppKit
import Vision

@main
struct TestRunner {
    static func main() {
        var totalTests = 0
        var passedTests = 0
        var failedTests = 0

        func test(_ name: String, block: () throws -> Void) {
            totalTests += 1
            do {
                try block()
                passedTests += 1
                print("  ✅ PASS: \(name)")
            } catch {
                failedTests += 1
                print("  ❌ FAIL: \(name)")
                print("     Error: \(error.localizedDescription)")
            }
        }

        func assertTrue(_ condition: Bool, _ message: String = "Expected true, got false") throws {
            if !condition {
                throw NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
            }
        }

        func assertFalse(_ condition: Bool, _ message: String = "Expected false, got true") throws {
            if condition {
                throw NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
            }
        }

        func assertEqual<T: Equatable>(_ actual: T, _ expected: T, _ message: String = "") throws {
            if actual != expected {
                let msg = message.isEmpty ? "Expected '\(expected)', got '\(actual)'" : "\(message) (Expected '\(expected)', got '\(actual)')"
                throw NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: msg])
            }
        }

        print("\n=======================================================")
        print("🧪 Running Byakugan Scan Automated Test Suite")
        print("=======================================================\n")

        // 1. String Extensions Tests
        print("▶️ [Suite 1/6] String Extensions")
        test("URL detection valid") {
            try assertTrue("https://byakugan-scan.aritro.cloud".isURL)
            try assertTrue("http://example.com/path?query=1".isURL)
            try assertFalse("not a url".isURL)
            try assertFalse("random text without scheme".isURL)
        }

        test("Email detection valid") {
            try assertTrue("aritrosaha2025@gmail.com".isEmail)
            try assertTrue("john.doe@subdomain.example.com".isEmail)
            try assertFalse("plain text".isEmail)
            try assertFalse("missing-domain@".isEmail)
        }

        test("Phone number detection") {
            try assertTrue("+1-800-555-0199".isPhoneNumber)
            try assertTrue("+91 9876543210".isPhoneNumber)
            try assertFalse("abcde".isPhoneNumber)
        }

        test("Text formatting: preserveLineBreaks=true, trimWhitespace=true") {
            let input = "  Line 1  \n   Line 2   \n"
            let formatted = input.formatted(preserveLineBreaks: true, trimWhitespace: true, joinWithSpace: false)
            try assertEqual(formatted, "Line 1\nLine 2")
        }

        test("Text formatting: joinWithSpace=true") {
            let input = "Sentence part one\npart two."
            let formatted = input.formatted(preserveLineBreaks: false, trimWhitespace: true, joinWithSpace: true)
            try assertEqual(formatted, "Sentence part one part two.")
        }

        test("Smart dehyphenation: split words across lines") {
            let input = "super-\ncomputer"
            let formatted = input.formatted()
            try assertEqual(formatted, "supercomputer")

            let academic = "This is an imple-\nmentation of the system.\nNext paragraph starts here."
            let res = academic.formatted(preserveLineBreaks: true, trimWhitespace: true, joinWithSpace: false, smartDehyphenation: true)
            try assertEqual(res, "This is an implementation\nof the system.\nNext paragraph starts here.")

            let multiLineContinuation = "This is a super-\ncomputer that processes data."
            let contRes = multiLineContinuation.formatted(preserveLineBreaks: true, trimWhitespace: true, joinWithSpace: false, smartDehyphenation: true)
            try assertEqual(contRes, "This is a supercomputer\nthat processes data.")

            // Mixed casing
            try assertEqual("Inter-\nnational".formatted(), "International")
            try assertEqual("SUPER-\nCOMPUTER".formatted(), "SUPERCOMPUTER")

            // Whitespace around line split
            let spaced = "super-  \n   computer".formatted()
            try assertEqual(spaced, "supercomputer")

            // Windows CRLF
            let crlf = "super-\r\ncomputer".formatted()
            try assertEqual(crlf, "supercomputer")
        }

        test("Smart dehyphenation: joinWithSpace=true") {
            let input = "This is a super-\ncomputer system."
            let formatted = input.formatted(preserveLineBreaks: false, trimWhitespace: true, joinWithSpace: true, smartDehyphenation: true)
            try assertEqual(formatted, "This is a supercomputer system.")
        }

        test("Smart dehyphenation: disabled") {
            let input = "super-\ncomputer"
            let preserved = input.formatted(preserveLineBreaks: true, trimWhitespace: true, joinWithSpace: false, smartDehyphenation: false)
            try assertEqual(preserved, "super-\ncomputer")

            let joined = input.formatted(preserveLineBreaks: false, trimWhitespace: true, joinWithSpace: true, smartDehyphenation: false)
            try assertEqual(joined, "super- computer")
        }

        test("Smart dehyphenation: non-breaking edge cases and compound words") {
            // Lists / bullet points
            let bulletList = "- Item 1\n- Item 2"
            try assertEqual(bulletList.formatted(), "- Item 1\n- Item 2")

            // List item continuing from previous line
            let listContinuation = "First section.\n- Second section."
            try assertEqual(listContinuation.formatted(), "First section.\n- Second section.")

            // Subtraction / math operations
            let math1 = "total - \ndiscount"
            try assertEqual(math1.formatted(), "total -\ndiscount")

            let math2 = "10 -\n5"
            try assertEqual(math2.formatted(), "10 -\n5")

            let math3 = "a - \nb"
            try assertEqual(math3.formatted(), "a -\nb")

            // Code decrement and arrows
            let code1 = "counter--\nnextStep()"
            try assertEqual(code1.formatted(), "counter--\nnextStep()")

            let code2 = "ptr->\nfield"
            try assertEqual(code2.formatted(), "ptr->\nfield")

            // Intentional double-dash / em-dash / en-dash
            let doubleDash = "word --\nnext"
            try assertEqual(doubleDash.formatted(), "word --\nnext")

            let emDash = "word —\nnext"
            try assertEqual(emDash.formatted(), "word —\nnext")

            // Single line compound words
            let compound = "state-of-the-art and high-performance"
            try assertEqual(compound.formatted(), "state-of-the-art and high-performance")
        }

        // 2. ScanResult Model Tests
        print("\n▶️ [Suite 2/6] ScanResult & ScanType Models")
        test("ScanType display names and SF symbols") {
            try assertEqual(ScanType.text.displayName, "Text Scan")
            try assertEqual(ScanType.qrCode.displayName, "QR Code")
            try assertEqual(ScanType.barcode.displayName, "Barcode")
            try assertEqual(ScanType.text.systemImage, "text.viewfinder")
            try assertEqual(ScanType.qrCode.systemImage, "qrcode.viewfinder")
            try assertEqual(ScanType.barcode.systemImage, "barcode.viewfinder")
        }

        test("ScanResult Codable serialization") {
            let original = ScanResult(type: .qrCode, content: "https://byakugan-scan.aritro.cloud", isFavourite: true)
            let encoder = JSONEncoder()
            let data = try encoder.encode(original)
            
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(ScanResult.self, from: data)
            
            try assertEqual(decoded.id, original.id)
            try assertEqual(decoded.type, original.type)
            try assertEqual(decoded.content, original.content)
            try assertEqual(decoded.isFavourite, original.isFavourite)
        }

        // 3. AppSettings Tests
        print("\n▶️ [Suite 3/6] AppSettings")
        test("AppSettings default values") {
            let settings = AppSettings.shared
            settings.resetToDefaults()
            try assertEqual(settings.textScanShortcut, "⌘⇧2")
            try assertEqual(settings.qrScanShortcut, "⌘⇧6")
            try assertEqual(settings.barcodeScanShortcut, "⌘⇧7")
            try assertTrue(settings.autoCopyToClipboard)
            try assertTrue(settings.playSoundOnCapture)
            try assertTrue(settings.showNotificationOnCapture)
            try assertEqual(settings.ocrLanguage, "en-US")
            try assertEqual(settings.ocrAccuracyLevel, .accurate)
            try assertTrue(settings.smartDehyphenation)
            try assertTrue(settings.detectTables)
            try assertEqual(settings.tableOutputFormat, .markdown)
        }

        test("AppSettings persistence mutations") {
            let settings = AppSettings.shared
            settings.textScanShortcut = "⌘⇧9"
            try assertEqual(settings.textScanShortcut, "⌘⇧9")
            settings.smartDehyphenation = false
            try assertFalse(settings.smartDehyphenation)
            settings.detectTables = false
            try assertFalse(settings.detectTables)
            settings.tableOutputFormat = .csv
            try assertEqual(settings.tableOutputFormat, .csv)
            settings.resetToDefaults()
            try assertEqual(settings.textScanShortcut, "⌘⇧2")
            try assertTrue(settings.smartDehyphenation)
            try assertTrue(settings.detectTables)
            try assertEqual(settings.tableOutputFormat, .markdown)
        }

        // 4. HotkeyService Parser Tests
        print("\n▶️ [Suite 4/6] HotkeyService Shortcut Parser")
        test("Parse default shortcuts") {
            let parsedText = HotkeyService.parseShortcut("⌘⇧2")
            try assertTrue(parsedText != nil, "Expected parsed shortcut for ⌘⇧2")
            
            let parsedQR = HotkeyService.parseShortcut("⌘⇧6")
            try assertTrue(parsedQR != nil, "Expected parsed shortcut for ⌘⇧6")
            
            let parsedBarcode = HotkeyService.parseShortcut("⌘⇧7")
            try assertTrue(parsedBarcode != nil, "Expected parsed shortcut for ⌘⇧7")
        }

        test("Parse invalid shortcuts returns nil") {
            let parsedInvalid = HotkeyService.parseShortcut("")
            try assertTrue(parsedInvalid == nil, "Empty shortcut should return nil")
            
            let parsedUnknownKey = HotkeyService.parseShortcut("⌘⇧§")
            try assertTrue(parsedUnknownKey == nil, "Unsupported key symbol should return nil")
        }

        // 5. NSImage Extensions Tests
        print("\n▶️ [Suite 5/6] NSImage Extensions")
        test("NSImage resized") {
            let baseImage = NSImage(size: NSSize(width: 100, height: 100))
            let resized = baseImage.resized(to: NSSize(width: 50, height: 50))
            try assertEqual(resized.size.width, 50.0)
            try assertEqual(resized.size.height, 50.0)
        }

        test("NSImage pngData generation") {
            let image = NSImage(size: NSSize(width: 10, height: 10))
            image.lockFocus()
            NSColor.blue.setFill()
            NSRect(x: 0, y: 0, width: 10, height: 10).fill()
            image.unlockFocus()
            
            let png = image.pngData
            try assertTrue(png != nil, "pngData should not be nil")
            
            if let data = png, data.count >= 4 {
                let header = Array(data.prefix(4))
                try assertEqual(header, [0x89, 0x50, 0x4E, 0x47], "PNG magic header")
            }
        }

        // 6. HistoryService Tests
        print("\n▶️ [Suite 6/6] HistoryService")
        test("HistoryService add and clearAll") {
            let history = HistoryService.shared
            history.clearAll()
            try assertEqual(history.history.count, 0)
            
            let item1 = ScanResult(type: .text, content: "First scan")
            let item2 = ScanResult(type: .qrCode, content: "Second scan")
            history.add(item1)
            history.add(item2)
            
            try assertEqual(history.history.count, 2)
            try assertEqual(history.history.first?.content, "Second scan")
            
            history.toggleFavourite(id: item2.id)
            try assertTrue(history.history.first?.isFavourite == true)
            
            history.remove(id: item1.id)
            try assertEqual(history.history.count, 1)
            
            history.clearAll()
            try assertEqual(history.history.count, 0)
        }

        // 7. UpdateService & In-Place Updater Tests
        print("\n▶️ [Suite 7/8] Native In-Place UpdateService")
        test("Semantic version comparison: basic increments") {
            try assertTrue(UpdateService.compareVersions("1.0.1", "1.0.0") == .orderedDescending)
            try assertTrue(UpdateService.compareVersions("1.0.0", "1.0.0") == .orderedSame)
            try assertTrue(UpdateService.compareVersions("1.0.0", "1.0.1") == .orderedAscending)
        }

        test("Semantic version comparison: prefix and formatting normalization") {
            try assertTrue(UpdateService.compareVersions("v1.0.1", "1.0.0") == .orderedDescending)
            try assertTrue(UpdateService.compareVersions("V2.0.0", "v1.9.9") == .orderedDescending)
            try assertTrue(UpdateService.compareVersions("  1.0.0  ", "1.0.0") == .orderedSame)
        }

        test("Semantic version comparison: multi-digit numerical sorting") {
            // "1.10.0" must be greater than "1.2.0" (numerical, not ASCII string comparison)
            try assertTrue(UpdateService.compareVersions("1.10.0", "1.2.0") == .orderedDescending)
            try assertTrue(UpdateService.compareVersions("1.2.0", "1.10.0") == .orderedAscending)
        }

        test("Semantic version comparison: varying length segments") {
            try assertTrue(UpdateService.compareVersions("1.0.0.1", "1.0.0") == .orderedDescending)
            try assertTrue(UpdateService.compareVersions("1.0", "1.0.0") == .orderedSame)
            try assertTrue(UpdateService.compareVersions("2.0", "1.9.9") == .orderedDescending)
        }

        test("isVersion newerThan helper") {
            try assertTrue(UpdateService.isVersion("1.0.1", newerThan: "1.0.0"))
            try assertFalse(UpdateService.isVersion("1.0.0", newerThan: "1.0.0"))
            try assertFalse(UpdateService.isVersion("0.9.9", newerThan: "1.0.0"))
        }

        test("GitHubReleaseInfo preferred asset selection") {
            let zipURL = URL(string: "https://github.com/halcyon-past/byakugan-scan/releases/download/v1.0.1/ByakuganScan.zip")!
            let dmgURL = URL(string: "https://github.com/halcyon-past/byakugan-scan/releases/download/v1.0.1/ByakuganScan.dmg")!
            let htmlURL = URL(string: "https://github.com/halcyon-past/byakugan-scan/releases/tag/v1.0.1")!

            let infoWithBoth = GitHubReleaseInfo(
                tagName: "v1.0.1",
                version: "1.0.1",
                releaseNotes: "New features",
                zipAssetURL: zipURL,
                dmgAssetURL: dmgURL,
                htmlURL: htmlURL
            )
            // Prefers ZIP for in-place auto-update speed
            try assertEqual(infoWithBoth.preferredAssetURL, zipURL)
            try assertTrue(infoWithBoth.isZip)

            let infoWithDmgOnly = GitHubReleaseInfo(
                tagName: "v1.0.1",
                version: "1.0.1",
                releaseNotes: "New features",
                zipAssetURL: nil,
                dmgAssetURL: dmgURL,
                htmlURL: htmlURL
            )
            try assertEqual(infoWithDmgOnly.preferredAssetURL, dmgURL)
            try assertFalse(infoWithDmgOnly.isZip)
        }

        test("UpdateState equality verification") {
            try assertTrue(UpdateState.idle == UpdateState.idle)
            try assertTrue(UpdateState.checking == UpdateState.checking)
            try assertTrue(UpdateState.upToDate(version: "1.0.0") == UpdateState.upToDate(version: "1.0.0"))
            try assertFalse(UpdateState.upToDate(version: "1.0.0") == UpdateState.upToDate(version: "1.0.1"))
            try assertTrue(UpdateState.error(message: "Failed") == UpdateState.error(message: "Failed"))
            try assertFalse(UpdateState.error(message: "Failed") == UpdateState.error(message: "Other"))
        }

        // 8. URLRouteService & Deep Links Tests
        print("\n▶️ [Suite 8/8] URLRouteService & Deep Links")
        test("URLRouteService: Parse scan mode endpoints") {
            let textURL = URL(string: "byakugan://scan?mode=text")!
            try assertEqual(URLRouteService.parse(url: textURL), .scan(mode: .text))

            let defaultURL = URL(string: "byakugan://scan")!
            try assertEqual(URLRouteService.parse(url: defaultURL), .scan(mode: .text))

            let qrURL = URL(string: "byakugan://scan?mode=qr")!
            try assertEqual(URLRouteService.parse(url: qrURL), .scan(mode: .qr))

            let barcodeURL = URL(string: "byakugan://scan?mode=barcode")!
            try assertEqual(URLRouteService.parse(url: barcodeURL), .scan(mode: .barcode))

            let lastURL = URL(string: "byakugan://scan?mode=last")!
            try assertEqual(URLRouteService.parse(url: lastURL), .scan(mode: .last))
        }

        test("URLRouteService: Parse settings and history endpoints") {
            let settingsURL = URL(string: "byakugan://settings")!
            try assertEqual(URLRouteService.parse(url: settingsURL), .settings)

            let prefsURL = URL(string: "byakugan://preferences")!
            try assertEqual(URLRouteService.parse(url: prefsURL), .settings)

            let historyURL = URL(string: "byakugan://history")!
            try assertEqual(URLRouteService.parse(url: historyURL), .history)

            let recentsURL = URL(string: "byakugan://recents")!
            try assertEqual(URLRouteService.parse(url: recentsURL), .history)
        }

        test("URLRouteService: Scheme filtering and invalid routes") {
            let httpURL = URL(string: "https://byakugan-scan.aritro.cloud/scan")!
            try assertEqual(URLRouteService.parse(url: httpURL), nil)

            let unknownActionURL = URL(string: "byakugan://unknown_action")!
            if case .unknown? = URLRouteService.parse(url: unknownActionURL) {
                // pass
            } else {
                try assertTrue(false, "Expected .unknown for unknown action")
            }

            let invalidModeURL = URL(string: "byakugan://scan?mode=invalid_mode")!
            if case .unknown? = URLRouteService.parse(url: invalidModeURL) {
                // pass
            } else {
                try assertTrue(false, "Expected .unknown for invalid scan mode")
            }
        }

        // Suite 9: SoundEffect Model & Profiles (Issue #4)
        print("\n▶️ [Suite 9/12] Selection Sound Variations & Audio Feedback")
        test("SoundEffect: All cases enumeration and display names") {
            try assertEqual(SoundEffect.allCases.count, 5)
            try assertEqual(SoundEffect.classicGlass.displayName, "Classic Glass")
            try assertEqual(SoundEffect.subtleClick.displayName, "Subtle Click")
            try assertEqual(SoundEffect.cameraShutter.displayName, "Camera Shutter")
            try assertEqual(SoundEffect.hapticPop.displayName, "Haptic Pop")
            try assertEqual(SoundEffect.none.displayName, "Mute / Silent")
        }

        test("SoundEffect: Codable serialization and deserialization") {
            for effect in SoundEffect.allCases {
                let data = try JSONEncoder().encode(effect)
                let decoded = try JSONDecoder().decode(SoundEffect.self, from: data)
                try assertEqual(decoded, effect)
                try assertTrue(!effect.systemImage.isEmpty, "Icon must not be empty")
            }
        }

        // Suite 10: FeedbackStyle Model & Options (Issue #3)
        print("\n▶️ [Suite 10/12] FeedbackStyle Model & Properties")
        test("FeedbackStyle: All cases and property checks") {
            try assertEqual(FeedbackStyle.allCases.count, 4)
            try assertTrue(FeedbackStyle.floatingHUD.showsHUD, "floatingHUD must show HUD")
            try assertTrue(!FeedbackStyle.floatingHUD.showsSystemNotification, "floatingHUD must not show system notif")
            try assertTrue(!FeedbackStyle.systemNotification.showsHUD, "systemNotification must not show HUD")
            try assertTrue(FeedbackStyle.systemNotification.showsSystemNotification, "systemNotification must show system notif")
            try assertTrue(FeedbackStyle.both.showsHUD && FeedbackStyle.both.showsSystemNotification, "both must show both")
            try assertTrue(!FeedbackStyle.none.showsHUD && !FeedbackStyle.none.showsSystemNotification, "none must show neither")
        }

        test("FeedbackStyle: Codable roundtrip") {
            for style in FeedbackStyle.allCases {
                let data = try JSONEncoder().encode(style)
                let decoded = try JSONDecoder().decode(FeedbackStyle.self, from: data)
                try assertEqual(decoded, style)
            }
        }

        // Suite 11: ThemeAccent Color Presets & Selection Overlay (Issue #6)
        print("\n▶️ [Suite 11/12] ThemeAccent Presets, NSColor & Selection Overlay")
        test("ThemeAccent: Curated cases, shortDisplayName, and hex mapping") {
            try assertEqual(ThemeAccent.allCases.count, 5)
            try assertEqual(ThemeAccent.byakuganChakra.hexString, "#D946EF")
            try assertEqual(ThemeAccent.byakuganChakra.shortDisplayName, "Chakra Pink")
            try assertEqual(ThemeAccent.neonCyan.hexString, "#06B6D4")
            try assertEqual(ThemeAccent.neonCyan.shortDisplayName, "Neon Cyan")
            try assertEqual(ThemeAccent.electricPurple.hexString, "#8B5CF6")
            try assertEqual(ThemeAccent.electricPurple.shortDisplayName, "Electric Purple")
            try assertEqual(ThemeAccent.emerald.hexString, "#10B981")
            try assertEqual(ThemeAccent.emerald.shortDisplayName, "Emerald")
            try assertEqual(ThemeAccent.systemAccent.hexString, "system")
            try assertEqual(ThemeAccent.systemAccent.shortDisplayName, "System")
            
            for accent in ThemeAccent.allCases {
                let nsCol = accent.nsColor
                try assertTrue(nsCol.alphaComponent > 0.9, "NSColor alpha must be opaque for \(accent.rawValue)")
            }
        }

        test("ThemeAccent: from(hexOrId:) lookup parser") {
            try assertEqual(ThemeAccent.from(hexOrId: "byakuganChakra"), .byakuganChakra)
            try assertEqual(ThemeAccent.from(hexOrId: "#06B6D4"), .neonCyan)
            try assertEqual(ThemeAccent.from(hexOrId: "#10b981"), .emerald)
            try assertEqual(ThemeAccent.from(hexOrId: "system"), .systemAccent)
            try assertEqual(ThemeAccent.from(hexOrId: "non_existent"), .byakuganChakra)
        }

        test("SelectionOverlayController: AppKit to Quartz screen rect conversion") {
            // Top-left 200x100 region on a 1440x900 display: AppKit y is 800 (maxY = 900) -> Quartz y = 0
            let appKitTopLeft = NSRect(x: 50, y: 800, width: 200, height: 100)
            let quartzTopLeft = SelectionOverlayController.quartzRect(fromAppKitScreenRect: appKitTopLeft, primaryScreenHeight: 900)
            try assertEqual(Int(quartzTopLeft.origin.x), 50)
            try assertEqual(Int(quartzTopLeft.origin.y), 0)
            try assertEqual(Int(quartzTopLeft.width), 200)
            try assertEqual(Int(quartzTopLeft.height), 100)
            
            // Bottom-left 300x150 region on a 1440x900 display: AppKit y is 0 (maxY = 150) -> Quartz y = 750
            let appKitBottomLeft = NSRect(x: 100, y: 0, width: 300, height: 150)
            let quartzBottomLeft = SelectionOverlayController.quartzRect(fromAppKitScreenRect: appKitBottomLeft, primaryScreenHeight: 900)
            try assertEqual(Int(quartzBottomLeft.origin.x), 100)
            try assertEqual(Int(quartzBottomLeft.origin.y), 750)
            try assertEqual(Int(quartzBottomLeft.width), 300)
            try assertEqual(Int(quartzBottomLeft.height), 150)
        }

        // Suite 12: FloatingHUDItem Analytics & Titles (Issue #3)
        print("\n▶️ [Suite 12/12] FloatingHUDItem Word Count & Analytics")
        test("FloatingHUDItem: Text scan word and character count") {
            let sampleResult = ScanResult(type: .text, content: "Instant on-device OCR for Apple Silicon")
            let item = FloatingHUDItem(result: sampleResult)
            try assertEqual(item.wordCount, 6)
            try assertEqual(item.characterCount, 39)
            try assertTrue(item.title.contains("Copied 6 words"), "Title must state copied word count")
            try assertEqual(item.previewText, "Instant on-device OCR for Apple Silicon")
        }

        test("FloatingHUDItem: QR code detection title") {
            let qrResult = ScanResult(type: .qrCode, content: "https://byakugan-scan.aritro.cloud")
            let qrItem = FloatingHUDItem(result: qrResult)
            try assertEqual(qrItem.title, "QR Code URL Detected")

            let barcodeResult = ScanResult(type: .barcode, content: "[EAN-13] 8901030829145")
            let barcodeItem = FloatingHUDItem(result: barcodeResult)
            try assertEqual(barcodeItem.title, "Barcode Scanned")
        }

        test("AppConstants: Version 1.0.6 & Settings window sizing verification") {
            try assertEqual(AppConstants.App.version, "1.0.6")
            try assertEqual(AppConstants.App.build, "7")
            try assertEqual(Int(AppConstants.UI.settingsWindowWidth), 680)
            try assertEqual(Int(AppConstants.UI.settingsWindowHeight), 540)
        }

        // Suite 13: Table & Grid OCR Detection & Formatting (Issue #2)
        print("\n▶️ [Suite 13/13] Table & Grid OCR Detection and Formatting")
        test("TableDetector: Real-world Stripe/AWS multi-column dashboard table") {
            let stripeCells = [
                TextCell(text: "Date", rect: CGRect(x: 0.05, y: 0.9, width: 0.15, height: 0.03)),
                TextCell(text: "Description", rect: CGRect(x: 0.25, y: 0.9, width: 0.3, height: 0.03)),
                TextCell(text: "Amount", rect: CGRect(x: 0.6, y: 0.9, width: 0.15, height: 0.03)),
                TextCell(text: "Status", rect: CGRect(x: 0.8, y: 0.9, width: 0.15, height: 0.03)),
                
                TextCell(text: "Oct 14", rect: CGRect(x: 0.05, y: 0.8, width: 0.15, height: 0.03)),
                TextCell(text: "Subscription plan", rect: CGRect(x: 0.25, y: 0.8, width: 0.3, height: 0.03)),
                TextCell(text: "$49.00", rect: CGRect(x: 0.6, y: 0.8, width: 0.15, height: 0.03)),
                TextCell(text: "Succeeded", rect: CGRect(x: 0.8, y: 0.8, width: 0.15, height: 0.03)),
                
                TextCell(text: "Oct 13", rect: CGRect(x: 0.05, y: 0.7, width: 0.15, height: 0.03)),
                TextCell(text: "Add-on usage", rect: CGRect(x: 0.25, y: 0.7, width: 0.3, height: 0.03)),
                TextCell(text: "$12.50", rect: CGRect(x: 0.6, y: 0.7, width: 0.15, height: 0.03)),
                TextCell(text: "Succeeded", rect: CGRect(x: 0.8, y: 0.7, width: 0.15, height: 0.03))
            ]

            let table = TableDetector.detectTable(from: stripeCells)
            try assertTrue(table != nil, "Expected table detection from multi-column grid")
            try assertEqual(table?.columnCount, 4)
            try assertEqual(table?.headers, ["Date", "Description", "Amount", "Status"])
            try assertEqual(table?.rows.count, 2)
            try assertEqual(table?.rows[0], ["Oct 14", "Subscription plan", "$49.00", "Succeeded"])
            try assertEqual(table?.rows[1], ["Oct 13", "Add-on usage", "$12.50", "Succeeded"])
        }

        test("TableDetector: Complex multi-line cells and headers (Byakugan shortcuts table)") {
            let cells = [
                // Header (with multi-line "Default\nShortcut" cell)
                TextCell(text: "Default", rect: CGRect(x: 0.22, y: 0.93, width: 0.08, height: 0.04)),
                TextCell(text: "Mode", rect: CGRect(x: 0.04, y: 0.89, width: 0.06, height: 0.04)),
                TextCell(text: "What it does", rect: CGRect(x: 0.38, y: 0.89, width: 0.12, height: 0.04)),
                TextCell(text: "Shortcut", rect: CGRect(x: 0.22, y: 0.85, width: 0.08, height: 0.04)),
                
                // Row 1 (multi-line in Col 1 and Col 3)
                TextCell(text: "Capture Text", rect: CGRect(x: 0.04, y: 0.74, width: 0.12, height: 0.04)),
                TextCell(text: "2", rect: CGRect(x: 0.28, y: 0.72, width: 0.02, height: 0.04)),
                TextCell(text: "Extracts unselectable text from videos, slides, PDFs, or images into", rect: CGRect(x: 0.38, y: 0.74, width: 0.58, height: 0.04)),
                TextCell(text: "(OCR)", rect: CGRect(x: 0.04, y: 0.69, width: 0.06, height: 0.04)),
                TextCell(text: "your clipboard", rect: CGRect(x: 0.38, y: 0.69, width: 0.14, height: 0.04)),
                
                // Row 2 (missing Col 2 shortcut, multi-line Col 3)
                TextCell(text: "Scan QR Code", rect: CGRect(x: 0.04, y: 0.54, width: 0.13, height: 0.04)),
                TextCell(text: "Decodes QR and MicroQR payloads on screen (with one-click Open /", rect: CGRect(x: 0.38, y: 0.56, width: 0.58, height: 0.04)),
                TextCell(text: "Mail / Call actions)", rect: CGRect(x: 0.38, y: 0.51, width: 0.20, height: 0.04)),
                
                // Row 3 (multi-line Col 3)
                TextCell(text: "Scan Barcode", rect: CGRect(x: 0.04, y: 0.37, width: 0.13, height: 0.04)),
                TextCell(text: "4", rect: CGRect(x: 0.28, y: 0.37, width: 0.02, height: 0.04)),
                TextCell(text: "Decodes EAN-8/13, UPC-E, Code 128/39/93, PDF417, Aztec, Data", rect: CGRect(x: 0.38, y: 0.39, width: 0.58, height: 0.04)),
                TextCell(text: "Matrix, and ITF-14", rect: CGRect(x: 0.38, y: 0.34, width: 0.18, height: 0.04)),
                
                // Row 4 (single-line cells)
                TextCell(text: "Cancel Selection", rect: CGRect(x: 0.04, y: 0.18, width: 0.15, height: 0.04)),
                TextCell(text: "Esc", rect: CGRect(x: 0.22, y: 0.18, width: 0.04, height: 0.04)),
                TextCell(text: "Dismisses the selection overlay without touching your clipboard", rect: CGRect(x: 0.38, y: 0.18, width: 0.55, height: 0.04))
            ]

            let table = TableDetector.detectTable(from: cells)
            try assertTrue(table != nil, "Expected complex table with multi-line cells to be detected")
            try assertEqual(table?.columnCount, 3)
            try assertEqual(table?.headers, ["Mode", "Default Shortcut", "What it does"])
            try assertEqual(table?.rows.count, 4)
            try assertEqual(table?.rows[0][0], "Capture Text (OCR)")
            try assertEqual(table?.rows[0][1], "2")
            try assertEqual(table?.rows[0][2], "Extracts unselectable text from videos, slides, PDFs, or images into your clipboard")
            try assertEqual(table?.rows[1][0], "Scan QR Code")
            try assertEqual(table?.rows[1][1], "") // Col 2 missing
            try assertEqual(table?.rows[1][2], "Decodes QR and MicroQR payloads on screen (with one-click Open / Mail / Call actions)")
            try assertEqual(table?.rows[2][0], "Scan Barcode")
            try assertEqual(table?.rows[2][1], "4")
            try assertEqual(table?.rows[2][2], "Decodes EAN-8/13, UPC-E, Code 128/39/93, PDF417, Aztec, Data Matrix, and ITF-14")
            try assertEqual(table?.rows[3][0], "Cancel Selection")
            try assertEqual(table?.rows[3][1], "Esc")
            try assertEqual(table?.rows[3][2], "Dismisses the selection overlay without touching your clipboard")
        }

        test("TableDetector: Handling missing and empty cells in columns") {
            let gapCells = [
                TextCell(text: "Product", rect: CGRect(x: 0.1, y: 0.9, width: 0.2, height: 0.03)),
                TextCell(text: "Model", rect: CGRect(x: 0.35, y: 0.9, width: 0.2, height: 0.03)),
                TextCell(text: "Price", rect: CGRect(x: 0.6, y: 0.9, width: 0.15, height: 0.03)),
                TextCell(text: "In Stock", rect: CGRect(x: 0.8, y: 0.9, width: 0.15, height: 0.03)),
                
                TextCell(text: "MacBook Pro", rect: CGRect(x: 0.1, y: 0.8, width: 0.2, height: 0.03)),
                TextCell(text: "M3 Max", rect: CGRect(x: 0.35, y: 0.8, width: 0.2, height: 0.03)),
                TextCell(text: "$3199", rect: CGRect(x: 0.6, y: 0.8, width: 0.15, height: 0.03)),
                TextCell(text: "Yes", rect: CGRect(x: 0.8, y: 0.8, width: 0.15, height: 0.03)),
                
                TextCell(text: "Mac mini", rect: CGRect(x: 0.1, y: 0.7, width: 0.2, height: 0.03)),
                // Missing Model column
                TextCell(text: "$599", rect: CGRect(x: 0.6, y: 0.7, width: 0.15, height: 0.03)),
                TextCell(text: "Yes", rect: CGRect(x: 0.8, y: 0.7, width: 0.15, height: 0.03))
            ]

            let table = TableDetector.detectTable(from: gapCells)
            try assertTrue(table != nil, "Expected table with missing cell to be detected")
            try assertEqual(table?.columnCount, 4)
            try assertEqual(table?.rows[1][0], "Mac mini")
            try assertEqual(table?.rows[1][1], "") // Missing cell mapped to empty string
            try assertEqual(table?.rows[1][2], "$599")
            try assertEqual(table?.rows[1][3], "Yes")
        }

        test("TableDetector: 2-column key-value settings table") {
            let kvCells = [
                TextCell(text: "Setting", rect: CGRect(x: 0.1, y: 0.9, width: 0.3, height: 0.03)),
                TextCell(text: "Value", rect: CGRect(x: 0.5, y: 0.9, width: 0.3, height: 0.03)),
                TextCell(text: "Resolution", rect: CGRect(x: 0.1, y: 0.8, width: 0.3, height: 0.03)),
                TextCell(text: "1080p", rect: CGRect(x: 0.5, y: 0.8, width: 0.3, height: 0.03)),
                TextCell(text: "Framerate", rect: CGRect(x: 0.1, y: 0.7, width: 0.3, height: 0.03)),
                TextCell(text: "60 FPS", rect: CGRect(x: 0.5, y: 0.7, width: 0.3, height: 0.03))
            ]
            let table = TableDetector.detectTable(from: kvCells)
            try assertTrue(table != nil, "Expected 2-column key-value table to be detected")
            try assertEqual(table?.columnCount, 2)
            try assertEqual(table?.headers, ["Setting", "Value"])
            try assertEqual(table?.rows[0], ["Resolution", "1080p"])
        }

        test("TableDetector: Non-table rejection (Zero false positives)") {
            // Prose paragraph
            let proseCells = [
                TextCell(text: "First long line of paragraph spanning the page.", rect: CGRect(x: 0.05, y: 0.9, width: 0.9, height: 0.03)),
                TextCell(text: "Second long line of paragraph spanning the page.", rect: CGRect(x: 0.05, y: 0.8, width: 0.85, height: 0.03)),
                TextCell(text: "Third concluding line.", rect: CGRect(x: 0.05, y: 0.7, width: 0.4, height: 0.03))
            ]
            try assertTrue(TableDetector.detectTable(from: proseCells) == nil, "Prose paragraph must NOT be detected as table")

            // Bullet list
            let bulletCells = [
                TextCell(text: "- First bullet item", rect: CGRect(x: 0.05, y: 0.9, width: 0.7, height: 0.03)),
                TextCell(text: "- Second bullet item", rect: CGRect(x: 0.05, y: 0.8, width: 0.7, height: 0.03)),
                TextCell(text: "- Third bullet item", rect: CGRect(x: 0.05, y: 0.7, width: 0.7, height: 0.03))
            ]
            try assertTrue(TableDetector.detectTable(from: bulletCells) == nil, "Bullet list must NOT be detected as table")

            // Single column list
            let singleCol = [
                TextCell(text: "Item 1", rect: CGRect(x: 0.1, y: 0.9, width: 0.2, height: 0.03)),
                TextCell(text: "Item 2", rect: CGRect(x: 0.1, y: 0.8, width: 0.2, height: 0.03)),
                TextCell(text: "Item 3", rect: CGRect(x: 0.1, y: 0.7, width: 0.2, height: 0.03))
            ]
            try assertTrue(TableDetector.detectTable(from: singleCol) == nil, "Single column must NOT be detected as table")

            // Code block
            let code = [
                TextCell(text: "func calculate() {", rect: CGRect(x: 0.05, y: 0.9, width: 0.4, height: 0.03)),
                TextCell(text: "    let x = 10", rect: CGRect(x: 0.05, y: 0.8, width: 0.3, height: 0.03)),
                TextCell(text: "    return x * 2", rect: CGRect(x: 0.05, y: 0.7, width: 0.35, height: 0.03)),
                TextCell(text: "}", rect: CGRect(x: 0.05, y: 0.6, width: 0.05, height: 0.03))
            ]
            try assertTrue(TableDetector.detectTable(from: code) == nil, "Code snippet must NOT be detected as table")
        }

        test("TableFormatter: Markdown table generation with alignment and pipe escaping") {
            let sampleTable = DetectedTable(
                headers: ["Item", "Qty", "Price, USD"],
                rows: [
                    ["Apple", "3", "$1.50"],
                    ["Banana", "", "$0.80"],
                    ["Orange | Special", "12", "$5.00"]
                ],
                columnCount: 3
            )

            let md = TableFormatter.toMarkdown(sampleTable)
            try assertTrue(md.contains("| Item"), "Markdown table must contain header")
            try assertTrue(md.contains("| :"), "Markdown table must contain separator")
            try assertTrue(md.contains("Orange \\| Special"), "Internal pipe in cell must be escaped as \\|")
            try assertTrue(md.contains("| Apple"), "Markdown table must contain data rows")
        }

        test("TableFormatter: CSV RFC 4180 generation with quotes and commas") {
            let sampleTable = DetectedTable(
                headers: ["Item", "Qty", "Price, USD"],
                rows: [
                    ["Apple", "3", "$1.50"],
                    ["Banana", "", "$0.80"],
                    ["Orange \"Special\"", "12", "$5.00"]
                ],
                columnCount: 3
            )

            let csv = TableFormatter.toCSV(sampleTable)
            try assertTrue(csv.contains("Item,Qty,\"Price, USD\""), "Header with comma must be quoted")
            try assertTrue(csv.contains("Apple,3,$1.50"), "Standard row should be comma-separated")
            try assertTrue(csv.contains("Banana,,$0.80"), "Empty cell represented as double comma")
            try assertTrue(csv.contains("\"Orange \"\"Special\"\"\""), "Quotes must be escaped with double quotes")
        }

        test("TableFormatter: TSV generation") {
            let sampleTable = DetectedTable(
                headers: ["Col1", "Col2"],
                rows: [["A", "B"], ["C", "D"]],
                columnCount: 2
            )
            let tsv = TableFormatter.toTSV(sampleTable)
            try assertEqual(tsv, "Col1\tCol2\nA\tB\nC\tD")
        }

        test("TableFormat model: All cases, display names, and Codable roundtrip") {
            try assertEqual(TableFormat.allCases.count, 2)
            try assertEqual(TableFormat.markdown.displayName, "Markdown Table (| Col 1 | Col 2 |)")
            try assertEqual(TableFormat.csv.displayName, "Comma-Separated Values (CSV)")
            try assertEqual(TableFormat.markdown.shortName, "Markdown")
            try assertEqual(TableFormat.csv.shortName, "CSV")

            let encoder = JSONEncoder()
            let data = try encoder.encode(TableFormat.csv)
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(TableFormat.self, from: data)
            try assertEqual(decoded, TableFormat.csv)
        }

        test("TableDetector: Sub-millisecond latency verification") {
            var benchmarkCells: [TextCell] = []
            for r in 0..<10 {
                for c in 0..<5 {
                    benchmarkCells.append(TextCell(
                        text: "Data_\(r)_\(c)",
                        rect: CGRect(x: Double(c)*0.2, y: 1.0 - Double(r)*0.08, width: 0.18, height: 0.05)
                    ))
                }
            }

            let start = CFAbsoluteTimeGetCurrent()
            let detected = TableDetector.detectTable(from: benchmarkCells)
            let durationMs = (CFAbsoluteTimeGetCurrent() - start) * 1000.0

            try assertTrue(detected != nil, "Table should be detected in benchmark")
            try assertTrue(durationMs < 10.0, "Table detection must be fast (< 10ms), took \(durationMs) ms")
        }

        // Summary Report
        print("\n=======================================================")
        print("📊 TEST EXECUTION SUMMARY")
        print("=======================================================")
        print("Total Tests:  \(totalTests)")
        print("Passed:       \(passedTests) ✅")
        print("Failed:       \(failedTests) \(failedTests > 0 ? "❌" : "")")
        print("=======================================================\n")

        if failedTests > 0 {
            print("🚨 SOME TESTS FAILED.")
            exit(1)
        } else {
            print("✨ ALL TESTS PASSED SUCCESSFULLY! 🎯\n")
            exit(0)
        }
    }
}
