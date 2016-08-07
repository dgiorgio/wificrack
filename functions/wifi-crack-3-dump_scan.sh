#!/bin/bash

PWD="$(pwd)"
CONFIG_DIR="$HOME/.wifi-crack"
CONFIG_FILE="$CONFIG_DIR/config.conf"
source "$CONFIG_FILE"

source "$CONFIG_INTERFACE"

source "$CURRENT_ATTACK_FILE"
source "$CONFIG_ATTACK"

# Somente visualização
airodump-ng --channel "$CHANNEL" --bssid "$BSSID" "$INTERFACE"
