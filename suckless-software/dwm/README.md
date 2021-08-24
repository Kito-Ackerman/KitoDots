## screenshots

_Centered master_
![screenshot](/screenshots/dwm-1.png)

_Firefox Fullscreen_
![screenshot](/screenshots/dwm-2.png)

_Common tile layout_
![screenshot](/screenshots/dwm-3.png)

## dwm

dwm is an incredible lightweight and fast tiling window manager for X developed by the [suckless](https://suckless.org/) community. The window manager is written in C, but the very particular feature of dwm is that there isn' t a real config file: you write the source code to make your DWM! There are a lot of prebuilded patch to make functions avaiable and that makes dwm the most extensible twm in the world, on par with xmonad or even better.

## Patches

I use this patches to make some functions i need to work :

- [fullgaps](https://dwm.suckless.org/patches/fullgaps/dwm-fullgaps-6.2.diff). Enable gaps between windows.
- [status2d](https://dwm.suckless.org/patches/status2d/dwm-status2d-20200508-60bb3df.diff). Enable colors for the statusbar.
- [centeredmaster](https://dwm.suckless.org/patches/centeredmaster/dwm-centeredmaster-6.1.diff). Cool layout to use. It is perfect on large screens but it can be awesome either on small ones like the mine.
- [attachaside](https://dwm.suckless.org/patches/attachaside/dwm-attachaside-6.1.diff). New windows are added in the stack.
- [cyclelayout](https://dwm.suckless.org/patches/cyclelayouts/). Switch layouts with a keycombination.
- [movestack](https://dwm.suckless.org/patches/movestack/). Move a window around the stack.
- [autostart](https://dwm.suckless.org/patches/autostart/). Start up some application automaticly when launch dwm.
- [actualfullscreen](https://dwm.suckless.org/patches/actualfullscreen/). Make windows fullscreen ( so borderless and without the topbar and gaps ).
- [no-title](https://dwm.suckless.org/patches/notitle/dwm-notitle-20210715-138b405.diff). Don' t show the window title
- [access-monitor](https://dwm.suckless.org/patches/accessnthmonitor/accessnthmon.diff). Interact with multi-monitor setup
