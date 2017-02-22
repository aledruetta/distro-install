#!/usr/bin/env bash
#  ______   _________  ______   ______
# /_____/\ /________/\/_____/\ /_____/\
# \::::_\/_\__.::.__\/\::::_\/_\:::__\/
#  \:\/___/\  \::\ \   \:\/___/\\:\ \  __
#   \::___\/_  \::\ \   \::___\/_\:\ \/_/\
#    \:\____/\  \::\ \   \:\____/\\:\_\ \ \
#     \_____\/   \__\/    \_____\/ \_____\/
#
# Instalador de Linux Mint 17.3 (Rosa)
# para computadores antigos do laboratório de
# informática da ETEC de Ubatuba, SP.
#
# Hardware:
# CPU Pentium 4, 1GB RAM, 40GB HD.
# Dual Boot Windows XP
#
# Distro:
# Linux Mint 17.3 (Rosa), escritório Mate, 32-bit
# Download: https://www.linuxmint.com/edition.php?id=205
# Notas da versão: https://linuxmint.com/rel_rosa_mate.php
#
# Autores: Alejandro e Lucas.
#


# Constantes
readonly DESCRIPTION="`lsb_release -ds`"
readonly CODENAME=`lsb_release -cs`
readonly DISTRIBUTOR=`lsb_release -is`
readonly ARQ_PROC=`getconf LONG_BIT`
readonly JDK_PPA_F="/etc/apt/sources.list.d/openjdk-r-ppa-trusty.list"
readonly JDK_PPA="ppa:openjdk-r/ppa"
readonly NETB_PPA_F="/etc/apt/sources.list.d/vajdics-netbeans-installer-trusty.list"
readonly NETB_PPA="ppa:vajdics/netbeans-installer"
readonly SUB3_PPA_F="/etc/apt/sources.list.d/webupd8team-sublime-text-3-trusty.list"
readonly SUB3_PPA="ppa:webupd8team/sublime-text-3"

# Detectar Sistema Operacional

echo "[Script] Sistema Operacional detectado: $DESCRIPTION ($ARQ_PROC-bit)"

if [ $DISTRIBUTOR != "LinuxMint" ] || [ $CODENAME != "rosa" ] || \
	[ $ARQ_PROC -ne 32 ]
then
	echo "[Script] Esse script foi escrito para Linux Mint 17.3 Rosa (32-bit)"
	echo "[Script] O sistema é incompatível!"
	exit 1
fi
printf "[Script] OK...\n\n"

# Superusuário

echo "[Script] Superusuário?"

if [ `id -u` -ne 0 ]; then
	echo "[Script] El script debe ser executado como superusuário (sudo)!"
	exit 1
fi
printf "[Script] OK...\n\n"

# Atualizar pacotes

echo "[Script] Atualizando repositórios da distribuição..."
 apt-get update
printf "[Script] OK...\n\n"

echo "[Script] Atualizando os pacotes..."
apt-get upgrade -y
printf "[Script] OK...\n\n"

# Codecs e ferramentas de compilador

echo "[Script] Instalando codecs e ferramentas de compilador..."
apt-get install ubuntu-restricted-extras build-essential -y
printf "[Script] OK...\n\n"

# Java OpenJDK 8

if [ ! -s "$JDK_PPA_F" ]; then
	echo "[Script] Adicionando repositório de terceiros..."
	apt-add-repository $JDK_PPA -y
	printf "[Script] OK...\n\n"

	echo "[Script] Atualizando caché do repositório..."
	apt-get update
	printf "[Script] OK...\n\n"
else
	echo "[Script] $JDK_PPA já existe"
	printf "[Script] OK...\n\n"
fi

echo "[Script] Instalando Java OpenJDK 8..."
apt-get install openjdk-8-jdk -y
printf "[Script] OK...\n\n"

echo "[Script] Selecionando a versão 8 do OpenJDK..."
echo "2" | update-alternatives --config java
printf "[Script] OK...\n\n"

echo "[Script] Verificando versão OpenJDK..."
java -version
javac -version
printf "[Script] OK...\n\n"

# Netbeans IDE 8.1

if [ ! -s "$NETB_PPA_F" ]; then
	echo "[Script] Adicionando repositório de terceiros..."
	add-apt-repository $NETB_PPA -y
	printf "[Script] OK...\n\n"

	echo "[Script] Atualizando caché do repositório..."
	apt-get update
	printf "[Script] OK...\n\n"
else
	echo "[Script] $NETB_PPA já existe"
	printf "[Script] OK...\n\n"
fi

echo "[Script] Instalando Netbeans 8.1 IDE..."
apt-get install netbeans-installer -y
printf "[Script] OK...\n\n"

# Sublime Text

if [ ! -s "$SUB3_PPA_F" ]; then
	echo "[Script] Adicionando repositório de terceiros..."
	add-apt-repository $SUB3_PPA -y
	printf "[Script] OK...\n\n"

	echo "[Script] Atualizando caché do repositório..."
	apt-get update
	printf "[Script] OK...\n\n"
else
	echo "[Script] $SUB3_PPA já existe"
	printf "[Script] OK...\n\n"
fi

echo "[Script] Instalando Sublime Text 3..."
apt-get install sublime-text -y
printf "[Script] OK...\n\n"

# Aplicativos

echo "[Script] Instalando Aplicativos:"
echo "[Script] - git (Controle de versões)"
apt-get install git -y
echo "[Script] - vim (Editor de texto)"
apt-get install vim -y
echo "[Script] - inkscape (Disenho vetorial)"
apt-get install inkscape -y
echo "[Script] - dia (Diagramas)"
apt-get install dia -y
echo "[Script] - meld (Comparador de arquivos)"
apt-get install meld -y
echo "[Script] - mysql-workbench (Administração de DB)"
apt-get install mysql-workbench -y
echo "[Script] - pyrenamer (Renomear arquivos em lote)"
apt-get install pyrenamer -y
printf "[Script] OK...\n\n"

# LAMP - Apache

echo "[Script] Instalando servidor Apache..."
apt-get install apache2 -y
printf "[Script] OK...\n\n"

echo "[Script] Mudando as permisões de /var/www/html..."
chown -R $USER.www-data /var/www/html
chmod -R 775 /var/www/html
printf "[Script] OK...\n\n"

echo "[Script] Criando link simbólico na home..."
ln -s /var/www/html /home/$USER
printf "[Script] OK...\n\n"

# LAMP - PHP

echo "[Script] Instalando linguagem de programação PHP..."
apt-get install php5 libapache2-mod-php5 -y
printf "[Script] OK...\n\n"

# LAMP - MySQL

echo "[Script] Instalando banco de dados MySQL..."
apt-get install mysql-server -y
apt-get install libapache2-mod-auth-mysql php5-mysql phpmyadmin -y
printf "[Script] OK...\n\n"

echo "[Script] Configurando PHP para trabalhar com MySQL..."

if [ ! -s "/etc/php5/apache2/php.ini.bak" ]; then
	# Backup
	cp /etc/php5/apache2/php.ini /etc/php5/apache2/php.ini.bak
fi

sed -i '/;\s*extension=mysql\.so/s/;\s*//' /etc/php5/apache2/php.ini
printf "[Script] OK...\n\n"

echo "[Script] Reiniciando Apache..."
/etc/init.d/apache2 restart
printf "[Script] OK...\n\n"

# LAMP - phpMyAdmin

echo "[Script] Configurando phpMyAdmin para acessar sem senha..."

if [ ! -s "/etc/phpmyadmin/config.inc.php.bak" ]; then
	# Backup
	cp /etc/phpmyadmin/config.inc.php /etc/phpmyadmin/config.inc.php.bak
fi

sed -i -E '/^\s*(\/){2}\s*.*AllowNoPassword/s/^\s*(\/){2}\s*//' /etc/phpmyadmin/config.inc.php
printf "[Script] OK...\n\n"

echo "[Script] Configurando Apache para acessar phpMyAdmin..."

if [ ! -s "/etc/apache2/apache2.conf.bak" ]; then
	# Backup
	cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak
fi
sudo echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf
printf "[Script] OK...\n\n"

echo "[Script] Reiniciando Apache..."
/etc/init.d/apache2 restart
printf "[Script] OK...\n\n"

# Conta Aluno

echo "[Script] Criando conta aluno (passwd: 'aluno'...)"
adduser aluno
adduser aluno www-data
printf "[Script] OK...\n\n"

echo "[Script] Criando link simbólico na home do aluno para /var/www/html..."
ln -s /var/www/html /home/aluno
printf "[Script] OK...\n\n"

# Atalhos escritório

# Aplicativos dos quais serão criados atalhos
echo "[Script] Criando atalhos pro escritório..."
apps=('/usr/share/applications/gcalctool.desktop'
'/usr/share/applications/libreoffice-writer.desktop'
'/usr/share/applications/libreoffice-calc.desktop'
'/usr/share/applications/gimp.desktop'
'/usr/share/applications/inkscape.desktop'
'/usr/share/applications/dia.desktop'
'/usr/share/applications/meld.desktop'
'/usr/share/applications/pyrenamer.desktop'
'/usr/share/applications/vlc.desktop'
'/usr/share/applications/sublime_text.desktop'
'/usr/share/applications/netbeans.desktop'
'/usr/share/applications/mysql-workbench.desktop')
printf "[Script] OK...\n\n"

echo "[Script] Mudando o proprietário e as permissões da área de trabalho do usuário"
sudo chown etec:etec /home/aluno/Área\ de\ Trabalho/
sudo chmod 1755 /home/aluno/Área\ de\ Trabalho/ /home/etec/Área\ de\ Trabalho/
printf "[Script] OK...\n\n"

echo "[Script] Copiando e configurando atalhos"
sudo cp ${apps[@]} /home/aluno/Área\ de\ Trabalho/
sudo cp ${apps[@]} /home/etec/Área\ de\ Trabalho/
sudo chown etec:etec /home/aluno/Área\ de\ Trabalho/*.desktop /home/etec/Área\ de\ Trabalho/*.desktop
sudo chmod 755 /home/aluno/Área\ de\ Trabalho/*.desktop /home/etec/Área\ de\ Trabalho/*.desktop
printf "[Script] OK...\n\n"

echo "[Script] Criando arquivo de texto na home com especificações do hardware..."
inxi -F > /home/$USER/hardinfo.txt
printf "[Script] OK...\n\n"

# Testes

echo 'Verifique as seguintes PPAs (não duplicadas):'
echo '============================================='
echo '   - ppa:openjdk-r/ppa'
echo '   - ppa:vajdics/netbeans-installer'
echo '   - ppa:webupd8team/sublime-text-3'
read -p 'Enter para continuar: '
inxi -r | grep openjdk-r
inxi -r | grep netbeans-installer
inxi -r | grep webupd8team
read -p 'Enter para continuar: '

echo 'Verifique a versão do Java:'
echo '==========================='
java -version
javac -version
read -p 'Enter para continuar: '

echo 'Verifique se os seguentes softwares foram instalado e os mesmos estão funcionando corretamente:'
echo '==============================================================================================='
printf '   - Workbench: '
mysql-workbench --version
printf '   - Inkscape: '
inkscape --version
printf '   - Gimp: '
gimp --version
printf '   - Sublime-Text 3: '
sublime-text --version
printf '   - Meld: '
meld --version
printf '   - PyRenamer: '
pyrenamer --version
printf '   - Dia: '
dia --version
printf '   - Vim: '
vim --version
printf '   - Git: '
git --version
echo '   - Netbeans (manual: versão, atualizações, plugins)'
netbeans --nosplash &

read -p 'Enter para continuar: '

echo 'Verifique se a conta "aluno" foi criada corretamente:'
echo '====================================================='
echo '/etc/passwd:'
cat /etc/passwd | grep aluno
echo 'groups:'
groups aluno
echo 'link simbólico html (Apache):'
ls -l /home/aluno/html
echo 'permissões:'
ls -ld /var/www/html
read -p 'Enter para continuar: '

echo '===================='
echo 'Verifique:'
echo '- Apache'
echo '- PHP'
echo '- MySQL e phpMyAdmin'
echo '===================='
echo '<?php phpinfo(); ?>' > /home/$USER/html/testphp.php
firefox http://localhost/ http://localhost/testphp.php http://localhost/phpmyadmin 2>/dev/null &
read -p 'Enter para continuar: '
rm /home/$USER/html/testphp.php

echo 'Verifique os arquivos de configuração:'
echo '======================================'
echo '/etc/phpmyadmin/config.inc.php'
cat /etc/phpmyadmin/config.inc.php | grep 'AllowNoPassword'
echo '/etc/apache2/apache2.conf'
cat /etc/apache2/apache2.conf | grep 'Include /etc/phpmyadmin/apache.conf'
echo '/etc/php5/apache2/php.ini'
cat /etc/php5/apache2/php.ini | grep 'extension=mysql.so/extension=mysql.so'
read -p 'Enter para continuar: '

echo 'Verifique se o Google é o search engine pro Firefox nas contas "etec" e "aluno"'
echo '==============================================================================='
read -p 'Enter para continuar: '

echo 'Verifique se o relatório de hardware foi criado na home:'
echo '========================================================'
cat /home/$USER/hardinfo.txt
read -p 'Enter para continuar: '
