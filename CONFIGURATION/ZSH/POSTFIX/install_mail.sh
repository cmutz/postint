#!/bin/bash

#####################"
# configuration send a mail
#


hostname > /etc/mailname


mv -v /etc/postfix/main.cf /etc/postfix/main.cf.old.postint
touch /etc/postfix/main.cf
cat << 'EOF' > /etc/postfix/main.cf
myorigin = /etc/mailname
smtpd_banner = $myhostname ESMTP

biff = no

append_dot_mydomain = no

readme_directory = no

myhostname = HOSTNAME
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
mydestination = localhost.localdomain, localhost
relayhost =
mynetworks = 127.0.0.0/8
mailbox_command = procmail -a "$EXTENSION"
mailbox_size_limit = 0
recipient_delimiter = +

default_transport = smtp
relay_transport = smtp

inet_interfaces = all
inet_protocols = ipv4
EOF

sed -i s/'^myhostname = HOSTNAME'/"myhostname = $HOSTNAME"/ /etc/postfix/main.cf 

/etc/init.d/postfix restart
