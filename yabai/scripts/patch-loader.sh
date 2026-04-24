#!/bin/bash
# Yabai Scripting Addition Loader Patch
# Fixes PAC ABI version mismatch on macOS Sequoia
# 
# This patch is needed because yabai v7.1.16+ is built with PAC ABI v1 (caps 0x81)
# but Dock.app on macOS Sequoia uses PAC ABI v0 (caps 0x80)
# The kernel blocks injection when versions don't match.
#
# Issue: https://github.com/asmvik/yabai/issues/2686

LOADER="/Library/ScriptingAdditions/yabai.osax/Contents/MacOS/loader"

if [ ! -f "$LOADER" ]; then
    echo "Error: Loader not found at $LOADER"
    echo "Make sure yabai is installed and scripting addition is present"
    exit 1
fi

echo "Checking current loader capabilities..."
current_caps=$(otool -f "$LOADER" | grep -E "capabilities 0x8[01]" | tail -1 | awk '{print $2}')

if [ "$current_caps" = "0x80" ]; then
    echo "✓ Loader already patched (capabilities 0x80)"
    exit 0
elif [ "$current_caps" = "0x81" ]; then
    echo "Found capabilities 0x81 - needs patching to 0x80"
else
    echo "Warning: Unknown capabilities value: $current_caps"
    echo "This patch may not be needed or the loader format changed"
fi

echo ""
echo "Applying patch..."

# Get offset for architecture 1 with caps 0x81
read I O <<< $(otool -f "$LOADER" | awk '/architecture/{i=$2} /capabilities 0x81/{f=1} f&&/offset/{print i, $2; exit}')

if [ -n "$O" ]; then
    echo "Patching architecture $I at offset $O"
    
    # Patch caps 0x81 -> 0x80 in both locations
    # 1. In the fat binary header (offset + 4)
    printf '\x80' | sudo dd of="$LOADER" bs=1 seek=$((8 + I*20 + 4)) count=1 conv=notrunc 2>/dev/null
    
    # 2. In the Mach-O header (slice offset + 11)
    printf '\x80' | sudo dd of="$LOADER" bs=1 seek=$((O + 11)) count=1 conv=notrunc 2>/dev/null
    
    echo "Resigning binary..."
    sudo codesign -f -s - "$LOADER" &>/dev/null
    
    echo "✓ Patch applied successfully!"
    echo ""
    echo "Verifying patch..."
    new_caps=$(otool -f "$LOADER" | grep -E "capabilities 0x8[01]" | tail -1 | awk '{print $2}')
    if [ "$new_caps" = "0x80" ]; then
        echo "✓ Verification successful - capabilities now 0x80"
        exit 0
    else
        echo "✗ Verification failed - capabilities still $new_caps"
        exit 1
    fi
else
    echo "Error: Could not find architecture with caps 0x81"
    exit 1
fi
