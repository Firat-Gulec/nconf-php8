FROM php:8.3-apache

RUN apt-get update \
    && apt-get install -y --no-install-recommends libldap2-dev perl libdbi-perl libdbd-mysql-perl nagios4-core \
    && docker-php-ext-configure ldap \
    && docker-php-ext-install mysqli ldap \
    && rm -rf /var/lib/apt/lists/*

# NConf needs short_open_tag; errors are shown to ease PHP 8 compatibility testing
RUN { echo "short_open_tag=On"; echo "display_errors=On"; echo "error_reporting=E_ALL"; } \
    > /usr/local/etc/php/conf.d/nconf.ini

COPY . /var/www/html/
COPY docker/entrypoint.sh /usr/local/bin/nconf-entrypoint.sh
# Windows checkouts (core.autocrlf) turn scripts into CRLF, which breaks the shebang lines
RUN find /var/www/html/bin /var/www/html/ADD-ONS -type f \( -name '*.pl' -o -name '*.pm' -o -name '*.sh' \) -exec sed -i 's/\r$//' {} + \
    && sed -i 's/\r$//' /usr/local/bin/nconf-entrypoint.sh \
    && chmod +x /usr/local/bin/nconf-entrypoint.sh /var/www/html/bin/*.pl

ENTRYPOINT ["nconf-entrypoint.sh"]
CMD ["apache2-foreground"]
