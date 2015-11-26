#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#===============================================================================================
#   System Required:  CentOS6.x (32bit/64bit)
#   Description:  Install Shadowsocks(libev) for CentOS
#   Author: V5FM <1@ruozhe.org>
#   Intro:  http://www.v5fm.com
#===============================================================================================

clear
echo "#############################################################"
echo "# Install Shadowsocks(libev) for CentOS6.x (32bit/64bit)"
echo "# Intro: http://www.v5fm.com"
echo "# Author: Ruozhe <1@ruozhe.org>"
echo "#############################################################"
echo ""

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install lnmp"
    exit 1
fi

#Set shadowsocks-libev config password
    echo "Please input password for shadowsocks-libev:"
    read -p "(Default password: v5fm.com):" shadowsockspwd
    if [ "$shadowsockspwd" = "" ]; then
        shadowsockspwd="v5fm.com"
    fi
    echo "password:$shadowsockspwd"
    echo "####################################"
# Set shadowsocks-libev config servers port
    echo "Please input servers port for shadowsocks-libev:"
    read -p "(Default port: 7999):" shadowsockspt
    if [ "$shadowsockspt" = "" ]; then
        shadowsockspt="7999"
    fi
    echo "port:$shadowsockspt"
    echo "####################################"

# install
yum update -y
yum install git build-essential autoconf libtool openssl-devel gcc -y
git clone https://github.com/madeye/shadowsocks-libev.git
cd shadowsocks-libev
./configure
make && make install

# Get ip address
    echo "Getting Public IP address, Please wait a moment..."
    IP=`curl -s checkip.dyndns.com | cut -d' ' -f 6  | cut -d'<' -f 1`
    if [ -z $IP ]; then
        IP=`curl -s ifconfig.me/ip`
    fi
# finish
iptables -A INPUT -p tcp --dport ${shadowsockspt} -j ACCEPT
nohup /usr/local/bin/ss-server -s 0.0.0.0 -p ${shadowsockspt} -k ${shadowsockspwd} -m aes-256-cfb &
echo "nohup /usr/local/bin/ss-server -s 0.0.0.0 -p ${shadowsockspt} -k ${shadowsockspwd} -m aes-256-cfb &" >> /etc/rc.local
# end
    clear
    echo ""
    echo "Congratulations, shadowsocks-libev install completed!"
    echo -e "Your Server IP: \033[41;37m ${IP} \033[0m"
    echo -e "Your Server Port: \033[41;37m ${shadowsockspt} \033[0m"
    echo -e "Your Password: \033[41;37m ${shadowsockspwd} \033[0m"
    echo -e "Your Local Port: \033[41;37m 1080 \033[0m"
    echo -e "Your Encryption Method: \033[41;37m aes-256-cfb \033[0m"
    echo ""
    echo "Welcome to visit:http://www.v5fm.com"
    echo "Enjoy it!"
    echo ""
exit
