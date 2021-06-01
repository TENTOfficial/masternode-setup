#!/bin/bash

apt-get update
apt-get install wget unzip gpw curl libgomp1 -y

# Creating a swap of 2GB only if it does not exist
# It is considered if it exist a swap it will be bigger than 2GB and we do not modify that

if [ ! -f /swapfile ]; then

	fallocate -l 2G /swapfile
	chmod 600 /swapfile
	mkswap /swapfile
	swapon /swapfile

	sh -c "echo '/swapfile none swap sw 0' >> /etc/fstab"
fi

# Disable services

systemctl disable --now tent.service \
  snowgem.service > /dev/null 2>&1

rm /lib/systemd/system/snowgem.service

# Setup /lib/systemd/system/tent.service

echo "Creating tent service file..."

echo "[Unit]
Description=TENT service
After=network.target

[Service]
User=root
Group=root

Type=simple
Restart=always

ExecStart=/root/snowgemd
WorkingDirectory=/root/.snowgem

TimeoutStopSec=300

[Install]
WantedBy=default.target" > /lib/systemd/system/tent.service

echo "
##################################################################
#          Run part2.sh if u are on amd64 processor (VPS)        #
#  Run part2_arm64.sh if u are on arm64 processor (RaspberryPI)  #
##################################################################"