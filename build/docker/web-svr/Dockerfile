FROM richarvey/nginx-php-fpm
COPY files/nginx.conf /etc/nginx/nginx.conf
COPY files/index.html /usr/share/nginx/html/index.html
COPY files/my-nginx.php /usr/share/nginx/html/my-nginx.php
RUN chmod 777 /usr/share/nginx/html/*.html
EXPOSE 80
