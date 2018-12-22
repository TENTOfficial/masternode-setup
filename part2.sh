#!/bin/bash
confFile=".snowgem/snowgem.conf"
#confFile="file.txt"
mnFile=".snowgem/masternode.conf"
#mnFile="mn.txt"

sudo killall -9 snowgemd

cd ~
if [ ! -d ~/.snowgem-params ]; then
  mkdir .snowgem
  rm $confFile
  rm $mnFile
  touch $confFile
  touch $mnFile
fi

#write data
rpcuser=$(gpw 1 30)
echo "rpcuser="$rpcuser >> $confFile
rpcpassword=$(gpw 1 30)
echo "rpcpassword="$rpcpassword >> $confFile
echo "addnode=explorer.snowgem.org" >> $confFile
echo "addnode=insight.snowgem.org" >> $confFile
echo "addnode=dnsseed1.snowgem.org" >> $confFile
echo "addnode=dnsseed2.snowgem.org" >> $confFile
echo "addnode=dnsseed3.snowgem.org" >> $confFile
echo "rpcport=16112" >> $confFile
echo "port=16113" >> $confFile
echo "listen=1" >> $confFile
echo "server=1" >> $confFile
echo "txindex=1" >> $confFile
echo "masternodeaddr="$2":16113" >> $confFile
echo "externalip="$2":16113" >> $confFile
echo "masternodeprivkey="$3 >> $confFile
echo "masternode=1" >> $confFile

if echo $2 | grep ":16113" ; then
  echo $1 $2 $3 $4 $5 >> $mnFile
else
  echo $1 $2":16113" $3 $4 $5 >> $mnFile
fi

if [ -d ~/.snowgem-params ]; then
  rm ~/.snowgem-params -r
fi

if [ -d ~/snowgem-wallet ]; then
  rm ./snowgem-wallet -r
fi

chmod +x ~/masternode-setup/fetch-params.sh

cd ~

./masternode-setup/fetch-params.sh

wget -N https://github.com/Snowgem/Snowgem/releases/download/3000450-20181208/snowgem-linux-3000450-20181208.zip -O ~/binary.zip
unzip -o ~/binary.zip -d ~

if [ ! -d ~/.snowgem/blocks ]; then
  wget -N https://cdn1.snowgem.org/blockchain_index.zip -O ~/blockchain.zip
  unzip -o ~/blockchain.zip -d ~/.snowgem
  rm ~/blockchain.zip
fi

chmod +x ~/snowgemd ~/snowgem-cli

#start

./snowgemd -daemon
sudo systemctl enable --now snowgem.service

x=1
echo "wait for starting"
while true ; do
    echo "It's normal, please wait until wallet info is displayed ($x)"
    sleep 1
    x=$(( $x + 1 ))
    if ./snowgem-cli getinfo | grep '"difficulty"' ; then
        ./snowgem-cli getinfo
        echo "checking masternode status"
        while true ; do
            echo "Please wait ($x)"
            sleep 1
            x=$(( $x + 1 ))
            if ! ./snowgem-cli masternodedebug | grep -q 'not yet activated'; then
                ./snowgem-cli masternodedebug
                break
            fi
        done
        break
    fi
done

./snowgem-cli getinfo
./snowgem-cli masternodedebug
