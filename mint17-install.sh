#!/usr/bin/env bash

echo '### Update & Upgrade ###'
sudo apt-get update
sudo apt-get upgrade -y

echo '### Codecs ###'
sudo apt-get install ubuntu-restricted-extras build-essentials -y

echo '### Java 8 SDK ###'
sudo apt-get install openjdk-8-jdk -y
sudo update-alternatives --config java
sudo update-alternatives --config javac
java -version
javac -version

echo '### Netbeans 8.1 ###'
sudo add-apt-repository ppa:vajdics/netbeans-installer -y
sudo apt-get update
sudo apt-get install netbeans

echo '### Sublime Text 3 ###'
sudo add-apt-repository ppa:webupd8team/sublime-text-3
sudo apt-get update
sudo apt-get install sublime-text -y

echo '### Install Apps ###'
sudo apt-get install inkscape dia meld mysql-workbench

echo '### Install LAMP ###'

echo '### Apache ###'
sudo apt-get install apache2 -y
sudo chown -R $USER.www-data html
sudo chmod -R 775 html
ln -s /var/www/html ~

echo '### PHP ###'
sudo apt-get install php5 libapache2-mod-php5 -y
cat '<?php phpinfo(); ?>' > ~/html/testphp.php
firefox http://localhost/testphp.php

echo '### MySQL ###'
sudo apt-get install mysql-server -y
# mysql -u root
# mysql> SET PASSWORD FOR 'root'@'localhost' = PASSWORD('yourpassword');
sudo apt-get install libapache2-mod-auth-mysql php5-mysql phpmyadmin -y

sudo sed -ie 's/;extension=mysql.so/extension=mysql.so/' /etc/php5/apache2/php.ini
sudo /etc/init.d/apache2 restart
sudo cat 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf
sudo /etc/init.d/apache2 restart
firefox http://localhost/phpmyadmin
