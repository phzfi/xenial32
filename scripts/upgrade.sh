#!/bin/bash
echo "Upgrading"

#TODO remove glue once using pharazon/trusty32 v0.0.2
echo "trusty32" > /etc/hostname
sed -i 's/precise/trusty/g' /etc/hosts

echo "Configure apt"
cp /vagrant/etc/apt/sources.list /etc/apt/sources.lsit

echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections

# debconf-utils offers a way of defining answers to interactive prompts
apt-get update || exit 2

apt-get upgrade -y
dpkg-reconfigure -f noninteractive grub-pc

echo "Removing old packages"
apt-get remove -y \
    amd64-microcode

yes | do-release-upgrade

#Glue - xenial specific
#See https://stackoverflow.com/questions/69581622/cp-r-not-specified-omitting-directory-etc-udev-rules-d-70-persistent-net-ru/69581623#69581623
sed -i 's/cp -p /cp -pr /g' /usr/share/initramfs-tools/hooks/udev

yes | apt-get -q -y upgrade

echo "Removing old packages"
apt-get remove -y \
    amd64-microcode
#    linux-image-3.13.* \

apt-get autoremove -y
apt-get clean -y


echo "xenial32" > /etc/hostname
sed -i 's/trusty/xenial/g' /etc/hosts

echo "Upgraded successfully"
