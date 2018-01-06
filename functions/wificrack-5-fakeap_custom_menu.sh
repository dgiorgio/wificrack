#!/bin/bash

PWD="$(pwd)"
SCRIPTPATH="$(dirname $0)"
FUNCTIONPATH="${SCRIPTPATH}"
INTERFACE="$1"

CONFIG_DIR="$HOME/.wificrack"
CONFIG_FILE="$CONFIG_DIR/config.conf"

source "$CONFIG_FILE"

TOOL_FAKEAP="hostapd"
TOOL_DHCP="dnsmasq"
TOOLS() {

    if [ "$TOOL_DHCP" == "hostapd" ]; then
        TOOL_DHCP="aircrack-ng"
    else
        TOOL_DHCP="hostapd"
    fi


    if [ "$TOOL_FAKEAP" == "hostapd" ]; then
        TOOL_FAKEAP="aircrack-ng"
    else
        TOOL_FAKEAP="hostapd"
    fi
}


while : ; do
    clear
    echo -ne "
        1 - Save Firewall [RECOMMENDED] - Before start FakeAP
        2 - Start FakeAP - Custom Mode
        3 - Tools used - [$TOOL_FAKEAP] [$TOOL_DHCP]
        4 - DHCP Settings
        5 - Wireless Settings
        6 - Edit fake DNS \"${CONFIG_FAKEAP_FILE_FAKEDNS}\"
        7 - Stop FakeAP - Restore Network/Firewall [RECOMMENDED]
        0 - Sair
        
        Escolha uma das opções: "
    read OPTION
    
    case "$OPTION" in
    1) iptables-save > "$CONFIG_FAKEAP_DIR/wificrack-iptables-save" ;;
    2) "${FUNCTIONPATH}"/wificrack-5-fakeap_custom_start.sh ;;
    3) TOOL ;;
    4) "${FUNCTIONPATH}"/wificrack-5-fakeap_config_range.sh ;;
    5) "${FUNCTIONPATH}"/wificrack-5-fakeap_config_wireless.sh ;;
    6) nano "${CONFIG_FAKEAP_FILE_FAKEDNS}" ;;
    7) killall dnsmasq ; killall hostapd ; systemctl restart network-manager ; iptables-restore < "$CONFIG_FAKEAP_DIR/wificrack-iptables-save";;
    0) break ;;
    *) echo "INVALID OPTION!!!"
    esac
    
done
