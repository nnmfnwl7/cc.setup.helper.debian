cc_setup_helper_version="20210827"

cc_ticker="PIVX"
cc_bin_file_name_prefix="pivx"
cc_gui_cfg_dir_name="PIVX"

cc_install_dir_path_default="~/Downloads/ccwallets/pivx"
cc_chain_dir_path_default="~/.pivx"
cc_wallet_name_default="wallet_pivx"
cc_conf_name_default="pivx.conf"


export CC=clang
export CXX=clang++

cc_firejail_make_args='
--mkdir=$HOME/.pivx-params 
--noblacklist=$HOME/.pivx-params 
--whitelist=$HOME/.pivx-params 
'

cc_firejail_profile_add='mkdir ${HOME}/.pivx-params\nnoblacklist ${HOME}/.pivx-params\nwhitelist ${HOME}/.pivx-params'

cc_git_src_url="https://github.com/PIVX-Project/PIVX.git"
cc_git_src_branch="v5.4.0"
cc_git_commit_id="e05705aea04fab82d3c2026c01aecc84a69ac71d"

cc_make_cpu_threads=4

cc_make_depends="bdb"

cc_command_configure='
./configure --quiet
LDFLAGS="-L`pwd`/depends/${cc_archdir}/lib/"
CPPFLAGS="-I`pwd`/depends/${cc_archdir}/include/"
CXXFLAGS="-O3 -march=native"

--disable-bench --disable-gui-tests --disable-tests
--enable-reduce-exports --without-miniupnpc --without-zmq
--with-gui=auto
'

# HINT >> add to above configure parameter to compile with debug symbols >>
# --enable-debug

cc_command_pre_make='
'

cc_command_post_make='
./params/install-params.sh
'

# conf file will scanned and comment existing conflist lines
# config to add be be line by line evaluated and added

cc_port=52472
cc_rpcport=52473
cc_rpcuser="BlockDXPIVX"
cc_rpcpassword=`cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 32 | head -n 1`

# lines will eval before add
cc_main_cfg_add='
listen=1
server=1

rpcbind=127.0.0.1
rpcallowip=127.0.0.1
port=${cc_port}
rpcport=${cc_rpcport}
rpcuser=${cc_rpcuser}
rpcpassword=${cc_rpcpassword}
txindex=1

bantime=180

maxuploadtarget=1500
'

cc_xbridge_cfg_add='
Title=PIVX
Address=
Ip=127.0.0.1
Port=${cc_rpcport}
Username=${cc_rpcuser}
Password=${cc_rpcpassword}
AddressPrefix=30
ScriptPrefix=13
SecretPrefix=212
COIN=100000000
MinimumAmount=0
TxVersion=1
DustAmount=0
CreateTxMethod=BTC
GetNewKeySupported=false
ImportWithNoScanSupported=true
MinTxFee=10000
BlockTime=60
FeePerByte=20
Confirmations=0
'

# list of incompatible CLI commands surrounded with spaces
cc_cli_not_compatible='
 unlock.new 
 getstakinginfo 
 getstakereport 
'
