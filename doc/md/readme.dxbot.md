**To setup dxbot strategy for custom trading pair:**
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
