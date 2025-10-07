#!/bin/bash

# Fix HMS SDK dSYM issue for TestFlight uploads
# This script should be run as a Build Phase in Xcode

echo "🔧 Fixing HMS SDK dSYM files for TestFlight upload..."

# Path to the built app
APP_PATH="$BUILT_PRODUCTS_DIR/$WRAPPER_NAME"
DSYM_PATH="$DWARF_DSYM_FOLDER_PATH/$DWARF_DSYM_FILE_NAME"

# HMS Frameworks that need dSYM fixes
HMS_FRAMEWORKS=(
    "HMSAnalyticsSDK"
    "HMSBroadcastExtensionSDK" 
    "HMSHLSPlayerSDK"
    "HMSSDK"
    "WebRTC"
)

echo "📱 App path: $APP_PATH"
echo "🔍 dSYM path: $DSYM_PATH"

# Create dSYM directory if it doesn't exist
mkdir -p "$DSYM_PATH/Contents/Resources/DWARF"

for framework in "${HMS_FRAMEWORKS[@]}"; do
    echo "🔧 Processing $framework.framework..."
    
    FRAMEWORK_PATH="$APP_PATH/Frameworks/$framework.framework"
    FRAMEWORK_DSYM_PATH="$DSYM_PATH/Contents/Resources/DWARF/$framework"
    
    if [ -f "$FRAMEWORK_PATH/$framework" ]; then
        echo "✅ Found $framework binary"
        
        # Copy the binary to dSYM folder
        cp "$FRAMEWORK_PATH/$framework" "$FRAMEWORK_DSYM_PATH"
        
        # Strip debug symbols from the framework binary
        strip -S "$FRAMEWORK_PATH/$framework"
        
        echo "✅ Created dSYM for $framework"
    else
        echo "⚠️  $framework binary not found at $FRAMEWORK_PATH"
    fi
done

echo "🎉 HMS SDK dSYM fix completed!"
