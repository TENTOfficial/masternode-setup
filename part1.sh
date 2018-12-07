fallocate -l 2G /swapfile

chmod 600 /swapfile

mkswap /swapfile

swapon /swapfile

sh -c "echo '/swapfile none swap sw 0' >> /etc/fstab"