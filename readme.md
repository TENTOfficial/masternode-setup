### This script is for root user on VPS only

### Install dependencies

On Ubuntu/Debian-based systems:
```
sudo apt-get update
```
```
sudo apt-get install \
      build-essential pkg-config libc6-dev m4 g++-multilib \
      autoconf libtool ncurses-dev unzip git python python-zmq \
      zlib1g-dev wget bsdmainutils automake curl gpw npm
```

### NOTE
```
You don't need to download blockchain manually, latest script will do it for you
```

### Download setup file
```
git clone https://github.com/TENTOfficial/masternode-setup
cd masternode-setup
chmod +x part1.sh part2.sh
```

### Create swap
```
sudo su
```
Type your password if needed.

Run the following commands:

```
./part1.sh
```

Press ```CTRL``` + ```D```

### Setup masternode

For example:
- Your masternode name is ```masternode1```
- Your vps ip is ```207.145.65.77```
- Your masternode privatekey is ```5JJaWWprqeNLwEYd5JucbUne68m51yumu5Peen5j5hrg4nrjej4```
- Your output is ```8b70363be7e585dde357124e67b182da25053d2f45c8454t4t45e4r5edddgdr4 0```

You'll need to run this command:
```
./part2.sh masternode1 207.145.65.77 5JJaWWprqeNLwEYd5JucbUne68m51yumu5Peen5j5hrg4nrjej4 8b70363be7e585dde357124e67b182da25053d2f45c8454t4t45e4r5edddgdr4 0
```

After it's finished, you'll receive this data:
```
{
  "balance": 0.00000000,
  "blocks": 1522284,
  "buildinfo": "v3.1.0-4b94b7a-dirty",
  "connections": 19,
  "difficulty": 216.9279947763039,
  "errors": "",
  "keypoololdest": 1519585211,
  "keypoolsize": 101,
  "networksolps": 26983,
  "paytxfee": 0,
  "protocolversion": 170010,
  "proxy": "",
  "relayfee": 0.000001,
  "testnet": false,
  "timeoffset": 0,
  "version": 3010050,
  "walletversion": 60000
}
```

In this case, your current syncing is at block: 1522284
You need to wait for syncing finish. Check the latest block at: https://explorer.snowgem.org/

Go to home
```
cd ~
```

To check current syncing process, run following command
```
./snowgem-cli getinfo
```


If your current block is latest block, go to ModernWallet and start this masternode.
