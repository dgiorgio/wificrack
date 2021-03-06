#!/bin/bash

PWD="$(pwd)"
CONFIG_DIR="$HOME/.wificrack"
CONFIG_FILE="$CONFIG_DIR/config.conf"
source "$CONFIG_FILE"

CONFIG_ATTACK="$1"

if [ -e "$CONFIG_ATTACK" ]; then
    source "$CONFIG_ATTACK"
    source "$CONFIG_OTHERSETTINGS_DIR/config_dhcpserver_default.conf"
fi

SELECT_ESSID="$ESSID"
SELECT_CHANNEL="$CHANNEL"
SELECT_BSSID="$BSSID"
SELECT_STATION="$STATION"

SAVE() {
SELECT_BSSID_NAME="$(echo $SELECT_BSSID | sed 's/:/-/g')"
if [ ! -e "$CONFIG_ATTACK" ]; then
    CONFIG_ATTACK="${CONFIG_ATTACK_DIR}/${SELECT_ESSID}_${SELECT_BSSID_NAME}"
fi

echo "ESSID=\"$SELECT_ESSID\"
CHANNEL=\"$SELECT_CHANNEL\"
BSSID=\"$SELECT_BSSID\"
STATION=\"$SELECT_STATION\"
" > "$CONFIG_ATTACK"
}


while : ; do
    clear
    if [ -z "$SELECT_ESSID" ]; then
        SELECT_ESSID_STATUS="[NÃO CONFIGURADO]"
    else
        SELECT_ESSID_STATUS=""
    fi

    if [ -z "$SELECT_CHANNEL" ]; then
        SELECT_CHANNEL_STATUS="[NÃO CONFIGURADO]"
    else
        SELECT_CHANNEL_STATUS=""
    fi

    if [ -z "$SELECT_BSSID" ]; then
        SELECT_BSSID_STATUS="[NÃO CONFIGURADO]"
    else
        SELECT_BSSID_STATUS=""
    fi

    if [ -z "$SELECT_STATION" ]; then
        SELECT_STATION_STATUS="[NÃO CONFIGURADO]"
    else
        SELECT_STATION_STATUS=""
    fi
    if [ -z "$SELECT_SAVE_FILE" ]; then
        SELECT_SAVE_FILE=""
    fi

    echo -ne "
        1 - Set DHCP server default: \033[1;32m$DHCPSERVER_DEFAULT\033[0m
        2 - CHANNEL DA REDE ALVO: \033[1;32m$SELECT_CHANNEL\033[0m \033[1;31m$SELECT_CHANNEL_STATUS\033[0m
        3 - BSSID DA REDE ALVO: \033[1;32m$SELECT_BSSID\033[0m \033[1;31m$SELECT_BSSID_STATUS\033[0m
        4 - STATION DA REDE ALVO: \033[1;32m$SELECT_STATION\033[0m \033[1;31m$SELECT_STATION_STATUS\033[0m
        99 - Salvar $SELECT_SAVE_FILE
        0 - Sair

        Choose one of the options: "
    read OPTION

    case "$OPTION" in
    1) echo -ne "
        1 - dnsmasq
        2 - isc-dhcp-server
        0 - Exit

        Choose one of the options: "
        read OPTION

        case "$OPTION" in
        1) echo "DHCPSERVER_DEFAULT=dnsmasq" > "$CONFIG_OTHERSETTINGS_DIR/config_dhcpserver_default.conf" && DHCPSERVER_DEFAULT="dnsmasq" ;;
        2) echo "DHCPSERVER_DEFAULT=isc-dhcp-server" > "$CONFIG_OTHERSETTINGS_DIR/config_dhcpserver_default.conf" && DHCPSERVER_DEFAULT="isc-dhcp-server" ;;
        0) ;;
        *) echo "INVALID OPTION!!!" ;;
        esac

    echo -n "Digite o nome da rede alvo: " ; read SELECT_ESSID ;;


    2) echo -n "Digite o channel da rede alvo: " ; read SELECT_CHANNEL ;;
    3) echo -n "Digite o BSSID da rede alvo: " ; read SELECT_BSSID ;;
    4) echo -n "Digite uma station da rede alvo: " ; read SELECT_STATION ;;
    99) SAVE && SELECT_SAVE_FILE=" [Ultimo arquivo salvo em \033[1;32m${CONFIG_ATTACK}\033[0m]"
    ;;
    0) break ;;
    *) echo "INVALID OPTION!!!"
    esac

done
