## Project source files copy and Operating system dependencies setup

**Update system and install git:**
   * estimated time on very slow machine few minutes
```
su - -c "apt update; apt full-upgrade; apt install git; exit"
```

**Create root directory(~/Downloads/ccwallets) and download all cc.setup.helper.debian**
   * estimated time on very slow machine 1 minute
```
mkdir -p ~/Downloads/ccwallets/cc.setup.helper.debian \
&& cd ~/Downloads/ccwallets/cc.setup.helper.debian \
&& git clone https://github.com/nnmfnwl7/cc.setup.helper.debian.git ./
```

**To install common software dependencies**
   * estimated time on very slow machine few minutes
   * firejail - sandboxing tool, to run wallets isolated from other programs/wallets/user files, also limited system calls, enabled by default
   * tor - TCP privacy routing layer
   * proxychains - useful tool to force application to make all TCP over TOR, enabled by default
```
./setup.dependencies.common.sh
```

**Proxychains configuration file update**
   * update file ~/proxychains/proxychains.conf
   * to allow localhost access
   * to update SOCKS version 4 to 5
```
./setup.cfg.proxychains.sh install
```

**Update user permissions to use tor**
```
su - -c "usermod -a -G debian-tor ${USER}; exit"
```

**If you need install software dependencies for graphical user interface wallets**
   * estimated time on very slow machine few minutes
```
./setup.dependencies.GUI.sh
```

**If you need install advanced tools like:**
   * estimated time on very slow machine few minutes
   * GNU screen - for management with remote console
   * vnc server - for management with remote desktop
   
```
./setup.dependencies.tools.sh
```
