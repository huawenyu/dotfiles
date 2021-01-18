#!/bin/sh
#mkfs -t ext2 -q /dev/ram1 1048576
#[ ! -d /ramcache ] && mkdir -p /ramcache
#mount /dev/ram1 /ramcache
mount -t tmpfs -o size=1G tmpfs /ramcache
