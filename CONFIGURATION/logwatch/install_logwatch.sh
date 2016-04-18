#!/bin/bash

##########################################
#
#	Copy file configuration logwatch
#
sed -i 's/\/usr\/sbin\/logwatch --output --detail high/\/usr\/sbin\/logwatch --outputmail --mailto '$MAIL'  --detail high/g' /etc/cron.daily/00logwatch
