#!/bin/bash

##########################################
#
#	Copy file configuration logwatch
#
sed -i 's/\/usr\/sbin\/logwatch --output mail/\/usr\/sbin\/logwatch --outputmail --mailto '$MAIL'  --detail high/g' /etc/cron.daily/00logwatch
