---
layout: post
permalink: /notes/
title: Max's notes
---

{%- assign date_format = site.minima.date_format | default: "%Y-%m-%d" -%}
{%- assign topics = "Travel|Career & Work|Money & Finance|Tech & Dev|Health & Sports|Life & Personal" | split: "|" -%}

<nav class="notes-toc" aria-label="Catégories">
  {% for topic in topics %}
    {%- assign topic_posts = site.posts | where: "topic", topic -%}
    {% if topic_posts.size > 0 %}
  <a href="#{{ topic | slugify }}">{{ topic }}</a>
    {% endif %}
  {% endfor %}
</nav>

{% for topic in topics %}
  {%- assign topic_posts = site.posts | where: "topic", topic -%}
  {% if topic_posts.size > 0 %}
<section class="notes-group">
  <h2 id="{{ topic | slugify }}">{{ topic }}</h2>
  <ul class="post-list">
    {% for post in topic_posts %}
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
</section>
  {% endif %}
{% endfor %}
