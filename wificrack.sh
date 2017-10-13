#!/bin/bash

# Create VAR to start
OPTION=""

################# VARIABLES #################
PWD="$(pwd)"
SCRIPTPATH="$(dirname $0)"
FUNCTIONPATH="${SCRIPTPATH}/functions"
CONFIG_DIR="$HOME/.wificrack"
CONFIG_FILE="$CONFIG_DIR/config.conf"
### INTERFACES
INTERFACE=""
INTERFACE_MAC=""
INTERNET=""
INTERNET_MAC=""


################# FUNCTIONS #################
# OPTION 99
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

# OPTION 5
FAKEAP() {
    while : ; do
        INFORMATION
        echo -n "
        1 - Save Firewall [RECOMMENDED] - Before start FakeAP
        2 - Start FakeAP - Simple Mode
        3 - Start FakeAP - Custom Mode
        4 - Stop FakeAP - Restore Network/Firewall [RECOMMENDED]
        99 - Configuration - required to create a FakeAP Custom Mode
        0 - Sair
        
        Choose a option: "
        read FAKEAP_OPTION
        
        case "$FAKEAP_OPTION" in
        1) iptables-save > "$CONFIG_FAKEAP_DIR/wificrack-iptables-save" ;;
        2) $TERMINAL "\"${FUNCTIONPATH}\"/wificrack-5-fakeap_start.sh $INTERFACE ; bash" ;;
        3) $TERMINAL "\"${FUNCTIONPATH}\"/wificrack-5-fakeap_start_custom.sh ; bash" ;;
        4) killall dnsmasq ; killall hostapd ; systemctl restart network-manager ; iptables-restore < "$CONFIG_FAKEAP_DIR/wificrack-iptables-save";;
        99) $TERMINAL "\"${FUNCTIONPATH}\"/wificrack-5-fakeap_config.sh" ;;
        0) break ;;
        *) echo "INVALID OPTION!!!" ;;
        esac
    done
}

# OPTION 6
WEP() {
    while : ; do
        INFORMATION
        echo -n "
        1 - Attack with .cap file
        2 - Fakeauth - Makes a false authentication to create a connection on the target.
        3 - ARP Request - Injects packets into a connection, use with Dump and Fakeauth.
        0 - Quit
        
        Choose a option: "
        read WEP_OPTION
        
        case "$WEP_OPTION" in
        1) $TERMINAL "\"${FUNCTIONPATH}\"/wificrack-6-wep_attack.sh ; bash" ;;
        2) $TERMINAL "\"${FUNCTIONPATH}\"/wificrack-6-fakeauth.sh ; bash" ;;
        3) $TERMINAL "\"${FUNCTIONPATH}\"/wificrack-6-arp_request.sh ; bash" ;;
        0) break ;;
        *) echo "INVALID OPTION!!!" ;;
        esac
    done
}

# OPTION 9
WPAWPA2_WPS() {
    while : ; do
        INFORMATION
        echo -n "
        1 - WPS Scan - Scan connections with WPS enabled.
        2 - WPS Brute Force - Brute force WPS on network target.
        0 - Sair
        
        Choose a option: "
        read WPAWPA2_WPS_OPTION
        
        case "$WPAWPA2_WPS_OPTION" in
        1) $TERMINAL "\"${FUNCTIONPATH}\"/wificrack-9-wps_scan.sh ; bash" ;;
        2) $TERMINAL "\"${FUNCTIONPATH}\"/wificrack-9-wps_brute_force.sh ; bash" ;;
        0) break ;;
        *) echo "INVALID OPTION!!!" ;;
        esac
    done
}

# OPTION 10
WPAWPA2_ATTACK() {
    while : ; do
        INFORMATION
        echo -n "
        1 - Capturar Handshake - Quick deauth attack to capture the handshake in Dump.
        2 - Wordlist Attack - Use a wordlist to find the key.
        0 - Sair
        
        Choose a option: "
        read WPAWPA2_ATTACK_OPTION
        
        case "$WPAWPA2_ATTACK_OPTION" in
        1) $TERMINAL "\"${FUNCTIONPATH}\"/wificrack-10-handshake_deauth.sh" ;;
        2) $TERMINAL "\"${FUNCTIONPATH}\"/wificrack-10-wordlist_attack.sh ; bash" ;;
        0) break ;;
        *) echo "INVALID OPTION!!!" ;;
        esac
    done
}

# OPTION 97
CHOOSE_INTERFACE() {
    SELECT_INTERFACE="NULL"
    while : ; do
        INFORMATION
        echo -ne "Choose a wireless interface: " ; read SELECT_INTERFACE
        if [ -z $SELECT_INTERFACE ]; then
            echo
        elif [ -e "/sys/class/net/$SELECT_INTERFACE" ]; then
            INTERFACE="$SELECT_INTERFACE"
            INTERFACE_MAC="$(cat /sys/class/net/$SELECT_INTERFACE/address)"
            break
        fi
    done
}

MENU() {
    while : ; do
        if [ -z "$CONFIG_ATTACK" ]; then
            CONFIG_ATTACK_STATUS="[ATTACK FILE NOT SELECTED]"
        elif [ -e "$CONFIG_ATTACK" ]; then
            CONFIG_ATTACK_STATUS=""
        else
            CONFIG_ATTACK_STATUS="[INVALID ATTACK FILE]"
        fi
        
        INFORMATION
        echo -ne "
        1 - Change the network interface mode
        2 - Sniff - Scan wifi network
        3 - Dump - Check connections on the target network
        4 - Death - DEAUTH on target network
        5 - FakeAP - Create a FakeAP
        6 - WEP - Attack
        7 - WEP - Chopchop [DEVELOPMENT]
        8 - WEP - Fragmentation Attack [DEVELOPMENT]
        9 - WPA/WPA2 - WPS Crack
        10 - WPA/WPA2 Attack
        98 - Edit and choose a config file to attack \033[1;31m$CONFIG_ATTACK_STATUS\033[0m
        99 - Other settings [DEVELOPMENT]
        0 - Quit
        [ENTER] to Update screen
        
        Choose a option: "
        read OPTION
        
        case "$OPTION" in
        1) "${FUNCTIONPATH}/wificrack-1-change_mode.sh" "$INTERFACE" ;;
        2) $TERMINAL "\"${FUNCTIONPATH}\"/wificrack-2-sniff.sh $INTERFACE ; bash" ;;
        3) "${FUNCTIONPATH}/wificrack-3-dump.sh" "$INTERFACE" ;;
        4) $TERMINAL "\"${FUNCTIONPATH}\"/wificrack-4-deauth.sh $INTERFACE" ;;
        5) FAKEAP ;;
        6) WEP ;;
        7)  ;;
        8)  ;;
        9) WPAWPA2_WPS ;;
        10) WPAWPA2_ATTACK ;;
        98) "${FUNCTIONPATH}"/wificrack-98-config_attack_menu.sh "$INTERFACE" "$CONFIG_ATTACK";;
        99) INFORMATION ; "${FUNCTIONPATH}"/wificrack-99-config.sh ;;
        0) break ;;
        *) echo "INVALID OPTION!!!"
        esac
        
    done
}

#######################################
################# RUN #################
#######################################

# Start - Choose Interface
CHOOSE_INTERFACE

mkdir -p "$CONFIG_DIR" 

# Select terminal
LIST_TERMINAL="gnome-terminal xfce4-terminal xterm konsole"
for SELECT_TERMINAL in ${LIST_TERMINAL}
do
    PATH_TERMINAL="$(which ${SELECT_TERMINAL} 2>/dev/null)"
    if [ -x "${PATH_TERMINAL}" ]; then
        break
    fi
done

case "${SELECT_TERMINAL}" in
    konsole) TERMINAL="${PATH_TERMINAL} -e bash -c" ;;
    gnome-terminal) TERMINAL="${PATH_TERMINAL} -x bash -c" ;;
    xfce4-terminal) TERMINAL="${PATH_TERMINAL} -x bash -c" ;;
    xterm) TERMINAL="${PATH_TERMINAL} -bg black -cr white -fg white -e bash -c" ;;
esac

echo "# Terminal sample
#TERMINAL=\"xterm -bg black -cr white -fg white -e bash -c\"
#TERMINAL=\"konsole -e bash -c\"
#TERMINAL=\"gnome-terminal -x bash -c\"
TERMINAL=\"${TERMINAL}\"
" > "$CONFIG_FILE"

# Select editor
if [ ! -x "${EDITOR}" ]; then
    for EDITOR in $(echo nano ee vim vi)
    do
        EDITOR="$(which ${EDITOR} 2>/dev/null)"
        if [ -x "${EDITOR}" ]; then
            EDITOR="${EDITOR}"
            echo "EDITOR=\"${EDITOR}\"" >> "$CONFIG_FILE"
            break
        fi
    done
fi

# Config File
echo '
DATA="$(date +%Y%m%d-%H%M%S)"
CONFIG_DIR="$HOME/.wificrack" #configuration directory
CONFIG_DIR_PROFILE="$CONFIG_DIR/$INTERFACE"

CONFIG_OTHERSETTINGS_DIR="$CONFIG_DIR/othersettings"
CONFIG_ATTACK_DIR="$CONFIG_DIR/attack" #directory with target attack settings
AIRCRACK_FILE_DIR="$CONFIG_DIR/aircrack" #directory with dump files captured with aircrack
CONFIG_FILE="$CONFIG_DIR/config.conf" #file with global settings

CONFIG_INTERFACE="$CONFIG_DIR_PROFILE/interface.conf" #interface configuration file
CURRENT_ATTACK_FILE="$CONFIG_DIR_PROFILE/current_attack_file.conf"

# FAKEAP VARIAVEIS
CONFIG_FAKEAP_DIR="$CONFIG_DIR_PROFILE/fakeap" #directory with fakeap settings
CONFIG_FAKEAP_FILE_DHCP="${CONFIG_FAKEAP_DIR}/dhcp.conf"
CONFIG_FAKEAP_FILE_WIRELESS="${CONFIG_FAKEAP_DIR}/wireless.conf"
CONFIG_FAKEAP_FILE_DNSMASQ="${CONFIG_FAKEAP_DIR}/wificrack-dnsmasq.conf"
CONFIG_FAKEAP_FILE_FAKEDNS="${CONFIG_FAKEAP_DIR}/fakedns.conf"
#CONFIG_FAKEAP_DIR_DNSMASQ_LOG="${CONFIG_FAKEAP_DIR}/log"
' >> "$CONFIG_FILE"


# Load
source "$CONFIG_FILE"
mkdir -p "$CONFIG_ATTACK_DIR" "$CONFIG_FAKEAP_DIR" "$AIRCRACK_FILE_DIR" "$CONFIG_DIR_PROFILE"
touch "${CONFIG_FAKEAP_FILE_FAKEDNS}"
if [ -e "$CURRENT_ATTACK_FILE" ]; then
    source "$CURRENT_ATTACK_FILE"
fi

# Start - Menu
MENU
