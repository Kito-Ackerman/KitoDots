#!/bin/sh

c=0;t=0

awk '/MHz/ {print $4}' < /proc/cpuinfo | (while read -r i
do
    t=$( echo "$t + $i" )
    c=$((c+1))
done
echo "scale=2; $t / $c / 1000" | awk '{print $1" GHz"}')
