# crypto currency wallets setup helper scripts for Debian based Linux distributions and subsystems

## Step By Step

1. Need to install git first to be able to checkout crypto currencies wallet setup helper scripts:
```
su - -c "apt install git; exit"
```

2. Create directory and download all setup helper scripts
```
mkdir -p ~/Downloads/ccwallets/cc.setup.helper.debian \
&& cd ~/Downloads/ccwallets/cc.setup.helper.debian \
&& git checkout https://github.com/nnmfnwl7/cc.setup.helper.debian.git ./
```

3. To install common software dependencies
```
./setup.dependencies.common.sh
```

4. If you need install software dependencies for graphical user interface wallets
```
./setup.dependencies.GUI.sh
```

5. If you need install advanced tools like:
   * firejail - sandboxing tool, optionally run wallets isolated from other programs/wallets/user files, also limited system calls
   * tor - TCP privacy routing layer
   * vnc server - remote desktop
   * 
```
./setup.dependencies.GUI.sh
```

6. To download and build wallets:
   * NOT securely sandboxed and NO privacy proxy by tor
```
./setup.cc.main.sh ./setup/setup.cc.blocknet.sh install
./setup.cc.main.sh ./setup/setup.cc.blocknet.sh install
./setup.cc.main.sh ./setup/setup.cc.litecoin.sh install
./setup.cc.main.sh ./setup/setup.cc.bitcoin.sh install
./setup.cc.main.sh ./setup/setup.cc.verge.sh install
./setup.cc.main.sh ./setup/setup.cc.dogecoin.sh install
./setup.cc.main.sh ./setup/setup.cc.pivx.sh install
```
   * securely sandboxed and privacy proxy by tor + generate firejail sandboxing run scripts:
```
./setup.cc.main.sh ./setup/setup.cc.blocknet.sh install firejail proxychains
./setup.cc.main.sh ./setup/setup.cc.litecoin.sh install firejail proxychains
./setup.cc.main.sh ./setup/setup.cc.bitcoin.sh install firejail proxychains
./setup.cc.main.sh ./setup/setup.cc.verge.sh install firejail proxychains
./setup.cc.main.sh ./setup/setup.cc.dogecoin.sh install firejail proxychains
./setup.cc.main.sh ./setup/setup.cc.pivx.sh install firejail proxychains
```
   * for more information about script and how to use optional arguments, please read help
```
./setup.cc.main.sh help | less
```

7. To generate or overwrite custom firejail sandboxing run scripts:
   * basic usage
```
./setup.cc.firejail.sh ./setup/setup.cc.blocknet.sh
./setup.cc.firejail.sh ./setup/setup.cc.litecoin.sh
./setup.cc.firejail.sh ./setup/setup.cc.bitcoin.sh
./setup.cc.firejail.sh ./setup/setup.cc.verge.sh
./setup.cc.firejail.sh ./setup/setup.cc.dogecoin.sh
./setup.cc.firejail.sh ./setup/setup.cc.pivx.sh
```
   * for more information about script and how to use optional arguments, please read help
```
./setup.cc.firejail.sh help | less
```

8. Hints how to remotely manage multiple console-interface-wallets(daemons) with GNU-screen + some basic navigation shortcuts for GNU-screen:
   * connect to remote machine by ssh
```
ssh user@hostname
```
   * reconnect or create new screen session
```
screen -R
```
   * some GNU-screen shortcuts and navigation between tabs to manage multiple console apps at same time:
```
* to detach from screen session CTRL + a + d
* to create new screen "tab" CTRL + a + c
* to list and select screen "tab" CTRL + a + "
* to go next tab CTRL + a + n
* to go previous tab CTRL + a + p
* to show screen help CTRL + a + ?
* to rename screen tab CTRL + a + A   
* to move screen tab to position 1 CTRL + a + :number 1 + ENTER
```
   * to start ie: blocknet wallet daemon securely sandboxed:
```
~/Downloads/ccwallets/blocknet && ./firejail.blocknet.d.bin.sh
```
   * to start ie: blocknet cli sandbox:
```
~/Downloads/ccwallets/blocknet && ./firejail.blocknet.d.cli.sh
```
   * to execute CLI RPC call for ie: blocknet:
```
./bin/blocknet.cli.bin <command...>
```
   * useful CLI RPC help command and list all by less command(Q to exit, / to search, n find next):
```
help | less
```
   * usefull CLI RPC to unlock wallet fully
```
walletpassphrase "$(read -sp "pwd: " undo; echo $undo;undo=)" 9999999999
```
   * usefull CLI RPC to unlock wallet fully and most secure way(supported only by NEW RPC CLIENTS LIKE BITCOIN)
```
-stdinwalletpassphrase walletpassphrase
```
   * usefull CLI RPC to show basic info about wallet
```
getwalletinfo | grep -e balance -e txcount -e unlocked 
```
   * usefull CLI RPC to get staking information
```
getstakingstatus
```
   * usefull CLI RPC to get basic blockchain information
```
getblockchaininfo | grep -e blocks -e headers -e bestblockhash
```
   * useful CLI RPC to get UPLOAD / DOWNLOAD data information
```
getnettotals | grep -e totalbytes
```
   * useful CLI RPC to get number of active connections
```
getconnectioncount
```
   * useful CLI RPC to disable or enable network
```
setnetworkactive true/false
```
   * useful CLI RPC to show connected nodes:
```
getpeerinfo | grep "\"addr\"" | grep "\."; 
```
   * useful CLI RPC to show list of all UTXOS:
```
listunspent 0 | grep -e address -e label -e amount -e confirmations
```
   * useful CLI RPC to list all generated addresses and all time received balances:
```
listreceivedbyaddress 0 true | grep -e address -e label -e amount
```
   * useful CLI RPC to list addresses and actual balances:
```
listaddressgroupings | grep -v -e "\[" -e "\]"
```
   * useful CLI RPC to stop wallet daemon:
```
stop
```
8. Hints how to remote desktop management with VNC:
   * to SSH connect to server
```
ssh user@hostname
```
   * to generate VNC password(one time only)
```
tigervncpasswd
```
   * to start tigervnc on server(do not worry, tiger vnc client resolution auto resize is supported :))
```
tigervncserver -localhost yes -geometry 1024x768 -depth 16 :1
```
   * to connect tigervnc client to server over secured and encrypted SSH tunnel
   * to enter or exit full screen mode push "F8" to show menu and "f" or click "full screen"
   * you will be asked for VNC password from previous step
```
ssh -L 5901:127.0.0.1:5901 -N -f user@hostname && xtigervncviewer -FullscreenSystemKeys=1 -MenuKey=F8 -RemoteResize=1 -FullScreen=0 localhost:5901 ; exit
```
