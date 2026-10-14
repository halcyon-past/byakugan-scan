#!/usr/bin/env bash
set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "🔄 Switching to Byakugan Scan [PRODUCTION]..."

# Gracefully terminate dev app if running
if pgrep -x "ByakuganScanDev" >/dev/null 2>&1; then
    echo "🛑 Quitting Dev app..."
    pkill -x "ByakuganScanDev" 2>/dev/null || true
    sleep 0.3
fi

# Ensure production app exists
PROD_APP="/Applications/Byakugan Scan.app"
if [ ! -d "$PROD_APP" ]; then
    if [ -d "$PROJECT_DIR/build/Byakugan Scan.app" ]; then
        PROD_APP="$PROJECT_DIR/build/Byakugan Scan.app"
    else
        echo "⚠️ Production app not found. Building it now..."
        "$PROJECT_DIR/scripts/build_app.sh"
    fi
fi

# Launch Production app
echo "🚀 Launching Byakugan Scan Production..."
open "$PROD_APP"

echo ""
echo "======================================================="
echo "✅ BYAKUGAN SCAN PRODUCTION IS NOW RUNNING!"
echo "======================================================="
echo "👁️  Look at your menu bar: you will see standard '[👁️]'"
echo "🔄  To return to Dev at any time:"
echo "    - Click the '[👁️]' icon -> click '🔨 To Dev' in footer, OR"
echo "    - Run: ./scripts/switch_to_dev.sh"
echo "======================================================="
