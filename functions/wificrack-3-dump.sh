#!/bin/bash

PWD="$(pwd)"
INTERFACE="$1"

CONFIG_DIR="$HOME/.wificrack"
CONFIG_FILE="$CONFIG_DIR/config.conf"

source "$CONFIG_FILE"
source "$CURRENT_ATTACK_FILE"
source "$CONFIG_ATTACK"

INFORMATION() {
    if [ -n "$INTERFACE" ]; then
        INTERFACE_MAC="$(cat /sys/class/net/$INTERFACE/address)"
    fi

    INTERFACE_MODE="$(cat /sys/class/net/$INTERFACE/type)"
    if [ "$INTERFACE_MODE" == "1" ]; then
        INTERFACE_MODE_STATUS="[MODE MANAGED]"
    elif [ "$INTERFACE_MODE" == "803" ]; then
        INTERFACE_MODE_STATUS="[MODE MONITOR]"
    else
        INTERFACE_MODE_STATUS=""
    fi
    if [ -e "$CURRENT_ATTACK_FILE" ]; then
        source "$CURRENT_ATTACK_FILE"
    fi

    clear
    iwconfig
    echo -e "\033[1;32m$INTERFACE\033[0m: \033[1;36m$INTERFACE_MAC\033[0m \033[1;35m$INTERFACE_MODE_STATUS\033[0m"
    echo -e "\033[1;32m$INTERNET\033[0m: \033[1;36m$INTERNET_MAC\033[0m"
    echo '==============================================================================='
    echo -e "ATTACK FILE: \033[1;32m$CONFIG_ATTACK\033[0m \033[1;31m$CONFIG_ATTACK_STATUS\033[0m"
    echo
}


DUMP() {
    # Salvar em arquivo
    echo "Arquivo será salvo em $AIRCRACK_FILE_DIR/$ESSID-$DATA"
    $TERMINAL "airodump-ng --channel \"$CHANNEL\" --bssid \"$BSSID\" --write \"$AIRCRACK_FILE_DIR/$ESSID-$DATA\" \"$INTERFACE\"" && \
    echo "Arquivo salvo com sucesso em $AIRCRACK_FILE_DIR/$ESSID-$DATA"
}

DUMP_SCAN() {
    # Somente visualização
    $TERMINAL "airodump-ng --channel \"$CHANNEL\" --bssid \"$BSSID\" \"$INTERFACE\""
}


while : ; do
    INFORMATION
    echo -n "
    1 - dump - Salva em arquivo
    2 - dump scan - Apenas scan
    0 - Sair

    Escolha uma das opções: "
    read DUMP_OPTION

    case "$DUMP_OPTION" in
    1) DUMP ;;
    2) DUMP_SCAN ;;
    0) break ;;
    *) echo "INVALID OPTION!!!" ;;
    esac
done
