---
---
const CACHE_NAME = 'maximeorefice-{{ site.time | date: "%s" }}';

const PRECACHE_URLS = [
  '/',
  '/livres/',
  '/offline/',
  '/assets/main.css',
  '/assets/darkmode.js',
  '/assets/header.js',
  '/assets/lazyload.js',
  '/assets/tables.js',
  '/assets/reading-progress.js',
  '/assets/books-pagination.js',
  '/assets/fonts/atkinson-bold.woff',
  '/assets/fonts/atkinson-regular.woff',
  {% for post in site.posts %}'{{ post.url }}',
  {% endfor %}
];

function cacheKey(request) {
  const url = new URL(request.url);
  if (url.search && url.pathname.startsWith('/assets/')) {
    return new Request(url.origin + url.pathname);
  }
  return request;
}

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache =>
      Promise.all(PRECACHE_URLS.map(url => cache.add(url).catch(() => null)))
    )
  );
  self.skipWaiting();
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', event => {
  const { request } = event;
  const url = new URL(request.url);

  if (url.origin !== self.location.origin || request.method !== 'GET') return;

  const key = cacheKey(request);

  if (request.mode === 'navigate') {
    event.respondWith(
      fetch(request)
        .then(response => {
          caches.open(CACHE_NAME).then(cache => cache.put(key, response.clone()));
          return response;
        })
        .catch(() =>
          caches.match(key, { ignoreVary: true })
            .then(cached => cached || caches.match('/offline/', { ignoreVary: true }))
        )
    );
  } else {
    event.respondWith(
      caches.match(key, { ignoreVary: true }).then(cached => {
        if (cached) return cached;
        return fetch(request).then(response => {
          if (response.ok) {
            caches.open(CACHE_NAME).then(cache => cache.put(key, response.clone()));
          }
          return response;
        });
      })
    );
  }
});
