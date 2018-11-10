#!/bin/bash

PWD="$(pwd)"
INTERFACE="$1"

CONFIG_DIR="$HOME/.wificrack"
CONFIG_FILE="$CONFIG_DIR/config.conf"

source "$CONFIG_FILE"

if [ -e "$CONFIG_FAKEAP_FILE_WIRELESS" ]; then
    source "$CONFIG_FAKEAP_FILE_WIRELESS"
fi

SELECT_FAKEAP_SSID="${FAKEAP_SSID}"
SELECT_FAKEAP_CHANNEL="${FAKEAP_CHANNEL}"
SELECT_FAKEAP_MAC="${FAKEAP_MAC}"

SAVE() {
echo "FAKEAP_SSID=\"$SELECT_FAKEAP_SSID\"
FAKEAP_CHANNEL=\"$SELECT_FAKEAP_CHANNEL\"
FAKEAP_MAC=\"${SELECT_FAKEAP_MAC}\"
" > "$CONFIG_FAKEAP_FILE_WIRELESS"
}


while : ; do
    clear
    if [ -z "$SELECT_FAKEAP_SSID" ]; then
        SELECT_FAKEAP_SSID_STATUS="[NÃO CONFIGURADO]"
    else
        SELECT_FAKEAP_SSID_STATUS=""
    fi

    if [ -z "$SELECT_FAKEAP_CHANNEL" ]; then
        SELECT_FAKEAP_CHANNEL_STATUS="[NÃO CONFIGURADO]"
    else
        SELECT_FAKEAP_CHANNEL_STATUS=""
    fi

    if [ -z "$SELECT_FAKEAP_MAC" ]; then
        SELECT_FAKEAP_MAC_STATUS="[NÃO CONFIGURADO]"
    else
        SELECT_FAKEAP_MAC_STATUS=""
    fi

    if [ -z "$SELECT_SAVE_FILE" ]; then
        SELECT_SAVE_FILE=""
    fi

    echo -ne "
        1 - FAKEAP SSID: \033[1;32m$SELECT_FAKEAP_SSID\033[0m \033[1;31m$SELECT_FAKEAP_SSID_STATUS\033[0m
        2 - FAKEAP CHANNEL: \033[1;32m$SELECT_FAKEAP_CHANNEL\033[0m \033[1;31m$SELECT_FAKEAP_CHANNEL_STATUS\033[0m
        3 - MAC Address - Deixe em branco por padrão (optional): \033[1;32m$SELECT_FAKEAP_MAC\033[0m \033[1;31m$SELECT_FAKEAP_MAC_STATUS\033[0m
        98 - Import victim conf
        99 - Salvar $SELECT_SAVE_FILE
        0 - Sair

        Escolha uma das opções: "
    read OPTION

    case "$OPTION" in
    1) echo -n "Digite o SSID: " ; read SELECT_FAKEAP_SSID ;;
    2) echo -n "Digite o channel: " ; read SELECT_FAKEAP_CHANNEL ;;
    3) echo -n "Digite o mac address: " ; read SELECT_FAKEAP_MAC ;;
    98)
    if [ -e "$CURRENT_ATTACK_FILE" ]; then
        source "${CURRENT_ATTACK_FILE}"
        source "${CONFIG_ATTACK}"
    fi
    SELECT_FAKEAP_SSID="${ESSID}"
    SELECT_FAKEAP_CHANNEL="${CHANNEL}"
    SELECT_FAKEAP_MAC="${BSSID}"
    ;;
    99) SAVE && SELECT_SAVE_FILE=" [Ultimo arquivo salvo em \033[1;32m$CONFIG_FAKEAP_FILE_WIRELESS\033[0m]"
    ;;
    0) break ;;
    *) echo "INVALID OPTION!!!"
    esac

done
