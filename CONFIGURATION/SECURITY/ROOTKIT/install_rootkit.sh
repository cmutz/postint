#!/bin/bash

##########################################
#
#	Copy file configuration rkhunter
#
echo "0 6 * * * root (/usr/sbin/chkrootkit 2>&1 | mutt -s '[$HOSTNAME] Résultats de chkrootkit' $MAIL)" >> /etc/crontab
