FROM debian:13

RUN apt-get update \
    && apt-get install -y \
        curl \
        unzip \
        netcat-openbsd \
        mariadb-client \
        php8.4-fpm \
        php8.4-mysql \
        php8.4-curl \
        php8.4-xml \
        php8.4-mbstring \
        php8.4-cli \
    && apt-get clean

WORKDIR /var/www/html

RUN chown -R www-data:www-data /var/www/html

COPY www.conf /etc/php/8.4/fpm/pool.d/www.conf

COPY toto.sh /usr/local/bin/toto.sh
RUN chmod +x /usr/local/bin/toto.sh

ENTRYPOINT ["/usr/local/bin/toto.sh"]

CMD ["php-fpm8.4", "-F"]