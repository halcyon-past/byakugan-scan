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
            try assertEqual(settings.qrScanShortcut, "⌘⇧3")
            try assertEqual(settings.barcodeScanShortcut, "⌘⇧4")
            try assertTrue(settings.autoCopyToClipboard)
            try assertTrue(settings.playSoundOnCapture)
            try assertTrue(settings.showNotificationOnCapture)
            try assertEqual(settings.ocrLanguage, "en-US")
            try assertEqual(settings.ocrAccuracyLevel, .accurate)
        }

        test("AppSettings persistence mutations") {
            let settings = AppSettings.shared
            settings.textScanShortcut = "⌘⇧9"
            try assertEqual(settings.textScanShortcut, "⌘⇧9")
            settings.resetToDefaults()
            try assertEqual(settings.textScanShortcut, "⌘⇧2")
        }

        // 4. HotkeyService Parser Tests
        print("\n▶️ [Suite 4/6] HotkeyService Shortcut Parser")
        test("Parse default shortcuts") {
            let parsedText = HotkeyService.parseShortcut("⌘⇧2")
            try assertTrue(parsedText != nil, "Expected parsed shortcut for ⌘⇧2")
            
            let parsedQR = HotkeyService.parseShortcut("⌘⇧3")
            try assertTrue(parsedQR != nil, "Expected parsed shortcut for ⌘⇧3")
            
            let parsedBarcode = HotkeyService.parseShortcut("⌘⇧4")
            try assertTrue(parsedBarcode != nil, "Expected parsed shortcut for ⌘⇧4")
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
