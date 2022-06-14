## Basic Step By Step Management With Remote Console with GNU Screen

   * GNU Screen is easy to manage multiple open terminals like Web Browser Tabs
   * How to easy manage multiple console-interface-wallets(daemons)
   * + some basic navigation shortcuts for GNU-screen:
   
   * connect to remote machine by ssh(please replace "user" and "hostname" with real values)
```
ssh user@hostname
```
   * reconnect to actual or create new screen session
```
screen -R
```
   * reconnect to actual already connected screen session multiple times
```
screen -x
```
   * some GNU-screen shortcuts and navigation between tabs to manage multiple console apps at same time:
```
* to detach from screen session(apps will keep running in background)    CTRL + a + d
* to create new screen "tab"    CTRL + a + c
* to list and select screen "tab"    CTRL + a + "
* to go next tab    CTRL + a + n
* to go previous tab    CTRL + a + p
* to cycle last 2 tabs    CTRL + a + a
* to show screen help    CTRL + a + ?
* to rename screen tab    CTRL + a + A
* to move screen tab to position 1    CTRL + a + :number 1 + ENTER
```
