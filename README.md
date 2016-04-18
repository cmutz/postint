#postint

Postint à un outils comme son nom l'indique post-installation d'un serveur Linux.

Pour le moment il supporte les distributions suivantes :
- Debian Wheezy
- Debian Jessie

###1°- Pre-requis

- lsb-release

- root

###2°- execution du script d'installation

`./install.sh arg1 arg2 arg3`

- **arg1** : type de server à installer ( server )
- **arg2** : remplacement des fichiers utilisateurs ( yes/no )
- **arg3** : installation automatique ( yes/no )


###3° - Utilisation du dossier INIT_SCRIPT

Ensuite dans le dossier OS, les scripts sont executés dans leurs ordre en fonction du numéro, du nom distributions et enfin de la version de la dsitrib.

exemple : 0.sh -> 1.sh -> 1_debian.sh -> 1_debian_quantal.sh


Par défault les numéros des fichiers correspondent :

- 0 -> mis à jour des paquets
- 1 -> installation des paquets
- 2 -> ajout de dépôts
- 3 -> configuration
- 9 -> fin de configuration



###A VENIR

- Logger dans un fichier les log écrans
- Prendre en compte les installations pour des services particuliers (xivo, owncloud, odoo ...) 



**__Date création : 21/08/2013__**
**__Date derniere modification : 14/04/2016__**
