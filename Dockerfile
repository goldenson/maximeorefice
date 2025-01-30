# syntax = docker/dockerfile:1
FROM nginx

COPY ./_site /usr/share/nginx/html
COPY _data /usr/share/nginx/html/_data

EXPOSE 80
