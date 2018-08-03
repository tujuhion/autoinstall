rpm -iUvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
yum -y install proftpd
systemctl restart proftpd
systemctl enable proftpd
firewall-cmd --permanent --add-port=21/tcp
firewall-cmd --reload
