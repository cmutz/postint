###############################################################################
#               Configuration systeme 
###############################################################################

### import file functions ###
. $PATH_LIBRARY/functions.sh
### END import file functions ###

$PATH_WGET https://download.owncloud.org/community/owncloud-$VERSION_OWNCLOUD.tar.bz2 -O /tmp/owncloud-$VERSION_OWNCLOUD.tar.bz2
$PATH_WGET https://owncloud.org/owncloud.asc -O /tmp/owncloud.asc
$PATH_WGET https://download.owncloud.org/community/$VERSION_OWNCLOUD.tar.asc -O /tmp/$VERSION_OWNCLOUD.tar.asc

gpg --import /tmp/owncloud.asc
gpg --verify /tmp/owncloud-9.0.0.tar.bz2.asc

$PATH_TAR xjvf /tmp/owncloud-$VERSION_OWNCLOUD.tar.bz2 -C /var/www/html/owncloud


### activation des modules apache2
a2enmod rewrite
a2enmod headers
a2enmod env
a2enmod dir
a2enmod mine

### redémarrage du service apache2
service apache2 restart

### fix des permissions
chown -R www-data:www-data /var/www/html/owncloud/


