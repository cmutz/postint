#!/bin/bash

##########################################
#
#	Copy file configuration rkhunter
#

rsync -av --progress chkrootkit.cron /etc/cron.d/chkrootkit
echo "0 6 * * * root (/usr/sbin/chkrootkit 2>&1 | mutt -s '[$HOSTNAME] Résultats de chkrootkit' $MAIL)" >> /etc/cron.d/chkrootkit
