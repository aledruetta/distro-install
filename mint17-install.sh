#!/usr/bin/env bash


# /_____/\ /________/\/_____/\ /_____/\
# \::::_\/_\__.::.__\/\::::_\/_\:::__\/
#  \:\/___/\  \::\ \   \:\/___/\\:\ \  __
#   \::___\/_  \::\ \   \::___\/_\:\ \/_/\
#    \:\____/\  \::\ \   \:\____/\\:\_\ \ \
#     \_____\/   \__\/    \_____\/ \_____\/
#
# mint17-install
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
# Autores: Alejandro Druetta e Lucas Xavier Leite.
#
# mint17-install is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# mint17-install is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with mint17-install. If not, see <http://www.gnu.org/licenses/>.


# set -e --> stop script if error
# set -u --> don't evaluate unset variables
# set -x --> for debugging
set -eux

# Constantes
readonly DESCRIPTION="$(lsb_release -ds)"
readonly CODENAME="$(lsb_release -cs)"
readonly DISTRIBUTOR="$(lsb_release -is)"
readonly ARQ_PROC=$(getconf LONG_BIT)
readonly DESK_ENV="$(env | grep DESKTOP_SESSION= | cut -d'=' -f2)"

readonly JDK_PPA_F="/etc/apt/sources.list.d/openjdk-r-ppa-trusty.list"
readonly JDK_PPA="ppa:openjdk-r/ppa"
readonly NETB_PPA_F="/etc/apt/sources.list.d/vajdics-netbeans-installer-trusty.list"
readonly NETB_PPA="ppa:vajdics/netbeans-installer"
readonly SUB3_PPA_F="/etc/apt/sources.list.d/webupd8team-sublime-text-3-trusty.list"
readonly SUB3_PPA="ppa:webupd8team/sublime-text-3"

readonly RED_N='\033[1;31m%s\n\033[0m'
readonly GREEN_N='\033[1;32m%s\n\033[0m'
readonly BLUE_N='\033[1;34m%s\n\033[0m'
readonly RED='\033[1;31m%s\033[0m'
readonly GREEN='\033[1;32m%s\033[0m'
readonly BLUE='\033[1;34m%s\033[0m'

# Superusuário

printf "%s" "$BLUE" "[Script][$(date +%T)] Superusuário"

if [[ "$(id -u)" -ne 0 ]] || [[ -z $DESK_ENV ]]; then
	printf "%s" "$RED_N" " Fail!"
	echo "O script deve ser executado como superusuário (sudo)"
	echo "e preservando as variáveis de ambiente (opção -E):"
	echo "\$ sudo -E ./$(basename $0)"
	echo
	exit 1
fi

printf "%s" "$GREEN_N" " OK!"

# Detectar Sistema Operacional

printf "%s" "$BLUE" "[Script][$(date +%T)] Sistema Operacional detectado: $DESCRIPTION ($ARQ_PROC-bit) $DESK_ENV"

if [[ $DISTRIBUTOR != "LinuxMint" ]] || [[ $CODENAME != "rosa" ]] || \
	[[ $ARQ_PROC -ne 32 ]] || [[ "$DESK_ENV" != "mate" ]]
then
	printf "%s" "$RED_N" " Fail!"
	echo "Esse script foi escrito para Linux Mint 17.3 Rosa (32-bit) Mate"
	echo "O sistema é incompatível!"
	exit 1
fi

printf "%s" "$GREEN_N" " OK!"

# Atualizar pacotes

printf "%s" "$BLUE_N" "[Script][$(date +%T)] Atualizando repositórios da distribuição..."
apt-get update

printf "%s" "$BLUE_N" "[Script][$(date +%T)] Atualizando os pacotes..."
apt-get upgrade -y

# Codecs e ferramentas de compilador

printf "%s" "$BLUE_N" "[Script][$(date +%T)] Instalando codecs e ferramentas de compilador..."
apt-get install ubuntu-restricted-extras build-essential -y

# PPA's

if [[ ! -s "$JDK_PPA_F" ]]; then		# Java
	printf "%s" "$BLUE_N" "[Script][$(date +%T)] Adicionando repositório de terceiros $JDK_PPA..."
	apt-add-repository $JDK_PPA -y
else
	printf "%s" "$BLUE" "[Script][$(date +%T)] $JDK_PPA já existe"
	printf "%s" "$GREEN_N" " OK!"
fi
printf "%s" "$RED_N" "$(cat /etc/apt/sources.list.d/*.list | grep openjdk)"

if [[ ! -s "$NETB_PPA_F" ]]; then		# Netbeans
	printf "%s" "$BLUE_N" "[Script][$(date +%T)] Adicionando repositório de terceiros $NETB_PPA..."
	add-apt-repository $NETB_PPA -y
else
	printf "%s" "$BLUE" "[Script][$(date +%T)] $NETB_PPA já existe"
	printf "%s" "$GREEN_N" " OK!"
fi
printf "%s" "$RED_N" "$(cat /etc/apt/sources.list.d/*.list | grep netbeans)"

if [[ ! -s "$SUB3_PPA_F" ]]; then		# Sublime-Text
	printf "%s" "$BLUE_N" "[Script][$(date +%T)] Adicionando repositório de terceiros $SUB3_PPA..."
	add-apt-repository $SUB3_PPA -y
else
	printf "%s" "$BLUE" "[Script][$(date +%T)] $SUB3_PPA já existe"
	printf "%s" "$GREEN_N" " OK!"
fi
printf "%s" "$RED_N" "$(cat /etc/apt/sources.list.d/*.list | grep sublime-text)"

printf "%s" "$BLUE_N" "[Script][$(date +%T)] Atualizando caché do repositório..."
apt-get update

# Java OpenJDK 8

printf "%s" "$BLUE_N" "[Script][$(date +%T)] Instalando Java OpenJDK 8..."
apt-get install openjdk-8-jdk -y

printf "%s" "$BLUE_N" "[Script][$(date +%T)] Selecionando a versão 8 do OpenJDK..."
echo "2" | update-alternatives --config java
echo

printf "%s" "$BLUE_N" "[Script][$(date +%T)] Verificando versão OpenJDK..."
printf "%s" "$RED_N" "$(eval 'java -version')"
printf "%s" "$RED_N" "$(eval 'javac -version')"

# Netbeans IDE 8.1

printf "%s" "$BLUE_N" "[Script][$(date +%T)] Instalando Netbeans 8.1 IDE..."
if [[ ! -d "/opt/netbeans" ]]; then
	mkdir -p /opt/netbeans
fi
apt-get install netbeans-installer -y

# Sublime Text

printf "%s" "$BLUE_N" "[Script][$(date +%T)] Instalando Sublime Text 3..."
apt-get install sublime-text -y

# Aplicativos

printf "%s" "$BLUE_N" "[Script][$(date +%T)] Instalando Aplicativos:"
apt-get install git -y
printf "%s" "$BLUE" "[Script][$(date +%T)] $(type git)"
printf "%s" "$GREEN_N" " OK!"
apt-get install vim -y
printf "%s" "$BLUE" "[Script][$(date +%T)] $(type vim)"
printf "%s" "$GREEN_N" " OK!"
apt-get install inkscape -y
printf "%s" "$BLUE" "[Script][$(date +%T)] $(type inkscape)"
printf "%s" "$GREEN_N" " OK!"
apt-get install dia -y
printf "%s" "$BLUE" "[Script][$(date +%T)] $(type dia)"
printf "%s" "$GREEN_N" " OK!"
apt-get install meld -y
printf "%s" "$BLUE" "[Script][$(date +%T)] $(type meld)"
printf "%s" "$GREEN_N" " OK!"
apt-get install mysql-workbench -y
printf "%s" "$BLUE" "[Script][$(date +%T)] $(type mysql-workbench)"
printf "%s" "$GREEN_N" " OK!"
apt-get install pyrenamer -y
printf "%s" "$BLUE" "[Script][$(date +%T)] $(type pyrenamer)"
printf "%s" "$GREEN_N" " OK!"

# LAMP - Apache

printf "%s" "$BLUE_N" "[Script][$(date +%T)] Instalando servidor Apache..."
apt-get install apache2 -y

printf "%s" "$BLUE_N" "[Script][$(date +%T)] Mudando as permisões de /var/www/html..."
adduser $SUDO_USER www-data
chown $SUDO_USER:www-data /var/www/html
chgrp -R www-data /var/www/html
find /var/www/html -type d -exec chmod 775 {} \;
find /var/www/html -type f -exec chmod 664 {} \;
find /var/www/html -type d -exec chmod g+s {} \;
setfacl -R -d -m u::rwX,g:www-data:rwX /var/www/html
chmod g+s /var/www/html
printf "%s" "$RED_N" "$(ls -ld /var/www/html)"

printf "%s" "$BLUE_N" "[Script][$(date +%T)] Criando link simbólico na home do usuário '$SUDO_USER'..."
if [[ ! -h "/home/$SUDO_USER/html" ]]; then
	ln -s /var/www/html /home/$SUDO_USER
fi
printf "%s" "$RED_N" "$(ls -ld /home/$SUDO_USER/html)"

# LAMP - PHP

printf "%s" "$BLUE_N" "[Script][$(date +%T)] Instalando linguagem de programação PHP..."
apt-get install php5 libapache2-mod-php5 -y

# LAMP - MySQL

printf "%s" "$BLUE_N" "[Script][$(date +%T)] Instalando banco de dados MySQL..."
apt-get install mysql-server -y
apt-get install libapache2-mod-auth-mysql php5-mysql phpmyadmin -y

printf "%s" "$BLUE_N" "[Script][$(date +%T)] Configurando PHP para trabalhar com MySQL..."

if [[ ! -s "/etc/php5/apache2/php.ini.bak" ]]; then
	# Backup
	cp /etc/php5/apache2/php.ini /etc/php5/apache2/php.ini.bak
fi

sed -i -E '/^;\s*extension=msql\.so/s/^;\s*//' /etc/php5/apache2/php.ini
printf "%s" "$RED_N" "$(grep -n "extension=msql.so" /etc/php5/apache2/php.ini)"

printf "%s" "$BLUE_N" "[Script][$(date +%T)] Reiniciando Apache..."
/etc/init.d/apache2 restart

# LAMP - phpMyAdmin

printf "%s" "$BLUE_N" "[Script][$(date +%T)] Configurando phpMyAdmin para acessar sem senha..."

if [[ ! -s "/etc/phpmyadmin/config.inc.php.bak" ]]; then
	# Backup
	cp /etc/phpmyadmin/config.inc.php /etc/phpmyadmin/config.inc.php.bak
fi

sed -i -E '/^\s*(\/){2}\s.*AllowNoPassword/s/^\s*(\/){2}\s//' /etc/phpmyadmin/config.inc.php
printf "%s" "$RED_N" "$(grep -n 'AllowNoPassword' /etc/phpmyadmin/config.inc.php)"

printf "%s" "$BLUE_N" "[Script][$(date +%T)] Configurando Apache para acessar phpMyAdmin..."

if [[ ! -s "/etc/apache2/apache2.conf.bak" ]]; then
	# Backup
	cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak
fi

include="Include /etc/phpmyadmin/apache.conf"
saida=$(eval 'grep -n "$include" /etc/apache2/apache2.conf')

if [[ -z "$saida" ]]; then
	echo "$include" >> /etc/apache2/apache2.conf
fi
printf "%s" "$RED_N" "$(eval 'grep -n "$include" /etc/apache2/apache2.conf')"

printf "%s" "$BLUE_N" "[Script][$(date +%T)] Reiniciando Apache..."
/etc/init.d/apache2 restart

# Conta Aluno

# to-do list --> corrigir entrada de dados
printf "%s" "$BLUE_N" "[Script][$(date +%T)] Criando conta aluno (passwd: 'aluno'...)"
idaluno="$(id aluno 2> /dev/null)"
if [[ -z "$idaluno" ]]; then
	adduser aluno
	adduser aluno www-data
	printf "%s" "$RED_N" "$idaluno"
fi

printf "%s" "$BLUE_N" "[Script][$(date +%T)] Criando link simbólico na home do aluno para /var/www/html..."
if [[ ! -h "/home/aluno/html" ]]; then
	ln -s /var/www/html /home/aluno
fi

# Atalhos escritório

# Aplicativos dos quais serão criados atalhos
printf "%s" "$BLUE_N" "[Script][$(date +%T)] Criando atalhos pro escritório..."
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

printf "%s" "$BLUE_N" "[Script][$(date +%T)] Mudando o proprietário e as permissões da área de trabalho do usuário"
if [[ ! -d "/home/aluno/Área\ de\ Trabalho/" ]]; then
	mkdir /home/aluno/Área\ de\ Trabalho/
fi
chown $SUDO_USER:$SUDO_USER /home/aluno/Área\ de\ Trabalho/
chmod 1755 /home/aluno/Área\ de\ Trabalho/ /home/$SUDO_USER/Área\ de\ Trabalho/

printf "%s" "$BLUE_N" "[Script][$(date +%T)] Copiando e configurando atalhos"
cp "${apps[@]}" /home/aluno/Área\ de\ Trabalho/
cp "${apps[@]}" /home/$SUDO_USER/Área\ de\ Trabalho/
chown $SUDO_USER:$SUDO_USER /home/aluno/Área\ de\ Trabalho/*.desktop /home/$SUDO_USER/Área\ de\ Trabalho/*.desktop
chmod 755 /home/aluno/Área\ de\ Trabalho/*.desktop /home/$SUDO_USER/Área\ de\ Trabalho/*.desktop

printf "%s" "$RED_N" "$(ls -l /home/aluno/Área\ de\ Trabalho/)"
printf "%s" "$RED_N" "$(ls -l /home/$SUDO_USER/Área\ de\ Trabalho/)"

# To-do list --> regex limpar terminal colorido
printf "%s" "$BLUE_N" "[Script][$(date +%T)] Criando relatório na home com especificações do hardware..."
inxi -F | tee /home/$SUDO_USER/hardinfo.txt

echo "<?php phpinfo(); ?>" > /home/$SUDO_USER/html/testphp.php
firefox http://localhost/ http://localhost/testphp.php http://localhost/phpmyadmin 2>/dev/null

# Limpando o cache de repositórios
sudo apt-get autoremove
sudo apt-get autoclean

# Garantindo permissões pro Firefox
chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.cache/mozilla

# Deletando arquivo teste PHP
rm /home/$SUDO_USER/html/testphp.php
