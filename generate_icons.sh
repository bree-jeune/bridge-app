#!/bin/bash
SOURCE=$1
# Adjust destination based on where the script is run. Assuming run from BridgeApp/BridgeApp root based on previous context, 
# but the ls showed Assets.xcassets is in BridgeApp/BridgeApp. 
# So if I run this from /Users/jeune/Desktop/BridgeApp/BridgeApp:
DEST="Assets.xcassets/AppIcon.appiconset"

if [ -z "$SOURCE" ]; then
  echo "Usage: ./generate_icons.sh <source_image>"
  exit 1
fi

mkdir -p "$DEST"

# Generate sizes
# iPhone Notification (20pt)
sips -z 40 40 "$SOURCE" --out "$DEST/Icon-40.png"
sips -z 60 60 "$SOURCE" --out "$DEST/Icon-60.png"

# iPhone Settings (29pt)
sips -z 58 58 "$SOURCE" --out "$DEST/Icon-58.png"
sips -z 87 87 "$SOURCE" --out "$DEST/Icon-87.png"

# iPhone Spotlight (40pt)
sips -z 80 80 "$SOURCE" --out "$DEST/Icon-80.png"
sips -z 120 120 "$SOURCE" --out "$DEST/Icon-120.png"

# iPhone App (60pt)
sips -z 120 120 "$SOURCE" --out "$DEST/Icon-120-1.png" 
sips -z 180 180 "$SOURCE" --out "$DEST/Icon-180.png"
# Note: 120 size is used for both Spotlight 40pt@3x and App 60pt@2x. 
# Contents.json usually distinguishes by filename to avoid confusion if we want strict naming.
# Let's match the Contents.json likely structure. 
# Usually: 20@2x, 20@3x, 29@2x, 29@3x, 40@2x, 40@3x, 60@2x, 60@3x, 1024

sips -z 40 40   "$SOURCE" --out "$DEST/20@2x.png"
sips -z 60 60   "$SOURCE" --out "$DEST/20@3x.png"
sips -z 58 58   "$SOURCE" --out "$DEST/29@2x.png"
sips -z 87 87   "$SOURCE" --out "$DEST/29@3x.png"
sips -z 80 80   "$SOURCE" --out "$DEST/40@2x.png"
sips -z 120 120 "$SOURCE" --out "$DEST/40@3x.png"
sips -z 120 120 "$SOURCE" --out "$DEST/60@2x.png"
sips -z 180 180 "$SOURCE" --out "$DEST/60@3x.png"
sips -z 1024 1024 "$SOURCE" --out "$DEST/1024.png"
