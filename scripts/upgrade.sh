#!/bin/bash
echo "Upgrading"

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

yes | apt-get -q -y upgrade

echo "Removing old packages"

apt-get autoremove -y
apt-get clean -y


echo "bionic32" > /etc/hostname
sed -i 's/xenial/bionic/g' /etc/hosts

echo "Upgraded successfully"
