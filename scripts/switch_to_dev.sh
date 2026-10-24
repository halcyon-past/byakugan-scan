#!/usr/bin/env bash
set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "🔄 Switching to Byakugan Scan [DEV]..."

# Check if rebuild requested or binary missing
if [ ! -d "/Applications/Byakugan Scan Dev.app" ] || [ "$1" == "--rebuild" ] || [ "$1" == "-b" ]; then
    echo "📦 Building Byakugan Scan Dev first..."
    "$PROJECT_DIR/scripts/build_dev.sh"
fi

# Gracefully terminate production app or previous dev app if running
if pgrep -x "ByakuganScan" >/dev/null 2>&1; then
    echo "🛑 Quitting Production app..."
    pkill -x "ByakuganScan" 2>/dev/null || true
    sleep 0.3
fi

if pgrep -x "ByakuganScanDev" >/dev/null 2>&1; then
    echo "🛑 Quitting previous Dev app instance..."
    pkill -x "ByakuganScanDev" 2>/dev/null || true
    sleep 0.5
fi

# Launch Dev app
echo "🚀 Launching Byakugan Scan Dev..."
open "/Applications/Byakugan Scan Dev.app"

echo ""
echo "======================================================="
echo "✅ BYAKUGAN SCAN DEV IS NOW RUNNING!"
echo "======================================================="
echo "👁️  Look at your menu bar: you will see '[👁️ DEV]'"
echo "⚙️  Preferences and scan history are isolated from Prod."
echo "🔄  To return to Prod at any time:"
echo "    - Click the '[👁️ DEV]' icon -> click '⇄ To Prod' in footer, OR"
echo "    - Run: ./scripts/switch_to_prod.sh"
echo "======================================================="
