#!/bin/bash

apt-get install ntp -y >/dev/null

dpoo=$(cat /etc/ntp.conf | grep -v '^#' | grep 'pool ' | awk '{print $2}')
dser=$(cat /etc/ntp.conf | grep -v '^#' | grep 'server ' | awk '{print $2}')

for i in $dpoo 
do 
sed -i "/$i/d" /etc/ntp.conf 
done
for i in $dser 
do 
sed -i "/$i/d" /etc/ntp.conf 
done
echo 'server ua.pool.ntp.org'>>/etc/ntp.conf
systemctl restart ntp.service
s_path=$(cd "$(dirname $0)" && pwd)
echo "0-59 * * * * root bash $s_path/ntp_verify.sh 2>&1">>/etc/crontab
cp /etc/ntp.conf /etc/ntp.conf.bak



