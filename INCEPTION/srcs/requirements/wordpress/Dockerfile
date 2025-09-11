FROM debian:13

RUN apt-get update \
    && apt-get install -y curl \
    && apt-get install -y unzip \
    && apt-get install -y netcat-openbsd \
    && apt-get install -y mariadb-client \
    && apt-get install -y php-mysql php-curl \
    && apt-get install -y php8.4-fpm \
    && apt-get clean

WORKDIR /var/www/html

RUN chown -R www-data:www-data /var/www/html

COPY www.conf /etc/php/8.4/fpm/pool.d/www.conf

COPY toto.sh /usr/local/bin/toto.sh
RUN chmod +x /usr/local/bin/toto.sh

ENTRYPOINT ["/usr/local/bin/toto.sh"]

CMD ["php-fpm8.4", "-F"]