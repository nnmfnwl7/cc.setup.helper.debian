**To download and build wallets from official repositories:**
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

**help tips**
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