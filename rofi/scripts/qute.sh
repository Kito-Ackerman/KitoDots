#!/bin/bash

cmd="rofi"


while [ -z "$query" ]; do
query=$(echo "" | $cmd -dmenu -i -p "Searching DuckDuckgo") || exit
done

qutebrowser "$query"
