#!/usr/bin/env bash
set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "======================================================="
echo "🧪 BYAKUGAN SCAN — AUTOMATED TEST RUNNER"
echo "======================================================="

# 1. Run Swift Core Unit Tests
echo ""
echo "🚀 [1/2] Compiling and running Swift unit test suite..."
SWIFT_FILES=(
  "$PROJECT_DIR/ByakuganScan/Core/Models/ScanResult.swift"
  "$PROJECT_DIR/ByakuganScan/Core/Models/SoundEffect.swift"
  "$PROJECT_DIR/ByakuganScan/Core/Models/FeedbackStyle.swift"
  "$PROJECT_DIR/ByakuganScan/Core/Models/ThemeAccent.swift"
  "$PROJECT_DIR/ByakuganScan/Core/Models/AppSettings.swift"
  "$PROJECT_DIR/ByakuganScan/Core/Services/HotkeyService.swift"
  "$PROJECT_DIR/ByakuganScan/Core/Services/HistoryService.swift"
  "$PROJECT_DIR/ByakuganScan/Core/Services/ScreenCaptureService.swift"
  "$PROJECT_DIR/ByakuganScan/Core/Services/UpdateService.swift"
  "$PROJECT_DIR/ByakuganScan/Core/Services/URLRouteService.swift"
  "$PROJECT_DIR/ByakuganScan/Core/Extensions/NSImage+Extensions.swift"
  "$PROJECT_DIR/ByakuganScan/Core/Extensions/String+Extensions.swift"
  "$PROJECT_DIR/ByakuganScan/Shared/Components/FloatingHUDController.swift"
  "$PROJECT_DIR/ByakuganScan/Shared/Components/SelectionOverlayController.swift"
  "$PROJECT_DIR/ByakuganScan/Shared/Constants/AppConstants.swift"
  "$PROJECT_DIR/Tests/RunAllTests.swift"
)

SDK_PATH=$(xcrun --show-sdk-path)
TEST_BIN="/tmp/ByakuganScan_UnitTests"

swiftc -target arm64-apple-macos14.0 \
  -sdk "$SDK_PATH" \
  "${SWIFT_FILES[@]}" \
  -o "$TEST_BIN"

"$TEST_BIN"
rm -f "$TEST_BIN"

# 2. Run Next.js Website Build Check
echo ""
echo "🌐 [2/2] Validating Next.js website build..."
cd "$PROJECT_DIR/website"
npm run build

echo ""
echo "======================================================="
echo "🎉 ALL TEST SUITES & BUILDS PASSED WITH ZERO ERRORS!"
echo "======================================================="
