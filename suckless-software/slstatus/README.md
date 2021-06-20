## slstatus

[slstatus](https://tools.suckless.org/slstatus/) is a status monitor for window managers that use WM_NAME or stdin to fill the status bar.

## Dependencies

I use colored text output for slstatus and in order for this to work you need to have dwm patched with [status2d](https://dwm.suckless.org/patches/status2d/dwm-status2d-20200508-60bb3df.diff)
You just need to run :

```bash
slstatus &
```

in the autostart file.

## Widget i use

- Clock ( + lot of space to make it center of the screen )
- Custom script to read the updates (Pacupdate)
- Custom volume script
- Free Space on HDD
- Ram usage
- Username + ' on ' + hostname
