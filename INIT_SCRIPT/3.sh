###############################################################################
#               Configuration systeme 
###############################################################################

### import file functions ###
. $PATCH_LIBRARY/functions.sh
### END import file functions ###



##########################################
#       configuration de l'envoi des mails
#
if [ $CONFIGURATION_CUSTOM="yes" ]; then
println info "\tconfiguration de l'envoi des mails\n"
$PATCH_BASH $PATCH_CONFIGURATION/POSTFIX/install_mail.sh
fi
##########################################
#       configuration security rootkit 
#
if [ $CONFIGURATION_CUSTOM="yes" ]; then
println info "\tconfiguration security rootkit\n"
$PATCH_BASH $PATCH_CONFIGURATION/SECURITY/ROOTKIT/install_rootkit.sh
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
cat $PATCH_CONFIGURATION/ssh/authorized_keys >> $HOME/.ssh/authorized_keys
fi
