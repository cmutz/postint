#!/bin/bash

##########################################
#
#	Copy file configuration rkhunter
#
cp -rav $PATCH_CONFIGURATION/etc/default/rkhunter /etc/default/ 
echo "0 6 * * * root (/usr/sbin/chkrootkit 2>&1 | mutt -s '[$HOSTNAME] Résultats de chkrootkit' infrastructure@whoople.fr)" >> /etc/crontab
