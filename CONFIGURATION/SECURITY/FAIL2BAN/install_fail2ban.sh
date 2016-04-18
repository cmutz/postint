#!/bin/bash

##########################################
#
#	Copy file configuration fail2banr
#
sed -i 's/destemail = root@localhost/destemail = '$MAIL'/g' /etc/fail2ban/jail.conf
