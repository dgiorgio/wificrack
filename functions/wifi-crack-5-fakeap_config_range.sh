#!/bin/bash

PWD="$(pwd)"
CONFIG_DIR="$HOME/.wifi-crack"
CONFIG_FILE="$CONFIG_DIR/config.conf"
source "$CONFIG_FILE"

if [ -e "$CONFIG_FAKEAP_FILE_DHCP" ]; then
    source "$CONFIG_FAKEAP_FILE_DHCP"
fi

SELECT_DHCP_RANGE="${DHCP_RANGE}"
SELECT_DHCP_RANGE_START="${DHCP_RANGE_START}"
SELECT_DHCP_RANGE_END="${DHCP_RANGE_END}"
SELECT_DHCP_SERVER="${DHCP_SERVER}"

SAVE() {
echo "DHCP_RANGE=\"$SELECT_DHCP_RANGE\"
DHCP_RANGE_START=\"$SELECT_DHCP_RANGE_START\"
DHCP_RANGE_END=\"$SELECT_DHCP_RANGE_END\"
DHCP_SERVER=\"$SELECT_DHCP_SERVER\"
" > "$CONFIG_FAKEAP_FILE_DHCP"
}


while : ; do
    clear
    if [ -z "$SELECT_DHCP_RANGE" ]; then
        SELECT_DHCP_RANGE_STATUS="[NÃO CONFIGURADO]"
    else
        SELECT_DHCP_RANGE_STATUS=""
    fi
    
    if [ -z "$SELECT_DHCP_RANGE_START" ]; then
        SELECT_DHCP_RANGE_START_STATUS="[NÃO CONFIGURADO]"
    else
        SELECT_DHCP_RANGE_START_STATUS=""
    fi
    
    if [ -z "$SELECT_DHCP_RANGE_END" ]; then
        SELECT_DHCP_RANGE_END_STATUS="[NÃO CONFIGURADO]"
    else
        SELECT_DHCP_RANGE_END_STATUS=""
    fi
    
    if [ -z "$SELECT_DHCP_SERVER" ]; then
        SELECT_DHCP_SERVER_STATUS="[NÃO CONFIGURADO]"
    else
        SELECT_DHCP_SERVER_STATUS=""
    fi
    if [ -z "$SELECT_SAVE_FILE" ]; then
        SELECT_SAVE_FILE=""
    fi
    
    echo -ne "
        1 - DHCP RANGE: \033[1;32m$SELECT_DHCP_RANGE\033[0m \033[1;31m$SELECT_DHCP_RANGE_STATUS\033[0m
        2 - DHCP_RANGE_START: \033[1;32m$SELECT_DHCP_RANGE_START\033[0m \033[1;31m$SELECT_DHCP_RANGE_START_STATUS\033[0m
        3 - DHCP_RANGE_END: \033[1;32m$SELECT_DHCP_RANGE_END\033[0m \033[1;31m$SELECT_DHCP_RANGE_END_STATUS\033[0m
        4 - DHCP_SERVER: \033[1;32m$SELECT_DHCP_SERVER\033[0m \033[1;31m$SELECT_DHCP_SERVER_STATUS\033[0m
        99 - Salvar $SELECT_SAVE_FILE
        0 - Sair
        
        Escolha uma das opções: "
    read OPTION
    
    case "$OPTION" in
    1) echo -n "Digite o range de ip: " ; read SELECT_DHCP_RANGE ;;
    2) echo -n "Digite o Start IP Address: ${SELECT_DHCP_RANGE}." ; read SELECT_DHCP_RANGE_START ; SELECT_DHCP_RANGE_START="${SELECT_DHCP_RANGE}.${SELECT_DHCP_RANGE_START}" ;;
    3) echo -n "Digite o End IP Address: ${SELECT_DHCP_RANGE}." ; read SELECT_DHCP_RANGE_END ; SELECT_DHCP_RANGE_END="${SELECT_DHCP_RANGE}.${SELECT_DHCP_RANGE_END}" ;;
    4) echo -n "Digite o IP Address do servidor DHCP: ${SELECT_DHCP_RANGE}." ; read SELECT_DHCP_SERVER ; SELECT_DHCP_SERVER="${SELECT_DHCP_RANGE}.${SELECT_DHCP_SERVER}" ;;
    99) SAVE && SELECT_SAVE_FILE=" [Ultimo arquivo salvo em \033[1;32m$CONFIG_FAKEAP_FILE_DHCP\033[0m]"
    ;;
    0) break ;;
    *) echo "INVALID OPTION!!!"
    esac
    
done