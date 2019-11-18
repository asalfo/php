FROM php:7.3.6-apache
MAINTAINER Salif Guigma <salif.guigma@gmail.com>
ARG PHPUNIT_VERSION=phpunit-7.2.6.phar
ARG ICU4C_VERSION=icu4c/62.1/icu4c-62_1-src.tgz
RUN  apt-get update && apt-get install -y --no-install-recommends \
      apt-utils \
      net-tools \
      libicu-dev \
      zlib1g-dev \
      build-essential \
      libpng-dev \
      libjpeg-dev \
      libfreetype6-dev \
      libxslt-dev \
      sudo \
      vim \
      git \
      wget \
      gnupg \
      clang \
      libzip-dev \
      unzip \
      apt-transport-https \
      ca-certificates \
      &&  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
      && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
      &&  apt-get update && apt-get install -y yarn \
      && curl -sL https://deb.nodesource.com/setup_10.x | bash -\
      && apt-get install -y nodejs \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/* \
      && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
      && curl -sS -o /tmp/icu.tar.gz -L http://download.icu-project.org/files/$ICU4C_VERSION \
      && tar -zxf /tmp/icu.tar.gz -C /tmp \
      && cd /tmp/icu/source \
      && ./configure --prefix=/usr/local \
      && make && make install \
      && wget https://dl.eff.org/certbot-auto \
      && chmod a+x certbot-auto \
      && mv certbot-auto /usr/local/bin \
      && docker-php-ext-configure intl --with-icu-dir=/usr/local \
      && docker-php-ext-install  pdo pdo_mysql  mysqli  opcache intl sockets mbstring bcmath xsl \
      && docker-php-ext-configure zip --with-libzip \
      && docker-php-ext-install zip \
      && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
      && docker-php-ext-install -j$(nproc) gd \
      && a2enmod rewrite \
      && a2enmod ssl \
      && pecl install apcu \
      && pecl clear-cache \
      && version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
      && cd /tmp && wget https://phar.phpunit.de/$PHPUNIT_VERSION && chmod +x $PHPUNIT_VERSION && mv $PHPUNIT_VERSION /usr/local/bin/phpunit \
      && echo "date.timezone = Europe/Madrid" >> $PHP_INI_DIR/conf.d/php.ini \
      && echo "short_open_tag = Off" >> $PHP_INI_DIR/conf.d/php.ini \
      && echo "memory_limit = 256M" >> $PHP_INI_DIR/conf.d/php.ini \
      && echo "log_errors = On" >> $PHP_INI_DIR/conf.d/php.ini \
      && echo "error_log = /dev/stderr" >> $PHP_INI_DIR/conf.d/php.ini \
      && echo "short_open_tag = Off" >> $PHP_INI_DIR/conf.d/php.ini \
      && echo "extension=apcu.so" >> $PHP_INI_DIR/conf.d/apcu.ini \
      && rm -rf /tmp/*
WORKDIR /var/www/html
EXPOSE 80
EXPOSE 443
