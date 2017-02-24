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
readonly COLORIDO='\033[1;34m%s\n\033[0m'

# Detectar Sistema Operacional

printf "$COLORIDO" "[Script][$(date +%T)] Sistema Operacional detectado: $DESCRIPTION ($ARQ_PROC-bit)"

if [ $DISTRIBUTOR != "LinuxMint" ] || [ $CODENAME != "rosa" ] || \
	[ $ARQ_PROC -ne 32 ]
then
	printf "$COLORIDO" "[Script][$(date +%T)] Esse script foi escrito para Linux Mint 17.3 Rosa (32-bit)"
	printf "$COLORIDO" "[Script][$(date +%T)] O sistema é incompatível!"
	exit 1
fi

# Superusuário

printf "$COLORIDO" "[Script][$(date +%T)] Superusuário?"

if [ `id -u` -ne 0 ]; then
	printf "$COLORIDO" "[Script][$(date +%T)] El script debe ser executado como superusuário (sudo)!"
	exit 1
fi

# Atualizar pacotes

printf "$COLORIDO" "[Script][$(date +%T)] Atualizando repositórios da distribuição..."
apt-get update

printf "$COLORIDO" "[Script][$(date +%T)] Atualizando os pacotes..."
apt-get upgrade -y

# Codecs e ferramentas de compilador

printf "$COLORIDO" "[Script][$(date +%T)] Instalando codecs e ferramentas de compilador..."
apt-get install ubuntu-restricted-extras build-essential -y

# PPA's

if [ ! -s "$JDK_PPA_F" ]; then		# Java
	printf "$COLORIDO" "[Script][$(date +%T)] Adicionando repositório de terceiros $JDK_PPA..."
	apt-add-repository $JDK_PPA -y
else
	printf "$COLORIDO" "[Script][$(date +%T)] $JDK_PPA já existe"
fi

if [ ! -s "$NETB_PPA_F" ]; then		# Netbeans
	printf "$COLORIDO" "[Script][$(date +%T)] Adicionando repositório de terceiros $NETB_PPA..."
	# add-apt-repository $NETB_PPA -y
else
	printf "$COLORIDO" "[Script][$(date +%T)] $NETB_PPA já existe"
fi

if [ ! -s "$SUB3_PPA_F" ]; then		# Sublime-Text
	printf "$COLORIDO" "[Script][$(date +%T)] Adicionando repositório de terceiros $SUB3_PPA..."
	add-apt-repository $SUB3_PPA -y
else
	printf "$COLORIDO" "[Script][$(date +%T)] $SUB3_PPA já existe"
fi

printf "$COLORIDO" "[Script][$(date +%T)] Atualizando caché do repositório..."
apt-get update

# Java OpenJDK 8

printf "$COLORIDO" "[Script][$(date +%T)] Instalando Java OpenJDK 8..."
apt-get install openjdk-8-jdk -y

printf "$COLORIDO" "[Script][$(date +%T)] Selecionando a versão 8 do OpenJDK..."
echo "2" | update-alternatives --config java

printf "$COLORIDO" "[Script][$(date +%T)] Verificando versão OpenJDK..."
java -version
javac -version

# Netbeans IDE 8.1

printf "$COLORIDO" "[Script][$(date +%T)] Instalando Netbeans 8.1 IDE..."
# apt-get install netbeans-installer -y

# Sublime Text

printf "$COLORIDO" "[Script][$(date +%T)] Instalando Sublime Text 3..."
apt-get install sublime-text -y

# Aplicativos

printf "$COLORIDO" "[Script][$(date +%T)] Instalando Aplicativos:"
printf "$COLORIDO" "[Script][$(date +%T)] - git (Controle de versões)"
apt-get install git -y
printf "$COLORIDO" "[Script][$(date +%T)] - vim (Editor de texto)"
apt-get install vim -y
printf "$COLORIDO" "[Script][$(date +%T)] - inkscape (Disenho vetorial)"
apt-get install inkscape -y
printf "$COLORIDO" "[Script][$(date +%T)] - dia (Diagramas)"
apt-get install dia -y
printf "$COLORIDO" "[Script][$(date +%T)] - meld (Comparador de arquivos)"
apt-get install meld -y
printf "$COLORIDO" "[Script][$(date +%T)] - mysql-workbench (Administração de DB)"
apt-get install mysql-workbench -y
printf "$COLORIDO" "[Script][$(date +%T)] - pyrenamer (Renomear arquivos em lote)"
apt-get install pyrenamer -y

# LAMP - Apache

printf "$COLORIDO" "[Script][$(date +%T)] Instalando servidor Apache..."
apt-get install apache2 -y

printf "$COLORIDO" "[Script][$(date +%T)] Mudando as permisões de /var/www/html..."
chown -R etec.www-data /var/www/html
chmod -R 775 /var/www/html

printf "$COLORIDO" "[Script][$(date +%T)] Criando link simbólico na home do usuário 'etec'..."
ln -s /var/www/html /home/etec

# LAMP - PHP

printf "$COLORIDO" "[Script][$(date +%T)] Instalando linguagem de programação PHP..."
apt-get install php5 libapache2-mod-php5 -y

# LAMP - MySQL

printf "$COLORIDO" "[Script][$(date +%T)] Instalando banco de dados MySQL..."
apt-get install mysql-server -y
apt-get install libapache2-mod-auth-mysql php5-mysql phpmyadmin -y

printf "$COLORIDO" "[Script][$(date +%T)] Configurando PHP para trabalhar com MySQL..."

if [ ! -s "/etc/php5/apache2/php.ini.bak" ]; then
	# Backup
	cp /etc/php5/apache2/php.ini /etc/php5/apache2/php.ini.bak
fi

sed -i -E '/^;\s*extension=msql\.so/s/^;\s*//' /etc/php5/apache2/php.ini

printf "$COLORIDO" "[Script][$(date +%T)] Reiniciando Apache..."
/etc/init.d/apache2 restart

# LAMP - phpMyAdmin

printf "$COLORIDO" "[Script][$(date +%T)] Configurando phpMyAdmin para acessar sem senha..."

if [ ! -s "/etc/phpmyadmin/config.inc.php.bak" ]; then
	# Backup
	cp /etc/phpmyadmin/config.inc.php /etc/phpmyadmin/config.inc.php.bak
fi

sed -i -E '/^\s*(\/){2}\s.*AllowNoPassword/s/^\s*(\/){2}\s//' /etc/phpmyadmin/config.inc.php

printf "$COLORIDO" "[Script][$(date +%T)] Configurando Apache para acessar phpMyAdmin..."

if [ ! -s "/etc/apache2/apache2.conf.bak" ]; then
	# Backup
	cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak
fi

include="Include /etc/phpmyadmin/apache.conf"
saida=$(eval 'grep -n "$include" /etc/apache2/apache2.conf')

if [ -z "$saida" ]; then
	echo "$include" >> /etc/apache2/apache2.conf
fi
echo "$saida"

printf "$COLORIDO" "[Script][$(date +%T)] Reiniciando Apache..."
/etc/init.d/apache2 restart

# Conta Aluno

# to-do list --> corrigir entrada de dados
printf "$COLORIDO" "[Script][$(date +%T)] Criando conta aluno (passwd: 'aluno'...)"
idaluno=$(id aluno 2> /dev/null)
if [ -z $idaluno ]; then
	adduser aluno
	adduser aluno www-data
fi

printf "$COLORIDO" "[Script][$(date +%T)] Criando link simbólico na home do aluno para /var/www/html..."
ln -s /var/www/html /home/aluno

# Atalhos escritório

# Aplicativos dos quais serão criados atalhos
printf "$COLORIDO" "[Script][$(date +%T)] Criando atalhos pro escritório..."
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

printf "$COLORIDO" "[Script][$(date +%T)] Mudando o proprietário e as permissões da área de trabalho do usuário"
mkdir /home/aluno/Área\ de\ Trabalho/
sudo chown etec:etec /home/aluno/Área\ de\ Trabalho/
sudo chmod 1755 /home/aluno/Área\ de\ Trabalho/ /home/etec/Área\ de\ Trabalho/

printf "$COLORIDO" "[Script][$(date +%T)] Copiando e configurando atalhos"
sudo cp ${apps[@]} /home/aluno/Área\ de\ Trabalho/
sudo cp ${apps[@]} /home/etec/Área\ de\ Trabalho/
sudo chown etec:etec /home/aluno/Área\ de\ Trabalho/*.desktop /home/etec/Área\ de\ Trabalho/*.desktop
sudo chmod 755 /home/aluno/Área\ de\ Trabalho/*.desktop /home/etec/Área\ de\ Trabalho/*.desktop

# To-do list --> regex limpar terminal colorido
printf "$COLORIDO" "[Script][$(date +%T)] Criando relatório na home com especificações do hardware..."
inxi -F > /home/etec/hardinfo.txt

# Testes

printf "Verifique as seguintes PPAs (não duplicadas):\n"
printf "=============================================\n"
printf "   - ppa:openjdk-r/ppa\n"
printf "   - ppa:vajdics/netbeans-installer\n"
printf "   - ppa:webupd8team/sublime-text-3\n"
read -p 'Enter para continuar: '
inxi -r | grep openjdk-r
inxi -r | grep netbeans-installer
inxi -r | grep webupd8team
read -p 'Enter para continuar: '

printf "Verifique a versão do Java:\n"
printf "===========================\n"
java -version
javac -version
read -p 'Enter para continuar: '

printf "Verifique se os seguentes softwares foram instalado e os mesmos estão funcionando corretamente:\n"
printf "===============================================================================================\n"
printf "   - Workbench: \n"
mysql-workbench --version
printf "   - Inkscape: \n"
inkscape --version
printf "   - Gimp: \n"
gimp --version
printf "   - Sublime-Text 3: \n"
sublime-text --version
printf "   - Meld: \n"
meld --version
printf "   - PyRenamer: \n"
pyrenamer --version
printf "   - Dia: \n"
dia --version
printf "   - Vim: \n"
vim --version
printf "   - Git: \n"
git --version
printf "   - Netbeans (manual: versão, atualizações, plugins)\n"
netbeans --nosplash &

read -p 'Enter para continuar: '

printf "Verifique se a conta 'aluno' foi criada corretamente:\n"
printf "=====================================================\n"
printf "/etc/passwd:\n"
id aluno
printf "link simbólico html (Apache):\n"
ls -l /home/aluno/html
printf "permissões:\n"
ls -ld /var/www/html
read -p 'Enter para continuar: '

printf "Verifique LAMP:\n"
printf "===============\n"
printf "- Apache\n"
printf "- PHP\n"
printf "- MySQL e phpMyAdmin\n"
echo "<?php phpinfo(); ?>" > /home/etec/html/testphp.php
firefox http://localhost/ http://localhost/testphp.php http://localhost/phpmyadmin 2>/dev/null &
read -p 'Enter para continuar: '
rm /home/etec/html/testphp.php

printf "Verifique os arquivos de configuração:\n"
printf "======================================\n"
printf "/etc/phpmyadmin/config.inc.php\n"
cat -n /etc/phpmyadmin/config.inc.php | grep 'AllowNoPassword'
printf "/etc/apache2/apache2.conf\n"
cat -n /etc/apache2/apache2.conf | grep 'Include /etc/phpmyadmin/apache.conf'
printf "/etc/php5/apache2/php.ini\n"
cat -n /etc/php5/apache2/php.ini | grep 'extension=msql.so'
read -p 'Enter para continuar: '

printf "Verifique se o Google é o search engine pro Firefox nas contas 'etec' e 'aluno'\n"
printf "===============================================================================\n"
read -p 'Enter para continuar: '

printf "Verifique se o relatório de hardware foi criado na home:\n"
printf "========================================================\n"
cat /home/etec/hardinfo.txt
read -p 'Enter para continuar: '
