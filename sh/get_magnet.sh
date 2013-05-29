#!/bin/bash

[[ -z $1 ]] && { echo "Usage: $(basename $0) magnet_link"; exit 1; }

[[ -z $2 ]] || cd /mnt/data/Public/Torrents/$2

if ! [[ "$1" =~ xt=urn:btih:([^&/]+) ]] ; then
    echo "Bad magnet link"
    exit 1
fi

#if [[ "$1" =~ xt=urn:btih:([^&/]+) ]]; then 
#    echo "Not a valid magnet link"
#    exit
#fi

if [ -z $2 ]; then 
    echo "d10:magnet-uri${#1}:${1}e"
else
    echo "d10:magnet-uri${#1}:${1}e" > "meta-${BASH_REMATCH[1]}.torrent"
    echo "Torrent added to ${2} category"
fi

