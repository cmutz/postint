#!/bin/bash

IP_WAN_1=94.247.167.139
IP_WAN_2=94.247.167.145
SIP_TEST=xphn00
dest_mail=infrastructure@servitics.fr


#listen_channel $SIP_TEST
listen_channel $IP_WAN_1
listen_channel $IP_WAN_2

function listen_channel() {

CHANNEL_TEST=`asterisk -rx "core show channels" | grep $1 | cut -f1 -d" "`

if [ -z "$CHANNEL_TEST" ];

        then echo "rien a signaler a `date +%Y-%m-%d-%H:%M:%S` sur l'ip $1" >> /var/log/hangup_chan.log

        else echo $1; mutt -s "Tentative d'attaque venant de l'ip $1 a `date +%Y-%m-%d-%H:%M:%S`" $dest_mail <.; asterisk -rx "channel request hangup $CHANNEL_TEST"
fi
}
