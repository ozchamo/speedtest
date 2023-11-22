FROM php:7.4-apache

# Install extensions
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libpq-dev \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql pdo_pgsql pgsql

# Prepare files and folders

# Copy sources

COPY backend/ /var/www/html/backend

COPY results/*.php /var/www/html/results/
COPY results/*.ttf /var/www/html/results/

COPY *.js /var/www/html/
COPY favicon.ico /var/www/html/

COPY docker/servers.json /servers.json

COPY docker/*.php /var/www/html/

RUN chown -R www-data:www-data /var/www/html
RUN chown -R www-data:www-data /etc/apache2

# Prepare environment variable defaults

ENV TITLE=LibreSpeed
ENV MODE=standalone
ENV PASSWORD=password
ENV TELEMETRY=false
ENV ENABLE_ID_OBFUSCATION=false
ENV REDACT_IP_ADDRESSES=false
ENV WEBPORT=8080

# Final touches
USER www-data
ENTRYPOINT ["/entrypoint.sh"]
