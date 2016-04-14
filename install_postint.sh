#!/bin/bash
#########################################
# Original script by Xavier Hienne
# # Copyright (c) 2016, Clement Mutz <c.mutz@whoople.fr>
# #########################################
# # Modified by Clement Mutz
# # Contact at c.mutz@whoople.fr
# #########################################
# Utilisation ./mon_script.sh arg1 arg2 arg3
# arg1 : type de serveur installe : (server ou ipbx)
# arg2 : remplacement des fichiers utilisateur (yes ou no)
# arg3 : installation automatique (sans question) (yes ou no)



#================== Globals ==================================================
. global.sh

#================== Functions ================================================
. $PATCH_LIBRARY/functions.sh


#================== Verification =============================================
### you must execute root user
[ `whoami`  != "root" ] && println error "This script need to be launched as root." && exit 1

# On verifie le nombre d'arguments
if test $# -eq 3;then
  println "arguments valides"
else
  println error "\n Usage: ${0} <arg1> <arg2> <arg3>"
  println error "\n arg1 type de server installe : (server ou ipbx)"
  println error "\n arg2 remplacement des fichiers utilisateur (yes ou no)"
  println error "\n arg3 installation auto (yes ou no)"
  exit 1
fi

# On verifie la bonne saisie
if f_checkanswer $1 server owncloud; then
    println error "\n arg1 attendu : (server/owncloud)"
    exit 2
fi
# On verifie la bonne saisie
if f_checkanswer $2 yes no; then
    println error "\n arg2 attendu : (yes/no)"
    exit 2
fi
# On verifie la bonne saisie
if f_checkanswer $3 yes no; then
    println error "\n arg3 attendu : (yes/no)"
    exit 2
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
        if ask_yn_question "\t*** Le paquet aptitude n'est pas prÃ©sent, voulez-vous l'installer ? ***"; then 
            apt-get -y install aptitude 
        fi
    fi
else echo " *** aptitude deja installe© sur cette machine *** ;) "
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

### mode non interactif
export DEBIAN_FRONTEND=noninteractive

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

echo >&2
if [ "$num_scripts" -eq 0 ]; then
    echo "ATTENTION: aucun script n'a ete execute."
elif [ "$num_failures" -eq 0 ]; then
    echo "$num_scripts scripts ont ete executes sans erreur."
else
    echo "$num_scripts scripts ont ete executes."
    echo "ATTENTION: $num_failures scripts se sont termines avec une erreur."
fi >&2

# pour le fun ......
$PATCH_BASH $PATCH_END_SCRIPT/resume_system.sh
sleep 2

$PATCH_BASH $PATCH_CONFIGURATION/ZSH/zsh_install.sh
chsh -s /bin/zsh
env zsh




