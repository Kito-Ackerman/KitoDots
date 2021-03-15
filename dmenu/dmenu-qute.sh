#!/bin/bash

while [ -z "$query" ]; do
	query=$( echo "" | dmenu  -p "Searching on qutebrowser :" )
done

qutebrowser $query
