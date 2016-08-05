#!/bin/bash

PWD="$(pwd)"
CONFIG_DIR="$HOME/.wifi-crack"
CONFIG_FILE="$CONFIG_DIR/config"
source "$CONFIG_FILE"

source "$CONFIG_INTERFACE"

wash -i "$INTERFACE"
