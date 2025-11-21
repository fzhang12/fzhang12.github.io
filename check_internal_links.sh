#!/bin/bash
# Script to check for internal links to a post before deleting it
# Usage: ./check_internal_links.sh post-filename

if [ -z "$1" ]; then
  echo "Usage: ./check_internal_links.sh <post-filename>"
  echo "Example: ./check_internal_links.sh 2025-11-04-my-first-post.md"
  exit 1
fi

POST_FILE="$1"
POST_BASENAME=$(basename "$POST_FILE" .md)
POST_SLUG="${POST_BASENAME#*-*-*-}"  # Remove date prefix (YYYY-MM-DD-)

echo "Checking for internal links to: $POST_FILE"
echo "Looking for references to: $POST_SLUG"
echo ""

# Search in posts and drafts
FOUND=0

echo "=== Searching in posts and drafts ==="
MATCHES=$(grep -r -i "$POST_SLUG" _posts/ _drafts/ 2>/dev/null | grep -v "^$POST_FILE:")

if [ -z "$MATCHES" ]; then
  echo "✅ No internal links found!"
else
  echo "⚠️  Found references in:"
  echo "$MATCHES" | while IFS= read -r line; do
    file=$(echo "$line" | cut -d: -f1)
    content=$(echo "$line" | cut -d: -f2-)
    echo "  📄 $file"
    echo "     $content"
    FOUND=1
  done
fi

echo ""
echo "=== Searching for date-based links ==="
# Also check for links using the full date format
DATE_PATTERN=$(echo "$POST_BASENAME" | sed 's/\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\)-.*/\1\/\2\/\3/')
DATE_MATCHES=$(grep -r "$DATE_PATTERN" _posts/ _drafts/ 2>/dev/null | grep -v "^$POST_FILE:")

if [ ! -z "$DATE_MATCHES" ]; then
  echo "⚠️  Found date-based references:"
  echo "$DATE_MATCHES" | while IFS= read -r line; do
    file=$(echo "$line" | cut -d: -f1)
    content=$(echo "$line" | cut -d: -f2-)
    echo "  📄 $file"
    echo "     $content"
    FOUND=1
  done
fi

echo ""
if [ $FOUND -eq 0 ]; then
  echo "✅ Safe to delete! No internal links found."
else
  echo "⚠️  WARNING: Found internal links. Consider:"
  echo "   1. Removing the links from other posts"
  echo "   2. Or keeping/updating the post instead of deleting"
fi

