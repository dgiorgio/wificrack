#!/bin/bash

PWD="$(pwd)"
source "$PWD/wifi-crack.conf"
#### VARIAVEIS UTILIZADAS
# DIR_CONFIG_USER

CAP_SELECT() {
ls -1 "$DIR_CONFIG_USER"/*.cap
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
