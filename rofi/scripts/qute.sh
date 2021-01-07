#!/bin/bash

cmd="rofi"


while [ -z "$query" ]; do
query=$(echo "" | $cmd -dmenu -i -p "Searching on Qutebrowser : ") || exit
done

qutebrowser "$query"
