###############################################################################
#		Mise à niveau du system
###############################################################################

### import file functions ###
. $PATH_LIBRARY/functions.sh
### END import file functions ###

set -u  # u pour envoyer sur l'entrée standard les variables non définies


pkg_manager="apt-get"

if [[ $INSTALL_AUTO = yes ]]; then
	$pkg_manager -yf dist-upgrade
else
	if f_ask_yn_question "\tMettre à jour les paquets de cette machine ?"; then
    	println info "Faire \" $pkg_manager upgrade ... \" "
		$pkg_manager -yf dist-upgrade
	fi
fi

################################################################################

