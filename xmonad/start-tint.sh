#!/bin/bash
if pgrep tint2; then
	pkill tint2
	exit 1
else
	tint2 -c ~/.config/tint2/panellauncher.tint2rc &
	tint2 -c ~/.config/tint2/clock.tint2rc &
	tint2 -c ~/.config/tint2/customscripts.tint2rc &
	tint2 -c ~/.config/tint2/icons.tint2rc &
	tint2 -c ~/.config/tint2/workspaces.tint2rc &
fi
exit
