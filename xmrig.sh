#!/bin/bash

# This bash for my personal use

yum install -y epel-release wget
yum install -y git make cmake gcc gcc-c++ libstdc++-static libmicrohttpd-devel libuv-static
cd /usr/local/src/
git clone https://github.com/xmrig/xmrig.git
cd xmrig
cmake . -DCMAKE_BUILD_TYPE=Release -DUV_LIBRARY=/usr/lib64/libuv.a && make
wget --no-check-certificate https://raw.githubusercontent.com/tujuhion/autoinstall/master/conf/config.json
./xmrig
