#!/bin/bash

# include tools
source "./src/tools.sh" || exit 1

# show help
if [ "${showhelp}" == "yes" ]; then
    echo ""
    echo "*** ABOUT ***"
    echo ""
    echo "crypto currency wallet or daemon setup helper script for Debian based Linux operating systems or subsystems"
    echo ""
    echo "*** USAGE ***"
    echo ""
    echo ""${0}" <path/to/crypto/source/script.sh> <install|update|reinstall> <optional arguments>"
    echo ""
    echo "*** ARGUMENTS(mandatory) ***"
    echo ""
    echo "<path/to/crypto/source/script.sh>"
    echo " >> relative or absolute path for valid crypto currency configuration script"
    echo " >> crypto config scripts are stored as ./src/cfg.cc.***.sh "
    echo ""
    echo "<install|update|reinstall|continue>"
    echo " >> install >> action for new installation"
    echo " >> update >> action to try clean,update and rebuild source"
    echo " >> reinstall >> action for source code to be removed and recompiled from scratch"
    echo " >> continue >> action to try continue in previously canceled installation"
    echo ""
    echo "*** ARGUMENTS(optional) ***"
    echo ""
    echo "<|/path/to/crypto/custom/install/directory/>"
    echo " >> crypto currency intallation root path directory(default specified in config script like ~/Downloads/ccwallets/***)"
    echo " >> second path argument is always taken as custom crypto install directory"
    echo ""
    echo "<|nofirejail>"
    echo " >> by default whole build process is done in firejail(secured sandbox environment to prevent malicious activities or data leak)"
    echo " >> nofirejail option is here to disable sanboxing"
    echo " >> it is NOT recommended to use this option"
    echo ""
    echo "<|noproxychains>"
    echo " >> by default, build process uses proxychains(by default tor network) to transmit data private way"
    echo " >> noproxychains option is here to disable privacy, also it will speeed up data downloading process"
    echo ""
    echo "examples:"
    echo ""${0}" ./setup/setup.cc.blocknet.sh install"
    echo ""${0}" ./setup/setup.cc.blocknet.sh install ~/Downloads/ccwallets/blocknet nofirejail noproxychains"
    echo ""
    exit 0
fi

# handle arguments

cc_script_cfg_path=
cc_action=
cc_firejail_default="firejail"
cc_firejail=${cc_firejail_default}
cc_proxychains_default="proxychains -q"
cc_proxychains=${cc_proxychains_default}
cc_install_dir_path=

argc=$#
argv=("$@")

for (( j=1; j<argc; j++ )); do
    if [ "${argv[j]}" = "nofirejail" ]; then
        if [ "${cc_firejail}" = "${cc_firejail_default}" ]; then
            cc_firejail=
            echo "INFO >> firejail disabled"
        else
            echo "Invalid argument: $j ${argv[j]}"
            exit 1
        fi
    elif [ "${argv[j]}" = "noproxychains" ]; then
        if [ "${cc_proxychains}" = "${cc_proxychains_default}" ]; then
            cc_proxychains=
            echo "INFO >> proxychains disabled"
        else
            echo "Invalid argument: $j ${argv[j]}"
            exit 1
        fi
    elif [ "${argv[j]}" = "install" ]; then
        if [ "${cc_action}" = "" ]; then
            cc_action="install"
            echo "INFO >> install enabled"
        else
            echo "Invalid argument: $j ${argv[j]}"
            exit 1
        fi
    elif [ "${argv[j]}" = "update" ]; then
        if [ "${cc_action}" = "" ]; then
            cc_action="update"
            echo "INFO >> update enabled"
        else
            echo "Invalid argument: $j ${argv[j]}"
            exit 1
        fi
    elif [ "${argv[j]}" = "reinstall" ]; then
        if [ "${cc_action}" = "" ]; then
            cc_action="reinstall"
            echo "INFO >> reinstall enabled"
        else
            echo "Invalid argument: $j ${argv[j]}"
            exit 1
        fi
    elif [ "${argv[j]}" = "continue" ]; then
        if [ "${cc_action}" = "" ]; then
            cc_action="continue"
            echo "INFO >> continue enabled"
        else
            echo "Invalid argument: $j ${argv[j]}"
            exit 1
        fi
    elif [[ "${argv[j]}" == *"/"* ]] ;then
        if [ "${cc_install_dir_path}" = "" ]; then
            cc_install_dir_path="${argv[j]}"
            echo "INFO >> cc install dir path >> ${cc_install_dir_path}"
        else
            echo "Invalid argument: $j ${argv[j]}"
            exit 1
        fi
    else
        echo "Invalid argument: $j ${argv[j]}"
        exit 1
    fi
done

tool_time_start

# include main cc cfg script
cc_script_cfg_path=${1}
tool_realpath cc_script_cfg_path "parameter #1 cc cfg script path"
tool_check_version_and_include_script ${cc_script_cfg_path} "loading cc cfg script" 

tool_variable_check_load_default cc_bin_file_name_prefix "" "cc cfg"

# check make script exist
cc_script_make_path="./src/setup.cc.make.sh"
tool_realpath cc_script_make_path "make script path"
tool_file_if_notexist_exit ${cc_script_make_path} "make script path"

# prepare install directory path
tool_variable_check_load_default cc_install_dir_path cc_install_dir_path_default
tool_realpath cc_install_dir_path "cc install dir path"
tool_make_and_check_dir_path cc_install_dir_path "cc install dir path"

# prepare binary files path
cc_bin_path=${cc_install_dir_path}"/bin"
tool_make_and_check_dir_path cc_bin_path "binary files dir"

# prepare git source files path
cc_git_src_path=${cc_install_dir_path}"/git.src"
echo "INFO >> using cc_git_src_path >> ${cc_git_src_path}"

if [ "${cc_action}" = "install" ]; then
    (test -d "${cc_git_src_path}") && echo "ERROR >> git source files >> ${cc_git_src_path} >> already exist, please choose update|reinstall|continue argument" && exit 1
    mkdir -p "${cc_git_src_path}"
    (test $? != 0) && echo "ERROR >> git source directory >> ${cc_git_src_path} >> make failed" && exit 1
    echo "INFO >> using cc_action >> ${cc_action}"
    
elif [ "${cc_action}" = "reinstall" ]; then
    (test ! -d "${cc_git_src_path}") && echo "ERROR >> git source files >> ${cc_git_src_path} >> do not exist, please use install argument" && exit 1
    rm -rfv "${cc_git_src_path}"
    (test $? != 0) && echo "ERROR >> git source directory >> ${cc_git_src_path} >> remove failed" && exit 1
    mkdir -p "${cc_git_src_path}"
    (test $? != 0) && echo "ERROR >> git source directory >> ${cc_git_src_path} >> make failed" && exit 1
    echo "INFO >> using cc_action >> ${cc_action}"
    
elif [ "${cc_action}" = "update" ]; then
    (test ! -d "${cc_git_src_path}") && echo "ERROR >> git source directory >> ${cc_git_src_path} >> do not exist, please use install argument" && exit 1
    echo "INFO >> using cc_action >> ${cc_action}"
    
elif [ "${cc_action}" = "continue" ]; then
    mkdir -p "${cc_git_src_path}"
    (test $? != 0) && echo "ERROR >> git source directory >> ${cc_git_src_path} >> make failed" && exit 1
    echo "INFO >> using cc_action >> ${cc_action}"
else
    echo "ERROR >> action<install|update|reinstall> not specified"
    exit 1
fi

# run checkout and build script

if [ "${cc_firejail}" != "" ]; then
    # process securely sandboxed by firejail
    cc_firejail_make_args_expand=`eval echo ${cc_firejail_make_args}`
    firejail --profile=./src/setup.cc.make.firejail.profile \
        --whitelist=`pwd` --read-only=`pwd` \
        --whitelist=${cc_git_src_path} \
        ${cc_firejail_make_args_expand} \
            ${cc_script_make_path} ${cc_script_cfg_path} ${cc_action} ${cc_git_src_path} "${cc_proxychains}"
    (test $? != 0) && echo "ERROR >> checkout and build script failed" && exit 1
else
            # process not sandboxed
            ${cc_script_make_path} ${cc_script_cfg_path} ${cc_action} ${cc_git_src_path} "${cc_proxychains}"
    (test $? != 0) && echo "ERROR >> checkout and build script failed" && exit 1
fi

# copy binary files

cp -u ${cc_git_src_path}"/src/"${cc_bin_file_name_prefix}d ${cc_bin_path}"/"${cc_bin_file_name_prefix}.d.bin
(test $? != 0) && echo "ERROR >> file >> ${cc_bin_file_name_prefix} >> copy failed" && exit 1
echo "INFO >> copy daemon file to bin >> ./bin/${cc_bin_file_name_prefix}.d.bin"

cp -u ${cc_git_src_path}"/src/"${cc_bin_file_name_prefix}-cli ${cc_bin_path}"/"${cc_bin_file_name_prefix}.cli.bin
(test $? != 0) && echo "ERROR >> file >> ${cc_bin_file_name_prefix}-cli >> copy failed" && exit 1
echo "INFO >> copy cli file to bin >> ./bin/${cc_bin_file_name_prefix}.cli.bin"

cp -u ${cc_git_src_path}"/src/qt/"${cc_bin_file_name_prefix}-qt ${cc_bin_path}"/"${cc_bin_file_name_prefix}.qt.bin || cp -u ${cc_git_src_path}"/src/"${cc_bin_file_name_prefix}-qt ${cc_bin_path}"/"${cc_bin_file_name_prefix}.qt.bin
(test $? != 0) && echo "WARNING >> file >> ${cc_bin_file_name_prefix}-qt >> copy failed" \
|| echo "INFO >> copy cli file to bin >> ./bin/${cc_bin_file_name_prefix}.qt.bin"

# check by av if present

clamscan_path="/usr/bin/clamscan"
if [ -f "${clamscan_path}" ]; then
    echo "INFO >> using clamscan_path >> ${clamscan_path}"
    ${clamscan_path} --no-summary ${cc_bin_path}"/"*
    (test $? != 0) && echo "ERROR >> AV SCAN >> ${clamscan_path} ${cc_bin_path}/* >> FAILED" && rm ${cc_bin_path}"/"* && exit 1
    echo "INFO >> AV SCAN >> ${cc_bin_path}/* >> success"
fi

echo "*** MAIN CC SETUP SUCCESS ***"

tool_time_finish_print

exit 0
