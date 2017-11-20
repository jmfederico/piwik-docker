FROM alpine:latest

RUN apk add --no-cache caddy

ENV CADDYPATH=/srv/caddy/.caddy

RUN mkdir -p /srv/caddy/html \
    mkdir -p /srv/caddy/.caddy

WORKDIR /srv/caddy/html

COPY Caddyfile* /srv/caddy/

EXPOSE 80/tcp
EXPOSE 443/tcp

CMD ["caddy", "--conf", "/srv/caddy/Caddyfile"]
