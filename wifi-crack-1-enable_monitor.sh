#!/bin/bash

PWD="$(pwd)"
source "$PWD/wifi-crack.conf"
#### VARIAVEIS UTILIZADAS
# INTERFACE

ifconfig $INTERFACE down
macchanger --random $INTERFACE
rfkill unblock wifi
iwconfig $INTERFACE mode monitor
ifconfig $INTERFACE up
