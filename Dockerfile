FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y software-properties-common python-software-properties

RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y \
        git \
        unzip \
        curl \
        wget \
        apache2 \
        php5-mysql \
        php5 \
        php5-curl \
        libapache2-mod-php5 \
        php5-mcrypt \
        php5-sqlite \
        php5-gd \
        php5-xdebug \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite && \
    a2enmod vhost_alias && \
    a2enmod headers\
    # Composer
    && curl -fSL "https://getcomposer.org/installer" -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php;

RUN echo "xdebug.remote_enable=on" >> /etc/php5/apache2/conf.d/20-xdebug.ini \
    && echo "xdebug.remote_connect_back=1" >> /etc/php5/apache2/conf.d/20-xdebug.ini \
    && echo "xdebug.max_nesting_level=400" >> /etc/php5/apache2/conf.d/20-xdebug.ini \
    && echo "xdebug.remote_addr_header=\"HTTP_X_REAL_IP\"" >> /etc/php5/apache2/conf.d/20-xdebug.ini

EXPOSE 80

WORKDIR /var/www/html

CMD ["apache2ctl", "-D", "FOREGROUND"]
