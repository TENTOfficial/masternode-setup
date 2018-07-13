### Install dependencies

On Ubuntu/Debian-based systems:
```
sudo apt-get update
```
```
sudo apt-get install \
      build-essential pkg-config libc6-dev m4 g++-multilib \
      autoconf libtool ncurses-dev unzip git python python-zmq \
      zlib1g-dev wget bsdmainutils automake curl
```

### Download setup file
```
git clone https://github.com/Snowgem/masternode-setup
cd masternode-setup
```

### Create swap
```
sudo su
```
Type your password if needed.

Run the following commands:

```
chmod +x part1.sh part2.sh
./part1.sh
```

Press ```CTRL``` + ```D```

### Build binary and setup masternode

For example:
- Your masternode name is ```masternode1```
- Your vps ip is ```207.145.65.77```
- Your masternode privatekey is ```5JJaWWprqeNLwEYd5JucbUne68m51yumu5Peen5j5hrg4nrjej4```
- Your output is ```8b70363be7e585dde357124e67b182da25053d2f45c8454t4t45e4r5edddgdr4 0```

You'll need to run this command:
```
./part2.sh masternode1 207.145.65.77 5JJaWWprqeNLwEYd5JucbUne68m51yumu5Peen5j5hrg4nrjej4 8b70363be7e585dde357124e67b182da25053d2f45c8454t4t45e4r5edddgdr4 0
```

Wait for building finish, check the status:

```
cd ~
./snowgem-wallet/src/snowgem-cli getinfo
```

You'll receive this data:
```
{
  "version": 2000455,
  "protocolversion": 170006,
  "walletversion": 60000,
  "balance": 0.00000000,
  "blocks": 10293,
  "timeoffset": 0,
  "connections": 125,
  "proxy": "",
  "difficulty": 626.6895395692187,
  "testnet": false,
  "keypoololdest": 1521271021,
  "keypoolsize": 101,
  "paytxfee": 0.00000000,
  "relayfee": 0.00000100,
  "errors": ""
}
```

In this case, your current syncing is at block: 10293
You need to wait for syncing finish. Check the latest block at: https://insight.snowgem.org/

If your current block is latest block, go to the next step in the guide.
