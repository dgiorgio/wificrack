#!/bin/bash

PWD="$(pwd)"
CONFIG_DIR="$HOME/.wificrack"
CONFIG_FILE="$CONFIG_DIR/config.conf"
source "$CONFIG_FILE"

INTERFACE="$1"

#### VARIAVEIS UTILIZADAS
# INTERFACE

airodump-ng "$INTERFACE"
