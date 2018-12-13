
confFile=".snowgem/snowgem.conf"
#confFile="file.txt"
mnFile=".snowgem/masternode.conf"
#mnFile="mn.txt"

killall -9 snowgemd

cd ~
mkdir .snowgem
rm $confFile
rm $mnFile
touch $confFile
touch $mnFile

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

echo $1 $2":16113" $3 $4 $5 >> $mnFile

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
systemctl enable --now snowgem.service

echo "wait for 200 seconds"
x=1
while [ $x -le 200 ]
do
  echo "$x"
  sleep 1
  x=$(( $x + 1 ))
done

./snowgem-cli getinfo
