#!/bin/bash

set -e

wget "http://www.adminer.org/latest.php" -O /var/www/html/adminer.php

mkdir -p /run/php

php-fpm7.4 -F