#!/usr/bin/env bash
set -e

# Directory setup
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$PROJECT_DIR/build"
APP_NAME="Byakugan Scan"
APP_BUNDLE="$BUILD_DIR/$APP_NAME.app"
CONTENTS="$APP_BUNDLE/Contents"
MACOS_DIR="$CONTENTS/MacOS"
RESOURCES_DIR="$CONTENTS/Resources"

echo "🚀 Building $APP_NAME for macOS..."

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
  -o "$MACOS_DIR/ByakuganScan"

# 2. Copy Info.plist
echo "📄 Copying Info.plist..."
cp "$PROJECT_DIR/ByakuganScan/Resources/Info.plist" "$CONTENTS/Info.plist"
plutil -replace CFBundleExecutable -string "ByakuganScan" "$CONTENTS/Info.plist"
plutil -replace CFBundleIdentifier -string "cloud.aritro.byakugan-scan" "$CONTENTS/Info.plist"

# 3. Create .icns file for macOS
echo "🎨 Generating AppIcon.icns..."
ICONSET_DIR="/tmp/ByakuganAppIcon.iconset"
rm -rf "$ICONSET_DIR"
mkdir -p "$ICONSET_DIR"

SRC_ICON="$PROJECT_DIR/ByakuganScan/Resources/Assets.xcassets/AppIcon.appiconset/icon_1024x1024.png"

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

# 4. Copy MenuBarIcon images into Resources for NSImage(named:) lookup
echo "👁️ Bundling MenuBarIcon assets..."
cp "$PROJECT_DIR/Assets/Icons/AS_icon_lightmode_32x32.png" "$RESOURCES_DIR/MenuBarIcon.png"
cp "$PROJECT_DIR/Assets/Icons/AS_icon_lightmode_64x64.png" "$RESOURCES_DIR/MenuBarIcon@2x.png"
cp "$PROJECT_DIR/Assets/Icons/AS_icon_darkmode_32x32.png"  "$RESOURCES_DIR/MenuBarIcon_Dark.png"
cp "$PROJECT_DIR/Assets/Icons/AS_icon_darkmode_64x64.png"  "$RESOURCES_DIR/MenuBarIcon_Dark@2x.png"

# 5. Ad-hoc codesign the bundle
echo "🔐 Signing app bundle..."
codesign --force --deep --sign - "$APP_BUNDLE"

echo "✅ Successfully built: $APP_BUNDLE"
echo "👉 Run with: open \"$APP_BUNDLE\""
