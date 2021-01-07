#!/bin/bash

cmd="rofi"
app='...'
# until [ "$app" != "" ] && [ "$app" != "0" ];do
while [ "$app" != "" ] && [ "$app" != "0" ];do
    app=$(echo "$path" | awk '{ for ( i = 2; i <= $FN; ++i ) print $2,$i }' | $cmd -dmenu -theme kito-dmenu -i -p "Whereis $app :") 
    path=$(whereis "$app")
done
