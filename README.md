# Secure and Private Crypto-wallets Setup-helper-scripts for Debian GNU/Linux

## About

Crypto currency(cc) wallets and daemons management could be time consuming task,
so here this project comes:
   * Easy to `prepare` fresh installed `machine` or virtual machine for cc GUI wallets or CLI daemons
   * Easy to manage `multiple wallet versions`
   * Easy to manage `multiple blockchain directories`
   * Easy to manage `multiple wallet.dat files`
   * Easy to make and `share custom build configurations` between developers, testers,...
   * Easy to `make custom profiles` by changing few lines of configuration
   * Easy to `setup Blocknet+XBridge+DxBot+trading/liquidity-Strategy`
   * Easy to setup `private, opensource and decetralized liquidity pools` that directly doing atomic-swaps between native wallets like BTC-LTC, DOGE-LTC...
   * Whole build process and wallet security `protection by firejail sandbox`
   * Whole build process and wallet `network privacy protection by TOR`
   * Easy to `test untrusted wallets in secured environment` because build-in system/network protection
   * And little bit more

## Basic Step By Step Linux Setup Tutorial

1. At first need to update system and install git:
   * estimated time on very slow machine few minutes
```
su - -c "apt update; apt full-upgrade; apt install git; exit"
```

2. Create root directory(~/Downloads/ccwallets) and download all cc.setup.helper.debian
   * estimated time on very slow machine 1 minute
```
mkdir -p ~/Downloads/ccwallets/cc.setup.helper.debian \
&& cd ~/Downloads/ccwallets/cc.setup.helper.debian \
&& git clone https://github.com/nnmfnwl7/cc.setup.helper.debian.git ./
```

3. To install common software dependencies
   * estimated time on very slow machine few minutes
   * firejail - sandboxing tool, to run wallets isolated from other programs/wallets/user files, also limited system calls, enabled by default
   * tor - TCP privacy routing layer
   * proxychains - useful tool to force application to make all TCP over TOR, enabled by default
```
./setup.dependencies.common.sh
```
   * Proxychains configuration update is needed
   * to allow localhost access
   * to update SOCKS version 4 to 5
```
./setup.cfg.proxychains.sh install
```
   * Need allow user to use tor
```
su - -c "usermod -a -G debian-tor ${USER}; exit"
```

4. If you need install software dependencies for graphical user interface wallets
   * estimated time on very slow machine few minutes
```
./setup.dependencies.GUI.sh
```

5. If you need install advanced tools like:
   * estimated time on very slow machine few minutes
   * GNU screen - for management with remote console
   * vnc server - for management with remote desktop
   
```
./setup.dependencies.tools.sh
```

## Basic Step By Step Blocknet Ecosystem Setup Tutorial

6. To download and build some wallets:
   * estimated time on very slow machine ~30 minutes per one wallet
   * build process is securely sandboxed and privacy protected by proxychains(tor)
```
./setup.cc.main.sh ./src/cfg.cc.blocknet.sh install
./setup.cc.main.sh ./src/cfg.cc.litecoin.sh install
./setup.cc.main.sh ./src/cfg.cc.bitcoin.sh install
./setup.cc.main.sh ./src/cfg.cc.verge.sh install
./setup.cc.main.sh ./src/cfg.cc.dogecoin.sh install
./setup.cc.main.sh ./src/cfg.cc.pivx.sh install
./setup.cc.main.sh ./src/cfg.cc.dash.sh install
./setup.cc.main.sh ./src/cfg.cc.lbrycrd.leveldb.sh install
./setup.cc.main.sh ./src/cfg.cc.lbrycrd.sqlite.sh install
./setup.cc.main.sh ./src/cfg.cc.pocketcoin.sh install
```
   * in certain cases download error could happen, because of used proxychains
   * for this case try again by replacing "install" with "continue"
```
./setup.cc.main.sh ./src/cfg.cc.<wallet name>.sh continue
```
   * if download problem persist try to add "noproxychains" option to try to download over clear-net
```
./setup.cc.main.sh ./src/cfg.cc.<wallet name>.sh continue noproxychains
```
   * for more information about build script and how to use optional arguments, please read help
```
./setup.cc.main.sh help | less
```

7. To generate or overwrite custom firejail sandboxing run scripts:
   * estimated time on very slow machine 1 minute
   * basic usage:
```
./setup.cc.firejail.sh ./src/cfg.cc.blocknet.sh
./setup.cc.firejail.sh ./src/cfg.cc.litecoin.sh
./setup.cc.firejail.sh ./src/cfg.cc.bitcoin.sh
./setup.cc.firejail.sh ./src/cfg.cc.verge.sh
./setup.cc.firejail.sh ./src/cfg.cc.dogecoin.sh
./setup.cc.firejail.sh ./src/cfg.cc.pivx.sh
./setup.cc.firejail.sh ./src/cfg.cc.dash.sh
./setup.cc.firejail.sh ./src/cfg.cc.lbrycrd.leveldb.sh
./setup.cc.firejail.sh ./src/cfg.cc.lbrycrd.sqlite.sh
./setup.cc.firejail.sh ./src/cfg.cc.pocketcoin.sh
```
   * for more information about firejail script and how to use optional arguments, please read help
```
./setup.cc.firejail.sh ... help | less
```

8. To setup dxbot strategy for custom trading pair:
   * estimated time on very slow machine 1 minute
   * blocknet/maker/taker wallet configuration will be updated if needed
   * blocknet xbridge configuration will be updated if needed
   * dxmakerbot will be downloaded if needed
   * dependencies for running dxmakerbot will be installed if needed
   * finally dxmakerbot custom strategy and run scripts will be created
   
   * following first command: is to setup custom blocknet(xbridge handler) with blocknet(as trading pair maker) with litecoin(as trading pair taker) with dxmakerbot alfa version and predefined strategy for block.ltc named as test1 strategy set up on addresses blocknet01 and litecoin01
```
./setup.cc.dxbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dxbot.alfa.sh ./src/cfg.strategy.block.ltc.sh test1      blocknet01   litecoin01
./setup.cc.dxbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.bitcoin.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dxbot.alfa.sh ./src/cfg.strategy.btc.ltc.sh test1         bitcoin01    litecoin02
./setup.cc.dxbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.verge.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dxbot.alfa.sh ./src/cfg.strategy.xvg.ltc.sh test1           verge01      litecoin03
./setup.cc.dxbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.dogecoin.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dxbot.alfa.sh ./src/cfg.strategy.doge.ltc.sh test1       dogecoin01   litecoin04
./setup.cc.dxbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.pivx.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dxbot.alfa.sh ./src/cfg.strategy.pivx.ltc.sh test1           pivx01       litecoin05
./setup.cc.dxbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.dash.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dxbot.alfa.sh ./src/cfg.strategy.dash.ltc.sh test1           dash01       litecoin06
./setup.cc.dxbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.lbrycrd.leveldb.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dxbot.alfa.sh ./src/cfg.strategy.lbc.ltc.sh test1 lbrycrd01    litecoin07
./setup.cc.dxbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.pocketcoin.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dxbot.alfa.sh ./src/cfg.strategy.pkoin.ltc.sh test1    pocketcoin01 litecoin08
```
   * for more information about dxbot script and how to use optional arguments, please read help
```
./setup.cc.dxbot.sh ... help | less
```

## Basic Step By Step Management With Remote Console

9. Hints how to remotely manage multiple console-interface-wallets(daemons) with GNU-screen + some basic navigation shortcuts for GNU-screen:
   * connect to remote machine by ssh(please replace "user" and "hostname" with real values)
```
ssh user@hostname
```
   * reconnect to actual or create new screen session
```
screen -R
```
   * some GNU-screen shortcuts and navigation between tabs to manage multiple console apps at same time:
```
* to detach from screen session(apps will keep running in backround)    CTRL + a + d
* to create new screen "tab"    CTRL + a + c
* to list and select screen "tab"    CTRL + a + "
* to go next tab    CTRL + a + n
* to go previous tab    CTRL + a + p
* to show screen help    CTRL + a + ?
* to rename screen tab    CTRL + a + A   
* to move screen tab to position 1    CTRL + a + :number 1 + ENTER
```
   * to start ie: blocknet wallet daemon securely sandboxed:
```
~/Downloads/ccwallets/blocknet && ./firejail.blocknet.wallet_block.d.bin.sh
```
   * to start ie: blocknet cli sandbox:
```
~/Downloads/ccwallets/blocknet && ./firejail.blocknet.wallet_block.cli.bin.sh
```
   * to execute CLI RPC call in actual cli sandxbox by predefined command:
```
./cli <rpc command... like help>
```
   * to show and easy use predefined cli commands for actual cli sandbox type ./ and autocomplete by TAB TAB key
```
./ TAB TAB
```

## Basic Step By Step Management With Remote Desktop

10. Hints how to remote desktop management with VNC:
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
   * (please replace "user" and "hostname" with real values)
```
ssh -L 5901:127.0.0.1:5901 -N -f user@hostname && xtigervncviewer -FullscreenSystemKeys=1 -MenuKey=F8 -RemoteResize=1 -FullScreen=0 localhost:5901 ; exit
```
## Advanced Examples Of Usage

11. How to generate 2 more pivx wallet run scripts, first for staking, second for blockdx liquidity to run em at same time:
   * first wallet designed for blockdx trading will be using default blockchain directory "~/.pivx/" and wallet.dat file as "wallet_pivx_blockdx" and firejail run script named with suffix "_blockdx"
   * second wallet designed for staking will be using custom blockchain directory "~/.pivx_staking" and wallet dat file "wallet_pivx_staking" and firejail run script named with suffix "_staking"
```
./setup.cc.firejail.sh ./src/cfg.cc.pivx.sh ~/Downloads/ccwallets/pivx/ ~/.pivx/ wallet_pivx_blockdx
./setup.cc.firejail.sh ./src/cfg.cc.pivx.sh ~/Downloads/ccwallets/pivx/ ~/.pivx_staking/ wallet_pivx_staking
```
   * after generating run script, to run GUI/DAEMON/CLI for staking wallet:
```
cd ~/Downloads/ccwallets/pivx/
./firejail.wallet_pivx_staking.qt.bin.sh
./firejail.wallet_pivx_staking.d.bin.sh
./firejail.wallet_pivx_staking.cli.bin.sh
```
   * after generating run script, to run GUI/DAEMON/CLI for blockdx liquidity wallet:
```
cd ~/Downloads/ccwallets/pivx/
./firejail.wallet_pivx_blockdx.qt.bin.sh
./firejail.wallet_pivx_blockdx.d.bin.sh
./firejail.wallet_pivx_blockdx.cli.bin.sh
```
   * so fast so simple, cheers.

## Some Other Useful predefined cli commands

12. For every firejail generated script for combination of wallet.version+blockchain.dir+wallet.dat there is always generated list of specific predefined CLI RPC commands like:

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

## Basic Step By Step Whole Ecosystem Startup Automatization Examples

13. Manual gnu screen and all stuff around initialization could take some time, so How to start user predefined ecosystem in GNU-screen with just copy pasting commands or saving like shell script for whatever even automatic startup...???

   * at first we need to start GNU-screen session named let say "cryptostuff" and one window/tab named let say "uptime" used for static system analysis.
   * IF YOU WANT FROM `SCREEN SESSION ABILITY TO SUPPORT AND START GUI WALLETS ALSO`, THIS INITIAL SCREEN START COMMAND MUST BE CALLED INSIDE GRAPHICAL USER INTERFACE SESSION OR INSIDE IE. VNC SESSION. So should not be called within classic SSH session.
   * Do not call this command twice it will start another screen session with same name. In case just connect by `screen -r sessionname` and quit it by ie `crtl+d`
```
screen -dmS "cryptostuff" -t "uptime"
```
   * use screen window/tab named "uptime" as for operating system/storage/temp/network status overview. This will enter and execute two commands inside this window/tab
```
gssn='cryptostuff' # gnu screen session name
gswt='uptime' # gnu screen window/tab title/name

screen -S ${gssn} -p "${gswt}" -X stuff 'sensors\n'
screen -S ${gssn} -p "${gswt}" -X stuff 'uptime; free -mh; df -h | grep -e "Size" -e " /$" -e "boot" -e "home"; sensors | grep -e temp -e Core -e Composite; /sbin/ifconfig | grep packets\n'
```
   * create new screen window/tab named like "htop" and run htop command for realtime system analysis
```
gswt='htop'
screen -drS ${gssn} -X screen -t "${gswt}"
screen -S ${gssn} -p "${gswt}" -X stuff 'htop\n'
```
   * create new screen window/tab named "cc.setup.helper.debian" reserved as own cc.setup.helper later management
```
gswt='cc.setup.helper.debian'
screen -drS ${gssn} -X screen -t "${gswt}"
screen -S ${gssn} -p "${gswt}" -X stuff 'cd ~/Downloads/ccwallets/cc.setup.helper.debian/\n'
screen -S ${gssn} -p "${gswt}" -X stuff 'ls -la\n'

```
   * create new screen tab named 'blocknet staking', run firejail protected QT wallet inside this tab for this specific previously generated 'blocknet staking wallet instance'
   * also screen tab 'blocknet staking cli', run firejail protected CLI inside this tab for this specific previously generated 'blocknet staking wallet instance'
```
gswt='blocknet.staking'
screen -drS ${gssn} -X screen -t "${gswt}"
screen -S ${gssn} -p "${gswt}" -X stuff 'cd ~/Downloads/ccwallets/blocknet/blocknet/\n'
screen -S ${gssn} -p "${gswt}" -X stuff './firejail.blocknet.wallet_block_staking.qt.bin.sh\n'

gswt='blocknet.staking.cli'
screen -drS ${gssn} -X screen -t "${gswt}"
screen -S ${gssn} -p "${gswt}" -X stuff 'cd ~/Downloads/ccwallets/blocknet/\n'
screen -S ${gssn} -p "${gswt}" -X stuff './firejail.blocknet.wallet_block_staking.cli.bin.sh\n'
```
   * 'pocketcoin staking' tab...
   * 'pocketcoin staking cli' tab...
```
gswt='pocketcoin.staking'
screen -drS ${gssn} -X screen -t "${gswt}"
screen -S ${gssn} -p "${gswt}" -X stuff 'cd ~/Downloads/ccwallets/pocketcoin/sqlite/\n'
screen -S ${gssn} -p "${gswt}" -X stuff './firejail.blocknet.wallet_pkoin_staking.qt.bin.sh\n'

gswt='pocketcoin.staking.cli'
screen -drS ${gssn} -X screen -t "${gswt}"
screen -S ${gssn} -p "${gswt}" -X stuff 'cd ~/Downloads/ccwallets/pocketcoin/sqlite/\n'
screen -S ${gssn} -p "${gswt}" -X stuff './firejail.blocknet.wallet_pkoin_staking.cli.bin.sh\n'
```
   * 'blocknet' tab running blocknet qt wallet, block wallet version with multi-pair-dxbot xbrodge API support
   * 'blocknet cli' tab running blocknet cli, block wallet version with multi-pair-dxbot xbrodge API support
```
gswt='blocknet'
screen -drS ${gssn} -X screen -t "${gswt}"
screen -S ${gssn} -p "${gswt}" -X stuff 'cd ~/Downloads/ccwallets/blocknet/blocknet.qa/\n'
screen -S ${gssn} -p "${gswt}" -X stuff './firejail.blocknet.wallet_block_dex.qt.bin.sh\n'

gswt='blocknet.cli'
screen -drS ${gssn} -X screen -t "${gswt}"
screen -S ${gssn} -p "${gswt}" -X stuff 'cd ~/Downloads/ccwallets/blocknet/blocknet.qa/\n'
screen -S ${gssn} -p "${gswt}" -X stuff './firejail.blocknet.wallet_block_dex.cli.bin.sh\n'
```
   * 'bitcoin' tab
   * 'bitcoin cli' tab
```
gswt='bitcoin'
screen -drS ${gssn} -X screen -t "${gswt}"
screen -S ${gssn} -p "${gswt}" -X stuff 'cd ~/Downloads/ccwallets/bitcoin/\n'
screen -S ${gssn} -p "${gswt}" -X stuff './firejail.bitcoin.wallet_btc_dex.qt.bin.sh\n'

gswt='bitcoin.cli'
screen -drS ${gssn} -X screen -t "${gswt}"
screen -S ${gssn} -p "${gswt}" -X stuff 'cd ~/Downloads/ccwallets/bitcoin/\n'
screen -S ${gssn} -p "${gswt}" -X stuff './firejail.bitcoin.wallet_btc_dex.cli.bin.sh\n'
```
   * 'litecoin' tab
   * 'litecoin cli' tab
```
gswt='litecoin'
screen -drS ${gssn} -X screen -t "${gswt}"
screen -S ${gssn} -p "${gswt}" -X stuff 'cd ~/Downloads/ccwallets/litecoin/\n'
screen -S ${gssn} -p "${gswt}" -X stuff './firejail.litecoin.wallet_ltc_dex.qt.bin.sh\n'

gswt='litecoin.cli'
screen -drS ${gssn} -X screen -t "${gswt}"
screen -S ${gssn} -p "${gswt}" -X stuff 'cd ~/Downloads/ccwallets/litecoin/\n'
screen -S ${gssn} -p "${gswt}" -X stuff './firejail.litecoin.wallet_ltc_dex.cli.bin.sh\n'
```
   * 'dogecoin' tab
   * 'dogecoin cli' tab
```
gswt='dogecoin'
screen -drS ${gssn} -X screen -t "${gswt}"
screen -S ${gssn} -p "${gswt}" -X stuff 'cd ~/Downloads/ccwallets/dogecoin/\n'
screen -S ${gssn} -p "${gswt}" -X stuff './firejail.dogecoin.wallet_doge_dex.qt.bin.sh\n'

gswt='dogecoin.cli'
screen -drS ${gssn} -X screen -t "${gswt}"
screen -S ${gssn} -p "${gswt}" -X stuff 'cd ~/Downloads/ccwallets/dogecoin/\n'
screen -S ${gssn} -p "${gswt}" -X stuff './firejail.dogecoin.wallet_doge_dex.cli.bin.sh\n'
```
   * finally screen tabs for dxbot, named 'BTC LTC', running previously generated dxbot BTC LTC pair script
   * new screen tab, named 'LTC BTC', running previously generated dxbot LTC BTC pair script
```
gswt='BTC.LTC'
screen -drS ${gssn} -X screen -t "${gswt}"
screen -S ${gssn} -p "${gswt}" -X stuff 'cd ~/Downloads/ccwallets/dxbot/\n'
screen -S ${gssn} -p "${gswt}" -X stuff './run.firejail.BTC.LTC.test1.sh\n'

gswt='LTC.BTC'
screen -drS ${gssn} -X screen -t "${gswt}"
screen -S ${gssn} -p "${gswt}" -X stuff 'cd ~/Downloads/ccwallets/dxbot/\n'
screen -S ${gssn} -p "${gswt}" -X stuff './run.firejail.LTC.BTC.test1.sh\n'
```
   * dxbot DOGE LTC pair script
   * dxbot LTC DOGE pair script
```
gswt='DOGE.LTC'
screen -drS ${gssn} -X screen -t "${gswt}"
screen -S ${gssn} -p "${gswt}" -X stuff 'cd ~/Downloads/ccwallets/dxbot/\n'
screen -S ${gssn} -p "${gswt}" -X stuff './run.firejail.DOGE.LTC.test1.sh\n'

gswt='LTC.DOGE'
screen -drS ${gssn} -X screen -t "${gswt}"
screen -S ${gssn} -p "${gswt}" -X stuff 'cd ~/Downloads/ccwallets/dxbot/\n'
screen -S ${gssn} -p "${gswt}" -X stuff './run.firejail.LTC.DOGE.test1.sh\n'
```
   * Now feel free to continue same way with other pairs like `dash`, `lbrycrd`, `pivx`, `verge`...
