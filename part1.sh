apt-get update

apt-get install wget unzip curl libgomp1 -y

#curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
#apt-get install nodejs -y

if [ ! -f /swapfile ]; then

	fallocate -l 2G /swapfile
	chmod 600 /swapfile
	mkswap /swapfile
	swapon /swapfile

	sh -c "echo '/swapfile none swap sw 0' >> /etc/fstab"
fi


# setup auto starting

#remove old one
if [ -f /lib/systemd/system/snowgem.service ]; then
  systemctl disable --now snowgem.service
  rm /lib/systemd/system/snowgem.service
fi

echo "Creating service file..."

service="echo '[Unit]
Description=Snowgem daemon
After=network-online.target
[Service]
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/root/snowgemd
WorkingDirectory=/root/.snowgem
User=root
KillMode=mixed
Restart=always
RestartSec=10
TimeoutStopSec=10
Nice=-20
ProtectSystem=full

[Install]
WantedBy=multi-user.target' >> /lib/systemd/system/snowgem.service"

echo $service
sh -c "$service"
