if [ ! -f /swapfile ]; then

fallocate -l 2G /swapfile

chmod 600 /swapfile

mkswap /swapfile

swapon /swapfile

sudo sh -c "echo '/swapfile none swap sw 0' >> /etc/fstab"
fi

#setup auto starting
#remove old one
if [ -f /lib/systemd/system/snowgem.service ]; then
	sudo systemctl disable --now snowgem.service
	sudo rm /lib/systemd/system/snowgem.service
else
	echo "File not existed, OK"
fi

#create new one
username=$(whoami)
echo $username

service=
if [ "$username" = "root" ] ; then
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
else
  service="echo '[Unit]
Description=Snowgem daemon
After=network-online.target

[Service]
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/home/'$username'/snowgemd
WorkingDirectory=/home/'$username'/.snowgem
User='$username'
KillMode=mixed
Restart=always
RestartSec=10
TimeoutStopSec=10
Nice=-20
ProtectSystem=full

[Install]
WantedBy=multi-user.target' >> /lib/systemd/system/snowgem.service"
fi
echo $service
sudo sh -c "$service"
