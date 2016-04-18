#!/bin/bash
#
#	Installation des paquets necessaire pour owncloud en version $VERSION_OWNCLOUD

### import file functions ###
. $PATH_LIBRARY/functions.sh
### END import file functions ###


set -u
export LC_ALL=C

    debs_to_install="

    mariadb-server 
    mariadb-client 
    
    apache2 
    libapache2-mod-php5 
    
    php5-json 
    php5-gd 
    php5-mysql 
    php5-curl 
    php5-intl 
    php5-mcrypt 
    php5-imagick

"

pkg_install_params="$debs_to_install"

#
#	Installation et retrait des paquets
#
pkg_manager="apt-get"
if [[ $INSTALL_AUTO = yes ]]; then
	$pkg_manager -yf  install $pkg_install_params
else
	if ask_yn_question "\tInstaller les paquets pour le service owncloud $1 ?"; then
    	println info "Faire \" $pkg_manager install $pkg_install_params \" "
		$pkg_manager -yf install $pkg_install_params
	fi
fi
