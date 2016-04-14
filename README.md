##postint

Postint à un outils comme son nom l'indique post-installation d'un serveur Linux.
Pour le moment il supporte les distributions suivantes :
- Debian Wheezy
- Debian Jessie

###1°- Fichier de configuration home

Adapter les fichiers suivants en fonction de son utilisation.
.bashrc
.screenrc
bin/whereami

-----------------------------------
#2°- execution des scripts d'installations

Ensuite dans le dossier OS, les scripts sont executés dans leurs ordre en fonction du numéro, du nom distributions et enfin de la version de la dsitrib.

exemple : 0.sh -> 1.sh -> 1_debian.sh -> 1_debian_quantal.sh


Par défault les numéros des fichiers correspond :

0 -> mis à jour des paquets
1 -> installation des paquets
2 -> ajout de dépôts

#### A FAIRE ####
Logger dans un fichier les log écrans

Auteur : Mutz Clement
Date derniere modification : 21/08/2013

WARNING !!!!!!!!!!!!!!!!!
Bien lire le TODO avant d'executer update.sh

Le fichier update.sh effectue plusieurs étapes décomposer comme suit :

