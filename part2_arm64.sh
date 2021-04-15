#!/bin/bash

# Args: $1    $2    $3
#       alias ip    key
# example: ./part2.sh mn1 207.145.65.77 5JJaWW...4nrjej4 8b703r5...edddgdr4 0 yes

confFile=~/.snowgem/snowgem.conf
#confFile="file.txt"
#mnFile=~/.snowgem/masternode.conf
#mnFile="mn.txt"

killall -9 snowgemd

cd ~
if [ ! -d ~/.snowgem ]; then
  mkdir .snowgem
fi

rm $confFile
#rm $mnFile

if [ ! -f $confFile ]; then
  touch $confFile
  #touch $mnFile

  #write data
  rpcuser=$(gpw 1 30)
  echo "rpcuser="$rpcuser >> $confFile
  rpcpassword=$(gpw 1 30)
  echo "rpcpassword="$rpcpassword >> $confFile
  echo "addnode=explorer.snowgem.org" >> $confFile
  echo "addnode=explorer.tent.app" >> $confFile
  echo "addnode=dnsseed1.snowgem.org" >> $confFile
  echo "addnode=dnsseed2.snowgem.org" >> $confFile
  echo "addnode=dnsseed3.snowgem.org" >> $confFile
  echo "addnode=dnsseed1.tent.app" >> $confFile
  echo "addnode=dnsseed2.tent.app" >> $confFile
  echo "addnode=dnsseed3.tent.app" >> $confFile
  echo "rpcport=16112" >> $confFile
  echo "port=16113" >> $confFile
  echo "listen=1" >> $confFile
  echo "server=1" >> $confFile
  echo "txindex=1" >> $confFile
  if echo $2 | grep ":16113" ; then
    echo "masternodeaddr=$2" >> $confFile
    echo "externalip=$2" >> $confFile
  else
    echo "masternodeaddr=[$2]:16113" >> $confFile
    echo "externalip=[$2]:16113" >> $confFile
  fi
  echo "masternodeprivkey="$3 >> $confFile
  echo "masternode=1" >> $confFile

fi

if [ -d ~/.snowgem-params ]; then
  rm ~/.snowgem-params -r
fi

if [ -d ~/snowgem-wallet ]; then
  rm ./snowgem-wallet -r
fi

chmod +x ~/masternode-setup/fetch-params.sh

cd ~

report_asgard_progress 'Fetching params ...' 70

./masternode-setup/fetch-params.sh

wget -N https://github.com/TENTOfficial/TENT/releases/download/Node/tent-linux-aarch64.zip -O ~/binary.zip
unzip -o ~/binary.zip -d ~

report_asgard_progress 'Downloading chain data ...' 80

if [ ! -d ~/.snowgem/blocks ]; then
  wget -N https://files.equihub.pro/snowgem/blockchain_index.zip
  cd ~
  report_asgard_progress 'Unpacking data ...' 88
  unzip -o ~/blockchain_index.zip -d ~/.snowgem
  rm ~/blockchain_index.zip
fi

chmod +x ~/snowgemd ~/snowgem-cli

#start

report_asgard_progress 'Starting services ...' 90

./snowgemd -daemon
systemctl enable --now tent.service
sleep 5
x=1
echo "Wait for starting"
sleep 15
while true ; do
    echo "Wallet is opening, please wait. This step will take few minutes ($x)"
    sleep 1
    x=$(( $x + 1 ))
    ./snowgem-cli getinfo &> text.txt
    line=$(tail -n 1 text.txt)
    if [[ $line == *"..."* ]]; then
        echo $line
    fi
    if [[ $(tail -n 1 text.txt) == *"sure server is running"* ]]; then
        echo "Cannot start wallet, please contact us on Discord(https://discord.gg/78rVJcH) for help"
        break
    elif [[ $(head -n 20 text.txt) == *"version"*  ]]; then
        echo "Checking masternode status"
        while true ; do
            echo "Please wait ($x)"
            sleep 1
            x=$(( $x + 1 ))
            ./snowgem-cli masternodedebug &> text.txt
            line=$(head -n 1 text.txt)
            echo $line
            if [[ $line == *"not yet activated"* ]]; then
                ./snowgem-cli masternodedebug
                break
            fi
        done
        ./snowgem-cli getinfo
        ./snowgem-cli masternodedebug
        break
    fi
done