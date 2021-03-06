#!/bin/bash

# parametre $1 : nom de logiciel a verifier
f_check_soft() {
   which $1 > /dev/null
    if [ $? != 0 ] ; then
        println error " $1	---> [ KO ]"
	println error "$1 non detecte sur cette distribution vous pouvez"
	println error "l'installer en faisant un apt-get install $1 "
	println error " et/ou verifier manuellement la presence du paquet"
        export check_soft="KO"
    else
        println ras " $1	---> [ OK ]"

    fi
sleep 0.5
}


# Test de validite IPv4 de l'adresse entree (expression reguliere)
# parametre $1 : adresse IP à vérifier
# code de sortie : 0 pour ok et 1 pour adresse ipv4 non valide
f_isIPv4() {
if [ $# = 1 ]
then
 printf $1 | grep -Eq '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-4]|2[0-4][0-9]|[01]?[1-9][0-9]?)$'
 return $?
else
 return 2
fi
}


f_verification_access_ping() {
# vérifier si le serveur est joiniable 
# code de sortie : 0 pour ok et 1 pour adresse ipv4 non valide
    if PATCH_PING=$(which ping) ; then 
	println info "\t\nvérification de l'accessibilité du serveur"
        ${PATCH_PING} -c1 $*
	# Si le resultat de la commande renvoi != 0 alors ça ping !
	echo $?
        if [ $? != 0 ] ; then return 2 echo toto;	else return 0;	fi
    else 
	return 2; 
    fi
}


f_generate_pair_authentication_keys() {
    println info "\t\n Verification du paquet ssh-keygen \n"
    check_soft ssh-keygen

    println info "\t\n Creation de la pair ssh sur le serveur local\n"
    if [ ! -f /root/.ssh/id_rsa.pub ]; then
    ${PATCH_KEYGEN} -t rsa -f /$1/.ssh/id_rsa -N ""
    else 
    println warn "\t\n/$1/.ssh/id_rsa.pub exist"
    println warn "\t\n Utilisation de la pair de clé /$1/.ssh/id_rsa"
    fi
	### Ne comprend pas ce que ça fait là !  ###
    println warn "\t\n------------> WARNING !!!! <------------ \n"
    println warn "\t\n------------> ETES VOUS PRET A RENTRER LE MOT DE PASSE de l'utilisateur $1 (presser entrer) <------------ \n"; read
    [ -f ${PATCH_SSH_COPY_ID} ] && ${PATCH_SSH_COPY_ID} -i /$1/.ssh/id_rsa.pub $1@$2 -p ${PORT_SSH}
	### Ne comprend pas ce que ça fait là !  ###
}

f_verification_connexion_ssh() {

    println info "\t vérification de la connection ssh\n"

    cat > ${PATCH_TMP}${NAME_SCRIPT} << EOF
#!/usr/bin/expect -f
set timeout 3
   
spawn ssh -p ${PORT_SSH} $1@$2 ls -ld /etc
expect {
"yes/no" {send "yes\n"}
"etc" {exec echo $1@$2 >> ${PATCH_TMP}serveur-ok.txt}
}

expect {
"Password" {exec echo $1@$2 >> ${PATCH_TMP}serveur-nok.txt}
"etc" {exec echo $1@$2 >> ${PATCH_TMP}serveur-ok.txt}
}

EOF
    chmod 700 ${PATCH_TMP}${NAME_SCRIPT}
    ${PATCH_TMP}${NAME_SCRIPT}
    if [[ -f /${PATCH_TMP}serveur-ok.txt ]]; then export ETAT_SSH="OK"; else export ETAT_SSH="KO"; fi
    #clean function
    if [[ -f ${PATCH_TMP}serveur-*.txt ]]; then rm ${PATCH_TMP}serveur-*.txt; fi # supprime d'eventiels fichiers
    if [[ -f ${PATCH_TMP}${NAME_SCRIPT} ]]; then rm ${PATCH_TMP}${NAME_SCRIPT}; fi # supprime d'eventiels fichiers
}

f_println() {
    level=$1
    text=$2

    if [ "$level" == "error" ]; then
        echo -en "\033[0;36;31m$text\033[0;38;39m\n\r"
    elif [ "$level" == "ras" ]; then
        echo -en "\033[0;01;32m$text\033[0;38;39m\n\r"
    elif [ "$level" == "warn" ]; then
        echo -en "\033[0;36;33m$text\033[0;38;39m\n\r"
    else
        echo -en "\033[0;36;40m$text\033[0;38;39m\n\r"
    fi
}


f_ask_yn_question()
{
    QUESTION=$1

    while true;
    do 
        echo -en "${QUESTION} (y/n) "
        read REPLY
        if [ "${REPLY}" == "y" ];
        then
            return 0;
        fi
        if [ "${REPLY}" == "n" ];
        then
            return 1;
        fi
    echo "Don't tell you life, reply using 'y' or 'n'"'!'
    done
}


# function detection de distribution 
f_detectdistro () {
  if [[ -z $distro ]]; then
    distro="Unknown"
    if grep -i debian /etc/lsb-release >/dev/null 2>&1; then distro="debian"; fi
    if [ -f /etc/debian_version ]; then distro="debian"; fi
    if grep -i ubuntu /etc/lsb-release >/dev/null 2>&1; then distro="ubuntu"; fi
    if grep -i mint /etc/lsb-release >/dev/null 2>&1; then distro="linux Mint"; fi
    if [ -f /etc/arch-release ]; then distro="arch Linux"; fi
    if [ -f /etc/fedora-release ]; then distro="fedora"; fi
    if [ -f /etc/redhat-release ]; then distro="red Hat Linux"; fi
    if [ -f /etc/slackware-version ]; then distro="Slackware"; fi
    if [ -f /etc/SUSE-release ]; then distro="SUSE"; fi
    if [ -f /etc/mandrake-release ]; then distro="Mandrake"; fi
    if [ -f /etc/mandriva-release ]; then distro="Mandriva"; fi
    if [ -f /etc/crunchbang-lsb-release ]; then distro="Crunchbang"; fi
    if [ -f /etc/gentoo-release ]; then distro="Gentoo"; fi
    if [ -f /var/run/dmesg.boot ] && grep -i bsd /var/run/dmesg.boot; then distro="BSD"; fi
    if [ -f /usr/share/doc/tc/release.txt ]; then distro="Tiny Core"; fi
  fi
}


#LOG functions
f_LOG() {
    echo "`date`:$@" >> $LOGFILE
}
f_INFO() {
    echo "$@"
    f_LOG "INFO: $@"
}
f_WARNING() {
    echo "$@"
    f_LOG "WARNING: $@"
}

# Verifie la réponse saisie de l'utilisateur
# arg1 : saisie de l'utilisateur
# argn : reponses attendu de l'utilisateur
# f_checkanswer arg1 arg2 arg3 ... argn
f_checkanswer () {
#On stock tous les elements
tab=($*)
#on recupere le derniere element
f_element=${tab[0]}
tab=(${*:2})
for mot in ${tab[*]}
do
    if [ "$f_element" = $mot ];
    then
        return 1;
    fi
done
}

