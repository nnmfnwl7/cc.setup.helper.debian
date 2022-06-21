#!/bin/bash

# include tools
source "./src/tools.sh" || exit 1
source "./src/tools.dxbot.sh" || exit 1

# show help
tool_dxbot_show_help

# handle arguments
cc_script_cfg_path_block=${1}
cc_script_cfg_path_maker=${2}
cc_script_cfg_path_taker=${3}
cc_script_cfg_path_dxbot=${4}
cc_script_cfg_path_strategy=${5}
cc_action_source=
cc_action_cc_config=
cc_action_xb_config=
cc_action_strategy=
cc_firejail_default="firejail"
cc_firejail=${cc_firejail_default}
cc_proxychains_default="proxychains -q"
cc_proxychains=${cc_proxychains_default}
cc_dxbot_install_dir_path=
cc_chain_dir_path_blocknet=
cc_chain_dir_path_maker=
cc_chain_dir_path_taker=
cc_conf_name_blocknet=
cc_conf_name_maker=
cc_conf_name_taker=
cc_dxbot_naming_suffix=
cc_address_maker=
cc_address_taker=

tool_realpath cc_script_cfg_path_block "parameter #1 block"
tool_realpath cc_script_cfg_path_maker "parameter #2 maker"
tool_realpath cc_script_cfg_path_taker "parameter #3 taker"
tool_realpath cc_script_cfg_path_dxbot "parameter #4 dxbot"
tool_realpath cc_script_cfg_path_strategy "parameter #5 strategy"

(test "${cc_script_cfg_path_maker}" = "${cc_script_cfg_path_taker}") && echo "ERROR >> maker and taker argument can not be the same" && exit 1

argc=$#
argv=("$@")
tool_dxbot_process_arguments ${argc} ${argv}




# version to check...
cc_setup_helper_version="20210827"

# update blocknet blockchain and xbridge configuration
tool_dxbot_update_cc_cfg_xb_cfg ${1} "blocknet"

# backup some blocknet variables for later usage in dxbot strategy config
cc_localhost="127.0.0.1"
tool_variable_check_load_default cc_rpcuser_block_bak cc_rpcuser
tool_variable_check_load_default cc_rpcpassword_block_bak cc_rpcpassword
tool_variable_check_load_default cc_rpchostname_block_bak cc_localhost
tool_variable_check_load_default cc_rpcport_block_bak cc_rpcport

# update maker blockchain and xbridge configuration
tool_dxbot_update_cc_cfg_xb_cfg ${2} "maker"
cc_ticker_maker_check=${cc_ticker}

# update taker blockchain and xbridge configuration
tool_dxbot_update_cc_cfg_xb_cfg ${3} "taker"
cc_ticker_taker_check=${cc_ticker}




# clean dxbot cfg variables
cc_dxbot_install_dir_path_default=

# include dxbot cfg
tool_check_version_and_include_script ${cc_script_cfg_path_dxbot} "loading dxbot cfg" 

# check dxbot configuration variables
tool_variable_check_load_default cc_dxbot_install_dir_path cc_dxbot_install_dir_path_default "dxbot cfg"
tool_variable_check_load_default cc_dxbot_git_src_url cc_dxbot_git_src_url "dxbot cfg"
tool_variable_check_load_default cc_dxbot_git_branch cc_dxbot_git_branch "dxbot cfg"
tool_variable_check_load_default cc_dxbot_git_commit_id cc_dxbot_git_commit_id "dxbot cfg"
tool_variable_check_load_default cc_dxbot_strategy_template_path_relative cc_dxbot_strategy_template_path_relative "dxbot cfg"

# dxbot install directory path check
tool_make_and_check_dir_path "cc_dxbot_install_dir_path" "dxbot cfg"

# dxbot git source path gen
cc_dxbot_git_src_path=${cc_dxbot_install_dir_path}"/git.src"
echo "INFO >> using >> cc_dxbot_git_src_path >> ${cc_dxbot_git_src_path}"

# if dxbot update enabled, so remove all git src first 
if [ "${cc_action_source}" = "update" ]; then
    echo "INFO >> removing existing cc_dxbot_git_src_path >> ${cc_dxbot_git_src_path}"
    rm -rfv "${cc_dxbot_git_src_path}"
fi

# dxbot git source dir recreate
tool_make_and_check_dir_path "cc_dxbot_git_src_path" "dxbot git dir"

# dxbot change directory
tool_cd ${cc_dxbot_git_src_path} "dxbot git dir"

# dxbot git clone
echo "INFO >> dxbot >> git clone >> cc_dxbot_git_src_url >> ${cc_dxbot_git_src_url}"
${cc_proxychains} git clone ${cc_dxbot_git_src_url} ./
(test $? != 0) && echo "WARNING >> dxmakerbot git clone >> ${cc_dxbot_git_src_url} >> failed/already exist"

# dxbot checkout branch
echo "INFO >> dxbot >> git checkout >> cc_dxbot_git_branch >> ${cc_dxbot_git_branch}"
${cc_proxychains} git checkout ${cc_dxbot_git_branch}
(test $? != 0) && echo "ERROR >> git checkout >> ${cc_dxbot_git_branch} >> failed" && exit 1

# dxbot commit_id check
tool_git_commit_id_check "${cc_dxbot_git_commit_id}" "dxbot"

# dxbot install requirements
echo "INFO >> dxbot installing requirements"
${cc_proxychains} pip3 install -r requirements.txt
(test $? != 0) && echo "ERROR >> dxmakerbot install requirements failed" && exit 1

# move above dir
tool_cd ".." "dxbot cd .."

# load dxbot strategy configuration script
tool_check_version_and_include_script ${cc_script_cfg_path_strategy} "loading dxbot strategy cfg" 

# load dxbot strategy configuration custom or default naming suffix
tool_variable_check_load_default cc_dxbot_naming_suffix cc_dxbot_naming_suffix_default "dxbot strategy cfg"
tool_variable_check_load_default cc_address_maker cc_address_maker_default "dxbot strategy cfg"
tool_variable_check_load_default cc_address_taker cc_address_taker_default "dxbot strategy cfg"

# check if tickers from maker taker configuration vs dxbot strategy configuration match
tool_cmp ${cc_ticker_maker} ${cc_ticker_maker_check}
tool_cmp ${cc_ticker_taker} ${cc_ticker_taker_check}

# copy dxbot strategy template, update template, create run scripts

# prepare maker/taker strategy and runscript name and path
cc_dxbot_strategy_maker_file_name="strategy_${cc_ticker_maker}_${cc_ticker_taker}_${cc_dxbot_naming_suffix}"
cc_dxbot_strategy_taker_file_name="strategy_${cc_ticker_taker}_${cc_ticker_maker}_${cc_dxbot_naming_suffix}"
cc_dxbot_strategy_maker_file_path=${cc_dxbot_git_src_path}"/"${cc_dxbot_strategy_maker_file_name}".py"
cc_dxbot_strategy_taker_file_path=${cc_dxbot_git_src_path}"/"${cc_dxbot_strategy_taker_file_name}".py"

cc_dxbot_run_strategy_maker_name="run.firejail.${cc_ticker_maker}.${cc_ticker_taker}.${cc_dxbot_naming_suffix}.sh"
cc_dxbot_run_strategy_taker_name="run.firejail.${cc_ticker_taker}.${cc_ticker_maker}.${cc_dxbot_naming_suffix}.sh"

# check if files not already exists to not be overwritten
if [ "${cc_action_strategy}" != "update" ]; then
    tool_file_if_exist_exit ${cc_dxbot_strategy_maker_file_path} "maker strategy config path"
    tool_file_if_exist_exit ${cc_dxbot_strategy_taker_file_path} "taker strategy config path"
    tool_file_if_exist_exit ${cc_dxbot_run_strategy_maker_name} "run maker strategy script path"
    tool_file_if_exist_exit ${cc_dxbot_run_strategy_taker_name} "run taker strategy script path"
fi

# copy strategy template
tool_cp ${cc_dxbot_git_src_path}${cc_dxbot_strategy_template_path_relative} ${cc_dxbot_strategy_maker_file_path} "maker strategy"
tool_cp ${cc_dxbot_git_src_path}${cc_dxbot_strategy_template_path_relative} ${cc_dxbot_strategy_taker_file_path} "taker strategy"

# restore blocknet rpc setting for updating dxbot strategy template
cc_rpc_user=${cc_rpcuser_block_bak}
cc_rpc_password=${cc_rpcpassword_block_bak}
cc_rpc_hostname=${cc_rpchostname_block_bak}
cc_rpc_port=${cc_rpcport_block_bak}

# scan dxbot strategy template file for needed variables
# try to match and replace dxbot strategy template file with dxbot strategy config variable values
tool_dxbot_strategy_template_update ${cc_dxbot_strategy_maker_file_path}

cc_ticker_maker=${cc_ticker_taker_check}
cc_ticker_taker=${cc_ticker_maker_check}

cc_address_maker_bak=${cc_address_maker}
cc_address_taker_bak=${cc_address_taker}
cc_address_maker=${cc_address_taker_bak}
cc_address_taker=${cc_address_maker_bak}

tool_dxbot_strategy_template_update ${cc_dxbot_strategy_taker_file_path} "_opposite"

# generate dxbot strategy firejail run script for maker
echo "#!/bin/bash

# run script generated with ./setup.cc.dxbot.sh --help

cd ${cc_dxbot_git_src_path} || exit 1
firejail \\
--name=${cc_dxbot_strategy_maker_file_name} \\
--whitelist=\`pwd\` \\
--read-only=\`pwd\` \\
--mkfile=\`pwd\`/${cc_dxbot_strategy_maker_file_name}.tmp.cfg \\
--read-write=\`pwd\`/${cc_dxbot_strategy_maker_file_name}.tmp.cfg \\
--whitelist=\${HOME}/.proxychains \\
--read-only=\${HOME}/.proxychains \\
--whitelist=\${HOME}/.local/bin \\
--read-only=\${HOME}/.local/bin \\
--whitelist=\${HOME}/.local/lib \\
--read-only=\${HOME}/.local/lib \\
    ${cc_proxychains} \\
            python3 dxmakerbot_v2_run.py --config ${cc_dxbot_strategy_maker_file_name} \$@
" > ${cc_dxbot_run_strategy_maker_name} && chmod 755 ${cc_dxbot_run_strategy_maker_name}
(test $? != 0) && echo "ERROR >> dxbot strategy run script >> ${cc_dxbot_run_strategy_maker_name} >> generate failed" && exit 1

# generate dxbot strategy firejail run script for taker
echo "#!/bin/bash

# run script generated with ./setup.cc.dxbot.sh --help

cd ${cc_dxbot_git_src_path} || exit 1
firejail \\
--name=${cc_dxbot_strategy_taker_file_name} \\
--whitelist=\`pwd\` \\
--read-only=\`pwd\` \\
--mkfile=\`pwd\`/${cc_dxbot_strategy_taker_file_name}.tmp.cfg \\
--read-write=\`pwd\`/${cc_dxbot_strategy_taker_file_name}.tmp.cfg \\
--whitelist=\${HOME}/.proxychains \\
--read-only=\${HOME}/.proxychains \\
--whitelist=\${HOME}/.local/bin \\
--read-only=\${HOME}/.local/bin \\
--whitelist=\${HOME}/.local/lib \\
--read-only=\${HOME}/.local/lib \\
    ${cc_proxychains} \\
            python3 dxmakerbot_v2_run.py --config ${cc_dxbot_strategy_taker_file_name} \$@
" > ${cc_dxbot_run_strategy_taker_name} && chmod 755 ${cc_dxbot_run_strategy_taker_name}
(test $? != 0) && echo "ERROR >> dxbot strategy run script >> ${cc_dxbot_run_strategy_taker_name} >> generate failed" && exit 1

echo "*** DXBOT SETUP SUCCESS ***"
exit 0
