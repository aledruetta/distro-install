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
readonly SCRIPT='\033[1;34m%s\n\033[0m'

# Detectar Sistema Operacional

printf "$SCRIPT" "[Script] Sistema Operacional detectado: $DESCRIPTION ($ARQ_PROC-bit)"

if [ $DISTRIBUTOR != "LinuxMint" ] || [ $CODENAME != "rosa" ] || \
	[ $ARQ_PROC -ne 32 ]
then
	printf "$SCRIPT" "[Script] Esse script foi escrito para Linux Mint 17.3 Rosa (32-bit)"
	printf "$SCRIPT" "[Script] O sistema é incompatível!"
	exit 1
fi
printf "$SCRIPT\n" "[Script] OK..."

# Superusuário

printf "$SCRIPT" "[Script] Superusuário?"

if [ `id -u` -ne 0 ]; then
	printf "$SCRIPT" "[Script] El script debe ser executado como superusuário (sudo)!"
	exit 1
fi
printf "$SCRIPT\n" "[Script] OK..."

# Atualizar pacotes

printf "$SCRIPT" "[Script] Atualizando repositórios da distribuição..."
apt-get update
printf "$SCRIPT\n" "[Script] OK..."

printf "$SCRIPT" "[Script] Atualizando os pacotes..."
apt-get upgrade -y
printf "$SCRIPT\n" "[Script] OK..."

# Codecs e ferramentas de compilador

printf "$SCRIPT" "[Script] Instalando codecs e ferramentas de compilador..."
apt-get install ubuntu-restricted-extras build-essential -y
printf "$SCRIPT\n" "[Script] OK..."

# PPA's

if [ ! -s "$JDK_PPA_F" ]; then		# Java
	printf "$SCRIPT" "[Script] Adicionando repositório de terceiros..."
	apt-add-repository $JDK_PPA -y
	printf "$SCRIPT\n" "[Script] OK..."
else
	printf "$SCRIPT" "[Script] $JDK_PPA já existe"
	printf "$SCRIPT\n" "[Script] OK..."
fi

if [ ! -s "$NETB_PPA_F" ]; then		# Netbeans
	printf "$SCRIPT" "[Script] Adicionando repositório de terceiros..."
	# add-apt-repository $NETB_PPA -y
	printf "$SCRIPT\n" "[Script] OK..."
else
	printf "$SCRIPT" "[Script] $NETB_PPA já existe"
	printf "$SCRIPT\n" "[Script] OK..."
fi

if [ ! -s "$SUB3_PPA_F" ]; then		# Sublime-Text
	printf "$SCRIPT" "[Script] Adicionando repositório de terceiros..."
	add-apt-repository $SUB3_PPA -y
	printf "$SCRIPT\n" "[Script] OK..."
else
	printf "$SCRIPT" "[Script] $SUB3_PPA já existe"
	printf "$SCRIPT\n" "[Script] OK..."
fi

printf "$SCRIPT" "[Script] Atualizando caché do repositório..."
apt-get update
printf "$SCRIPT\n" "[Script] OK..."

# Java OpenJDK 8

printf "$SCRIPT" "[Script] Instalando Java OpenJDK 8..."
apt-get install openjdk-8-jdk -y
printf "$SCRIPT\n" "[Script] OK..."

printf "$SCRIPT" "[Script] Selecionando a versão 8 do OpenJDK..."
printf "2" | update-alternatives --config java
printf "$SCRIPT\n" "[Script] OK..."

printf "$SCRIPT" "[Script] Verificando versão OpenJDK..."
java -version
javac -version
printf "$SCRIPT\n" "[Script] OK..."

# Netbeans IDE 8.1

printf "$SCRIPT" "[Script] Instalando Netbeans 8.1 IDE..."
# apt-get install netbeans-installer -y
printf "$SCRIPT\n" "[Script] OK..."

# Sublime Text

printf "$SCRIPT" "[Script] Instalando Sublime Text 3..."
apt-get install sublime-text -y
printf "$SCRIPT\n" "[Script] OK..."

# Aplicativos

printf "$SCRIPT" "[Script] Instalando Aplicativos:"
printf "$SCRIPT" "[Script] - git (Controle de versões)"
apt-get install git -y
printf "$SCRIPT" "[Script] - vim (Editor de texto)"
apt-get install vim -y
printf "$SCRIPT" "[Script] - inkscape (Disenho vetorial)"
apt-get install inkscape -y
printf "$SCRIPT" "[Script] - dia (Diagramas)"
apt-get install dia -y
printf "$SCRIPT" "[Script] - meld (Comparador de arquivos)"
apt-get install meld -y
printf "$SCRIPT" "[Script] - mysql-workbench (Administração de DB)"
apt-get install mysql-workbench -y
printf "$SCRIPT" "[Script] - pyrenamer (Renomear arquivos em lote)"
apt-get install pyrenamer -y
printf "$SCRIPT\n" "[Script] OK..."

# LAMP - Apache

printf "$SCRIPT" "[Script] Instalando servidor Apache..."
apt-get install apache2 -y
printf "$SCRIPT\n" "[Script] OK..."

printf "$SCRIPT" "[Script] Mudando as permisões de /var/www/html..."
chown -R $USER.www-data /var/www/html
chmod -R 775 /var/www/html
printf "$SCRIPT\n" "[Script] OK..."

printf "$SCRIPT" "[Script] Criando link simbólico na home..."
ln -s /var/www/html /home/$USER
printf "$SCRIPT\n" "[Script] OK..."

# LAMP - PHP

printf "$SCRIPT" "[Script] Instalando linguagem de programação PHP..."
apt-get install php5 libapache2-mod-php5 -y
printf "$SCRIPT\n" "[Script] OK..."

# LAMP - MySQL

printf "$SCRIPT" "[Script] Instalando banco de dados MySQL..."
apt-get install mysql-server -y
apt-get install libapache2-mod-auth-mysql php5-mysql phpmyadmin -y
printf "$SCRIPT\n" "[Script] OK..."

printf "$SCRIPT" "[Script] Configurando PHP para trabalhar com MySQL..."

if [ ! -s "/etc/php5/apache2/php.ini.bak" ]; then
	# Backup
	cp /etc/php5/apache2/php.ini /etc/php5/apache2/php.ini.bak
fi

sed -i -E '/^;\s*extension=msql\.so/s/^;\s*//' /etc/php5/apache2/php.ini
printf "$SCRIPT\n" "[Script] OK..."

printf "$SCRIPT" "[Script] Reiniciando Apache..."
/etc/init.d/apache2 restart
printf "$SCRIPT\n" "[Script] OK..."

# LAMP - phpMyAdmin

printf "$SCRIPT" "[Script] Configurando phpMyAdmin para acessar sem senha..."

if [ ! -s "/etc/phpmyadmin/config.inc.php.bak" ]; then
	# Backup
	cp /etc/phpmyadmin/config.inc.php /etc/phpmyadmin/config.inc.php.bak
fi

sed -i -E '/^\s*(\/){2}\s.*AllowNoPassword/s/^(\/){2}\s//' /etc/phpmyadmin/config.inc.php
printf "$SCRIPT\n" "[Script] OK..."

printf "$SCRIPT" "[Script] Configurando Apache para acessar phpMyAdmin..."

if [ ! -s "/etc/apache2/apache2.conf.bak" ]; then
	# Backup
	cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak
fi
sudo printf "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf
printf "$SCRIPT\n" "[Script] OK..."

printf "$SCRIPT" "[Script] Reiniciando Apache..."
/etc/init.d/apache2 restart
printf "$SCRIPT\n" "[Script] OK..."

# Conta Aluno

printf "$SCRIPT" "[Script] Criando conta aluno (passwd: 'aluno'...)"
adduser aluno
adduser aluno www-data
printf "$SCRIPT\n" "[Script] OK..."

printf "$SCRIPT" "[Script] Criando link simbólico na home do aluno para /var/www/html..."
ln -s /var/www/html /home/aluno
printf "$SCRIPT\n" "[Script] OK..."

# Atalhos escritório

# Aplicativos dos quais serão criados atalhos
printf "$SCRIPT" "[Script] Criando atalhos pro escritório..."
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
printf "$SCRIPT\n" "[Script] OK..."

printf "$SCRIPT" "[Script] Mudando o proprietário e as permissões da área de trabalho do usuário"
sudo chown etec:etec /home/aluno/Área\ de\ Trabalho/
sudo chmod 1755 /home/aluno/Área\ de\ Trabalho/ /home/etec/Área\ de\ Trabalho/
printf "$SCRIPT\n" "[Script] OK..."

printf "$SCRIPT" "[Script] Copiando e configurando atalhos"
sudo cp ${apps[@]} /home/aluno/Área\ de\ Trabalho/
sudo cp ${apps[@]} /home/etec/Área\ de\ Trabalho/
sudo chown etec:etec /home/aluno/Área\ de\ Trabalho/*.desktop /home/etec/Área\ de\ Trabalho/*.desktop
sudo chmod 755 /home/aluno/Área\ de\ Trabalho/*.desktop /home/etec/Área\ de\ Trabalho/*.desktop
printf "$SCRIPT\n" "[Script] OK..."

printf "$SCRIPT" "[Script] Criando arquivo de texto na home com especificações do hardware..."
inxi -F > /home/$USER/hardinfo.txt
printf "$SCRIPT\n" "[Script] OK..."

# Testes

printf "Verifique as seguintes PPAs (não duplicadas):"
printf "============================================="
printf "   - ppa:openjdk-r/ppa"
printf "   - ppa:vajdics/netbeans-installer"
printf "   - ppa:webupd8team/sublime-text-3"
read -p 'Enter para continuar: '
inxi -r | grep openjdk-r
inxi -r | grep netbeans-installer
inxi -r | grep webupd8team
read -p 'Enter para continuar: '

printf "Verifique a versão do Java:"
printf "==========================="
java -version
javac -version
read -p 'Enter para continuar: '

printf "Verifique se os seguentes softwares foram instalado e os mesmos estão funcionando corretamente:"
printf "==============================================================================================="
printf "   - Workbench: "
mysql-workbench --version
printf "   - Inkscape: "
inkscape --version
printf "   - Gimp: "
gimp --version
printf "   - Sublime-Text 3: "
sublime-text --version
printf "   - Meld: "
meld --version
printf "   - PyRenamer: "
pyrenamer --version
printf "   - Dia: "
dia --version
printf "   - Vim: "
vim --version
printf "   - Git: "
git --version
printf "   - Netbeans (manual: versão, atualizações, plugins)"
netbeans --nosplash &

read -p 'Enter para continuar: '

printf "Verifique se a conta 'aluno' foi criada corretamente:"
printf "====================================================="
printf "/etc/passwd:"
id aluno
printf "link simbólico html (Apache):"
ls -l /home/aluno/html
printf "permissões:"
ls -ld /var/www/html
read -p 'Enter para continuar: '

printf "===================="
printf "Verifique:"
printf "- Apache"
printf "- PHP"
printf "- MySQL e phpMyAdmin"
printf "===================="
printf "<?php phpinfo(); ?>" > /home/$USER/html/testphp.php
firefox http://localhost/ http://localhost/testphp.php http://localhost/phpmyadmin 2>/dev/null &
read -p 'Enter para continuar: '
rm /home/$USER/html/testphp.php

printf "Verifique os arquivos de configuração:"
printf "======================================"
printf "/etc/phpmyadmin/config.inc.php"
cat -n /etc/phpmyadmin/config.inc.php | grep 'AllowNoPassword'
printf "/etc/apache2/apache2.conf"
cat -n /etc/apache2/apache2.conf | grep 'Include /etc/phpmyadmin/apache.conf'
printf "/etc/php5/apache2/php.ini"
cat -n /etc/php5/apache2/php.ini | grep 'extension=msql.so'
read -p 'Enter para continuar: '

printf "Verifique se o Google é o search engine pro Firefox nas contas 'etec' e 'aluno'"
printf "==============================================================================="
read -p 'Enter para continuar: '

printf "Verifique se o relatório de hardware foi criado na home:"
printf "========================================================"
cat /home/$USER/hardinfo.txt
read -p 'Enter para continuar: '
