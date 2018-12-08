fallocate -l 2G /swapfile

chmod 600 /swapfile

mkswap /swapfile

swapon /swapfile

sh -c "echo '/swapfile none swap sw 0' >> /etc/fstab"

#setup auto starting

#disable the old one
systemctl disable --now snowgem.service

#remove old one
sudo rm /lib/systemd/system/snowgem.service

#create new one
sh -c "echo '[Unit]
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

#start
systemctl enable --now snowgem.service