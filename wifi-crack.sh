#!/bin/bash

################# VARIAVEIS #################
PWD="$(pwd)"
SCRIPT="$(readlink -f $0)"
SCRIPTPATH="$(dirname ${SCRIPT})"
FUNCTIONPATH="${SCRIPTPATH}/functions"
OPTION=""
CONFIG_DIR="$HOME/.wifi-crack"
CONFIG_FILE="$CONFIG_DIR/config"
### INTERFACES
INTERFACE=""
INTERFACE_MAC=""
INTERNET=""
INTERNET_MAC=""


#### Temporário
echo 'DATA="$(date +%Y%m%d-%H%M%S)"
#TERMINAL="xterm -bg black -cr white -fg white -e bash -c"
TERMINAL="gnome-terminal -x bash -c"
EDITOR="nano"
CONFIG_DIR="$HOME/.wifi-crack" #diretorio de configuração
CONFIG_ATTACK_DIR="$CONFIG_DIR/attack" #diretorio com as configurações do alvo para ataque
AIRCRACK_FILE_DIR="$CONFIG_DIR/aircrack" #diretorio com os arquivos dump capturados com o aircrack
CONFIG_FILE="$CONFIG_DIR/config" #arquivo com as configurações globais
CONFIG_INTERFACE="$CONFIG_DIR/interface" #arquivo de configuração das interfaces
CURRENT_ATTACK_FILE="$CONFIG_DIR/current_attack_file"
' > "$CONFIG_FILE"
#### Fim Temporário

source "$CONFIG_FILE"
mkdir -p "$CONFIG_DIR" "$CONFIG_ATTACK_DIR" "$AIRCRACK_FILE_DIR"
touch "$CONFIG_INTERFACE"
source "$CONFIG_INTERFACE"

################# FUNÇÕES #################
INFORMATION() {
    if [ -e "$CONFIG_INTERFACE" ]; then
        source "$CONFIG_INTERFACE"
    fi
        
    clear
    iwconfig
    echo -e "\033[1;32m$INTERFACE\033[0m: \033[1;36m$INTERFACE_MAC\033[0m"
    echo -e "\033[1;32m$INTERNET\033[0m: \033[1;36m$INTERNET_MAC\033[0m"
    echo '==============================================================================='
    echo -e "ARQUIVO DE ATAQUE: \033[1;32m$CONFIG_ATTACK\033[0m \033[1;31m$CONFIG_ATTACK_STATUS\033[0m"
}

MONITOR() {
    while : ; do
        INFORMATION
        echo -n "
        1 - Habilitar 'MONITOR MODE'
        2 - Desabilitar 'MONITOR MODE'
        0 - Sair
        
        Escolha uma das opções: "
        read MONITOR_OPTION
        
        case "$MONITOR_OPTION" in
        1) "${FUNCTIONPATH}"/wifi-crack-1-enable_monitor.sh ;;
        2) "${FUNCTIONPATH}"/wifi-crack-1-disable_monitor.sh ;;
        0) break ;;
        *) echo "INVALID OPTION!!!" ;;
        esac
    done
}

DUMP() {
    while : ; do
        INFORMATION
        echo -n "
        1 - dump - Salva em arquivo
        2 - dump scan - Apenas scan
        0 - Sair
        
        Escolha uma das opções: "
        read DUMP_OPTION
        
        case "$DUMP_OPTION" in
        1) $TERMINAL "\"${FUNCTIONPATH}\"/wifi-crack-3-dump.sh ; bash" ;;
        2) $TERMINAL "\"${FUNCTIONPATH}\"/wifi-crack-3-dump_scan.sh ; bash" ;;
        0) break ;;
        *) echo "INVALID OPTION!!!" ;;
        esac
    done
}

FAKEAP() {
    while : ; do
        INFORMATION
        echo -n "
        1 - FakeAP - Criar um AP falso [dnsmasq REQUIRED]
        2 - Configuration - Configurações necessárias para criar um AP falso
        3 - Instalar o dnsmasq
        0 - Sair
        
        Escolha uma das opções: "
        read FAKEAP_OPTION
        
        case "$FAKEAP_OPTION" in
        1) "${FUNCTIONPATH}"/wifi-crack-5-fakeap.sh ;;
        2) "${FUNCTIONPATH}"/wifi-crack-5-fakeap_config.sh ;;
        3) apt-get install -y dnsmasq ;;
        0) break ;;
        *) echo "INVALID OPTION!!!" ;;
        esac
    done
}

WEP() {
    while : ; do
        INFORMATION
        echo -n "
        1 - Atacar com arquivo .cap
        2 - Fakeauth - Faz uma falsa autenticação para criar uma conexão no alvo.
        3 - ARP Request - Injeta pacotes em uma conexão, utilizar com Dump e Fakeauth.
        0 - Sair
        
        Escolha uma das opções: "
        read WEP_OPTION
        
        case "$WEP_OPTION" in
        1) $TERMINAL "\"${FUNCTIONPATH}\"/wifi-crack-6-wep_attack.sh ; bash" ;;
        2) $TERMINAL "\"${FUNCTIONPATH}\"/wifi-crack-6-fakeauth.sh ; bash" ;;
        3) $TERMINAL "\"${FUNCTIONPATH}\"/wifi-crack-6-arp_request.sh ; bash" ;;
        0) break ;;
        *) echo "INVALID OPTION!!!" ;;
        esac
    done
}

WPAWPA2_WPS() {
    while : ; do
        INFORMATION
        echo -n "
        1 - WPS Scan - Escanear conexões com WPS habilitado.
        2 - WPS Brute Force - Brute force WPS na rede alvo.
        0 - Sair
        
        Escolha uma das opções: "
        read WPAWPA2_WPS_OPTION
        
        case "$WPAWPA2_WPS_OPTION" in
        1) $TERMINAL "\"${FUNCTIONPATH}\"/wifi-crack-9-wps_scan.sh ; bash" ;;
        2) $TERMINAL "\"${FUNCTIONPATH}\"/wifi-crack-9-wps_brute_force.sh ; bash" ;;
        0) break ;;
        *) echo "INVALID OPTION!!!" ;;
        esac
    done
}

WPAWPA2_ATTACK() {
    while : ; do
        INFORMATION
        echo -n "
        1 - Capturar Handshake - Ataque deauth rapido para capturar o handshake no Dump.
        2 - Wordlist Attack - Utiliza uma wordlist para descobrir a chave.
        0 - Sair
        
        Escolha uma das opções: "
        read WPAWPA2_ATTACK_OPTION
        
        case "$WPAWPA2_ATTACK_OPTION" in
        1) $TERMINAL "\"${FUNCTIONPATH}\"/wifi-crack-10-handshake_deauth.sh" ;;
        2) $TERMINAL "\"${FUNCTIONPATH}\"/wifi-crack-10-wordlist_attack.sh ; bash" ;;
        0) break ;;
        *) echo "INVALID OPTION!!!" ;;
        esac
    done
}


INTERFACE_CONFIGURE() {
    source "$CONFIG_INTERFACE"
    SELECT_INTERFACE="$INTERFACE"
    SELECT_INTERNET="$INTERNET"
    while : ; do
        if [ -z "$SELECT_INTERFACE" ]; then
            SELECT_INTERFACE_STATUS="[NÃO CONFIGURADO]"
            SELECT_INTERFACE_MAC=""
        elif [ -e "/sys/class/net/$SELECT_INTERFACE" ]; then
            SELECT_INTERFACE_STATUS=""
            SELECT_INTERFACE_MAC="$(cat /sys/class/net/$SELECT_INTERFACE/address)"
        else
            SELECT_INTERFACE_STATUS="[INTERFACE NÃO DETECTADA!!!]"
            SELECT_INTERFACE_MAC=""
        fi
        
        if [ -z "$SELECT_INTERNET" ]; then
            SELECT_INTERNET_STATUS="[NÃO CONFIGURADO]"
            SELECT_INTERNET_MAC=""
        elif [ -e "/sys/class/net/$SELECT_INTERNET" ]; then
            SELECT_INTERNET_STATUS=""
            SELECT_INTERNET_MAC="$(cat /sys/class/net/$SELECT_INTERNET/address)"
        else
            SELECT_INTERNET_STATUS="[INTERFACE NÃO DETECTADA!!!]"
            SELECT_INTERNET_MAC=""
        fi
        
        INFORMATION
        echo -ne "
        1 - Interface wireless selecionada: \033[1;32m$SELECT_INTERFACE\033[0m \033[1;36m$SELECT_INTERFACE_MAC\033[0m \033[1;31m$SELECT_INTERFACE_STATUS\033[0m
        2 - Interface com gateway para fakeap: \033[1;32m$SELECT_INTERNET\033[0m \033[1;36m$SELECT_INTERNET_MAC\033[0m \033[1;31m$SELECT_INTERNET_STATUS\033[0m
        99 - Salvar e sair
        0 - Sair
        
        Escolha uma das opções: "
        read OPTION
        
        case "$OPTION" in
        1) echo -n "Digite o nome da interface wireless: " ; read SELECT_INTERFACE ;;
        2) echo -n "Digite o nome da interface gateway para fakeap: " ; read SELECT_INTERNET ;;
        99) echo "INTERFACE=\"$SELECT_INTERFACE\"
INTERFACE_MAC=\"\$(cat /sys/class/net/$SELECT_INTERFACE/address)\"
INTERNET=\"$SELECT_INTERNET\"
INTERNET_MAC=\"\$(cat /sys/class/net/$SELECT_INTERNET/address)\"
        " > "$CONFIG_INTERFACE" ; break ;;
        0) break ;;
        *) echo "INVALID OPTION!!!"
        esac
        
    done
}

CONFIG_ATTACK_MENU() {
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
                $TERMINAL "\"${FUNCTIONPATH}\"/wifi-crack-98-config_attack_menu.sh \"$CONFIG_ATTACK\""
                source "$CONFIG_ATTACK"
            else
                echo "Selecione um arquivo!!!"
            fi
            ;;
        3) $TERMINAL "\"${FUNCTIONPATH}\"/wifi-crack-98-config_attack_menu.sh" ;;
        0) break ;;
        *) echo "INVALID OPTION!!!" ;;
        esac
    done
}


MENU() {
    while : ; do
        if [ -e "$CONFIG_INTERFACE" ]; then
            source "$CONFIG_INTERFACE"
        fi
        if [ -z "$INTERFACE" ]; then
            INTERFACE_STATUS="[INTERFACE WIRELESS NÃO CONFIGURADA]"
        elif [ -e "/sys/class/net/$INTERFACE" ]; then
            INTERFACE_STATUS=""
        else
            INTERFACE_STATUS="[INTERFACE WIRELESS NÃO DETECTADA!!!]"
        fi
        if [ -z "$CONFIG_ATTACK" ]; then
            CONFIG_ATTACK_STATUS="[ARQUIVO DE ATAQUE NÃO SELECIONADO]"
        elif [ -e "$CONFIG_ATTACK" ]; then
            CONFIG_ATTACK_STATUS=""
        else
            CONFIG_ATTACK_STATUS="[ARQUIVO DE ATAQUE INVALIDO!!!]"
        fi
        INFORMATION
        echo -ne "
        1 - Habilitar/Desabilitar 'MONITOR MODE' na interface
        2 - Sniff - Escanear as redes wifi
        3 - Dump - Verificar conexões da rede alvo
        4 - Death - DEAUTH na rede alvo
        5 - FakeAP - Criar um AP falso [DESENVOLVIMENTO]
        6 - WEP - Attack
        7 - WEP - Chopchop [DESENVOLVIMENTO]
        8 - WEP - Fragmentation Attack [DESENVOLVIMENTO]
        9 - WPA/WPA2 - WPS Crack
        10 - WPA/WPA2 Attack - Ataque a redes WPA/WPA2
        97 - Configuração das interfaces \033[1;31m$INTERFACE_STATUS\033[0m
        98 - Editar e escolher arquivo de configuração para ataque \033[1;31m$CONFIG_ATTACK_STATUS\033[0m
        99 - Configurações [DESENVOLVIMENTO]
        0 - Sair
        
        Escolha uma das opções: "
        read OPTION
        
        case "$OPTION" in
        1) MONITOR ;;
        2) $TERMINAL "\"${FUNCTIONPATH}\"/wifi-crack-2-sniff.sh ; bash" ;;
        3) DUMP ;;
        4) $TERMINAL "\"${FUNCTIONPATH}\"/wifi-crack-4-deauth.sh" ;;
        5) FAKEAP ;;
        6) WEP ;;
        7)  ;;
        8)  ;;
        9) WPAWPA2_WPS ;;
        10) WPAWPA2_ATTACK ;;
        97) INTERFACE_CONFIGURE ; source "$CONFIG_INTERFACE" ;;
        98) CONFIG_ATTACK_MENU ;;
        99) INFORMATION ; "${FUNCTIONPATH}"/wifi-crack-99-config.sh ;;
        0) break ;;
        *) echo "INVALID OPTION!!!"
        esac
        
    done
}

################# RUN #################
if [ -z "$INTERFACE" ]; then
    INTERFACE_CONFIGURE
fi
if [ -e "$CURRENT_ATTACK_FILE" ]; then
    source "$CURRENT_ATTACK_FILE"
fi
MENU
