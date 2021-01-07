#!/bin/bash
OPTIONS="Riavvia\nSpegni\nEsci"

LAUNCHER="rofi -width 30 -dmenu -i -p rofi-power:"
DM=lxdm-plymouth
option=`echo -e $OPTIONS | $LAUNCHER | awk '{print $1}' | tr -d '\r\n'`
if [ ${#option} -gt 0 ]
then
    case $option in
      Esci)
        systemctl restart $DM
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
