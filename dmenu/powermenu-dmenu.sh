#!/bin/sh

LAUNCHER='dmenu -p "power : "'
DM=lxdm-plymouth
option=`echo -e "Riavvia\nSpegni\nLogout" | dmenu -i -l 4 -p "Power : " `
if [ ${#option} -gt 0 ]
then
    case $option in
      Esci)
        killall "${manager}" || output "Process ${manager} was not running."
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
