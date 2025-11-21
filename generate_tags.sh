#!/bin/bash
# Script to automatically generate tag pages from posts
# Run this before committing to ensure all tags have pages

echo "Generating tag pages..."

# Get all tags from posts
TAGS=$(grep -h "^tags:" _posts/*.md _drafts/*.md 2>/dev/null | \
       sed 's/tags: \[//' | sed 's/\]//' | \
       tr ',' '\n' | sed 's/^ *//' | sed 's/ *$//' | \
       sort -u)

# Create tags directory if it doesn't exist
mkdir -p tags

# Generate a page for each tag
for tag in $TAGS; do
  # Skip empty tags
  [ -z "$tag" ] && continue
  
  # Create slug (lowercase, replace spaces with dashes)
  slug=$(echo "$tag" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g' | sed 's/[^a-z0-9-]//g')
  
  # Check if tag page already exists
  if [ ! -f "tags/${slug}.md" ]; then
    echo "Creating tag page: tags/${slug}.md"
    cat > "tags/${slug}.md" <<EOF
---
layout: tag
title: "Posts tagged with '${tag}'"
tag: ${tag}
permalink: /tags/${slug}/
---

EOF
  else
    echo "Tag page already exists: tags/${slug}.md"
  fi
done

echo "Done! Tag pages generated."

