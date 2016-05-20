#!/bin/bash
#
#	Installation des paquets communs à tous les systèmes d'exploitations que nous installons (serveurs ou clients)

### import file functions ###
. $PATH_LIBRARY/functions.sh
### END import file functions ###


set -u
export LC_ALL=C

    debs_to_install="

        #
        #	Outils de la dernière chance
        #
        bash-static
        busybox-static
        e2fsck-static

        #
        #	Développement
        #
        binutils
        make
        patch

        #
        #	Debug
        #
        tcpdump
        tshark

	#
        #	Surveillance
        #
        atop
        htop
        iftop
        iotop
        ipmitool
        iptraf
        itop
	lm-sensors
        mytop

        #
        #	Utilitaires réseau
        #
        telnet
        vlan
        w3m
        cifs-utils
	ntp

	#
        #	Utilitaires d'archivage
        #
        bzip2
        p7zip
        unrar-free
        unzip

        #
        #	Autres utilitaires
        #
        apt-file
        bash-completion
        bc
        gawk
        kpartx
	less
	logwatch
        lsb-release
        mbr
        minicom
        mlocate
        mmv
        molly-guard
        mutt
        ncurses-hexedit
        psmisc
        pwgen
	postfix
        screen
        time
        tmux
        tree
        vim
	zsh

	#
	#	Reseau
	#
	chkrootkit
	rkhunter
	fail2ban
	lynis
"

debs_to_purge="
    busybox		# Remplacé par busybox-static
    # mawk		# Remplacé par gawk -- mais nécessaires pour certains programmes comme corosync
    vim-tiny		# Remplacé par vim
"

debs_to_remove="
    # Lister ici les paquets à retirer mais dont on veut conserver la configuration
"


function clean_list()
{
    IFS=$'\n'

    sed -r '
	s/^[[:space:]]+//
	s/[[:space:]]*(#.*)?$//
	/^[[:space:]]*$/d
    ' <<< "$*"
}

debs_to_install=$(clean_list "$debs_to_install")
debs_to_purge=$(clean_list "$debs_to_purge")
debs_to_remove=$(clean_list "$debs_to_remove")

# Pour améliorer la gestion des dépendances, on passe simultanément à "apt-get install"
# les paquets à installer ainsi que les paquets à retirer (suffixés par "-")
pkg_install_params="$debs_to_install"
pkg_install_params="$pkg_install_params $(echo -n "$debs_to_remove" | sed -r 's/[[:space:]]+|$/-&/')"
pkg_install_params="$pkg_install_params $(echo -n "$debs_to_purge" | sed -r 's/[[:space:]]+|$/-&/')"

# On passe les paquets à purger à "apt-get purge"
pkg_purge_params="$debs_to_purge"

#
#	Installation et retrait des paquets
#
pkg_manager="apt-get"
#type -p aptitude > /dev/null && pkg_manager="aptitude"
#read -r -p "Mettre à jour les paquets de cette machine (o/N)? " answer
if [[ $INSTALL_AUTO = yes ]]; then
	$pkg_manager -yf  install $pkg_install_params
else
	if ask_yn_question "\tMettre à jour les paquets de cette machine ?"; then
    	println info "Faire \" $pkg_manager install $pkg_install_params \" "
		$pkg_manager -yf install $pkg_install_params
	fi
fi
$pkg_manager purge --assume-yes $pkg_purge_params
#
#	Postinst
#
update-alternatives --set editor /usr/bin/vim.basic
apt-file update
