---
title: Квітникарство. Таємний блоґ на тему квітів
---

<ul class="index-post-list">
{%- for post in site.posts %}
  <li>
    <p><a href="{{ post.url }}">{{ post.date | date: "%Y-%m-%d" }}: {{ post.title }}</a></p>
    {{ post.excerpt }}
  </li>
{%- endfor %}
</ul>
