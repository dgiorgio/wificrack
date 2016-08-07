#!/bin/bash

PWD="$(pwd)"
CONFIG_DIR="$HOME/.wifi-crack"
CONFIG_FILE="$CONFIG_DIR/config.conf"
source "$CONFIG_FILE"


CAP_SELECT() {
ls -1 "$AIRCRACK_FILE_DIR"/*.cap
echo -n "
Escolha um arquivo .cap e aperte <Enter>: "
read CAP_FILE
}
until [ -e "$CAP_FILE" ] ; do
    echo "Arquivo não existe!
    "
    CAP_SELECT
done

aircrack-ng "$CAP_FILE"
