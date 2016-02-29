#!/bin/bash
#########################################
# Original script by Xavier Hienne
# # Copyright (c) 2013, Clément Mutz <c.mutz@servitics.fr>
# #########################################
# # Modified by Clément Mutz
# # Contact at c.mutz@servitics.fr
# #########################################
# Utilisation ./mon_script.sh arg1 arg2 arg3
# arg1 : type de server installé : (server ou ipbx)
# arg2 : remplacement des fichiers utilisateur (yes ou no)
# arg3 : installation auto (yes ou no)
#================== Globals ==================================================
export PATCH_BASH="/bin/bash"
export PATCH_CP="/bin/cp"
export PATCH_INIT_SCRIPT="INIT_SCRIPT"
export PATCH_END_SCRIPT="END_SCRIPT"
export PATCH_CONFIGURATION="CONFIGURATION"
export PATCH_LIBRARY="LIBRARY"
export LOGFILE=./log.`date +%s`.out
export SCRIPT_TYPE=$1
export CONFIGURATION_BASH_CUSTOM=$2
export INSTALL_AUTO=$3

#================== Functions ================================================
. $PATCH_LIBRARY/functions.sh

### you must execute root user
[ `whoami`  != "root" ] && println error "This script need to be launched as root." && exit 1

if test $# -eq 3;then
  println "arguments valides"
else
  println error "\n Usage: ${0} <arg1> <arg2> <arg3>"
  println error "\n arg1 type de server installé : (server ou ipbx)"
  println error "\n arg2 remplacement des fichiers utilisateur (yes ou no)"
  println error "\n arg3 installation auto (yes ou no)"
  exit 1
fi

#### search package lsb_release ###
if ! type -p lsb_release > /dev/null; then
    echo "Avant toute chose, installez le programme lsb_release (paquet lsb-release sur Debian et CentOS et redhat-lsb sur RedHat)" >&2
    exit 2
fi

### search aptitude else ask installation ###
if ! type -p aptitude > /dev/null; then
    if [[ $INSTALL_AUTO = yes ]]; then
        println info "Installation du paquet aptitude"
        apt-get -y install aptitude
    else
        if ask_yn_question "\t*** Le paquet aptitude n'est pas présent, voulez-vous l'installer ? ***"; then 
            apt-get -y install aptitude 
        fi
    fi
else echo " *** aptitude déjà installé sur cette machine *** ;) "
fi

### update/upgrade/install for type distribution  ###
detectdistro
#dist_vendor=$(lsb_release --short --id | tr [A-Z] [a-z])
dist_vendor=$distro
println info "\t$distro"
dist_name=$(lsb_release --short --codename | tr [A-Z] [a-z])
cd "$(dirname "$0")"		# WARNING: current directory has changed!
num_scripts=0
num_failures=0

if [[ $INSTALL_AUTO = no ]]; then
    if  ! ask_yn_question "\t*** Vous avez une '$dist_vendor - $dist_name' ***"; then
        read -r -p " *** Renseigner le nom du syteme (ubuntu,debian,linux_mint) *** " dist_vendor
        read -r -p " *** Renseigner le nom de votre version (quantal,wheezy) *** " dist_name
    fi
fi


for i in {0..9}; do
  postinst_base="./$PATCH_INIT_SCRIPT/$i"
  postinst_vendor_base="$postinst_base.${dist_vendor}"
  postinst_dist_base="${postinst_vendor_base}_$dist_name"

   println info "
   postinst_base : $postinst_base.sh\n postinst_vendor_base: $postinst_vendor_base.sh \n 
   postinst_dist_base : $postinst_dist_base \n 
   "


   for script in "$postinst_base.sh" "$postinst_vendor_base.sh" "$postinst_dist_base.sh" "$postinst_base".ALL.*.sh "$postinst_vendor_base".*.sh "$postinst_dist_base".*.sh; do
	println "\n\n  script en cours d'execution : $script\n\n"
	[ -f "$script" -a -s "$script" ] || continue
	cat <<- _END_ >&2

	################################################################################
	#
	#	$(readlink -f "$script")
	#
	_END_
	let "num_scripts++"
	if ! bash -u -e "$script"; then
	    echo "*** ATTENTION: une erreur s'est produite dans le script '$script' ***" >&2
	    let "num_failures++"
	fi
    done
done


##########################################
#	configuration de l'envoi des mails
#
println info "\tconfiguration de l'envoi des mails\n"
$PATCH_BASH $PATCH_CONFIGURATION/POSTFIX/install_mail.sh

##########################################
#	configuration security rootkit 
#
println info "\tconfiguration security rootkit\n"
$PATCH_BASH $PATCH_CONFIGURATION/SECURITY/ROOTKIT/install_rootkit.sh

##########################################
#	configuration global 
#
[ $CONFIGURATION_BASH_CUSTOM="yes" ] && println info "\tconfiguration global\n";$PATCH_CP -rav $PATCH_CONFIGURATION/etc/vim/. /etc/vim/.;$PATCH_CP -rav $PATCH_CONFIGURATION/HOME_DIR/. $HOME/;chown -R $(id -u -n):$(id -u -n) $HOME/.;chmod +x $HOME/whereami

##########################################
#	configuration iptables
#
#
#println info "\tconfiguration iptables\n"
#$PATCH_BASH $PATCH_CONFIGURATION/FIREWALL/install_iptables.sh

##########################################
#	configuration logrotate
#
#println info "\tconfiguration logrotate\n"
#$PATCH_BASH $PATCH_CONFIGURATION/LOGROTATE/install_logrotate.sh

source ~/.bashrc

clear

echo -e "\n\n\n"

echo >&2
if [ "$num_scripts" -eq 0 ]; then
    echo "ATTENTION: aucun script n'a été exécuté."
elif [ "$num_failures" -eq 0 ]; then
    echo "$num_scripts scripts ont été exécutés sans erreur."
else
    echo "$num_scripts scripts ont été exécutés."
    echo "ATTENTION: $num_failures scripts se sont terminés avec une erreur."
fi >&2

echo -e "\n\n\n"

# pour le fun ......
$PATCH_BASH $PATCH_END_SCRIPT/resume_system.sh
sleep 2
 
#chmod +x $PATCH_END_SCRIPT/clean_pc.sh
#./$PATCH_END_SCRIPT/clean_pc.sh
#sleep 2

### BEGIN unset env variables  ###
unset PATCH_BASH
unset PATCH_CP
unset PATCH_INIT_SCRIPT
unset PATCH_END_SCRIPT
unset PATCH_CONFIGURATION
unset PATCH_LIBRARY
unset LOGFILE
unset SCRIPT_TYPE
unset CONFIGURATION_BASH_CUSTOM
unset INSTALL_AUTO
### END unset env variables ###




