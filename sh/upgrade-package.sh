#!/bin/bash

[[ -z $1 ]] && { echo "Usage: $(basename $0) package"; exit 1; }

if dpkg -s "$1" 2>/dev/null | grep -q Status.*installed; then
    echo "Attempting to upgrade $1"
    sudo apt-get install "$1"
else
    echo "Package $1 is not installed"
fi