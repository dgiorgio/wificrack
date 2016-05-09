#!/bin/bash

PWD="$(pwd)"
source "$PWD/wifi-crack.conf"
#### VARIAVEIS UTILIZADAS
# DATA
# DIR_CONFIG_USER
# INTERFACE
# INTERFACE_MAC
# INTERFACE_INTERNET
# VITIMA
# CHANNEL
# BSSID
# STATION
# DHCP_RANGE
# DHCP_SERVER
# DHCP_RANGE_START
# DHCP_RANGE_END


CAP_SELECT() {
ls -1 "$DIR_CONFIG_USER"/*.cap
echo -n "
Escolha um arquivo .cap e aperte <Enter>: "
read CAP_FILE
}
until [ -e "$CAP_FILE" ] ; do
    echo "Arquivo não existe!
    "
    CAP_SELECT
done

WL_SELECT() {
echo -n "
Escolha um arquivo wordlist e aperte <Enter>: "
read WL_FILE
}
until [ -e "$WL_FILE" ] ; do
    echo "Arquivo não existe!
    "
    WL_SELECT
done

aircrack-ng "$CAP_FILE" -w "$WL_FILE"
