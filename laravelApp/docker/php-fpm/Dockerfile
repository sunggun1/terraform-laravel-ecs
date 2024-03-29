FROM php:7.4-fpm-alpine3.12
USER root

WORKDIR /var/www

RUN apk update && apk add --no-cache $PHPIZE_DEPS \
   build-base shadow nano curl gcc git bash vim \
   php7 \
   php7-fpm \
   php7-common \
   php7-pdo \
   php7-pdo_mysql \
   php7-mysqli \
   php7-mcrypt \
   php7-mbstring \
   php7-xml \
   php7-openssl \
   php7-json \
   php7-phar \
   php7-zip \
   php7-gd \
   php7-dom \
   php7-session \
   php7-zlib

# # Install extensions
RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-enable pdo_mysql

# Remove Cache
RUN rm -rf /var/cache/apk/*

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/5.3.4.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis

# Copy config
COPY ./config/php/local.ini /usr/local/etc/php/conf.d/local.ini

# verify that the binary w
RUN addgroup -g 1000 -S www && \
    adduser -u 1000 -S www -G www

COPY --chown=www:www . /var/www/

RUN ["chmod", "+x", "./start_script.sh"]

EXPOSE 9000
RUN chmod 775 /var/www/storage
USER www
# Run php-fpm

CMD ["./start_script.sh"]