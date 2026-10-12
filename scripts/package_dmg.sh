#!/usr/bin/env bash
set -e

# Directory setup
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$PROJECT_DIR/build"
APP_NAME="Byakugan Scan"
APP_BUNDLE="$BUILD_DIR/$APP_NAME.app"

# 1. Build app bundle if missing
if [ ! -d "$APP_BUNDLE" ]; then
  echo "📦 App bundle not found in build/, running build_app.sh first..."
  "$PROJECT_DIR/scripts/build_app.sh"
fi

# 2. Extract app version from AppConstants.swift
VERSION=$(grep 'static let version =' "$PROJECT_DIR/ByakuganScan/Shared/Constants/AppConstants.swift" | sed -E 's/.*"([^"]+)".*/\1/' | tr -d '[:space:]')
if [ -z "$VERSION" ]; then
  VERSION="1.0.0"
fi

echo "💿 Packaging DMG for $APP_NAME v$VERSION..."

DMG_NAME="ByakuganScan.dmg"
VERSIONED_DMG_NAME="ByakuganScan-v$VERSION.dmg"
DMG_OUTPUT="$BUILD_DIR/$DMG_NAME"
VERSIONED_DMG_OUTPUT="$BUILD_DIR/$VERSIONED_DMG_NAME"

# 3. Prepare clean DMG staging directory
STAGING_DIR="/tmp/ByakuganScan_DMG_Staging"
rm -rf "$STAGING_DIR"
mkdir -p "$STAGING_DIR"

# Copy signed app bundle
cp -R "$APP_BUNDLE" "$STAGING_DIR/"

# Create /Applications symlink for drag-and-drop installer UX
ln -s /Applications "$STAGING_DIR/Applications"

# Remove stale DMGs if any
rm -f "$DMG_OUTPUT" "$VERSIONED_DMG_OUTPUT"

# 4. Generate compressed read-only DMG with hdiutil
hdiutil create \
  -volname "$APP_NAME" \
  -srcfolder "$STAGING_DIR" \
  -ov \
  -format UDZO \
  "$DMG_OUTPUT"

# Copy to versioned DMG name
cp "$DMG_OUTPUT" "$VERSIONED_DMG_OUTPUT"

# Clean staging directory
rm -rf "$STAGING_DIR"

# 5. Generate signed ZIP archive for native in-place auto-updater
echo "📦 Packaging ZIP archive for in-place auto-updater..."
ZIP_OUTPUT="$BUILD_DIR/ByakuganScan.zip"
VERSIONED_ZIP_OUTPUT="$BUILD_DIR/ByakuganScan-v$VERSION.zip"
rm -f "$ZIP_OUTPUT" "$VERSIONED_ZIP_OUTPUT"

ditto -c -k --keepParent "$APP_BUNDLE" "$ZIP_OUTPUT"
cp "$ZIP_OUTPUT" "$VERSIONED_ZIP_OUTPUT"

echo ""
echo "======================================================="
echo "🎉 RELEASE PACKAGES GENERATED SUCCESSFULLY!"
echo "   DMG Asset:  $DMG_OUTPUT"
echo "   DMG Tagged: $VERSIONED_DMG_OUTPUT"
echo "   ZIP Asset:  $ZIP_OUTPUT"
echo "   ZIP Tagged: $VERSIONED_ZIP_OUTPUT"
echo "======================================================="
