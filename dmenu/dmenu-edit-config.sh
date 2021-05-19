#!/bin/bash
#  ____ _____
# |  _ \_   _|  Derek Taylor (DistroTube)
# | | | || |    http://www.youtube.com/c/DistroTube
# | |_| || |    http://www.gitlab.com/dwt1/
# |____/ |_|
#
# Dmenu script for editing some of my more frequently edited config files.


declare options=("alacritty
awesome
bash
doom.d/config.el
doom.d/init.el
dunst
neovim
picom
polybar
quickmarks
qutebrowser
xmobar
xmonad
zsh
quit")

choice=$(echo -e "${options[@]}" | dmenu -i -p 'Edit config file: ')

case "$choice" in
	quit)
		echo "Program terminated." && exit 1
	;;
	alacritty)
		choice="$HOME/.config/alacritty/alacritty.yml"
	;;
	awesome)
		choice="$HOME/.config/awesome/rc.lua.org"
	;;
	bash)
		choice="$HOME/.bashrc.org"
	;;
    doom.d/config.el)
		choice="$HOME/.doom.d/config.el"
	;;
    doom.d/init.el)
		choice="$HOME/.doom.d/init.el"
	;;
	dunst)
		choice="$HOME/.config/dunst/dunstrc"
	;;
	emacs.d/init.el)
		choice="$HOME/.emacs.d/init.el"
	;;
	neovim)
		choice="$HOME/.config/nvim/init.vim"
	;;
	picom)
		choice="$HOME/.config/picom/picom.conf"
	;;
	polybar)
		choice="$HOME/.config/polybar/config"
	;;
	quickmarks)
		choice="$HOME/.config/qutebrowser/quickmarks"
	;;
	qutebrowser)
		choice="$HOME/.config/qutebrowser/autoconfig.yml"
	;;
	xmobar)
		choice="$HOME/.config/xmobar/xmobarrc0"
	;;
	xmonad)
		choice="$HOME/.xmonad/xmonad.hs.org"
	;;
	zsh)
		choice="$HOME/.zshrc.org"
	;;
	*)
		exit 1
	;;
esac
alacritty -e nvim  "$choice" 
# emacsclient -c -a emacs "$choice"

