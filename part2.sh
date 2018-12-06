
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

git clone https://github.com/Snowgem/Snowgem snowgem-wallet

cd snowgem-wallet

chmod +x zcutil/build.sh depends/config.guess depends/cargo-checksum.sh depends/config.sub autogen.sh share/genbuild.sh src/leveldb/build_detect_platform depends/Makefile

./zcutil/build.sh

chmod +x zcutil/fetch-params.sh

./zcutil/fetch-params.sh

./src/snowgemd -daemon

cd ~

cd snowgem-wallet
