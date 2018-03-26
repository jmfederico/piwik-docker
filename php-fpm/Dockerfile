FROM php:7.2-fpm-alpine
RUN apk add --no-cache libjpeg-turbo-dev libpng-dev freetype-dev \
    && docker-php-ext-install mysqli \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd
RUN apk add --no-cache fcgi

COPY php-fpm.d/*.conf /usr/local/etc/php-fpm.d/

HEALTHCHECK --timeout=3s --interval=30s \
  CMD SCRIPT_NAME=/ping \
  SCRIPT_FILENAME=/ping \
  QUERY_STRING= \
  REQUEST_METHOD=GET \
  cgi-fcgi -bind -connect 127.0.0.1:9000 | grep pong || exit 1
