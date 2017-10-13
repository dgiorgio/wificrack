#!/bin/bash

PWD="$(pwd)"
INTERFACE="$1"
CONFIG_ATTACK="$2"

CONFIG_DIR="$HOME/.wificrack"
CONFIG_FILE="$CONFIG_DIR/config.conf"

source "$CONFIG_FILE"

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

SAVE() {
    SELECT_BSSID_NAME="$(echo $SELECT_BSSID | sed 's/:/-/g')"
#    if [ ! -e "$CONFIG_ATTACK" ]; then
        CONFIG_ATTACK="${CONFIG_ATTACK_DIR}/${SELECT_ESSID}_${SELECT_BSSID_NAME}"
#    fi

    echo "
ESSID=\"$SELECT_ESSID\"
CHANNEL=\"$SELECT_CHANNEL\"
BSSID=\"$SELECT_BSSID\"
STATION=\"$SELECT_STATION\"" > "$CONFIG_ATTACK"
echo "CONFIG_ATTACK=\"$CONFIG_ATTACK\"" > "$CURRENT_ATTACK_FILE"
}


CONFIG_ATTACK_MENU() {
    SELECT_ESSID="$ESSID"
    SELECT_CHANNEL="$CHANNEL"
    SELECT_BSSID="$BSSID"
    SELECT_STATION="$STATION"

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
            1 - ESSID DA REDE ALVO: \033[1;32m$SELECT_ESSID\033[0m \033[1;31m$SELECT_ESSID_STATUS\033[0m
            2 - CHANNEL DA REDE ALVO: \033[1;32m$SELECT_CHANNEL\033[0m \033[1;31m$SELECT_CHANNEL_STATUS\033[0m
            3 - BSSID DA REDE ALVO: \033[1;32m$SELECT_BSSID\033[0m \033[1;31m$SELECT_BSSID_STATUS\033[0m
            4 - STATION DA REDE ALVO: \033[1;32m$SELECT_STATION\033[0m \033[1;31m$SELECT_STATION_STATUS\033[0m
            98 - Start Scan Wifi
            99 - Salvar $SELECT_SAVE_FILE
            0 - Sair
            
            Escolha uma das opções: "
        read OPTION
        
        case "$OPTION" in
        1) echo -n "Digite o nome da rede alvo: " ; read SELECT_ESSID ;;
        2) echo -n "Digite o channel da rede alvo: " ; read SELECT_CHANNEL ;;
        3) echo -n "Digite o BSSID da rede alvo: " ; read SELECT_BSSID ;;
        4) echo -n "Digite uma station da rede alvo: " ; read SELECT_STATION ;;
        98) $TERMINAL "functions/wificrack-2-sniff.sh $INTERFACE; bash" ;;
        99) SAVE && SELECT_SAVE_FILE=" [Ultimo arquivo salvo em \033[1;32m${CONFIG_ATTACK}\033[0m]" ;;
        0) break ;;
        *) echo "INVALID OPTION!!!"
        esac
        
    done
}

while : ; do
    if [ -z "$CONFIG_ATTACK" ]; then
        CONFIG_ATTACK_STATUS="[NÃO SELECIONADO]"
    elif [ -e "$CONFIG_ATTACK" ]; then
        CONFIG_ATTACK_STATUS=""
    else
        CONFIG_ATTACK_STATUS="[ARQUIVO INVALIDO!!!]"
    fi
    INFORMATION
    echo -ne "
    1 - Escolher um arquivo de configuração para ataque: \033[1;32m$CONFIG_ATTACK\033[0m \033[1;31m$CONFIG_ATTACK_STATUS\033[0m
    2 - Editar arquivo selecionado.
    3 - Criar um arquivo de configuração para ataque.
    0 - Sair
    
    Escolha uma das opções: "
    read CONFIG_ATTACK_MENU_OPTION
    
    case "$CONFIG_ATTACK_MENU_OPTION" in
    1) 
        find "$CONFIG_ATTACK_DIR"/ -maxdepth 1
        echo -n "Digite o nome do arquivo de configuração para ataque: "
        read CONFIG_ATTACK
        if [ -e "$CONFIG_ATTACK" ]; then
            source "$CONFIG_ATTACK"
            echo "CONFIG_ATTACK=\"$CONFIG_ATTACK\"" > "$CURRENT_ATTACK_FILE"
        else
            echo "Arquivo não existe!!!"
        fi
        ;;
    2)
        if [ -e "$CONFIG_ATTACK" ]; then
            source "$CONFIG_ATTACK"
            CONFIG_ATTACK_MENU
        else
            echo "Selecione um arquivo!!!"
        fi
        ;;
    3)  ESSID=""
        CHANNEL=""
        BSSID=""
        STATION=""
        CONFIG_ATTACK_MENU ;;
    0) break ;;
    *) echo "INVALID OPTION!!!" ;;
    esac
done
