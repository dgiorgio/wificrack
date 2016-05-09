#!/bin/bash

PWD="$(pwd)"
source "$PWD/wifi-crack.conf"
#### VARIAVEIS UTILIZADAS
# INTERFACE

airodump-ng $INTERFACE
#xterm -bg black -cr white -fg white -e bash -c "airodump-ng $INTERFACE" 
