#!/bin/bash

PWD="$(pwd)"
CONFIG_DIR="$HOME/.wificrack"
CONFIG_FILE="$CONFIG_DIR/config.conf"
source "$CONFIG_FILE"

source "$CONFIG_INTERFACE"

wash -i "$INTERFACE"
