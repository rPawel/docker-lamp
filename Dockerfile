# runnable base
FROM rpawel/ubuntu:trusty

RUN apt-get -q -y update \
 && apt-get dist-upgrade -y --no-install-recommends \
# Packages
 && DEBIAN_FRONTEND=noninteractive apt-get install -y -q apache2-mpm-worker libapache2-mod-fastcgi \
  php5-fpm php5 php5-cli php5-dev php-pear php5-common php5-apcu \
  php5-mcrypt php5-gd php5-mysql php5-curl php5-json php5-intl \
  php5-memcached \
  imagemagick graphicsmagick graphicsmagick-libmagick-dev-compat php5-imagick trimage \
  exim4 git subversion \
# Config
 && a2enmod actions fastcgi alias headers deflate rewrite \
 && a2dismod autoindex \
 && a2disconf other-vhosts-access-log \
 && rm -rf /etc/php5/fpm/pool.d/* \
 && pecl install memcache \
 && /usr/sbin/php5enmod memcache \
 && useradd -d /var/www/app --no-create-home --shell /bin/bash -g www-data -G adm user \
 && mkdir -p /var/log/app; chmod 775 /var/log/app/; chown user:www-data /var/log/app/ \
 && mkdir -p /var/log/php5; chmod 775 /var/log/php5; chown www-data:www-data /var/log/php5/ \
 && mkdir -p /var/log/supervisor

ADD ./config /etc/

RUN update-exim4.conf \
 && chown www-data: -R /var/lib/apache2/fastcgi \
 && DEBIAN_FRONTEND=newt

