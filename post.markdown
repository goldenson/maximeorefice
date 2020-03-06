---
layout: post
permalink: /notes/
title: Max's notes
---

<ul>
  {% for post in site.posts %}
    <li>
      {%- assign date_format = site.minima.date_format | default: "%b %-d, %Y" -%}
      <a href="{{ post.url }}">{{ post.title }}</a> | <span class="post-meta">{{ post.date | date: date_format }}</span>
    </li>
  {% endfor %}
</ul>
