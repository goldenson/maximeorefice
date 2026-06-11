---
layout: post
permalink: /notes/
title: Max's notes
---

<ul class="post-list">
  {% for post in site.posts %}
    {%- assign date_format = site.minima.date_format | default: "%Y-%m-%d" -%}
    {%- assign read_time = post.content | number_of_words | divided_by: 200 | plus: 1 -%}
    <li class="post-item">
      <a class="post-item-link" href="{{ post.url }}">{{ post.title }}</a>
      <span class="post-item-meta">
        <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: date_format }}</time>
        · {{ read_time }} min{% if post.language == "fr" %} · 🇫🇷{% endif %}
      </span>
    </li>
  {% endfor %}
</ul>
