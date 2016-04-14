#postint

Postint à un outils comme son nom l'indique post-installation d'un serveur Linux.
Pour le moment il supporte les distributions suivantes :
- Debian Wheezy
- Debian Jessie

###1°- Pre-requis

- lsb-release

- root

###2°- execution du script d'installation

install.sh arg1 arg2 arg3

arg1 : type de server à installer ( server )
arg2 : remplacement des fichiers utilisateurs ( yes/no )
arg3 : installation automatique ( yes/no )




Ensuite dans le dossier OS, les scripts sont executés dans leurs ordre en fonction du numéro, du nom distributions et enfin de la version de la dsitrib.

exemple : 0.sh -> 1.sh -> 1_debian.sh -> 1_debian_quantal.sh


Par défault les numéros des fichiers correspond :

0 -> mis à jour des paquets
1 -> installation des paquets
2 -> ajout de dépôts

#### A FAIRE ####
Logger dans un fichier les log écrans


Adapter les fichiers suivants en fonction de son utilisation.
.bashrc
.screenrc
bin/whereami


Auteur : Mutz Clement
Date derniere modification : 21/08/2013

WARNING !!!!!!!!!!!!!!!!!
Bien lire le TODO avant d'executer update.sh

Le fichier update.sh effectue plusieurs étapes décomposer comme suit :

