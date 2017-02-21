#!/usr/bin/env bash
#  ______   _________  ______   ______
# /_____/\ /________/\/_____/\ /_____/\
# \::::_\/_\__.::.__\/\::::_\/_\:::__\/
#  \:\/___/\  \::\ \   \:\/___/\\:\ \  __
#   \::___\/_  \::\ \   \::___\/_\:\ \/_/\
#    \:\____/\  \::\ \   \:\____/\\:\_\ \ \
#     \_____\/   \__\/    \_____\/ \_____\/
#
# Instalador de Linux Mint 17.3 (Rosa) 32-bit
# para computadores antigos do laboratório de
# informática da ETEC de Ubatuba, SP.
#
# Hardware:
# CPU Pentium 4, 1GB RAM, 40GB HD.
#
# Notas da versão: https://linuxmint.com/rel_rosa_mate.php
#
# Autores: Alejandro e Lucas.
#

echo '##########################################'
echo '############ Update & Upgrade ############'
echo '##########################################'

sudo apt-get update
sudo apt-get upgrade -y

echo '################################'
echo '############ Codecs ############'
echo '################################'

sudo apt-get install ubuntu-restricted-extras build-essential -y

echo '####################################'
echo '############ Java 8 SDK ############'
echo '####################################'

sudo apt-add-repository ppa:openjdk-r/ppa -y
sudo apt-get update
sudo apt-get install openjdk-8-jdk -y

echo 'Por favor, selecione a versão 8 do Java SDK:'
sudo update-alternatives --config java
sudo update-alternatives --config javac

echo '######################################'
echo '############ Netbeans 8.1 ############'
echo '######################################'

sudo add-apt-repository ppa:vajdics/netbeans-installer -y
sudo apt-get update
sudo apt-get install netbeans-installer -y

echo '########################################'
echo '############ Sublime Text 3 ############'
echo '########################################'

sudo add-apt-repository ppa:webupd8team/sublime-text-3 -y
sudo apt-get update
sudo apt-get install sublime-text -y

echo '######################################'
echo '############ Install Apps ############'
echo '######################################'

sudo apt-get install inkscape dia meld mysql-workbench pyrenamer -y

echo '################################'
echo '############ Apache ############'
echo '################################'

sudo apt-get install apache2 -y
sudo chown -R $USER.www-data /var/www/html
sudo chmod -R 775 /var/www/html
ln -s /var/www/html ~

echo '#############################'
echo '############ PHP ############'
echo '#############################'

sudo apt-get install php5 libapache2-mod-php5 -y
echo '<?php phpinfo(); ?>' > ~/html/testphp.php

echo '###############################'
echo '############ MySQL ############'
echo '###############################'

sudo apt-get install mysql-server -y
sudo apt-get install libapache2-mod-auth-mysql php5-mysql phpmyadmin -y
sudo sed -i 's/;extension=mysql.so/extension=mysql.so/' /etc/php5/apache2/php.ini
sudo /etc/init.d/apache2 restart

echo '####################################'
echo '############ phpMyAdmin ############'
echo '####################################'

sudo sed -i -E '/^\s*(\/){2}\s*.*AllowNoPassword/s/^\s*(\/){2}\s*//' /etc/phpmyadmin/config.inc.php
sudo echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf
sudo /etc/init.d/apache2 restart

echo '#######################################'
echo '############ Conta "aluno" ############'
echo '#######################################'

echo 'Criando conta aluno...'
echo 'password: "aluno". Ignorar as outras opções.'
sudo adduser aluno
sudo adduser aluno www-data
sudo ln -s /var/www/html /home/aluno
sudo inxi -F | tee ~/hardinfo.txt

# Testes

echo '####################################'
echo '############ CHECKLIST #############'
echo '####################################'

echo '* Verifique as seguintes PPAs (não duplicadas):'
echo '   - ppa:openjdk-r/ppa'
echo '   - ppa:vajdics/netbeans-installer'
echo '   - ppa:webupd8team/sublime-text-3'
read -p 'Enter para continuar: '
sudo inxi -r | grep openjdk-r
sudo inxi -r | grep netbeans-installer
sudo inxi -r | grep webupd8team
read -p 'Enter para continuar: '

echo '* Verifique a versão do Java:'
java -version
javac -version
read -p 'Enter para continuar: '

echo '* Verifique se os seguentes softwares foram instalado e os mesmos'
echo 'estão funcionando corretamente:'
echo '   - Netbeans 8.1 (Plugins PHP e HTML)'
echo '   - Workbench'
echo '   - Inkscape'
echo '   - Gimp'
echo '   - Sublime-Text 3'
echo '   - Meld'
echo '   - PyRenamer'
echo '   - Dia'
read -p 'Enter para continuar: '

echo '* Verifique se a conta "aluno" foi criada corretamente:'
echo '/etc/passwd:'
cat /etc/passwd | grep aluno
echo 'groups:'
groups aluno
echo 'link simbólico html (Apache):'
ls -l ~/html
echo 'permissões:'
ls -ld /var/www/html
read -p 'Enter para continuar: '

echo '* Verifique se o servidor Apache está funcionando corretamente:'
firefox http://localhost/ &
read -p 'Enter para continuar: '

echo '* Verifique se o PHP está funcionando corretamente:'
firefox http://localhost/testphp.php &
read -p 'Enter para continuar: '
sudo rm ~/html/testphp.php

echo '* Verifique se o MySQL está funcionando corretamente ("exit" para sair):'
# mysql> SET PASSWORD FOR 'root'@'localhost' = PASSWORD('yourpassword');
mysql -u root
read -p 'Enter para continuar: '

echo '* Verifique o phpMyAdmin:'
firefox http://localhost/phpmyadmin &
read -p 'Enter para continuar: '

echo '* Verifique os arquivos de configuração:'
echo '/etc/phpmyadmin/config.inc.php'
cat /etc/phpmyadmin/config.inc.php | grep 'AllowNoPassword'
echo '/etc/apache2/apache2.conf'
cat /etc/apache2/apache2.conf | grep 'Include /etc/phpmyadmin/apache.conf'
echo '/etc/php5/apache2/php.ini'
cat /etc/php5/apache2/php.ini | grep 'extension=mysql.so/extension=mysql.so'
read -p 'Enter para continuar: '

echo '* Verifique se o Google é o search engine pro Firefox'
echo 'nas contas "etec" e "aluno"'
read -p 'Enter para continuar: '
