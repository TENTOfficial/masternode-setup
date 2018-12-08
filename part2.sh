
confFile=".snowgem/snowgem.conf"
#confFile="file.txt"
mnFile=".snowgem/masternode.conf"
#mnFile="mn.txt"

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

wget -N https://github.com/Snowgem/ModernWallet/releases/download/data/params.zip -O ~/params.zip
rm ~/.snowgem-params
unzip -o ~/params.zip -d ~/.snowgem-params

chmod +x ~/snowgemd ~/snowgem-cli

chmod +x ~/masternode-setup/fetch-params_old.sh

cd ~

./masternode-setup/fetch-params_old.sh

wget -N https://github.com/Snowgem/Snowgem/releases/download/200458-20181006/snowgem-linux-2000458-20181006.zip -O ~/binary.zip
unzip -o ~/binary.zip -d ~

./snowgemd -daemon

sleep 5

./snowgem-cli getinfo
