#!/usr/bin/env bash
set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$PROJECT_DIR/build"
APP_NAME="Byakugan Scan Dev"
APP_BUNDLE="$BUILD_DIR/$APP_NAME.app"
CONTENTS="$APP_BUNDLE/Contents"
MACOS_DIR="$CONTENTS/MacOS"
RESOURCES_DIR="$CONTENTS/Resources"

echo "🔨 Building $APP_NAME for macOS (Development Build)..."

# Clean previous build
rm -rf "$APP_BUNDLE"
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

# 1. Compile Swift sources
echo "📦 Compiling Swift sources with swiftc..."
SWIFT_FILES=$(find "$PROJECT_DIR/ByakuganScan" -name "*.swift")
SDK_PATH=$(xcrun --show-sdk-path)

swiftc -target arm64-apple-macos14.0 \
  -sdk "$SDK_PATH" \
  -O \
  $SWIFT_FILES \
  -o "$MACOS_DIR/ByakuganScanDev"

# 2. Copy and configure Info.plist
echo "📄 Configuring Info.plist for Development..."
VERSION=$(grep 'static let version =' "$PROJECT_DIR/ByakuganScan/Shared/Constants/AppConstants.swift" | sed -E 's/.*"([^"]+)".*/\1/' | tr -d '[:space:]')
BUILD_NUM=$(grep 'static let build =' "$PROJECT_DIR/ByakuganScan/Shared/Constants/AppConstants.swift" | sed -E 's/.*"([^"]+)".*/\1/' | tr -d '[:space:]')

cp "$PROJECT_DIR/ByakuganScan/Resources/Info.plist" "$CONTENTS/Info.plist"
plutil -replace CFBundleExecutable -string "ByakuganScanDev" "$CONTENTS/Info.plist"
plutil -replace CFBundleIdentifier -string "cloud.aritro.byakugan-scan.dev" "$CONTENTS/Info.plist"
plutil -replace CFBundleName -string "Byakugan Scan Dev" "$CONTENTS/Info.plist"
plutil -replace CFBundleDisplayName -string "Byakugan Scan Dev" "$CONTENTS/Info.plist"
plutil -replace CFBundleShortVersionString -string "${VERSION:-1.0.11}" "$CONTENTS/Info.plist"
plutil -replace CFBundleVersion -string "${BUILD_NUM:-12}" "$CONTENTS/Info.plist"

# 3. Create .icns file for macOS
echo "🎨 Generating AppIcon.icns..."
ICONSET_DIR="/tmp/ByakuganAppIconDev.iconset"
rm -rf "$ICONSET_DIR"
mkdir -p "$ICONSET_DIR"

SRC_ICON="$PROJECT_DIR/ByakuganScan/Resources/Assets.xcassets/AppIconDev.appiconset/icon_1024x1024.png"
if [ ! -f "$SRC_ICON" ]; then
    SRC_ICON="$PROJECT_DIR/ByakuganScan/Resources/Assets.xcassets/AppIcon.appiconset/icon_1024x1024.png"
fi

sips -z 16 16     "$SRC_ICON" --out "$ICONSET_DIR/icon_16x16.png" >/dev/null 2>&1
sips -z 32 32     "$SRC_ICON" --out "$ICONSET_DIR/icon_16x16@2x.png" >/dev/null 2>&1
sips -z 32 32     "$SRC_ICON" --out "$ICONSET_DIR/icon_32x32.png" >/dev/null 2>&1
sips -z 64 64     "$SRC_ICON" --out "$ICONSET_DIR/icon_32x32@2x.png" >/dev/null 2>&1
sips -z 128 128   "$SRC_ICON" --out "$ICONSET_DIR/icon_128x128.png" >/dev/null 2>&1
sips -z 256 256   "$SRC_ICON" --out "$ICONSET_DIR/icon_128x128@2x.png" >/dev/null 2>&1
sips -z 256 256   "$SRC_ICON" --out "$ICONSET_DIR/icon_256x256.png" >/dev/null 2>&1
sips -z 512 512   "$SRC_ICON" --out "$ICONSET_DIR/icon_256x256@2x.png" >/dev/null 2>&1
sips -z 512 512   "$SRC_ICON" --out "$ICONSET_DIR/icon_512x512.png" >/dev/null 2>&1
sips -z 1024 1024 "$SRC_ICON" --out "$ICONSET_DIR/icon_512x512@2x.png" >/dev/null 2>&1

iconutil -c icns "$ICONSET_DIR" -o "$RESOURCES_DIR/AppIcon.icns"
rm -rf "$ICONSET_DIR"

# 4. Copy MenuBarIcon images into Resources
echo "👁️ Bundling MenuBarIcon assets..."
cp "$PROJECT_DIR/Assets/Icons/AS_icon_lightmode_32x32.png" "$RESOURCES_DIR/MenuBarIcon.png"
cp "$PROJECT_DIR/Assets/Icons/AS_icon_lightmode_64x64.png" "$RESOURCES_DIR/MenuBarIcon@2x.png"
cp "$PROJECT_DIR/Assets/Icons/AS_icon_darkmode_32x32.png"  "$RESOURCES_DIR/MenuBarIcon_Dark.png"
cp "$PROJECT_DIR/Assets/Icons/AS_icon_darkmode_64x64.png"  "$RESOURCES_DIR/MenuBarIcon_Dark@2x.png"

# 5. Ad-hoc codesign with permanent designated requirement for cloud.aritro.byakugan-scan.dev
echo "🔐 Signing dev app bundle with cloud.aritro.byakugan-scan.dev designated requirement..."
codesign --force --deep --sign - -r='designated => identifier "cloud.aritro.byakugan-scan.dev"' "$APP_BUNDLE"

# 6. Install to /Applications so it is directly launchable and recognized by macOS
echo "📥 Installing to /Applications/$APP_NAME.app..."
if pgrep -x "ByakuganScanDev" >/dev/null 2>&1; then
    echo "🛑 Quitting currently running Dev app before installation..."
    pkill -x "ByakuganScanDev" 2>/dev/null || true
    sleep 0.5
fi
rm -rf "/Applications/$APP_NAME.app"
cp -R "$APP_BUNDLE" "/Applications/$APP_NAME.app"

echo "✅ Successfully built and installed: /Applications/$APP_NAME.app"
echo "👉 Launch with: ./scripts/switch_to_dev.sh"
