#!/bin/bash

LAUNCHER='dmenu -p "power : "'
DM=lxdm-plymouth
option=`echo -e "Riavvia\nSpegni\nLogout" | dmenu -nf '#999' -nb '#292d3e' -sf '#eee' -sb '#0077bb' -i -l 4 -p "Power : " `
if [ ${#option} -gt 0 ]
then
    case $option in
      Esci)
	loginctl terminate-session $XDG_SESSION_ID
        ;;
      Riavvia)
        systemctl reboot
        ;;
      Spegni)
        systemctl poweroff
        ;;
      *)
        ;;
    esac
fi
