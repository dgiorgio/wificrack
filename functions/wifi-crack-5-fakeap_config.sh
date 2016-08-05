#!/bin/bash

PWD="$(pwd)"
CONFIG_DIR="$HOME/.wifi-crack"
CONFIG_FILE="$CONFIG_DIR/config"
source "$CONFIG_FILE"

source "$CONFIG_INTERFACE"

# Interface wireless utilizada
INTERFACE=wlan0
INTERFACE_INTERNET=eth0

DHCP_RANGE="192.168.100"
DHCP_SERVER="$DHCP_RANGE.1"
DHCP_RANGE_START="$DHCP_RANGE.50"
DHCP_RANGE_END="$DHCP_RANGE.150"

#install dnsmasq (only do this once)
#apt-get install -y dnsmasq

#edit dhcp configuration
echo -e "interface=at0\ndhcp-range=$DHCP_RANGE_START,$DHCP_RANGE_END,12h" > /etc/dnsmasq.d/wifi-crack.conf

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
