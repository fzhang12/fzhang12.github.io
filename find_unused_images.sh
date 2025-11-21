#!/bin/bash
# Script to find unused/orphaned images in assets/images/
# Usage: ./find_unused_images.sh

echo "Scanning for unused images..."
echo ""

# Get all image files
IMAGES_DIR="assets/images"
if [ ! -d "$IMAGES_DIR" ]; then
  echo "⚠️  Images directory not found: $IMAGES_DIR"
  exit 1
fi

# Find all image files
ALL_IMAGES=$(find "$IMAGES_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.svg" -o -name "*.webp" \) 2>/dev/null)

if [ -z "$ALL_IMAGES" ]; then
  echo "✅ No images found in $IMAGES_DIR"
  exit 0
fi

UNUSED_COUNT=0
USED_COUNT=0

echo "=== Checking image usage ==="
echo ""

for image_path in $ALL_IMAGES; do
  # Get just the filename
  image_file=$(basename "$image_path")
  # Get relative path from assets/
  image_rel_path="${image_path#assets/}"
  
  # Search for references in posts and drafts
  # Look for both full path and just filename
  USAGE=$(grep -r -i "$image_file\|$image_rel_path" _posts/ _drafts/ 2>/dev/null)
  
  if [ -z "$USAGE" ]; then
    echo "❌ UNUSED: $image_path"
    UNUSED_COUNT=$((UNUSED_COUNT + 1))
  else
    echo "✅ Used: $image_file"
    USED_COUNT=$((USED_COUNT + 1))
    # Show where it's used
    echo "$USAGE" | sed 's/^/   → /'
  fi
  echo ""
done

echo "=== Summary ==="
echo "Total images: $((USED_COUNT + UNUSED_COUNT))"
echo "✅ Used: $USED_COUNT"
echo "❌ Unused: $UNUSED_COUNT"

if [ $UNUSED_COUNT -gt 0 ]; then
  echo ""
  echo "💡 Tip: Review unused images and delete them if not needed:"
  echo "   rm assets/images/unused-image.jpg"
fi

