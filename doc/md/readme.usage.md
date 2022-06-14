## Basic Files Structure understanding and usage
   
   * By default all files are stored in:
```
~/Downloads/ccwallets/
```

   * to start ie: blocknet wallet daemon securely sandboxed:
```
~/Downloads/ccwallets/blocknet && ./firejail.blocknet.wallet_block.d.bin.sh
```

   * to start ie: blocknet cli sandbox:
```
~/Downloads/ccwallets/blocknet && ./firejail.blocknet.wallet_block.cli.bin.sh
```

   * For every firejail generated CLI script for combination of wallet.version+blockchain.dir+wallet.dat there is always generated list of specific predefined CLI RPC commands like:
   * to show and easy use predefined cli commands for actual cli sandbox type ./ and autocomplete by TAB TAB key
```
./ TAB TAB
```

   * to execute CLI RPC call in actual cli sandxbox by predefined command:
```
./cli <rpc command... like help>
```

   * list all commands(Q to exit, / to search, n find next):
   * `help | less`:
```
./help
```
   * unlock wallet fully /unlock for staking only /lock wallet:
   * `walletpassphrase "$(read -sp "pwd: " undo; echo $undo;undo=)" 9999999999`
```
./unlock.full
./unlock.staking
./lock
```
   * unlock wallet fully and most secure way(supported only by NEW RPC CLIENTS LIKE BITCOIN)
   * `-stdinwalletpassphrase walletpassphrase`
```
./unlock.full
```
   * show basic info about wallet
   * `getwalletinfo | grep -e balance -e txcount -e unlocked`
```
./getwalletinfo.basic
```
   * show staking information
   * `getstakingstatus`
```
./getstakingstatus
```
   * show basic blockchain information
   * `getblockchaininfo | grep -e blocks -e headers -e bestblockhash`
```
./getblockchaininfo.basic
```
   * show UPLOAD / DOWNLOAD data information
   * `getnettotals | grep -e totalbytes`
```
./getnettotals.basics
```
   * show number of active connections
   * `getconnectioncount`
```
./getconnectioncount
```
   * disable or enable network
   * `setnetworkactive true/false`
```
./setnetworkactive.true
./setnetworkactive.false
```
   * show connected nodes:
   * `getpeerinfo | grep "\"addr\"" | grep "\."`
```
./getpeerinfo.basic
```
   * show list of all wallet UTXOs:
   * `listunspent 0 | grep -e address -e label -e amount -e confirmations`
```
./listunspent.basic
```
   * list all generated addresses and all time received balances:
   * `listreceivedbyaddress 0 true | grep -e address -e label -e amount`
```
./listreceivedbyaddress.basic
```
   * list addresses and actual balances:
   * `listaddressgroupings | grep -v -e "\[" -e "\]"`
```
./listaddressgroupings.basic
```
   * stop wallet:
   * `stop`
```
./stop
```
