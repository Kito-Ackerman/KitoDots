#!/bin/bash
xrandr --output HDMI-2 --auto --right-of HDMI-1
picom &
slstatus &
dunst &
sxhkd &
~/.fehbg &
/usr/bin/emacs  --daemon & 
