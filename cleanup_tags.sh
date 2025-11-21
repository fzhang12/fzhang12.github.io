#!/bin/bash
# Script to find and optionally remove orphaned tag pages
# (Tag pages with no posts)

echo "Checking for orphaned tag pages..."

# Get all tags currently used in posts
USED_TAGS=$(grep -h "^tags:" _posts/*.md _drafts/*.md 2>/dev/null | \
            sed 's/tags: \[//' | sed 's/\]//' | \
            tr ',' '\n' | sed 's/^ *//' | sed 's/ *$//' | \
            sort -u)

# Convert to lowercase slugs for comparison
USED_SLUGS=""
for tag in $USED_TAGS; do
  slug=$(echo "$tag" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g' | sed 's/[^a-z0-9-]//g')
  USED_SLUGS="$USED_SLUGS $slug"
done

# Check each tag file
ORPHANED=0
for tag_file in tags/*.md; do
  # Skip index.md
  [ "$(basename "$tag_file")" = "index.md" ] && continue
  
  # Get the slug from filename
  slug=$(basename "$tag_file" .md)
  
  # Check if this tag is used
  if ! echo "$USED_SLUGS" | grep -q " $slug "; then
    # Get the actual tag name from the file
    tag_name=$(grep "^tag:" "$tag_file" | sed 's/tag: *//' | sed 's/^ *//' | sed 's/ *$//')
    
    echo "⚠️  Orphaned tag: $tag_name (file: $tag_file)"
    ORPHANED=$((ORPHANED + 1))
    
    # Ask if user wants to delete (if run interactively)
    if [ -t 0 ]; then
      read -p "  Delete this tag page? (y/N): " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm "$tag_file"
        echo "  ✅ Deleted: $tag_file"
      fi
    fi
  fi
done

if [ $ORPHANED -eq 0 ]; then
  echo "✅ No orphaned tag pages found!"
else
  if [ ! -t 0 ]; then
    echo ""
    echo "Found $ORPHANED orphaned tag page(s)."
    echo "Run interactively to delete them, or delete manually."
  fi
fi

echo "Done!"

