#!/usr/bin/env bash

set -eux

cd /var/www/html

find . -type d -exec sudo chmod 775 {} \;
find . -type f -exec sudo chmod 664 {} \;
sudo chgrp -R www-data *
sudo setfacl -R -d -m u::rwX,g:www-data:rwX *
sudo chmod -R g+s *
