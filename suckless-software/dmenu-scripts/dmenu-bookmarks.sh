#!/bin/bash
BROWSER=vimb
while [ -z "$query" ]; do
	query=$( cat /home/kito/.config/vimb/quickmarks | dmenu -i -l 15 -p "Searching on $BROWSER :" )
done

$BROWSER $query
