#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

function show_help {
    echo << EOF
handle_args.sh -a ACTION -e ENVIRONMENT -s SOMEARG
...
EOF
}

while getopts "a:e:s:h?" opt; do
    case "$opt" in
    a)  ACTION=$OPTARG
        ;;
    e)  ENVIRONMENT=$OPTARG
        ;;
    s)  SOMEARG=$OPTARG
        ;;
    h|\?)
        echo "show help/usage..."
        exit 0
        ;;
    esac
done

function emit_outputs {
    jq -n "
{ 
    action: \"${ACTION}\", 
    environment: \"${ENVIRONMENT}\",
    somearg: \"${SOMEARG}\"
}
"
}

function install {
    emit_outputs
}

function upgrade {
    emit_outputs
}

function uninstall {
    emit_outputs
}

function main {
    if [[ ${ACTION} == install ]] ; then
        install
    elif [[ ${ACTION} == upgrade ]] ; then
        upgrade
    elif [[ ${ACTION} == uninstall ]] ; then
        uninstall
    else
        # TODO: emit errors as json also?
        echo "ACTION must be one of install, upgrade, or uninstall"
        exit 1
    fi
}

main
