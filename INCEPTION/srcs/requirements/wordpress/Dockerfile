FROM debian:13

RUN apt-get update \
    && apt-get install -y curl \
    && apt-get install -y unzip \
    && apt-get install -y mariadb-client \
    && apt-get install -y php-mysql php-curl \
    && apt-get install -y php8.4-fpm \
    && apt-get clean

WORKDIR /var/www/html

# Télécharger et installer WordPress
# RUN curl -O https://wordpress.org/latest.zip \
#     && unzip latest.zip \
#     && mv wordpress/* . \
#     && rm -rf wordpress latest.zip

# Définir les bons droits
RUN chown -R www-data:www-data /var/www/html

# RUN PHP_VERSION=$(ls /etc/php/) && \
#     sed -i 's|listen = .*|listen = 9000|' /etc/php/$PHP_VERSION/fpm/pool.d/www.conf && \
#     echo "cgi.fix_pathinfo=0" >> /etc/php/$PHP_VERSION/fpm/php.ini

COPY www.conf /etc/php/8.4/fpm/pool.d/.

COPY toto.sh /usr/local/bin/toto.sh
RUN chmod +x /usr/local/bin/toto.sh

ENTRYPOINT ["/usr/local/bin/toto.sh"]
