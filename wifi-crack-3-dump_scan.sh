#!/bin/bash

PWD="$(pwd)"
source "$PWD/wifi-crack.conf"
#### VARIAVEIS UTILIZADAS
# INTERFACE
# CHANNEL
# BSSID

# Somente visualização
airodump-ng --channel "$CHANNEL" --bssid "$BSSID" "$INTERFACE"
