FROM ubuntu:20.04

WORKDIR /

COPY . .

RUN mv ondrej-ubuntu-php-focal.list /etc/apt/sources.list.d/ \
    && apt update \
    && apt install tzdata cron wget unzip php8.3 nginx php8.3-fpm php8.3-curl php8.3-dom php8.3-gd php8.3-mbstring php8.3-zip php8.3-pgsql php8.3-sqlite3 php8.3-mysql -y \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    && rm /etc/nginx/sites-available/default \
    && mv default /etc/nginx/sites-available \
    && cd /var/www \
    && wget https://download.nextcloud.com/server/releases/latest.zip \
    && unzip latest.zip \
    && rm latest.zip \
    && chmod -R 777 /var/www/nextcloud/ \
    && (crontab -u www-data -l;echo "*/5  *  *  *  * php -f /var/www/nextcloud/cron.php") | crontab -u www-data

EXPOSE 80

CMD service php8.3-fpm start && service nginx start && service cron start

