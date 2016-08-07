#!/bin/bash

PWD="$(pwd)"
CONFIG_DIR="$HOME/.wifi-crack"
CONFIG_FILE="$CONFIG_DIR/config.conf"
source "$CONFIG_FILE"

source "$CONFIG_INTERFACE"
source "$CURRENT_ATTACK_FILE"
source "$CONFIG_ATTACK"


CAP_SELECT() {
ls -1 "$AIRCRACK_FILE_DIR"/*.cap
echo -n "
Escolha um arquivo .cap e aperte <Enter>: "
read CAP_FILE
}
until [ -e "$CAP_FILE" ] ; do
    echo "Nenhum arquivo .cap foi selecionado, ou o arquivo não existe!"
    echo ""
    CAP_SELECT
done

WL_SELECT() {
echo -n "
Escolha um arquivo wordlist e aperte <Enter>: "
read WL_FILE
}
until [ -e "$WL_FILE" ] ; do
    echo "Arquivo não existe!
    "
    WL_SELECT
done

aircrack-ng "$CAP_FILE" -w "$WL_FILE"
