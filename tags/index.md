---
layout: page
title: Tags
permalink: /tags/
---

<style>
  /* Custom styles for tags */
  .post-tag {
    display: inline-block;
    padding: 0.2rem 0.6rem;
    margin: 0.2rem 0.2rem 0.2rem 0;
    background-color: #f0f0f0;
    border-radius: 3px;
    color: #0066cc;
    text-decoration: none;
    transition: background-color 0.2s;
  }

  .post-tag:hover {
    background-color: #e0e0e0;
    text-decoration: none;
  }
</style>

<!-- Tag list -->
<p>
  {% assign sorted_tags = site.tags | sort %}
  {% for tag_pair in sorted_tags %}
    {% assign tag_name = tag_pair[0] %}
    {% assign posts_count = tag_pair[1] | size %}
    <a href="{{ '/tags/' | relative_url }}{{ tag_name | slugify }}/" class="post-tag">{{ tag_name }} ({{ posts_count }})</a>
  {% endfor %}
  {% if sorted_tags.size == 0 %}
    <em>No tags yet.</em>
  {% endif %}
</p>

<p>Click on any tag above to see all posts tagged with it.</p>


