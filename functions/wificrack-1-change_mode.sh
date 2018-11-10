#!/bin/bash

PWD="$(pwd)"
CONFIG_DIR="$HOME/.wificrack"
CONFIG_FILE="$CONFIG_DIR/config.conf"
source "$CONFIG_FILE"

INTERFACE="$1"

if [  -e "/sys/class/net/$INTERFACE/type" ]; then
    INTERFACE_MODE="$(cat /sys/class/net/$INTERFACE/type)"
    if [ "$INTERFACE_MODE" == "1" ]; then
        ifconfig $INTERFACE down
        macchanger --random $INTERFACE
        rfkill unblock wifi
        iwconfig $INTERFACE mode monitor
        ifconfig $INTERFACE up
    elif [ "$INTERFACE_MODE" == "803" ]; then
        ifconfig $INTERFACE down
        macchanger -p $INTERFACE
        rfkill unblock wifi
        iwconfig $INTERFACE mode managed
        ifconfig $INTERFACE up
    fi
fi
