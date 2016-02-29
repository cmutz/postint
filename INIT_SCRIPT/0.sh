###############################################################################
#		Mise à niveau du system
###############################################################################

### import file functions ###
. $PATCH_LIBRARY/functions.sh
### END import file functions ###

set -u  # u pour envoyer sur l'entrée standard les variables non définies
export LC_ALL=C

pkg_manager="apt-get"
type -p aptitude > /dev/null && pkg_manager="aptitude"

println info " Mise à jour de la liste des paquets \n "
sleep 1
$pkg_manager update

#read -r -p "Mettre à jour les paquets de cette machine (o/N)? " answer
if [[ $INSTALL_AUTO = yes ]]; then
	$pkg_manager -yf upgrade
else
	if ask_yn_question "\tMettre à jour les paquets de cette machine ?"; then
    	println info "Faire \" $pkg_manager upgrade ... \" "
		$pkg_manager -yf upgrade
	fi
fi

################################################################################

