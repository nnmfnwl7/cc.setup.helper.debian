#!/bin/bash

# include tools
source "./src/tools.sh" || exit 1

# showhelp is auto set by tools
if [ "${showhelp}" == "yes" ]; then
    echo ""
    echo "*** ABOUT ***"
    echo ""
    echo "crypto currency firejail sanxboxing setup helper script for Debian based Linux operating systems or subsystems"
    echo ""
    echo "*** USAGE ***"
    echo ""
    echo ""${0}" <path/to/crypto/source/script.sh> <optional arguments>"
    echo ""
    echo "*** ARGUMENTS(mandatory) ***"
    echo ""
    echo "<path/to/crypto/source/script.sh>"
    echo " >> relative or absolute path for valid crypto currency configuration script"
    echo ""
    echo "*** ARGUMENTS(optional) ***"
    echo ""
    echo "<|/path/to/crypto/custom/install/directory/>"
    echo " >> crypto currency intallation root path directory(default specified in config script)"
    echo " >> second path argument is always taken as custom crypto install directory"
    echo ""
    echo "<|/path/to/crypto/custom/blockchain/data/directory/>"
    echo " >> crypto currency blockchain path directory(default specified in config script)"
    echo " >> third path argument is always taken as custom crypto install directory"
    echo " >> it is mandatory to set custom install directory first"
    echo ""
    echo "<|noproxychains>"
    echo " >> by default, generated scripts uses proxychains(by default tor network) to transmit data private way"
    echo " >> noproxychains option is here to disable privacy, also it will speeed up wallet data download/upload process"
    echo ""
    echo "<|wallet_ticker_custom_name>"
    echo " >> custom wallet.dat naming(default is specified in config script, custom must start by word wallet)"
    echo ""
    echo "<|custom_firejail_profile_name_suffix>"
    echo " >> if no custom profile name is specified, wallet_ticker_custom_name or cc-wallet_name_default is used"
    echo " >> to make multiple custom firejail profile names/profiles"
    echo " >> ie: to start multiple wallets with multiple data directories at same time"
    echo " >> ie: to have profiles for multiple wallet dat files"
    echo ""
    echo "example:"
    echo ""${0}" ./setup/setup.cc.blocknet.sh ~/Downloads/ccwallets/blocknet ~/.blocknet wallet_block_dex"
    echo ""${0}" ./setup/setup.cc.blocknet.sh ~/Downloads/ccwallets/blocknet ~/.blocknet_staking wallet_block_staking"
    echo ""
    exit 0
fi

# handle arguments

cc_script_cfg_path=
cc_install_dir_path=
cc_chain_dir_path=
cc_proxychains_default="proxychains -q"
cc_proxychains=${cc_proxychains_default}
cc_wallet_name=
cc_firejail_profile_name_suffix=

(test "${1}" = "") && echo "invalid crypto source script path argument" && exit 1

argc=$#
argv=("$@")

for (( j=1; j<argc; j++ )); do
    if [[ "${argv[j]}" == "noproxychains"* ]]; then
        if [ "${cc_proxychains}" = "${cc_proxychains_default}" ]; then
            cc_proxychains=
            echo "INFO >> proxychains disabled"
        else
            echo "Invalid argument: $j ${argv[j]}"
            exit 1
        fi
    elif [[ "${argv[j]}" == *"/"* ]] ;then
        if [ "${cc_install_dir_path}" = "" ]; then
            cc_install_dir_path="${argv[j]}"
            echo "INFO >> cc install dir path >> ${cc_install_dir_path}"
        elif [ "${cc_chain_dir_path}" = "" ]; then
            cc_chain_dir_path="${argv[j]}"
            echo "INFO >> cc chain dir path >> ${cc_chain_dir_path}"
        else
            echo "Invalid argument: $j ${argv[j]}"
            exit 1
        fi
    elif [[ "${argv[j]}" == "wallet"* ]] ;then
        if [ "${cc_wallet_name}" = "" ]; then
            cc_wallet_name="${argv[j]}"
            echo "INFO >> wallet name >> ${cc_wallet_name}"
        else
            echo "Invalid argument: $j ${argv[j]}"
            exit 1
        fi
    else
        if [ "${cc_firejail_profile_name_suffix}" = "" ]; then
            cc_firejail_profile_name_suffix="${argv[j]}"
            echo "INFO >> firejail profile name >> ${cc_firejail_profile_name_suffix}"
        else
            echo "Invalid argument: $j ${argv[j]}"
            exit 1
        fi
    fi    
done

# include main cc cfg script
cc_script_cfg_path=${1}
tool_realpath cc_script_cfg_path "parameter #1 cc cfg script path"
tool_check_version_and_include_script ${cc_script_cfg_path} "loading cc cfg script" 

tool_variable_check_load_default cc_bin_file_name_prefix "" "cc cfg"
tool_variable_check_load_default cc_gui_cfg_dir_name "" "cc cfg"

# cc install directory
tool_variable_check_load_default cc_install_dir_path cc_install_dir_path_default
tool_realpath cc_install_dir_path
tool_dir_if_notexist_exit cc_install_dir_path "cc install directory"

# cc install directory git source
cc_git_src_path=${cc_install_dir_path}"/git.src"
tool_dir_if_notexist_exit cc_git_src_path "cc install directory git.src"

# cc install directory bin files
cc_bin_path=${cc_install_dir_path}"/bin"
tool_dir_if_notexist_exit cc_bin_path "cc bin files directory"

# prepare cc chain dir path
tool_variable_check_load_default cc_chain_dir_path cc_chain_dir_path_default "cc chain dir path"
tool_realpath cc_chain_dir_path "cc chain dir path"
tool_make_and_check_dir_path cc_chain_dir_path "cc chain dir path"

# check conf file
tool_variable_check_load_default cc_conf_name_default cc_conf_name_default "cc_conf_name_default"

# wallet dat file
tool_variable_check_load_default cc_wallet_name cc_wallet_name_default "wallet dat naming"

# if firejail suffix name is not specified use .cc_wallet_name instead
cc_firejail_profile_name_suffix_tmp="."${cc_wallet_name}
tool_variable_check_load_default cc_firejail_profile_name_suffix cc_firejail_profile_name_suffix_tmp "firejail suffix naming"

# firejail profile file name suffix if custom not exist default will be loaded
cc_firejail_profile_middlename=${cc_bin_file_name_prefix}${cc_firejail_profile_name_suffix}
tool_variable_check_load_default cc_firejail_profile_middlename cc_firejail_profile_middlename "firejail profile name"

# cli command directory for this prefix
cc_cli_dir_name="cli"${cc_firejail_profile_name_suffix}

# change directory where firejail profile templates are

cc_firejail_template_profiles_dir="src"
tool_cd ${cc_firejail_template_profiles_dir} "helper files data dir"

# prepare firejail profile and startup script for firejail sandboxed make script

cc_custombuild_firejail_profile_file_name_src="setup.cc.make.firejail.profile"
cc_custombuild_firejail_profile_file_name_dst="firejail.${cc_bin_file_name_prefix}.dev.env.profile"
echo "INFO >> copy firejail make profile >> ${cc_custombuild_firejail_profile_file_name_dst}"
cp ${cc_custombuild_firejail_profile_file_name_src} ${cc_install_dir_path}"/"${cc_custombuild_firejail_profile_file_name_dst}
(test $? != 0) && echo "ERROR >> copy file >> ${cc_custombuild_firejail_profile_file_name_dst} >> failed" && exit 1

cc_custombuild_script_path=${cc_install_dir_path}"/firejail.${cc_bin_file_name_prefix}.dev.env.sh"
echo "INFO >> create script >> ${cc_custombuild_script_path} >> to start custom build firejail sandbox"
echo "
cd ${cc_git_src_path}
(test $? != 0) && echo \"ERROR >> cd ${cc_git_src_path} >> failed\" && exit 1
firejail --profile=./../${cc_custombuild_firejail_profile_file_name_dst} --whitelist=\`pwd\` bash
(test $? != 0) && echo \"ERROR >> firejail failed\" && exit 1
" > ${cc_custombuild_script_path} && chmod 755 ${cc_custombuild_script_path}
(test $? != 0) && echo "ERROR >> create script >> ${cc_custombuild_script_path} >> failed" && exit 1

# copy and rename firejail templates to cc install directories

firejail_list=`ls | grep firejail.cc_template.`
for f in $firejail_list; do
    new_name=`echo ${f} | sed -e "s+\\\.cc_template\\\.+\\\.${cc_firejail_profile_middlename}\\\.+g"`
    cp ${f} ${cc_install_dir_path}"/"${new_name}
    (test $? != 0) && echo "ERROR >> file >> ${f} >> copy failed" && exit 1
done
echo "INFO >> copy firejail templates"

# update firejail files by cc

tool_cd ${cc_install_dir_path} "cc_install_dir_path"

firejail_list=`ls | grep firejail\\\.${cc_firejail_profile_middlename}\\\.`
for f in $firejail_list; do
    echo "updating "${f}
    sed -i \
        -e "s+{cc_install_dir_path}+${cc_install_dir_path}+g" \
        -e "s+{cc_chain_dir_path}+${cc_chain_dir_path}+g" \
        -e "s+{cc_conf_name_default}+${cc_conf_name_default}+g" \
        -e "s+{cc_bin_file_name_prefix}+${cc_bin_file_name_prefix}+g" \
        -e "s+{cc_firejail_profile_middlename}+${cc_firejail_profile_middlename}+g" \
        -e "s+{cc_cli_dir_name}+${cc_cli_dir_name}+g" \
        -e "s+{cc_gui_cfg_dir_name}+${cc_gui_cfg_dir_name}+g" \
        -e "s+{cc_wallet_name}+${cc_wallet_name}+g" \
        -e "s+{cc_proxychains}+${cc_proxychains}+g" \
        -e "s+{cc_firejail_profile_add}+${cc_firejail_profile_add}+g" \
        ${f}
done
echo "INFO >> update firejail profiles"

# update firejail run scripts permissions

firejail_list=`ls | grep firejail\\\.${cc_firejail_profile_middlename}\\\..*sh`
for f in $firejail_list; do
    chmod 755 ${f}
    (test $? != 0) && echo "ERROR >> file >> ${f} >> chmod 755 failed" && exit 1
done

# make cli command directory and generate all supported commands

function tool_firejail_mk_cli_script() {  #var name filename #var name cmd
    (test "${1}" != "" ) && local filename=`eval echo "\\${${1}}"`
    (test "${2}" != "" ) && local cmd=`eval echo \"\\${${2}}\"`
    
    (test "${filename}" = "" ) && echo "ERROR >> ${FUNCNAME[*]} >> variable >> ${1} >> value >> ${filename} >> load failed" && exit 1
    
    (test "${cmd}" = "" ) && echo "ERROR >> ${FUNCNAME[*]} >> variable >> ${2} >> value >> ${cmd} >> load failed" && exit 1
    
    echo "${cmd}" > "${filename}" && chmod 755 "${filename}"
    (test $? != 0) && echo "ERROR >> ${FUNCNAME[*]} >> ${filename} >> script generate failed" && exit 1
    
    echo "INFO >> ${FUNCNAME[*]} >> script >> ${filename} >> generate success"
}

# make and change to cli dir

tool_make_and_check_dir_path cc_cli_dir_name "cli commands directory"
tool_cd ${cc_cli_dir_name} "cli commands directory"

# gen cli command script
cli_file="cli"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} \$@
"
tool_firejail_mk_cli_script cli_file cli_cmd_full

# gen help command script
cli_file="help"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} help | less
"
tool_firejail_mk_cli_script cli_file cli_cmd_full

# gen unlock unlock wallet old style
cli_file="unlock.full"
cli_id="unlock.old"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} walletpassphrase \"\$(read -sp 'pwd: ' undo; echo \$undo;undo=)\" 9999999999
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen unlock unlock wallet new style
cli_file="unlock.full"
cli_id="unlock.new"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} -stdinwalletpassphrase walletpassphrase 9999999999
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen unlock unlock wallet for staking only
cli_file="unlock.staking.only"
cli_id="unlock.staking.only"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} walletpassphrase \"\$(read -sp 'pwd: ' undo; echo \$undo;undo=)\" 9999999999 true
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen lock wallet
cli_file="lock"
cli_id="lock"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} walletlock
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen stop wallet
cli_file="stop"
cli_id="stop"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} stop
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen basic wallet info
cli_file="getwalletinfo.basic"
cli_id="getwalletinfo.basic"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} getwalletinfo | grep -e balance -e txcount -e unlocked 
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen getstakingstatus
cli_file="getstakingstatus"
cli_id="getstakingstatus"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} getstakingstatus 
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen getstakinginfo for PKOIN
cli_file="getstakinginfo"
cli_id="getstakinginfo"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} getstakinginfo 
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen getstakereport for PKOIN
cli_file="getstakereport"
cli_id="getstakereport"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} getstakereport 
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen getblockchaininfo
cli_file="getblockchaininfo"
cli_id="getblockchaininfo"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} getblockchaininfo
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen getblockchaininfo.basics
cli_file="getblockchaininfo.basics"
cli_id="getblockchaininfo.basics"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} getblockchaininfo | grep -e blocks -e headers -e bestblockhash 
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen getnettotals
cli_file="getnettotals.basics"
cli_id="getnettotals.basics"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} getnettotals | grep -e totalbytes
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen connections count
cli_file="getconnectioncount"
cli_id="getconnectioncount"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} getconnectioncount
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen gte peer info
cli_file="getpeerinfo.basic"
cli_id="getpeerinfo.basic"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} getpeerinfo | grep \"\\\"addr\\\"\" | grep \"\.\"
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen enable network
cli_file="setnetworkactive.true"
cli_id="setnetworkactive.true"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} setnetworkactive true
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen disable network
cli_file="setnetworkactive.false"
cli_id="setnetworkactive.false"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} setnetworkactive false
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen list UTXOs
cli_file="listunspent.basic"
cli_id="listunspent.basic"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} listunspent 0 | grep -e address -e label -e amount -e confirmations
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen list address and balance
cli_file="listaddressgroupings.basic"
cli_id="listaddressgroupings"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} listaddressgroupings | grep -v -e \"\\[\" -e \"\\]\"
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen list address and all time recv
cli_file="listreceivedbyaddress.basic"
cli_id="listreceivedbyaddress"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} listreceivedbyaddress 0 true | grep -e address -e label -e amount
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen list UTXOs
cli_file="dxGetTokenBalances"
cli_id="dxcmdall"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} dxGetTokenBalances
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi


# exit

echo "*** FIREJAIL CC SETUP SUCCESS ***"

exit 0
