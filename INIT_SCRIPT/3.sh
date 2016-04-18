###############################################################################
#               Configuration systeme 
###############################################################################

### import file functions ###
. $PATH_LIBRARY/functions.sh
### END import file functions ###

##########################################
#       configuration security rootkit 
#
if [ $CONFIGURATION_CUSTOM="yes" ]; then
println info "\tconfiguration security rootkit\n"
$PATH_BASH $PATH_CONFIGURATION/SECURITY/ROOTKIT/install_rootkit.sh
fi

##########################################
#       configuration logwatch
#
if [ $CONFIGURATION_CUSTOM="yes" ]; then
println info "\tconfiguration logwatch\n"
$PATH_BASH $PATH_CONFIGURATION/logwatch/install_logwatch.sh
fi

##########################################
#       configuration fail2ban
#
if [ $CONFIGURATION_CUSTOM="yes" ]; then
println info "\tconfiguration fail2ban\n"
$PATH_BASH $PATH_CONFIGURATION/SECURITY/FAIL2BAN/install_fail2ban.sh
fi

##########################################
#       configuration global 
#
if [ $CONFIGURATION_CUSTOM="yes" ]; then
println info "\tconfiguration global\n"
rsync -av --progress $PATH_CONFIGURATION/etc /
$PATH_CP -rav $PATH_CONFIGURATION/HOME_DIR/. $HOME/
chown -R $(id -u -n):$(id -u -n) $HOME/.
fi

##########################################
#	cle ssh publique
#
if [ $CONFIGURATION_CUSTOM="yes" ]; then
if [ ! -d "$HOME/.ssh" ];then mkdir $HOME/.ssh/; fi
println info "\t try to copy public key ssh\n"
cat $PATH_CONFIGURATION/ssh/authorized_keys >> $HOME/.ssh/authorized_keys
fi


##########################################
#       redemarrage des services
#
ntpq -p
service ntp restart
service postfix restart
service fail2ban restart
