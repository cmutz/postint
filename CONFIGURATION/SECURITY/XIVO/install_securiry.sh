#!/bin/bash

##########################################
#
#	install protect hack asterisk
#
cp -va $PATCH_CONFIGURATION/SECURITY/XIVO/hangup_chan.sh /$HOME/
#sed -i "/exit 0/i\while true; do bash /root/hangup_chan.sh; sleep 20; done" /etc/rc.local
