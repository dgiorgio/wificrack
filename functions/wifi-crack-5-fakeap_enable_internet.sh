#!/bin/bash

PWD="$(pwd)"
CONFIG_DIR="$HOME/.wifi-crack"
CONFIG_FILE="$CONFIG_DIR/config.conf"
source "$CONFIG_FILE"
source "$CONFIG_INTERFACE"

source "${CONFIG_FAKEAP_FILE_DHCP}"

#edit dhcp configuration
echo -e "interface=at0\ndhcp-range=$DHCP_RANGE_START,$DHCP_RANGE_END,12h" > /etc/dnsmasq.d/wifi-crack.conf

#start fake ap
airbase-ng -e "$FAKEAP_SSID" -c "$FAKEAP_CHANNEL" "$INTERFACE"
#ex: airbase-ng -e fake-ap -c 6 mon0

ifconfig at0 "$DHCP_SERVER" up
#removing iptables rules
iptables --flush
iptables --table nat --flush
iptables --delete-chain
iptables --table nat --delete-chain

#enable packet forward in iptables
iptables -P FORWARD ACCEPT

#link the wifi card and the card thats connected to the internet
iptables -t nat -A POSTROUTING -o "$INTERFACE_INTERNET" -j MASQUERADE

#start dnsmasq
/etc/init.d/dnsmasq restart

#enable ip forward
echo "1" > /proc/sys/net/ipv4/ip_forward
