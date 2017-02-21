#!/usr/bin/env bash
#  ______   _________  ______   ______
# /_____/\ /________/\/_____/\ /_____/\
# \::::_\/_\__.::.__\/\::::_\/_\:::__\/
#  \:\/___/\  \::\ \   \:\/___/\\:\ \  __
#   \::___\/_  \::\ \   \::___\/_\:\ \/_/\
#    \:\____/\  \::\ \   \:\____/\\:\_\ \ \
#     \_____\/   \__\/    \_____\/ \_____\/
#
# Instalador de Linux Mint 17.3 computadores antigos do laboratório de
# informática da ETEC de Ubatuba, SP.
#
# Hardware:
# CPU Pentium 4, 1GB RAM, 40GB HD.
#
# Autores: Alejandro e Lucas.
#

echo '##########################################'
echo '############ Update & Upgrade ############'
echo '##########################################'

echo 'Estamos atualizando o sistema. Isso vai demorar, paciência...'
sudo apt-get update
sudo apt-get upgrade -y

echo '################################'
echo '############ Codecs ############'
echo '################################'

echo 'Estamos instalando alguns codecs adicionais e as ferramentas de compilação...'
sudo apt-get install ubuntu-restricted-extras build-essential -y

echo '####################################'
echo '############ Java 8 SDK ############'
echo '####################################'

echo 'Atualizando o Java SDK pra versão 8 via PPA...'
sudo apt-add-repository ppa:openjdk-r/ppa -y
sudo apt-get update
sudo apt-get install openjdk-8-jdk -y
echo 'Por favor, selecione a versão 8 do Java SDK'
sudo update-alternatives --config java
sudo update-alternatives --config javac
echo 'Verifique se a versão é a correta:'
java -version
javac -version

echo '######################################'
echo '############ Netbeans 8.1 ############'
echo '######################################'

echo 'Atualizando o Netbeans pra versão 8.1 via PPA...'
sudo add-apt-repository ppa:vajdics/netbeans-installer -y
sudo apt-get update
sudo apt-get install netbeans-installer -y

echo '########################################'
echo '############ Sublime Text 3 ############'
echo '########################################'

echo 'Instalando o Sublime Text via PPA...'
sudo add-apt-repository ppa:webupd8team/sublime-text-3 -y
sudo apt-get update
sudo apt-get install sublime-text -y

echo '######################################'
echo '############ Install Apps ############'
echo '######################################'

echo 'Instalando Inkscape, Dia, Meld e Workbench...'
sudo apt-get install inkscape dia meld mysql-workbench pyrenamer -y

echo '######################################'
echo '############ Install LAMP ############'
echo '######################################'

echo 'Vamos começar a instalação e configuração do LAMP Stack...'

echo '################################'
echo '############ Apache ############'
echo '################################'

sudo apt-get install apache2 -y
sudo chown -R $USER.www-data /var/www/html
sudo chmod -R 775 /var/www/html
ln -s /var/www/html ~
echo 'Testando o acesso ao servidor Apache...'
firefox http://localhost/ &

echo '#############################'
echo '############ PHP ############'
echo '#############################'

sudo apt-get install php5 libapache2-mod-php5 -y
echo '<?php phpinfo(); ?>' > ~/html/testphp.php
echo 'Testando o PHP...'
firefox http://localhost/testphp.php &

echo '###############################'
echo '############ MySQL ############'
echo '###############################'

echo 'Senha usuário root: "root"'
sudo apt-get install mysql-server -y
sudo apt-get install libapache2-mod-auth-mysql php5-mysql phpmyadmin -y
sudo sed -i 's/;extension=mysql.so/extension=mysql.so/' /etc/php5/apache2/php.ini
sudo /etc/init.d/apache2 restart
echo 'Testando o MySQL. Para sair digite "exit"...'
mysql -u root
# mysql> SET PASSWORD FOR 'root'@'localhost' = PASSWORD('yourpassword');

echo '####################################'
echo '############ phpMyAdmin ############'
echo '####################################'

echo 'Acesse o phpMyAdmin como root e mude para acessar sem password'
sudo sed -i -E '/^\s*(\/){2}\s*.*AllowNoPassword/s/^\s*(\/){2}\s*//' /etc/phpmyadmin/config.inc.php
sudo echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf
sudo /etc/init.d/apache2 restart
echo 'Testando o phpMyAdmin e acesso aos bancos de dados...'
firefox http://localhost/phpmyadmin &

echo 'Deletando o arquivo de teste testphp.php...'
sudo rm ~/html/testphp.php

echo '#######################################'
echo '############ Conta "aluno" ############'
echo '#######################################'

echo 'Criando conta aluno...'
echo 'password: "aluno". Ignorar as outras opções.'
sudo adduser aluno
echo 'Adicionando o usuário aluno ao grupo www-data...'
sudo adduser aluno www-data
groups aluno
echo 'Criando link simbólico na home -> /var/www/html...'
sudo ln -s /var/www/html /home/aluno
echo 'Salvando informação de hardware na home...'
sudo inxi -F > ~/hardinfo.txt

echo '####################################'
echo '############ CHECKLIST #############'
echo '####################################'
echo ''
echo '- Versão do Java'
echo '- Versão e funcionamento do Netbeans. Plugins HTML e PHP.'
echo '- Verificar Inkscape, Meld, Sublime, Dia, PyRenamer, Workbench'
echo '- cat /etc/phpmyadmin/config.inc.php'
echo '- cat /etc/apache2/apache2.conf'
echo '- cat /etc/php5/apache2/php.ini'
echo '- Conta Aluno e link simbólico'
echo '- Google search engine (Firefox)'
