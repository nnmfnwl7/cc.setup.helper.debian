#!/bin/bash

# version to check...
cc_setup_helper_version="20210827"

# not allowed to run as root

id | grep root && echo "ERROR >> IT IS NOT ALLOWED TO RUN THIS SCRIPT AS ROOT !!!" && exit 1

# help

if [ "${#}" = "0" ]; then
    showhelp="yes"
else
    argc=$#
    argv=("$@")
    for (( j=0; j<argc; j++ )); do
        if [ "${argv[j]}" = "help" ] || [ "${argv[j]}" = "-help" ] || [ "${argv[j]}" = "--help" ] || [ "${argv[j]}" = "-h" ]; then
            showhelp="yes"
            return 0
        fi
    done
fi

if [ "${showhelp}" = "" ]; then
    echo "INFO >> including tools >> tools.sh"
fi

#
function tool_time_start() {
    time_at_start=`date -u`
}

#
function tool_time_finish_print() {
    time_at_finish=`date -u`
    echo "STARTED >> ${time_at_start}"
    echo "FINISHED >> ${time_at_finish}"
}

# 
function tool_realpath() {  #path.variable.name  #prefix.info
    (test "${1}" == "") && echo "ERROR >> ${2} >> realpath variable >> ${1} >> is missing" && exit 1
    local dir_path=`eval echo "\\${${1}}"`
    dir_path=`eval realpath -m ${dir_path}`
    (test $? != 0) && echo "ERROR >> ${2} >> realpath variable >> ${1} >> value >> ${dir_path} >> is invalid" && exit 1
    eval `echo "$1=\"${dir_path}\""`
    echo "INFO >> ${2} >> realpath variable >> ${1} >> value is >> ${dir_path}"
}

# function include bash source code in
function tool_check_version_and_include_script() { # cfg.path # prefix.info #
    # default prefix
    local prefix_info=${2}
    (test "${prefix_info}" == "" ) && local prefix_info="main"
    
    # cfg script path
    bash_script_path=${1}
    (test "${bash_script_path}" == "") && echo "ERROR >> ${prefix_info} >> no script path parameter" && exit 1
    
    # initial info
    echo "INFO >> ${prefix_info} >> trying to check version and include script >> ${bash_script_path}"
    
    # script realpath
    bash_script_path=`realpath ${bash_script_path}`
    (test $? != 0) && echo "ERROR >> ${prefix_info} >> script realpath >> ${1} >> is invalid" && exit 1
    
    # check version
    version=`cat "${bash_script_path}" | grep "cc_setup_helper_version=\"${cc_setup_helper_version}\""`
    (test "${version}" == "" ) && echo "ERROR >> ${prefix_info} >> script file >> ${bash_script_path} >> version >> ${version} >> is invalid" && exit 1
    
    # include script
    source ${bash_script_path}
    (test $? != 0) && echo "ERROR >> ${prefix_info} >> script file >> ${bash_script_path} >> not found" && exit 1
    
    # final success
    echo "INFO >> ${prefix_info} >> including >> ${bash_script_path}"
    
    return 0
}

# 
function tool_make_and_check_dir_path() {  #dir.path.var.name  #prefix.info
    (test "${1}" == "") && echo "ERROR >> ${2} >> no dir path variable name argument" && exit 1
    local dir_path=`eval echo "\\${${1}}"`
    (test "${dir_path}" == "") && echo "ERROR >> ${2} >> ${1} >> no dir path value" && exit 1
    dir_path=`eval realpath -m ${dir_path}`
    (test ! -d "${dir_path}") && mkdir -p ${dir_path}
    (test ! -d "${dir_path}") && echo "ERROR >> ${2} >> make and check dir >> ${1} >> ${dir_path} >> failed" && exit 1
    eval `echo "$1=\"${dir_path}\""`
    echo "INFO >> ${2} >> using directory >> ${1} >> ${dir_path}"
}

# 
function tool_git_commit_id_check() {  #commit.id  #prefix.info
    actual_git_commit_id=`git rev-parse HEAD`
    echo "INFO >> ${2} >> checking actual vs exp git commit id >> ${actual_git_commit_id} vs ${1}"
    (test "${actual_git_commit_id}" != "${1}") && echo "ERROR >> ${2} >> git commit id check >> ${1} >> failed" && exit 1
}

# 
function tool_dir_if_notexist_exit() {  #file.path.var.name  #prefix.info
    (test "${1}" == "") && echo "ERROR >> ${2} >> no file path variable name argument" && exit 1
    local var=`eval echo "\\${${1}}"`
    (test "${var}" == "") && echo "ERROR >> ${2} >> ${1} >> no file path value" && exit 1
    (test ! -d "${var}") && echo "ERROR >> ${2} >> ${1} >> directory does not exists" && exit 1
    echo "INFO >> ${2} >> ${1} >> ${var}"
}

# 
function tool_file_if_notexist_exit() {  #file.path  #prefix.info
    (test "${1}" == "") && echo "ERROR >> ${2} >> no source argument" && exit 1
    (test ! -f "${1}") && echo "ERROR >> ${2} >> ${1} >> file does not exists" && exit 1
}

# 
function tool_file_if_exist_exit() {  #file.path  #prefix.info
    (test "${1}" == "") && echo "ERROR >> ${2} >> no source argument" && exit 1
    (test -f "${1}") && echo "ERROR >> ${2} >> ${1} >> file already exists" && exit 1
}

# 
function tool_cp() {  #src  #dst  #prefix.info
    (test "${1}" == "") && echo "ERROR >> ${3} >> no source argument" && exit 1
    (test "${2}" == "") && echo "ERROR >> ${3} >> no destination argument" && exit 1
    cp ${1} ${2}
    (test $? != 0) && echo "ERROR >> ${3} >> copy >> ${1} >> to >> ${2} >> failed" && exit 1
}

# 
function tool_cd() { #path #prefix.info
    (test "${1}" == "") && echo "ERROR >> ${2} >> cd >> no path argument" && exit 1
    cd ${1}
    (test $? != 0) && echo "ERROR >> ${2} >> cd >> ${1} >> failed" && exit 1
    echo "INFO >> ${2} >> cd >> ${1}"
}

# 
function tool_cmp() {  #cmp1  #cmp2 #prefix info
    (test "${1}" != "${2}") && echo "ERROR >> ${3} >> compare >> ${1} >> ${2} >> failed" && exit 1
}

# 
function tool_variable_check_load_default() {  #var.name  #var.name.default #prefix.info
    (test "${1}" != "" ) && local var=`eval echo "\\${${1}}"`
    (test "${2}" != "" ) && local var_default=`eval echo "\\${${2}}"`
    (test "${var}" = "" ) && var=${var_default}
    (test "${var}" = "" ) && echo "ERROR >> ${3} >> variable >> ${1} >> value >> ${var} >> default >> ${2} >> value >> ${var_default} >> load failed" && exit 1
    eval `echo "$1=\"${var}\""`
    echo "INFO >> ${3} >> using variable >> ${1} >> ${var}"
}
