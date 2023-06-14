FROM php:5.4-apache
ENV PHP_INI_DATE_TIMEZONE 'UTC'
ENV PHP_INI_MEMORY_LIMIT 256M

RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get update -y \
    && apt-get install -y --force-yes --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libjpeg62-turbo \
        libpng-dev \
        libpng16-16 \
        libldap2-dev \
        libxml2-dev \
        libzip-dev \
        zlib1g-dev \
        libicu-dev \
        g++ \
        default-mysql-client \
        unzip \
        curl \
        apt-utils libcurl4-openssl-dev wget
RUN docker-php-ext-install calendar intl mysql gd soap zip

RUN wget --no-check-certificate https://curl.haxx.se/download/curl-7.52.1.tar.gz
RUN tar xzvf curl-7.52.1.tar.gz
RUN cd curl-7.52.1 && ./configure --prefix=/usr/ && make && make install && cd ..
RUN docker-php-ext-install curl

COPY docker-run.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-run.sh

EXPOSE 80

ENTRYPOINT ["docker-run.sh"]
