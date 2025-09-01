FROM debian:12

RUN apt-get update \
    && apt-get install -y curl \
    && apt-get install -y unzip \
    && apt-get install -y php-mysql php-curl \
    && apt-get install -y apache2 libapache2-mod-php \
    && get-apt clean

WORKDIR /var/www/html

RUN curl -O https://wordpress.org/latest.zip \
    && unzip latest.zip \
    && mv wordpress/* . \
    && rm latest.zip \
    && rm -rf latest*

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]