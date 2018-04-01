#!/bin/bash
if [ -z "$(pgrep 'ntpd')" ]
then
echo "NOTICE: ntp is not running"
systemctl start ntp.service >> /dev/null 2>&1
fi
zero=0
ntp_diff=$(diff -q /etc/ntp.conf.bak /etc/ntp.conf | grep -c 'differ')
if [[ $ntp_diff -gt 0 ]]
then
echo "NOTICE: /etc/ntp.conf was changed. Calculated diff:"
diff -u0 /etc/ntp.conf.bak /etc/ntp.conf
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
systemctl restart ntp.service >> /dev/null 2>&1
fi
