FROM ubuntu:latest

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libpng-dev \
    zlib1g-dev \
    libzip-dev \
    zip \
    unzip \
    nginx \
    supervisor \
    cron \
    && mkdir -p /etc/apt/keyrings \
    && apt-get install -y gnupg gosu curl && curl -sS 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x14aa40ec0831756756d7f66c4f4ea0aae5267a6c' | gpg --dearmor | tee /etc/apt/keyrings/ppa_ondrej_php.gpg > /dev/null \
    && echo "deb [signed-by=/etc/apt/keyrings/ppa_ondrej_php.gpg] https://ppa.launchpadcontent.net/ondrej/php/ubuntu jammy main" > /etc/apt/sources.list.d/ppa_ondrej_php.list \
    && apt-get update && apt-get install -y php8.2-cli php8.2-fpm php8.2-mysql php8.2-gd php8.2-zip
RUN mkdir -p /var/run/php/
RUN apt-get install -y php8.2-mbstring php8.2-xml php8.2-curl
RUN mkdir -p /run/php && \
    chown www-data:www-data /run/php && \
    mkdir -p /etc/php/8.2/fpm/pool.d && \
    mkdir -p /var/log/php


COPY conf/fpm-pool.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY conf/php.ini /etc/php/8.2/fpm/php.ini
COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/lib/php/sessions && chown www-data:www-data /var/lib/php/sessions

COPY --chown=www-data:www-data ./src /var/www/html
RUN chmod 775 /var/www/html
RUN chmod 775 /var/www/html/*

ADD conf/crontab /crontab
RUN /usr/bin/crontab /crontab

COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80/tcp

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]