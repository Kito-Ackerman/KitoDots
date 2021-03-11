#!/bin/bash

query=$( cat /home/kito/.config/vimb/quickmarks | dmenu -i -l 15 -p "Search :" | awk '{printf $NF}' || exit )
vimb "$query"


