#!/bin/bash

PWD="$(pwd)"
CONFIG_DIR="$HOME/.wifi-crack"
CONFIG_FILE="$CONFIG_DIR/config"
source "$CONFIG_FILE"

CONFIG_ATTACK="$1"

if [ -e "$CONFIG_ATTACK" ]; then
    source "$CONFIG_ATTACK"
fi

SELECT_ALVO="$ALVO"
SELECT_CHANNEL="$CHANNEL"
SELECT_BSSID="$BSSID"
SELECT_STATION="$STATION"

SAVE() {
SELECT_BSSID_NAME="$(echo $SELECT_BSSID | sed 's/:/-/g')"
if [ ! -e "$CONFIG_ATTACK" ]; then
    CONFIG_ATTACK="${CONFIG_ATTACK_DIR}/${SELECT_ALVO}_${SELECT_BSSID_NAME}"
fi

echo "ALVO=\"$SELECT_ALVO\"
CHANNEL=\"$SELECT_CHANNEL\"
BSSID=\"$SELECT_BSSID\"
STATION=\"$SELECT_STATION\"
" > "$CONFIG_ATTACK"
}


while : ; do
    clear
    if [ -z "$SELECT_ALVO" ]; then
        SELECT_ALVO_STATUS="[NÃO CONFIGURADO]"
    else
        SELECT_ALVO_STATUS=""
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
        1 - ESSID DA REDE ALVO: \033[1;32m$SELECT_ALVO\033[0m \033[1;31m$SELECT_ALVO_STATUS\033[0m
        2 - CHANNEL DA REDE ALVO: \033[1;32m$SELECT_CHANNEL\033[0m \033[1;31m$SELECT_CHANNEL_STATUS\033[0m
        3 - BSSID DA REDE ALVO: \033[1;32m$SELECT_BSSID\033[0m \033[1;31m$SELECT_BSSID_STATUS\033[0m
        4 - STATION DA REDE ALVO: \033[1;32m$SELECT_STATION\033[0m \033[1;31m$SELECT_STATION_STATUS\033[0m
        99 - Salvar $SELECT_SAVE_FILE
        0 - Sair
        
        Escolha uma das opções: "
    read OPTION
    
    case "$OPTION" in
    1) echo -n "Digite o nome da rede alvo: " ; read SELECT_ALVO ;;
    2) echo -n "Digite o channel da rede alvo: " ; read SELECT_CHANNEL ;;
    3) echo -n "Digite o BSSID da rede alvo: " ; read SELECT_BSSID ;;
    4) echo -n "Digite uma station da rede alvo: " ; read SELECT_STATION ;;
    99) SAVE && SELECT_SAVE_FILE="[Ultimo arquivo salvo em \033[1;32m${CONFIG_ATTACK}\033[0m]"
    ;;
    0) break ;;
    *) echo "INVALID OPTION!!!"
    esac
    
done
