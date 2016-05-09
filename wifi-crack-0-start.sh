#!/bin/bash

################# VARIAVEIS #################
OPTION=""
#TERMINAL="xterm -bg black -cr white -fg white -e bash -c"
TERMINAL="gnome-terminal -x bash -c"
EDITOR="nano"

################# FUNÇÕES #################
MONITOR() {
    while : ; do
        clear
        iwconfig
        echo -n "
        ==========================================
        1 - Habilitar 'MONITOR MODE'
        2 - Desabilitar 'MONITOR MODE'
        0 - Sair
        
        Escolha uma das opções: "
        read MONITOR_OPTION
        
        case "$MONITOR_OPTION" in
        1) ./wifi-crack-1-enable_monitor.sh ;;
        2) ./wifi-crack-1-disable_monitor.sh ;;
        0) break ;;
        *) echo "INVALID OPTION!!!" ;;
        esac
    done
}

DUMP() {
    while : ; do
        clear
        iwconfig
        echo -n "
        ==========================================
        1 - dump - Salva em arquivo <alvo>-%Y%m%d-%H%M%S-XX
        2 - dump scan - Apenas scan
        0 - Sair
        
        Escolha uma das opções: "
        read DUMP_OPTION
        
        case "$DUMP_OPTION" in
        1) $TERMINAL "./wifi-crack-3-dump.sh ; bash" ;;
        2) $TERMINAL "./wifi-crack-3-dump_scan.sh ; bash" ;;
        0) break ;;
        *) echo "INVALID OPTION!!!" ;;
        esac
    done
}

FAKEAP() {
    while : ; do
        clear
        iwconfig
        echo -n "
        ==========================================
        1 - FakeAP - Criar um AP falso [dnsmasq REQUIRED]
        2 - Configuration - Configurações necessárias para criar um AP falso
        3 - Instalar o dnsmasq
        0 - Sair
        
        Escolha uma das opções: "
        read FAKEAP_OPTION
        
        case "$FAKEAP_OPTION" in
        1) ./wifi-crack-5-fakeap.sh ;;
        2) ./wifi-crack-5-fakeap_config.sh ;;
        3) apt-get install -y dnsmasq ;;
        0) break ;;
        *) echo "INVALID OPTION!!!" ;;
        esac
    done
}

WEP() {
    while : ; do
        clear
        iwconfig
        echo -n "
        ==========================================
        1 - Atacar com arquivo .cap
        2 - Fakeauth - Faz uma falsa autenticação para criar uma conexão no alvo.
        3 - ARP Request - Injeta pacotes em uma conexão, utilizar com Dump e Fakeauth.
        0 - Sair
        
        Escolha uma das opções: "
        read WEP_OPTION
        
        case "$WEP_OPTION" in
        1) $TERMINAL './wifi-crack-6-wep_attack.sh ; bash' ;;
        2) $TERMINAL './wifi-crack-6-fakeauth.sh ; bash' ;;
        3) $TERMINAL './wifi-crack-6-arp_request.sh ; bash' ;;
        0) break ;;
        *) echo "INVALID OPTION!!!" ;;
        esac
    done
}

WPAWPA2_WPS() {
    while : ; do
        clear
        iwconfig
        echo -n "
        ==========================================
        1 - WPS Scan - Escanear conexões com WPS habilitado.
        2 - WPS Brute Force - Brute force WPS na rede alvo.
        0 - Sair
        
        Escolha uma das opções: "
        read WPAWPA2_WPS_OPTION
        
        case "$WPAWPA2_WPS_OPTION" in
        1) $TERMINAL './wifi-crack-9-wps_scan.sh ; bash' ;;
        2) $TERMINAL './wifi-crack-9-wps_brute_force.sh ; bash' ;;
        0) break ;;
        *) echo "INVALID OPTION!!!" ;;
        esac
    done
}

WPAWPA2_ATTACK() {
    while : ; do
        clear
        iwconfig
        echo -n "
        ==========================================
        1 - Capturar Handshake - Ataque deauth rapido para capturar o handshake no Dump.
        2 - Wordlist Attack - Utiliza uma wordlist para descobrir a chave.
        0 - Sair
        
        Escolha uma das opções: "
        read WPAWPA2_ATTACK_OPTION
        
        case "$WPAWPA2_ATTACK_OPTION" in
        1) $TERMINAL './wifi-crack-10-handshake_deauth.sh ; bash' ;;
        2) $TERMINAL './wifi-crack-10-wordlist_attack.sh ; bash' ;;
        0) break ;;
        *) echo "INVALID OPTION!!!" ;;
        esac
    done
}

MENU() {
    while : ; do
        clear
        iwconfig
        echo -n "
        ==========================================
        1 - Habilitar/Desabilitar 'MONITOR MODE' na interface
        2 - Sniff - Escanear as redes wifi
        3 - Dump - Verificar conexões da rede alvo
        4 - Death - DEAUTH na rede alvo
        5 - FakeAP - Criar um AP falso
        6 - WEP - Attack
        7 - WEP - Chopchop [DESENVOLVIMENTO]
        8 - WEP - Fragmentation Attack [DESENVOLVIMENTO]
        9 - WPA/WPA2 - WPS Crack
        10 - WPA/WPA2 Attack - Ataque a redes WPA/WPA2
        99 - Editar o arquivo de configurações
        0 - Sair
        
        Escolha uma das opções: "
        read OPTION
        
        case "$OPTION" in
        1) MONITOR ;;
        2) $TERMINAL './wifi-crack-2-sniff.sh ; bash' ;;
        3) DUMP ;;
        4) $TERMINAL './wifi-crack-4-deauth.sh' ;;
        5) FAKEAP ;;
        6) WEP ;;
        7)  ;;
        8)  ;;
        9) WPAWPA2_WPS ;;
        10) WPAWPA2_ATTACK ;;
        99) $TERMINAL "$EDITOR wifi-crack.conf" ;;
        0) break ;;
        *) echo "INVALID OPTION!!!"
        esac
        
    done
}

################# RUN #################
MENU
