#!/usr/bin/env sh

set -e
set -x

iptables -t nat -A DOCKER -p udp --dport 20000:29999 -j DNAT --to-destination <bgp ipv4 地址>
iptables -t nat -A POSTROUTING -p udp --dport 20000:29999 --source <bgp ipv4 地址> --destination <bgp ipv4 地址> -j MASQUERADE
iptables -t filter -I DOCKER-USER -p udp --dport 20000:29999 --destination <bgp ipv4 地址> -j ACCEPT

ip6tables -t nat -A OUTPUT -p udp --dport 20000:29999 -j DNAT --to-destination <bgp ipv6 地址>
ip6tables -t nat -A PREROUTING -p udp --dport 20000:29999 -j DNAT --to-destination <bgp ipv6 地址>
ip6tables -t nat -A POSTROUTING -p udp --dport 20000:29999 --source <bgp ipv6 地址> --destination <bgp ipv6 地址> -j MASQUERADE
ip6tables -t filter -I FORWARD -p udp --dport 20000:29999 --destination <bgp ipv6 地址> -j ACCEPT
