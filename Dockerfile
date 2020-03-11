FROM centos:7
MAINTAINER Ashok ashmail4me@gmail.com
RUN yum update -y
RUN rpm -Uvh http://vault.centos.org/7.0.1406/extras/x86_64/Packages/epel-release-7-5.noarch.rpm
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN yum --enablerepo=remi,remi-php56 install -y httpd libevent libevent-devel php php-common php-opcache php-cli php-pear php-pdo php-mysql php-mysqlnd php-pgsql php-sqlite php-gd php-mbstring php-mcrypt php-xml php-simplexml php-curl php-zip php-pecl-memcache docker-php-ext-install epel-release mod_ssl mysql urw-fonts
RUN yum update curl.x86_64 -y
RUN pear install http_request2
COPY Index.html /var/www/html
WORKDIR /var/www/html
RUN chown -R apache:apache /var/www/html
RUN sed -i -e 's/;opcache.validate_timestamps=1/opcache.validate_timestamps=0/' \
     -e 's/;opcache.fast_shutdown=0/opcache.fast_shutdown=1/' \
         /etc/php.d/10-opcache.ini
RUN sed -i '1 a\    weekly' /etc/logrotate.d/httpd
EXPOSE 80 443
CMD ["-D", "FOREGROUND"]
ENTRYPOINT ["/usr/sbin/httpd"]
