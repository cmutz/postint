###############################################################################
#               Configuration systeme 
###############################################################################

### import file functions ###
. $PATH_LIBRARY/functions.sh
### END import file functions ###

###############################################################################
#		Configuration cron
###############################################################################

dest_file=/etc/cron.d/chkrootkit
if [ -e "$dest_file" ]; then
    echo "WARNING: '$dest_file' already exists and is left unchanged" >&2
else
    cat <<- _END_ > "$dest_file"
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
##########################################
#       configuration security rootkit 
#
0 6 * * * root (/usr/sbin/chkrootkit 2>&1 | mutt -s '[$HOSTNAME] Résultats de chkrootkit' $MAIL)

_END_
fi

##########################################
#
#       Copy file configuration logwatch
#
if [ $CONFIGURATION_CUSTOM="yes" ]; then
println info "\tconfiguration logwatch\n"
sed -i 's/\/usr\/sbin\/logwatch --output mail/\/usr\/sbin\/logwatch --output mail --mailto '$MAIL'  --detail high/g' /etc/cron.daily/00logwatch
fi

##########################################
#       configuration fail2ban
#
if [ $CONFIGURATION_CUSTOM="yes" ]; then
println info "\tconfiguration fail2ban\n"
sed -i 's/destemail = root@localhost/destemail = '$MAIL'/g' /etc/fail2ban/jail.conf
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
#       configuration tmux
#
if [ $CONFIGURATION_CUSTOM="yes" ]; then
println info "\t configuration tmux\n"
println info "\t source : https://github.com/tony/tmux-config \n"

git clone https://github.com/tony/tmux-config.git ~$HOME/.tmux
ln -s ~/.tmux/.tmux.conf ~/.tmux.conf
cd ~/.tmux
git submodule init
git submodule update
cd ~/.tmux/vendor/tmux-mem-cpu-load
cmake .
make
sudo make install
fi



##########################################
#       redemarrage des services
#
ntpq -p
service ntp restart
service postfix restart
service fail2ban restart
