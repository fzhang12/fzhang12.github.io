---
title: This is a Test Draft Post
tags: [test, draft]
---

This is a draft post that should **only** appear when you run:

```bash
bundle exec jekyll serve --drafts
```

## What to Test

1. **Without `--drafts` flag**: This post should NOT appear
   - Run: `bundle exec jekyll serve`
   - Check homepage - this post shouldn't be there
   - Check `http://localhost:4000/feed.xml` - this post shouldn't be in RSS

2. **With `--drafts` flag**: This post SHOULD appear
   - Run: `bundle exec jekyll serve --drafts`
   - Check homepage - this post should appear
   - You can click through and read it

## When Ready to Publish

When you're ready to publish this (or any draft):
1. Move it from `_drafts/` to `_posts/`
2. Add date prefix: `2025-11-21-test-draft-post.md`
3. It will automatically appear on your site!

---

*This is just a test draft to verify the system works.*

