FROM alpine:latest

RUN apk add --no-cache caddy curl

ENV CADDYPATH=/srv/caddy/.caddy

RUN mkdir -p /srv/caddy/html \
    mkdir -p /srv/caddy/.caddy

WORKDIR /srv/caddy/html

COPY Caddyfile* /srv/caddy/

EXPOSE 80/tcp
EXPOSE 443/tcp

HEALTHCHECK --timeout=3s --interval=30s \
  CMD curl -k -sS -If https://${DOMAIN}/piwik.js || exit 1

CMD ["caddy", "--conf", "/srv/caddy/Caddyfile"]
