#!/bin/bash

PWD="$(pwd)"
CONFIG_DIR="$HOME/.wifi-crack"
CONFIG_FILE="$CONFIG_DIR/config.conf"
source "$CONFIG_FILE"
source "$CONFIG_INTERFACE"

source "${CONFIG_FAKEAP_FILE_DHCP}"

# Enable internet
# iptables rules
