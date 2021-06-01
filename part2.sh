#!/bin/bash

# Args: $1    $2    $3
#       alias ip    key
# example: ./part2.sh mn1 207.145.65.77 5JJaWW...4nrjej4

rpcuser=$(gpw 1 30)
rpcpassword=$(gpw 1 30)

killall -9 snowgemd

# Setup ~/.snowgem/snowgem.conf

cd
if [ ! -d ~/.snowgem ]; then
  mkdir .snowgem
fi

echo "Creating snowgem.conf file..."

echo "rpcuser=$rpcuser
rpcpassword=$rpcpassword

addnode=explorer.snowgem.org
addnode=dnsseed1.snowgem.org
addnode=dnsseed2.snowgem.org
addnode=dnsseed3.snowgem.org
addnode=explorer.tent.app
addnode=dnsseed1.tent.app
addnode=dnsseed2.tent.app
addnode=dnsseed3.tent.app
addnode=95.217.148.35:16113
addnode=50.212.213.251:16113
addnode=62.75.223.139:16113
addnode=50.212.213.244:16113
addnode=62.75.217.58:16113
addnode=199.19.73.146:16113

txindex=1
server=1
listen=1
port=16113
rpcport=16112
" > ~/.snowgem/snowgem.conf 

if echo $2 | grep ":16113" ; then
  echo "masternodeaddr=$2
externalip=$2" >> ~/.snowgem/snowgem.conf
else
  echo "masternodeaddr=[$2]:16113
externalip=[$2]:16113" >> ~/.snowgem/snowgem.conf
fi

echo "masternode=1
masternodeprivkey=$3" >> ~/.snowgem/snowgem.conf

# Download and install params
wget -N https://github.com/TENTOfficial/masternode-setup/raw/master/fetch-params.sh
chmod +x fetch-params.sh
./fetch-params.sh

# Download and unzip binary
wget -N https://github.com/TENTOfficial/TENT/releases/download/Node/tent-linux.zip -O ~/binary.zip
unzip -o ~/binary.zip -d ~

# Download and unzip latest bootstrap
if [ ! -d ~/.snowgem/blocks ]; then
  wget -N https://files.equihub.pro/snowgem/blockchain_index.zip
  unzip -o ~/blockchain_index.zip -d ~/.snowgem
  rm ~/blockchain_index.zip
fi

# Download peers
if [ -f ~/.snowgem/peers.dat ]; then
  rm ~/.snowgem/peers.dat
fi
cd ~/.snowgem
wget https://github.com/TENTOfficial/TENT-Core/releases/download/data/peers.dat
cd

chmod +x ~/snowgemd ~/snowgem-cli

# Enable and start tent.service
systemctl enable --now tent.service

echo "
###################################################################
#                       READ THIS CAREFULLY                       #
#           YOU NEED TO WAIT FOR THE NODE TO BE SYNCED.           #
#                                                                 #
#  Run the following command to see if u are synced:              #
#  ./snowgem-cli getinfo                                          #
#  If you get the following, wait for the node to load fully:     #
#     error code: -28                                             #
#     error message:                                              #
#     Loading block index...                                      #
#  Run the command again after a while.                           #
#  Check \"blocks\" value and compare it with the \"Height\"          #
#       from https://explorer.tent.app/ to be the same            #
#  After you are synced run:                                      #
#  ./snowgem-cli masternodedebug                                  #
#  If you get \"Hot node, waiting for remote activation.\" you can  #
#      \"Start alias\" from TENT Core                               #
#                                                                 #
#  For help or aditional questions you can always contact us on   #
#             Discord(https://discord.gg/78rVJcH)                 #
###################################################################"