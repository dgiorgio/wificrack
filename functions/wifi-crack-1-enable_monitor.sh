#!/bin/bash

PWD="$(pwd)"
CONFIG_DIR="$HOME/.wifi-crack"
CONFIG_FILE="$CONFIG_DIR/config.conf"
source "$CONFIG_FILE"

source "$CONFIG_INTERFACE"

ifconfig $INTERFACE down
macchanger --random $INTERFACE
rfkill unblock wifi
iwconfig $INTERFACE mode monitor
ifconfig $INTERFACE up
