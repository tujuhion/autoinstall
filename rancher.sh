#!/bin/bash

yum -y update
yum remove docker docker-common docker-selinux docker-engine
yum -y install yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum -y install docker-ce
systemctl start docker
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --reload
docker run -d --restart=unless-stopped -p 8080:8080 rancher/server:stable

