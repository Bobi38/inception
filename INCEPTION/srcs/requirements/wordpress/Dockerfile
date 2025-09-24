FROM debian:13

# ✅ Installation des dépendances PHP + outils
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
        sendmail \
        php8.4-cli \
    && apt-get clean

# ✅ Définir le répertoire de travail
WORKDIR /var/www/html

# ✅ Permissions pour WordPress
RUN chown -R www-data:www-data /var/www/html

# ✅ Config PHP-FPM (pool config)
COPY www.conf /etc/php/8.4/fpm/pool.d/www.conf

# ✅ Script de lancement
COPY toto.sh /usr/local/bin/toto.sh
RUN chmod +x /usr/local/bin/toto.sh

# ✅ Exposer le port utilisé par PHP-FPM pour FastCGI
EXPOSE 9000

# ✅ Entrypoint (ton script WordPress)
ENTRYPOINT ["/usr/local/bin/toto.sh"]

# ✅ CMD final : démarrer PHP-FPM en mode foreground (nécessaire pour Docker)
CMD ["php-fpm8.4", "-F"]