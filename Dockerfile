From php:7.2.8-apache
MAINTAINER Salif Guigma <salif.guigma@gmail.com>
ARG PHPUNIT_VERSION=phpunit-7.2.6.phar
ARG ICU4C_VERSION=icu4c/62.1/icu4c-62_1-src.tgz
RUN   apt-get update && apt-get install -y --no-install-recommends \
      apt-utils \
      libicu-dev \
      zlib1g-dev \
      build-essential \
      libpng-dev \
      libjpeg-dev \
      libfreetype6-dev \
      vim \
      git \
      wget \
      gnupg \
      clang \
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
      && docker-php-ext-configure intl --with-icu-dir=/usr/local \
      && docker-php-ext-install zip pdo pdo_mysql  mysqli  opcache intl sockets mbstring bcmath xsl \
      && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
      && docker-php-ext-install -j$(nproc) gd \
      && a2enmod rewrite \
      && pecl install xdebug \
      && docker-php-ext-enable xdebug \
      && pecl install apcu \
      && pecl clear-cache \
      && version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
      && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
      && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
      && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
      && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
      && cd /tmp && wget https://phar.phpunit.de/$PHPUNIT_VERSION && chmod +x $PHPUNIT_VERSION && mv $PHPUNIT_VERSION /usr/local/bin/phpunit \
      && echo "date.timezone = Europe/Madrid" >> $PHP_INI_DIR/conf.d/php.ini \
      && echo "short_open_tag = Off" >> $PHP_INI_DIR/conf.d/php.ini \
      && echo "memory_limit = 256M" >> $PHP_INI_DIR/conf.d/php.ini \
      && echo "log_errors = On" >> $PHP_INI_DIR/conf.d/php.ini \
      && echo "error_log = /dev/stderr" >> $PHP_INI_DIR/conf.d/php.ini \
      && echo "short_open_tag = Off" >> $PHP_INI_DIR/conf.d/php.ini \
      && echo "xdebug.remote_enable=On" >> $PHP_INI_DIR/conf.d/xdebug.ini \
      && echo "xdebug.remote_autostart=1" >> $PHP_INI_DIR/conf.d/xdebug.ini \
      && echo "xdebug.remote_port=9000" >> $PHP_INI_DIR/conf.d/xdebug.ini \
      && usermod -u 1000 www-data \
      && groupmod -g 1000 www-data \
      && usermod -s /bin/bash www-data \
      && rm -rf /tmp/*
