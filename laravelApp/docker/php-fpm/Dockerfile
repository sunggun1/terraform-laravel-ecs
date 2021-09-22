FROM php:7.4-fpm-alpine3.12

ARG APP_ENV

WORKDIR /var/www

# Install Additional dependencies
RUN apk update && apk add --no-cache $PHPIZE_DEPS \
   build-base shadow nano curl gcc git bash \
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

# RUN apk add nodejs
RUN apk add --update npm
RUN apk add --update nodejs nodejs-npm

# Install extensions
RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-enable pdo_mysql


# install xdebug and enable it if the development environment is local
RUN if [ $APP_ENV = "local" ]; then \
   pecl install xdebug; \
   docker-php-ext-enable xdebug; \
fi;

# Install PHP Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Remove Cache
RUN rm -rf /var/cache/apk/*


# Copy config
COPY ./config/php/local.ini /usr/local/etc/php/conf.d/local.ini

RUN addgroup -g 1000 -S www && \
    adduser -u 1000 -S www -G www

USER www

COPY --chown=www:www . /var/www

USER root
RUN chgrp -R www /var/www
RUN composer install


# Expose port 9000 and start php-fpm server
EXPOSE 3000

# Run php-fpm
#CMD ["php-fpm"]
CMD php artisan serve --host=0.0.0.0 --port 3000

# FROM php:7.4-fpm-alpine3.12

# WORKDIR /var/www

# RUN apk update && apk add \
#     build-base \
#     freetype-dev \
#     libjpeg-turbo-dev \
#     libpng-dev \
#     libonig-dev \
#     libzip-dev \
#     zip \
#     jpegoptim optipng pngquant gifsicle \
#     vim \
#     unzip \
#     git \
#     curl

# RUN docker-php-ext-install mbstring zip exif pcntl
# RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
# RUN docker-php-ext-install gd

# # Install Redis Extension
# RUN apk add autoconf && pecl install -o -f redis \
# &&  rm -rf /tmp/pear \
# &&  docker-php-ext-enable redis && apk del autoconf

# # Copy config
# COPY ./config/php/local.ini /usr/local/etc/php/conf.d/local.ini

# RUN addgroup -g 1000 -S www && \
#     adduser -u 1000 -S www -G www

# USER www

# COPY --chown=www:www . /var/www

# RUN npm install

# EXPOSE 9000

# CMD npm start