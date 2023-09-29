#!/usr/bin/env sh

set -e
set -x

ip route add 172.20.0.0/14 via <nat 的 IPV4>
ip route add fd00::/8 via <nat 的 IPV6>
