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

printf "\e[1;34m[Script]\e[0m Sistema Operacional detectado: $DESCRIPTION ($ARQ_PROC-bit)\n"
printf "\e[1;34m[Script]\e[0m Sistema Operacional detectado: $DESCRIPTION ($ARQ_PROC-bit)\n"

if [ $DISTRIBUTOR != "LinuxMint" ] || [ $CODENAME != "rosa" ] || \
	[ $ARQ_PROC -ne 32 ]
then
	printf "\e[1;34m[Script]\e[0m Esse script foi escrito para Linux Mint 17.3 Rosa (32-bit)\n"
	printf "\e[1;34m[Script]\e[0m Esse script foi escrito para Linux Mint 17.3 Rosa (32-bit)\n"
	printf "\e[1;34m[Script]\e[0m O sistema é incompatível!\n"
	printf "\e[1;34m[Script]\e[0m O sistema é incompatível!\n"
	exit 1
fi
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

# Superusuário

printf "\e[1;34m[Script]\e[0m Superusuário?\n"
printf "\e[1;34m[Script]\e[0m Superusuário?\n"

if [ `id -u` -ne 0 ]; then
	printf "\e[1;34m[Script]\e[0m El script debe ser executado como superusuário (sudo)!\n"
	printf "\e[1;34m[Script]\e[0m El script debe ser executado como superusuário (sudo)!\n"
	exit 1
fi
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

# Atualizar pacotes

printf "\e[1;34m[Script]\e[0m Atualizando repositórios da distribuição...\n"
printf "\e[1;34m[Script]\e[0m Atualizando repositórios da distribuição...\n"
 apt-get update
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

printf "\e[1;34m[Script]\e[0m Atualizando os pacotes...\n"
printf "\e[1;34m[Script]\e[0m Atualizando os pacotes...\n"
apt-get upgrade -y
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

# Codecs e ferramentas de compilador

printf "\e[1;34m[Script]\e[0m Instalando codecs e ferramentas de compilador...\n"
printf "\e[1;34m[Script]\e[0m Instalando codecs e ferramentas de compilador...\n"
apt-get install ubuntu-restricted-extras build-essential -y
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

# PPA's

if [ ! -s "$JDK_PPA_F" ]; then		# Java
	printf "\e[1;34m[Script]\e[0m Adicionando repositório de terceiros...\n"
	printf "\e[1;34m[Script]\e[0m Adicionando repositório de terceiros...\n"
	apt-add-repository $JDK_PPA -y
	printf "\e[1;34m[Script]\e[0m OK...\n\n"
	printf "\e[1;34m[Script]\e[0m OK...\n\n"
else
	printf "\e[1;34m[Script]\e[0m $JDK_PPA já existe\n"
	printf "\e[1;34m[Script]\e[0m $JDK_PPA já existe\n"
	printf "\e[1;34m[Script]\e[0m OK...\n\n"
	printf "\e[1;34m[Script]\e[0m OK...\n\n"
fi

if [ ! -s "$NETB_PPA_F" ]; then		# Netbeans
	printf "\e[1;34m[Script]\e[0m Adicionando repositório de terceiros...\n"
	printf "\e[1;34m[Script]\e[0m Adicionando repositório de terceiros...\n"
	add-apt-repository $NETB_PPA -y
	printf "\e[1;34m[Script]\e[0m OK...\n\n"
	printf "\e[1;34m[Script]\e[0m OK...\n\n"
else
	printf "\e[1;34m[Script]\e[0m $NETB_PPA já existe\n"
	printf "\e[1;34m[Script]\e[0m $NETB_PPA já existe\n"
	printf "\e[1;34m[Script]\e[0m OK...\n\n"
	printf "\e[1;34m[Script]\e[0m OK...\n\n"
fi

if [ ! -s "$SUB3_PPA_F" ]; then		# Sublime-Text
	printf "\e[1;34m[Script]\e[0m Adicionando repositório de terceiros...\n"
	printf "\e[1;34m[Script]\e[0m Adicionando repositório de terceiros...\n"
	add-apt-repository $SUB3_PPA -y
	printf "\e[1;34m[Script]\e[0m OK...\n\n"
	printf "\e[1;34m[Script]\e[0m OK...\n\n"
else
	printf "\e[1;34m[Script]\e[0m $SUB3_PPA já existe\n"
	printf "\e[1;34m[Script]\e[0m $SUB3_PPA já existe\n"
	printf "\e[1;34m[Script]\e[0m OK...\n\n"
	printf "\e[1;34m[Script]\e[0m OK...\n\n"
fi

printf "\e[1;34m[Script]\e[0m Atualizando caché do repositório...\n"
printf "\e[1;34m[Script]\e[0m Atualizando caché do repositório...\n"
apt-get update
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

# Java OpenJDK 8

printf "\e[1;34m[Script]\e[0m Instalando Java OpenJDK 8...\n"
printf "\e[1;34m[Script]\e[0m Instalando Java OpenJDK 8...\n"
apt-get install openjdk-8-jdk -y
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

printf "\e[1;34m[Script]\e[0m Selecionando a versão 8 do OpenJDK...\n"
printf "\e[1;34m[Script]\e[0m Selecionando a versão 8 do OpenJDK...\n"
printf "2" | update-alternatives --config java
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

printf "\e[1;34m[Script]\e[0m Verificando versão OpenJDK...\n"
printf "\e[1;34m[Script]\e[0m Verificando versão OpenJDK...\n"
java -version
javac -version
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

# Netbeans IDE 8.1

printf "\e[1;34m[Script]\e[0m Instalando Netbeans 8.1 IDE...\n"
printf "\e[1;34m[Script]\e[0m Instalando Netbeans 8.1 IDE...\n"
apt-get install netbeans-installer -y
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

# Sublime Text

printf "\e[1;34m[Script]\e[0m Instalando Sublime Text 3...\n"
printf "\e[1;34m[Script]\e[0m Instalando Sublime Text 3...\n"
apt-get install sublime-text -y
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

# Aplicativos

printf "\e[1;34m[Script]\e[0m Instalando Aplicativos:\n"
printf "\e[1;34m[Script]\e[0m Instalando Aplicativos:\n"
printf "\e[1;34m[Script]\e[0m - git (Controle de versões)\n"
printf "\e[1;34m[Script]\e[0m - git (Controle de versões)\n"
apt-get install git -y
printf "\e[1;34m[Script]\e[0m - vim (Editor de texto)\n"
printf "\e[1;34m[Script]\e[0m - vim (Editor de texto)\n"
apt-get install vim -y
printf "\e[1;34m[Script]\e[0m - inkscape (Disenho vetorial)\n"
printf "\e[1;34m[Script]\e[0m - inkscape (Disenho vetorial)\n"
apt-get install inkscape -y
printf "\e[1;34m[Script]\e[0m - dia (Diagramas)\n"
printf "\e[1;34m[Script]\e[0m - dia (Diagramas)\n"
apt-get install dia -y
printf "\e[1;34m[Script]\e[0m - meld (Comparador de arquivos)\n"
printf "\e[1;34m[Script]\e[0m - meld (Comparador de arquivos)\n"
apt-get install meld -y
printf "\e[1;34m[Script]\e[0m - mysql-workbench (Administração de DB)\n"
printf "\e[1;34m[Script]\e[0m - mysql-workbench (Administração de DB)\n"
apt-get install mysql-workbench -y
printf "\e[1;34m[Script]\e[0m - pyrenamer (Renomear arquivos em lote)\n"
printf "\e[1;34m[Script]\e[0m - pyrenamer (Renomear arquivos em lote)\n"
apt-get install pyrenamer -y
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

# LAMP - Apache

printf "\e[1;34m[Script]\e[0m Instalando servidor Apache...\n"
printf "\e[1;34m[Script]\e[0m Instalando servidor Apache...\n"
apt-get install apache2 -y
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

printf "\e[1;34m[Script]\e[0m Mudando as permisões de /var/www/html...\n"
printf "\e[1;34m[Script]\e[0m Mudando as permisões de /var/www/html...\n"
chown -R $USER.www-data /var/www/html
chmod -R 775 /var/www/html
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

printf "\e[1;34m[Script]\e[0m Criando link simbólico na home...\n"
printf "\e[1;34m[Script]\e[0m Criando link simbólico na home...\n"
ln -s /var/www/html /home/$USER
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

# LAMP - PHP

printf "\e[1;34m[Script]\e[0m Instalando linguagem de programação PHP...\n"
printf "\e[1;34m[Script]\e[0m Instalando linguagem de programação PHP...\n"
apt-get install php5 libapache2-mod-php5 -y
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

# LAMP - MySQL

printf "\e[1;34m[Script]\e[0m Instalando banco de dados MySQL...\n"
printf "\e[1;34m[Script]\e[0m Instalando banco de dados MySQL...\n"
apt-get install mysql-server -y
apt-get install libapache2-mod-auth-mysql php5-mysql phpmyadmin -y
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

printf "\e[1;34m[Script]\e[0m Configurando PHP para trabalhar com MySQL...\n"
printf "\e[1;34m[Script]\e[0m Configurando PHP para trabalhar com MySQL...\n"

if [ ! -s "/etc/php5/apache2/php.ini.bak" ]; then
	# Backup
	cp /etc/php5/apache2/php.ini /etc/php5/apache2/php.ini.bak
fi

sed -i -E '/^;\s*extension=msql\.so/s/^;\s*//' /etc/php5/apache2/php.ini
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

printf "\e[1;34m[Script]\e[0m Reiniciando Apache...\n"
printf "\e[1;34m[Script]\e[0m Reiniciando Apache...\n"
/etc/init.d/apache2 restart
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

# LAMP - phpMyAdmin

printf "\e[1;34m[Script]\e[0m Configurando phpMyAdmin para acessar sem senha...\n"
printf "\e[1;34m[Script]\e[0m Configurando phpMyAdmin para acessar sem senha...\n"

if [ ! -s "/etc/phpmyadmin/config.inc.php.bak" ]; then
	# Backup
	cp /etc/phpmyadmin/config.inc.php /etc/phpmyadmin/config.inc.php.bak
fi

sed -i -E '/^\s*(\/){2}\s.*AllowNoPassword/s/^(\/){2}\s//' /etc/phpmyadmin/config.inc.php
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

printf "\e[1;34m[Script]\e[0m Configurando Apache para acessar phpMyAdmin...\n"
printf "\e[1;34m[Script]\e[0m Configurando Apache para acessar phpMyAdmin...\n"

if [ ! -s "/etc/apache2/apache2.conf.bak" ]; then
	# Backup
	cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak
fi
sudo printf "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

printf "\e[1;34m[Script]\e[0m Reiniciando Apache...\n"
printf "\e[1;34m[Script]\e[0m Reiniciando Apache...\n"
/etc/init.d/apache2 restart
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

# Conta Aluno

printf "\e[1;34m[Script]\e[0m Criando conta aluno (passwd: 'aluno'...)\n"
printf "\e[1;34m[Script]\e[0m Criando conta aluno (passwd: 'aluno'...)\n"
adduser aluno
adduser aluno www-data
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

printf "\e[1;34m[Script]\e[0m Criando link simbólico na home do aluno para /var/www/html...\n"
printf "\e[1;34m[Script]\e[0m Criando link simbólico na home do aluno para /var/www/html...\n"
ln -s /var/www/html /home/aluno
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

# Atalhos escritório

# Aplicativos dos quais serão criados atalhos
printf "\e[1;34m[Script]\e[0m Criando atalhos pro escritório...\n"
printf "\e[1;34m[Script]\e[0m Criando atalhos pro escritório...\n"
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
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

printf "\e[1;34m[Script]\e[0m Mudando o proprietário e as permissões da área de trabalho do usuário\n"
printf "\e[1;34m[Script]\e[0m Mudando o proprietário e as permissões da área de trabalho do usuário\n"
sudo chown etec:etec /home/aluno/Área\ de\ Trabalho/
sudo chmod 1755 /home/aluno/Área\ de\ Trabalho/ /home/etec/Área\ de\ Trabalho/
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

printf "\e[1;34m[Script]\e[0m Copiando e configurando atalhos\n"
printf "\e[1;34m[Script]\e[0m Copiando e configurando atalhos\n"
sudo cp ${apps[@]} /home/aluno/Área\ de\ Trabalho/
sudo cp ${apps[@]} /home/etec/Área\ de\ Trabalho/
sudo chown etec:etec /home/aluno/Área\ de\ Trabalho/*.desktop /home/etec/Área\ de\ Trabalho/*.desktop
sudo chmod 755 /home/aluno/Área\ de\ Trabalho/*.desktop /home/etec/Área\ de\ Trabalho/*.desktop
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

printf "\e[1;34m[Script]\e[0m Criando arquivo de texto na home com especificações do hardware...\n"
printf "\e[1;34m[Script]\e[0m Criando arquivo de texto na home com especificações do hardware...\n"
inxi -F > /home/$USER/hardinfo.txt
printf "\e[1;34m[Script]\e[0m OK...\n\n"
printf "\e[1;34m[Script]\e[0m OK...\n\n"

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

printf "====================\n"
printf "Verifique:\n"
printf "- Apache\n"
printf "- PHP\n"
printf "- MySQL e phpMyAdmin"
printf "====================\n"
printf "<?php phpinfo(); ?>" > /home/$USER/html/testphp.php
firefox http://localhost/ http://localhost/testphp.php http://localhost/phpmyadmin 2>/dev/null &
read -p 'Enter para continuar: '
rm /home/$USER/html/testphp.php

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
cat /home/$USER/hardinfo.txt
read -p 'Enter para continuar: '
