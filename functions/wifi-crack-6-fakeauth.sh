#!/bin/bash

PWD="$(pwd)"
CONFIG_DIR="$HOME/.wifi-crack"
CONFIG_FILE="$CONFIG_DIR/config"
source "$CONFIG_FILE"

source "$CONFIG_INTERFACE"
source "$CURRENT_ATTACK_FILE"

aireplay-ng --fakeauth 0 -a "$BSSID" -h "$INTERFACE_MAC" "$INTERFACE"
