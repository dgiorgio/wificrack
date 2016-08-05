#!/bin/bash

PWD="$(pwd)"
CONFIG_DIR="$HOME/.wifi-crack"
CONFIG_FILE="$CONFIG_DIR/config"
source "$CONFIG_FILE"

source "$CONFIG_INTERFACE"

ifconfig $INTERFACE down
macchanger -p $INTERFACE
rfkill unblock wifi
iwconfig $INTERFACE mode managed
ifconfig $INTERFACE up
