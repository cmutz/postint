###############################################################################
#               Configuration systeme 
###############################################################################

### import file functions ###
. $PATCH_LIBRARY/functions.sh
### END import file functions ###

##########################################
#       configuration security rootkit 
#
if [ $CONFIGURATION_CUSTOM="yes" ]; then
println info "\tconfiguration security rootkit\n"
$PATCH_BASH $PATCH_CONFIGURATION/SECURITY/ROOTKIT/install_rootkit.sh
fi

##########################################
#       configuration logwatch
#
if [ $CONFIGURATION_CUSTOM="yes" ]; then
println info "\tconfiguration logwatch\n"
$PATCH_BASH $PATCH_CONFIGURATION/logwatch/install_logwatch.sh
fi

##########################################
#       configuration fail2ban
#
if [ $CONFIGURATION_CUSTOM="yes" ]; then
println info "\tconfiguration fail2ban\n"
$PATCH_BASH $PATCH_CONFIGURATION/SECURITY/FAIL2BAN/install_fail2ban.sh
fi

##########################################
#       configuration global 
#
if [ $CONFIGURATION_CUSTOM="yes" ]; then
println info "\tconfiguration global\n"
rsync -av --progress $PATCH_CONFIGURATION/etc /
$PATCH_CP -rav $PATCH_CONFIGURATION/HOME_DIR/. $HOME/
chown -R $(id -u -n):$(id -u -n) $HOME/.
fi

##########################################
#	cle ssh publique
#
if [ $CONFIGURATION_CUSTOM="yes" ]; then
if [ ! -d "$HOME/.ssh" ];then mkdir $HOME/.ssh/; fi
println info "\t try to copy public key ssh\n"
cat $PATCH_CONFIGURATION/ssh/authorized_keys >> $HOME/.ssh/authorized_keys
fi


##########################################
#       redemarrage des services
#
service ntp restart
ntpq -p
service postfix restart
service fail2ban restart
