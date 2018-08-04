yum -y install epel-release
yum -y install proftpd
sed -i "s/ProFTPD server/$HOSTNAME/g" /etc/proftpd.conf
systemctl restart proftpd
systemctl enable proftpd
firewall-cmd --permanent --add-port=21/tcp
firewall-cmd --reload
