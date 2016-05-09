#!/bin/bash

PWD="$(pwd)"
source "$PWD/wifi-crack.conf"
#### VARIAVEIS UTILIZADAS
# INTERFACE

ifconfig $INTERFACE down
macchanger -p $INTERFACE
rfkill unblock wifi
iwconfig $INTERFACE mode managed
ifconfig $INTERFACE up
