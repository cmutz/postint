###############################################################################
#               Configuration systeme 
###############################################################################

### import variables globales ###
. global.sh
### END import variables globales  ###

### import file functions ###
. $PATCH_LIBRARY/functions.sh
### END import file functions ###



##########################################
#       configuration de l'envoi des mails
#
println info "\tconfiguration de l'envoi des mails\n"
$PATCH_BASH $PATCH_CONFIGURATION/POSTFIX/install_mail.sh

##########################################
#       configuration security rootkit 
#
println info "\tconfiguration security rootkit\n"
$PATCH_BASH $PATCH_CONFIGURATION/SECURITY/ROOTKIT/install_rootkit.sh

##########################################
#       configuration global 
#
if [ $CONFIGURATION_BASH_CUSTOM="yes" ]; then
println info "\tconfiguration global\n"
rsync -av --progress $PATCH_CONFIGURATION/etc /
$PATCH_CP -rav $PATCH_CONFIGURATION/HOME_DIR/. $HOME/
chown -R $(id -u -n):$(id -u -n) $HOME/.
fi



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

