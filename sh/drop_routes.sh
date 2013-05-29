#!/bin/sh

route del -net 10.1.1.1 netmask 255.255.255.255 dev eth0
route del -net 10.1.1.0 netmask 255.255.255.0 dev eth0
route del -net 10.1.1.0 netmask 255.255.255.0 dev eth1
route del -net 0.0.0.0 netmask 0.0.0.0 dev eth1