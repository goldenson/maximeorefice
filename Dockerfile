# syntax = docker/dockerfile:1
FROM nginx

COPY ./_site /usr/share/nginx/html

RUN -d -v db:/_data goldenson/maximeorefice

EXPOSE 80
