FROM php:fpm-alpine
RUN apk add --no-cache libjpeg-turbo-dev libpng-dev freetype-dev \
    && docker-php-ext-install mysqli \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd
