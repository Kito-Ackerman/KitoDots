#!/bin/bash

while [ -z "$query" ]; do
	query=$( echo "" | dmenu -nf '#999' -nb '#292d3e' -sf '#eee' -sb '#0077bb' -p "Searching on qutebrowser :" )
done

qutebrowser $query
