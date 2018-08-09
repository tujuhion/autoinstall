#!/bin/bash

echo "Domain name (Without www):"
read DOMAIN
echo FTP Username :
read USERNAME
echo Password :
read PASSWORD

HOMEDIR="/home/$DOMAIN"
SERVERROOT="/usr/local/lsws"
DOMAINCONF="$SERVERROOT/conf/templates/$DOMAIN.conf"

# Create directory
mkdir $HOMEDIR
mkdir $HOMEDIR/{html,logs}
mkdir $SERVERROOT/conf/vhosts/$DOMAIN
mkdir $SERVERROOT/conf/cert/$DOMAIN

# Create file
touch $HOMEDIR/html/.htaccess
cp $SERVERROOT/conf/templates/incl.conf $SERVERROOT/conf/templates/$DOMAIN.conf
cp $SERVERROOT/conf/templates/vhconf.conf $SERVERROOT/conf/vhosts/$DOMAIN/vhconf.conf
sed -i "s/##DOMAIN##/$DOMAIN/g" $SERVERROOT/conf/templates/$DOMAIN.conf
sed -i "s/##DOMAIN##/$DOMAIN/g" $SERVERROOT/conf/vhosts/$DOMAIN/vhconf.conf
#sed -i "s/defdomain[[:space:]][*]/$DOMAIN defdomain */g" $SERVERROOT/conf/httpd_config.conf
sed -i "s/##END_ALL_VHOST##/cat \/usr\/local\/lsws\/conf\/templates\/$DOMAIN.conf/e" $SERVERROOT/conf/httpd_config.conf
rm -f $DOMAINCONF
cat << EOT > $HOMEDIR/html/index.php
<?php
echo "Its Works!";
?>
EOT

# Generate Cert
openssl genrsa -out $SERVERROOT/conf/cert/$DOMAIN/$DOMAIN.key 2048
openssl rsa -in $SERVERROOT/conf/cert/$DOMAIN/$DOMAIN.key -out $SERVERROOT/conf/cert/$DOMAIN/$DOMAIN.key
openssl req -sha256 -new -key $SERVERROOT/conf/cert/$DOMAIN/$DOMAIN.key -out $SERVERROOT/conf/cert/$DOMAIN/$DOMAIN.csr -subj "/CN=$DOMAIN"
openssl x509 -req -sha256 -days 365 -in $SERVERROOT/conf/cert/$DOMAIN/$DOMAIN.csr -signkey $SERVERROOT/conf/cert/$DOMAIN/$DOMAIN.key -out $SERVERROOT/conf/cert/$DOMAIN/$DOMAIN.crt

# Create FTP User
useradd $USERNAME -d /home/$DOMAIN -p $(echo $PASSWORD | openssl passwd -1 -stdin) -M

# Fix Permission
chown -R $USERNAME:$USERNAME $HOMEDIR/html/
chown -R lsadm:lsadm $SERVERROOT/conf/cert/
chown -R lsadm:lsadm $SERVERROOT/conf/vhosts/
chown -R lsadm:lsadm $SERVERROOT/conf/inclconf/

# Reload
/usr/local/lsws/bin/lswsctrl reload

echo =================================================
echo Done!
echo Your vhost is ready
echo "Domain       : $DOMAIN"
echo "Homedir      : $HOMEDIR"
echo "FTP User     : $USERNAME"
echo "FTP Password : $PASSWORD"
echo =================================================
