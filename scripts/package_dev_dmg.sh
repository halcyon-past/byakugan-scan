#!/usr/bin/env bash
set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$PROJECT_DIR/build"
APP_NAME="Byakugan Scan Dev"
APP_BUNDLE="$BUILD_DIR/$APP_NAME.app"

# 1. Build dev app bundle if missing
if [ ! -d "$APP_BUNDLE" ]; then
  echo "📦 Dev app bundle not found in build/, running build_dev.sh first..."
  "$PROJECT_DIR/scripts/build_dev.sh"
fi

VERSION=$(grep 'static let version =' "$PROJECT_DIR/ByakuganScan/Shared/Constants/AppConstants.swift" | sed -E 's/.*"([^"]+)".*/\1/' | tr -d '[:space:]')
if [ -z "$VERSION" ]; then
  VERSION="1.0.11"
fi

echo "💿 Packaging DMG for $APP_NAME v$VERSION..."

DMG_NAME="ByakuganScan-Dev.dmg"
VERSIONED_DMG_NAME="ByakuganScan-Dev-v$VERSION.dmg"
DMG_OUTPUT="$BUILD_DIR/$DMG_NAME"
VERSIONED_DMG_OUTPUT="$BUILD_DIR/$VERSIONED_DMG_NAME"

# 2. Prepare clean DMG staging directory
STAGING_DIR="/tmp/ByakuganScanDev_DMG_Staging"
rm -rf "$STAGING_DIR"
mkdir -p "$STAGING_DIR"

# Copy signed dev app bundle
cp -R "$APP_BUNDLE" "$STAGING_DIR/"

# Create /Applications symlink for drag-and-drop installer UX
ln -s /Applications "$STAGING_DIR/Applications"

# Remove stale DMGs if any
rm -f "$DMG_OUTPUT" "$VERSIONED_DMG_OUTPUT"

# 3. Generate compressed read-only DMG with hdiutil
hdiutil create \
  -volname "$APP_NAME" \
  -srcfolder "$STAGING_DIR" \
  -ov \
  -format UDZO \
  "$DMG_OUTPUT"

cp "$DMG_OUTPUT" "$VERSIONED_DMG_OUTPUT"
rm -rf "$STAGING_DIR"

echo ""
echo "======================================================="
echo "🎉 DEV INSTALLER DMG GENERATED SUCCESSFULLY!"
echo "   DMG Asset:  $DMG_OUTPUT"
echo "   DMG Tagged: $VERSIONED_DMG_OUTPUT"
echo "======================================================="
