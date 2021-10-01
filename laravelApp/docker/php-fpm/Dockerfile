FROM php:7.4-fpm-alpine3.12

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /var/www

ARG PHPGROUP
ARG PHPUSER

ENV PHPGROUP=${PHPGROUP}
ENV PHPUSER=${PHPUSER}

RUN adduser -g ${PHPGROUP} -s /bin/bash -D ${PHPUSER}; exit 0

RUN sed -i "s/user = www-data/user = ${PHPUSER}/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = ${PHPGROUP}/g" /usr/local/etc/php-fpm.d/www.conf

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

# Install extensions
RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-enable pdo_mysql

# Remove Cache
RUN rm -rf /var/cache/apk/*

RUN apk add dos2unix

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/5.3.4.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis

# Copy config
COPY ./config/php/local.ini /usr/local/etc/php/conf.d/local.ini

USER www-data
COPY --chown=www-data:www-data . /var/www

USER root
RUN chgrp -R www-data /var/www
RUN sed -i 's/\r$//' ./start_script.sh
RUN ["chmod", "+x", "./start_script.sh"]
RUN dos2unix ./start_script.sh

USER www-data
EXPOSE 3000
RUN ls -l


# Run php-fpm
CMD ./start_script.sh