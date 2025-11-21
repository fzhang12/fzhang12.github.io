#!/bin/bash
# Comprehensive pre-delete checklist for a post
# Usage: ./pre_delete_check.sh <post-filename>

if [ -z "$1" ]; then
  echo "Usage: ./pre_delete_check.sh <post-filename>"
  echo "Example: ./pre_delete_check.sh 2025-11-04-my-first-post.md"
  exit 1
fi

POST_FILE="$1"

if [ ! -f "_posts/$POST_FILE" ] && [ ! -f "$POST_FILE" ]; then
  if [ -f "_posts/$POST_FILE" ]; then
    POST_PATH="_posts/$POST_FILE"
  elif [ -f "$POST_FILE" ]; then
    POST_PATH="$POST_FILE"
  else
    echo "❌ Error: Post file not found: $POST_FILE"
    exit 1
  fi
else
  if [ -f "_posts/$POST_FILE" ]; then
    POST_PATH="_posts/$POST_FILE"
  else
    POST_PATH="$POST_FILE"
  fi
fi

echo "=========================================="
echo "Pre-Delete Checklist for: $POST_PATH"
echo "=========================================="
echo ""

# 1. Check internal links
echo "1️⃣  Checking for internal links..."
echo "----------------------------------------"
./check_internal_links.sh "$POST_PATH"
echo ""

# 2. Check for images in the post
echo "2️⃣  Checking for images in this post..."
echo "----------------------------------------"
IMAGES_IN_POST=$(grep -i "\.jpg\|\.jpeg\|\.png\|\.gif\|\.svg\|\.webp" "$POST_PATH" 2>/dev/null)

if [ -z "$IMAGES_IN_POST" ]; then
  echo "✅ No images found in this post"
else
  echo "📷 Images referenced in this post:"
  echo "$IMAGES_IN_POST" | sed 's/^/   /'
  echo ""
  echo "💡 After deleting, check if these images are used elsewhere"
  echo "   Run: ./find_unused_images.sh"
fi
echo ""

# 3. Get post metadata
echo "3️⃣  Post information..."
echo "----------------------------------------"
TITLE=$(grep "^title:" "$POST_PATH" 2>/dev/null | sed 's/title: *//' | sed 's/^"//' | sed 's/"$//')
DATE=$(grep "^date:" "$POST_PATH" 2>/dev/null | sed 's/date: *//')
TAGS=$(grep "^tags:" "$POST_PATH" 2>/dev/null | sed 's/tags: *//')

echo "   Title: $TITLE"
echo "   Date: $DATE"
echo "   Tags: $TAGS"
echo ""

# 4. Check if it's linked from homepage or other pages
echo "4️⃣  Checking for references in site files..."
echo "----------------------------------------"
POST_SLUG=$(basename "$POST_PATH" .md | sed 's/^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}-//')
OTHER_REFS=$(grep -r -i "$POST_SLUG" index.html about.md tags/ 2>/dev/null | grep -v "$POST_PATH")

if [ -z "$OTHER_REFS" ]; then
  echo "✅ No references found in site pages"
else
  echo "⚠️  Found references:"
  echo "$OTHER_REFS" | sed 's/^/   /'
fi
echo ""

# Summary
echo "=========================================="
echo "✅ Checklist complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Review the findings above"
echo "2. If safe to delete: rm $POST_PATH"
echo "3. Test locally: bundle exec jekyll serve"
echo "4. Commit and push"

