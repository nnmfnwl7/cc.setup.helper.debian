## Basic Step By Step Whole Ecosystem Startup Semi/+Automatization Examples

**Manual gnu screen and all stuff around initialization could take some time, so How to start user predefined ecosystem in GNU-screen with just copy pasting commands or saving like shell script for whatever even automatic startup...???**

   * at first we need to start GNU-screen session named let say "cryptostuff" and one window/tab named let say "uptime" used for static system analysis.
   * IF YOU WANT FROM `SCREEN SESSION ABILITY TO SUPPORT AND START GUI WALLETS ALSO`, THIS INITIAL SCREEN START COMMAND MUST BE CALLED INSIDE GRAPHICAL USER INTERFACE SESSION OR INSIDE IE. VNC SESSION. So should not be called within classic SSH session because that will not export GUI environment variables so will not be able to detect display used for GUI apps.
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

## Autostart Right After Pc Restart With Crontab

   * At first choose lines from above GNU Screen startup automatization
   * and save it all in file:
```
~/ccwallets.autostart.sh
```

   * Run command
```
crontab -e
```

   * And add line, but replace `username` with real user login name
```
@reboot bash /home/username/ccwallets.autostart.sh
```
