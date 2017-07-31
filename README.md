# Dockerized Stratis Wallet

Dockerfile for Stratis Interim Wallet (stratisX) [[Source](https://github.com/stratisproject/stratisX)] based on Debian

:moneybag: Donations welcomed at `SQr33rJ7w7G5nnV7YF4dikhExmy8U1RLWJ` :bow:

## Setup

1. Build the Docker image
2. Copy wallet and existing data
3. Create stratis.conf
4. Run the Docker container
5. Unlock the wallet

**Build the Docker image**

~~~~
$ docker build -t stratis .
~~~~

**Create the data directory and copy existing files (i.e. from the macOS Stratis Wallet)**

~~~~
mkdir -p ~/Docker/stratis
cp ~/Library/Application\ Support/Stratis/* ~/Docker/stratis
~~~~

> This copies the wallet.dat, databases, etc.pp.

**Create stratis.conf**

~~~~
vim ~/Docker/stratis/stratis.conf
~~~~

Example configruation:
```
rpcuser=stratisrpc
rpcpassword=XENkrC9AAqTTftU6YQg8mU66fKGL6L8aeJfAeSkrbXRK
rpcallowip=172.17.*.*
rpcport=16174
port=
gen=0
server=1
staking=1

addnode=101.100.131.181
addnode=103.24.76.21
# add more nodes if you want...
```

> Note: You should change the rpcpassword.

> Note: Don't modify `rpcallowip=172.17.*.*` because Docker uses a network in this range to connect the container to the network.

**Run the Docker container**

~~~~
docker run --name stratis -d \
  --publish 16174:16174 \
  --volume ~/Docker/stratis:/var/lib/stratis \
  stratis
~~~~

**Unlock the wallet**

~~~~
stratisd-unlockwallet
~~~~

> The wallet is now unlocked for stacking.

## Credits

[ewrogers/stratis-dockerfile](https://github.com/ewrogers/stratis-dockerfile)
