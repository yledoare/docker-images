#!/bin/bash
# Script used by the Dockerfile.

usermod -u ${HOST_USER_ID} www-data
groupmod -g ${HOST_USER_ID} www-data

chgrp -hR www-data /var/www/html
chmod g+rwx /var/www/html/conf

echo "[docker-run] => update ${PHP_INI_DIR}/conf.d/php.ini"
cat <<EOF > ${PHP_INI_DIR}/conf.d/php.ini
date.timezone = ${PHP_INI_DATE_TIMEZONE:-UTC}
memory_limit = ${PHP_INI_MEMORY_LIMIT:-256M}
error_reporting = E_ERROR & ~E_DEPRECATED & ~E_STRICT
display_errors = On
display_startup_errors = Off
log_errors = Off
log_errors_max_len = 1024
ignore_repeated_errors = Off
track_errors = Off
html_errors = On
mssql.min_error_severity = 10
EOF

exec apache2-foreground
