screenshots
----

*Mountaineer Colorscheme*
![screenshot](./screenshots/mountaineer.png)

*Simple Dark Colorscheme*
![screenshot](./screenshots/simple-dark-cs.png)

*Gruvbox Material Colorscheme*
![screenshot](./screenshots/dwm_ss.png)

dwm
-----

dwm is an incredible lightweight and fast tiling window manager for X developed by the [suckless](https://suckless.org/) community. The window manager is written in C and also requires the enduser to modify the code if changes are desired. Luckily there are a lot of patches written by dwm/suckless users for those that are less familiar with C.

Patches
-----

- [fullgaps](https://dwm.suckless.org/patches/fullgaps/dwm-fullgaps-6.2.diff). Enable gaps between windows.
- [status2d](https://dwm.suckless.org/patches/status2d/dwm-status2d-20200508-60bb3df.diff). Enable colors for the statusbar.
- [centeredmaster](https://dwm.suckless.org/patches/centeredmaster/dwm-centeredmaster-6.1.diff). Only usefull on widescreens, not so much on mine
- [attachaside](https://dwm.suckless.org/patches/attachaside/dwm-attachaside-6.1.diff). New windows are added in the stack. Should've been the default behaviour in my opinion.


Usage
-----

Recommended to clone into you `.congif/` directory.

```
git clone https://github.com/manu-febie/dwm
```

```
sudo make clean install
```

```
# .xinitrc

exec dwm
```
