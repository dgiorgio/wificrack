#!/bin/bash

PWD="$(pwd)"
SCRIPTPATH="$(dirname $0)"
FUNCTIONPATH="${SCRIPTPATH}"
CONFIG_DIR="$HOME/.wifi-crack"
CONFIG_FILE="$CONFIG_DIR/config.conf"
source "$CONFIG_FILE"

source "$CONFIG_INTERFACE"

while : ; do
    clear
    echo -ne "
        1 - DHCP Settings
        2 - Wireless Settings
        3 - Edit fake DNS \"${CONFIG_FAKEAP_FILE_FAKEDNS}\"
        0 - Sair
        
        Escolha uma das opções: "
    read OPTION
    
    case "$OPTION" in
    1) "${FUNCTIONPATH}"/wifi-crack-5-fakeap_config_range.sh ;;
    2) "${FUNCTIONPATH}"/wifi-crack-5-fakeap_config_wireless.sh ;;
    3) nano "${CONFIG_FAKEAP_FILE_FAKEDNS}" ;;
    0) break ;;
    *) echo "INVALID OPTION!!!"
    esac
    
done
