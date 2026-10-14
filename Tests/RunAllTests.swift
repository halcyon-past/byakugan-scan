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
            try assertEqual(res, "This is an implementation of the system.\nNext paragraph starts here.")

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
        }

        test("AppSettings persistence mutations") {
            let settings = AppSettings.shared
            settings.textScanShortcut = "⌘⇧9"
            try assertEqual(settings.textScanShortcut, "⌘⇧9")
            settings.smartDehyphenation = false
            try assertFalse(settings.smartDehyphenation)
            settings.resetToDefaults()
            try assertEqual(settings.textScanShortcut, "⌘⇧2")
            try assertTrue(settings.smartDehyphenation)
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

        test("AppConstants: Version 1.0.4 & Settings window sizing verification") {
            try assertEqual(AppConstants.App.version, "1.0.4")
            try assertEqual(AppConstants.App.build, "5")
            try assertEqual(Int(AppConstants.UI.settingsWindowWidth), 680)
            try assertEqual(Int(AppConstants.UI.settingsWindowHeight), 540)
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
