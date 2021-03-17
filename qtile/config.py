# -*- coding: utf-8 -*-
import os
import re
import socket
import subprocess
from libqtile import qtile
from libqtile.config import Click, Drag, Group, KeyChord, Key, Match, Screen
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
from libqtile.lazy import lazy
from typing import List  # noqa: F401

mod = "mod4"                                     # Sets mod key to SUPER/WINDOWS
myTerm = "alacritty"                             # My terminal of choice
browser = "brave-dev"
minimalbrowser = "vimb"
filemanager = "nautilus"

keys = [
         ### The essentials
         Key([mod], "Return",
             lazy.spawn(myTerm),
             desc='Launches My Terminal'
             ),
         Key([mod, "shift"], "Return",
             lazy.spawn("dmenu_run -i -p 'Run: '"),
             desc='Run Launcher'
             ),
         Key([mod], "Tab",
             lazy.next_layout(),
             desc='Toggle through layouts'
             ),
         Key([mod], "q",
             lazy.window.kill(),
             desc='Kill active window'
             ),
         Key([mod, "shift"], "r",
             lazy.restart(),
             desc='Restart Qtile'
             ),
         Key([mod, "shift"], "q",
             lazy.shutdown(),
             desc='Shutdown Qtile'
             ),
         Key([mod], "k",
             lazy.layout.down(),
             desc='Move focus down in current stack pane'
             ),
         Key([mod], "j",
             lazy.layout.up(),
             desc='Move focus up in current stack pane'
             ),
         Key([mod], "Right",
             lazy.layout.down(),
             desc='Move focus down in current stack pane'
             ),
         Key([mod], "Left",
             lazy.layout.up(),
             desc='Move focus up in current stack pane'
             ),
         Key([mod, "shift"], "k",
             lazy.layout.shuffle_down(),
             desc='Move windows down in current stack'
             ),
         Key([mod, "shift"], "j",
             lazy.layout.shuffle_up(),
             desc='Move windows up in current stack'
             ),
         Key([mod, "shift"], "Right",
             lazy.layout.shuffle_down(),
             desc='Move windows down in current stack'
             ),
         Key([mod, "shift"], "Left",
             lazy.layout.shuffle_up(),
             desc='Move windows up in current stack'
             ),
         Key([mod], "h",
             lazy.layout.shrink(),
             lazy.layout.decrease_nmaster(),
             desc='Shrink window (MonadTall), decrease number in master pane (Tile)'
             ),
         Key([mod], "l",
             lazy.layout.grow(),
             lazy.layout.increase_nmaster(),
             desc='Expand window (MonadTall), increase number in master pane (Tile)'
             ),
         Key([mod], "n",
             lazy.layout.normalize(),
             desc='normalize window size ratios'
             ),
         Key([mod], "m",
             lazy.window.toggle_fullscreen(),
             desc='toggle window between minimum and maximum sizes'
             ),
         Key([mod, "shift"], "f",
             lazy.window.toggle_floating(),
             desc='toggle floating'
             ),
         Key([mod, "shift"], "m",
             lazy.layout.maximize(),
             desc='toggle fullscreen'
             ),
         Key([mod, "shift"], "space",
             lazy.layout.rotate(),
             lazy.layout.flip(),
             desc='Switch which side main pane occupies (XmonadTall)'
             ),

         #Gui apps
         Key([mod,"control"], "f",
             lazy.spawn(filemanager),
             desc='launch GUI filemanager'
             ),
         Key([mod,"control"], "b",
             lazy.spawn(browser),
             desc='launch GUI Browser'
             ),
         Key([mod,"control"], "q",
             lazy.spawn(minimalbrowser),
             desc='launch minimal browser'
             ),
         Key([mod,"control"], "c",
             lazy.spawn("ferdi"),
             desc='launch my chat client (ferdi actually)'
             ),
         Key([mod,"control"], "h",
             lazy.spawn("bpytop"),
             desc='launch htop replacement'
             ),

         # Emacs programs launched using the key chord MOD+e followed by 'key'
         KeyChord([mod],"e", [
             Key([], "e",
                 lazy.spawn("emacsclient -c -a 'emacs'"),
                 desc='Launch Emacs'
                 ),
             Key([], "b",
                 lazy.spawn("emacsclient -c -a 'emacs' --eval '(ibuffer)'"),
                 desc='Launch ibuffer inside Emacs'
                 ),
             Key([], "d",
                 lazy.spawn("emacsclient -c -a 'emacs' --eval '(dired nil)'"),
                 desc='Launch dired inside Emacs'
                 ),
             Key([], "i",
                 lazy.spawn("emacsclient -c -a 'emacs' --eval '(erc)'"),
                 desc='Launch erc inside Emacs'
                 ),
             Key([], "m",
                 lazy.spawn("emacsclient -c -a 'emacs' --eval '(mu4e)'"),
                 desc='Launch mu4e inside Emacs'
                 ),
             Key([], "n",
                 lazy.spawn("emacsclient -c -a 'emacs' --eval '(elfeed)'"),
                 desc='Launch elfeed inside Emacs'
                 ),
             Key([], "s",
                 lazy.spawn("emacsclient -c -a 'emacs' --eval '(eshell)'"),
                 desc='Launch the eshell inside Emacs'
                 ),
             Key([], "v",
                 lazy.spawn("emacsclient -c -a 'emacs' --eval '(+vterm/here nil)'"),
                 desc='Launch vterm inside Emacs'
                 )
         ]),

         # Gui applications using key chord MOD+Control followed by 'key'

         # Dmenu scripts launched using the key chord SUPER+p followed by 'key'
         KeyChord([mod], "p", [
             Key([], "x",
                 lazy.spawn("sh /home/kito/.config/dmenu/powermenu-dmenu.sh"),
                 desc='Power menu with dmenu'
                 ),
             Key([], "c",
                 lazy.spawn("sh /home/kito/.config/dmenu/dmenu-edit-config.sh"),
                 desc='Quick configuration file edit with dmenu'
                 ),
             Key([], "q",
                 lazy.spawn("sh /home/kito/.config/dmenu/dmenu-bookmarks.sh"),
                 desc='vimb integration with dmenu'
                 ),
             Key([], "s",
                 lazy.spawn("sh /home/kito/.config/dmenu/dmenu-scrot.sh"),
                 desc='Take screenshots via dmenu'
                 ),
         ])

]

group_names = [("DEV", {'layout': 'monadtall'}),
               ("WWW", {'layout': 'max'}),
               ("CHAT", {'layout': 'monadtall'}),
               ("DOC", {'layout': 'monadtall'}),
               ("SYS", {'layout': 'monadtall'}),
               ("VBOX", {'layout': 'monadtall'}),
               ("MUS", {'layout': 'monadtall'}),
               ("VID", {'layout': 'monadtall'}),
               ("GFX", {'layout': 'floating'})]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

for i, (name, kwargs) in enumerate(group_names, 1):
    keys.append(Key([mod], str(i), lazy.group[name].toscreen()))        # Switch to another group
    keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name))) # Send current window to another group

layout_theme = {"border_width": 2,
                "margin": 10,
                "border_focus": "89ddff",
                "border_normal": "89aaff"
                }

layouts = [
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.Matrix(**layout_theme),
    layout.Max(**layout_theme),
    layout.Floating(**layout_theme)
    # layout.Bsp(**layout_theme),
    # layout.Stack(stacks=2, **layout_theme),
    # layout.Columns(**layout_theme),
    # layout.RatioTile(**layout_theme),
    # layout.VerticalTile(**layout_theme),
    # layout.Zoomy(**layout_theme),
    # layout.Tile(shift_windows=True, **layout_theme),
    # layout.Stack(num_stacks=2),
    # layout.TreeTab(
    #      font = "Ubuntu",
    #      fontsize = 10,
    #      sections = ["FIRST", "SECOND"],
    #      section_fontsize = 11,
    #      bg_color = "141414",
    #      active_bg = "90C435",
    #      active_fg = "000000",
    #      inactive_bg = "384323",
    #      inactive_fg = "a0a0a0",
    #      padding_y = 5,
    #      section_top = 10,
    #      panel_width = 320
    #      ),
]

colors = [["#2e3440", "#2e3440"], # background
          ["#242831", "#242831"], # background alt
          ["#ffffff", "#ffffff"], # white
          ["#ff5555", "#ff5555"], # white alt
          ["#797FD4", "#797FD4"], # violet
          ["#89aaff", "#89aaff"], # blue
          ["#89ddff", "#89ddff"], # ice
          ["#E05F27", "#E05F27"], # orange
          ["#c3e88d", "#c3e88d"], # green
          ["#ffcb6b", "#ffcb6b"], # orange
          ["#f07178", "#f07178"]] # red

##### DEFAULT WIDGET SETTINGS #####
widget_defaults = dict(
    font="Ubuntu Mono",
    fontsize = 12,
    padding = 2,
    background=colors[2]
)
extension_defaults = widget_defaults.copy()

def init_widgets_list():
    widgets_list = [
              widget.Sep(
                       linewidth = 0,
                       padding = 6,
                       foreground = colors[2],
                       background = colors[1]
                       ),
              widget.Image(
                       filename = "~/.config/qtile/icons/python-white.png",
                       scale = "False",
                       mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn("dmenu_run -c -l 15 -i -p 'Run :'")}
                       ),
             widget.Sep(
                       linewidth = 0,
                       padding = 6,
                       foreground = colors[2],
                       background = colors[1]
                       ),
              widget.GroupBox(
                       font = "Ubuntu Bold",
                       fontsize = 9,
                       margin_y = 3,
                       margin_x = 0,
                       padding_y = 5,
                       padding_x = 3,
                       borderwidth = 3,
                       active = colors[2],
                       inactive = colors[2],
                       rounded = False,
                       highlight_color = colors[0],
                       highlight_method = "line",
                       this_current_screen_border = colors[6],
                       this_screen_border = colors [4],
                       other_current_screen_border = colors[6],
                       other_screen_border = colors[4],
                       foreground = colors[2],
                       background = colors[1]
                       ),
              widget.Sep(
                       linewidth = 0,
                       padding = 40,
                       foreground = colors[2],
                       background = colors[1]
                       ),
              widget.WindowName(
                       max_chars = 25,
                       empty_group_string = '---',
                       foreground = colors[6],
                       background = colors[1],
                       padding = 0
                       ),
              widget.Sep(
                       linewidth = 0,
                       padding = 6,
                       foreground = colors[1],
                       background = colors[1]
                       ),
              widget.TextBox(
                       text = ' ',
                       background = colors[1],
                       foreground = colors[0],
                       padding = 0,
                       fontsize = 20
                       ),
              widget.TextBox(
                       text = ' ',
                       background = colors[1],
                       foreground = colors[0],
                       padding = 0,
                       fontsize = 20
                       ),
              widget.Clock(
                       foreground = colors[6],
                       background = colors[0],
                       format = "   %A, %B %d - %H:%M "
                       ),
              widget.TextBox(
                       text = ' ',
                       background = colors[1],
                       foreground = colors[0],
                       padding = 0,
                       fontsize = 20
                       ),
              # widget.Sep(
              #          linewidth = 1,
              #          padding = 6,
              #          foreground = colors[1],
              #          background = colors[1],
              #          ),
              widget.TextBox(
                       text = ' ',
                       background = colors[1],
                       foreground = colors[0],
                       padding = 0,
                       fontsize = 20
                       ),
             widget.Net(
                       interface = "enp37s0",
                       format = '  ↓ {down} ↑ {up}',
                       foreground = colors[8],
                       background = colors[0],
                       padding = 5
                       ),
              widget.TextBox(
                       text = ' ',
                       background = colors[1],
                       foreground = colors[0],
                       padding = 0,
                       fontsize = 20
                       ),
              widget.TextBox(
                       text = ' ',
                       background = colors[1],
                       foreground = colors[0],
                       padding = 0,
                       fontsize = 20
                       ),
              widget.TextBox(
                       text = " 🌡",
                       padding = 2,
                       foreground = colors[2],
                       background = colors[0],
                       fontsize = 11
                       ),
              widget.ThermalSensor(
                       foreground = colors[10],
                       background = colors[0],
                       threshold = 90,
                       padding = 5
                       ),
              widget.TextBox(
                       text = ' ',
                       background = colors[1],
                       foreground = colors[0],
                       padding = 0,
                       fontsize = 20
                       ),
              widget.TextBox(
                       text = ' ',
                       background = colors[1],
                       foreground = colors[0],
                       padding = 0,
                       fontsize = 20
                       ),
              widget.TextBox(
                       text = " ⟳",
                       padding = 2,
                       foreground = colors[9],
                       background = colors[0],
                       fontsize = 14
                       ),
              widget.CheckUpdates(
                       update_interval = 1800,
                       distro = "Arch_checkupdates",
                       display_format = "{updates} Updates",
                       mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e sudo pacman -Syu')},
                       foreground = colors[9],
                       background = colors[0]
                       ),
              widget.TextBox(
                       text = ' ',
                       background = colors[1],
                       foreground = colors[0],
                       padding = 0,
                       fontsize = 20
                       ),
              widget.TextBox(
                       text = ' ',
                       background = colors[1],
                       foreground = colors[0],
                       padding = 0,
                       fontsize = 20
                       ),
              widget.TextBox(
                       text = "   ",
                       foreground = colors[4],
                       background = colors[0],
                       padding = 0,
                       fontsize = 14
                       ),
              widget.Memory(
                       foreground = colors[4],
                       background = colors[0],
                       mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e bpytop')},
                       padding = 5
                       ),
              widget.TextBox(
                       text = ' ',
                       background = colors[1],
                       foreground = colors[0],
                       padding = 0,
                       fontsize = 20
                       ),
              widget.TextBox(
                       text = ' ',
                       background = colors[1],
                       foreground = colors[0],
                       padding = 0,
                       fontsize = 20
                       ),
              widget.TextBox(
                       text = " :",
                       foreground = colors[9],
                       background = colors[0],
                       padding = 0
                       ),
              widget.Volume(
                       foreground = colors[9],
                       background = colors[0],
                       padding = 5
                       ),
              widget.TextBox(
                       text = ' ',
                       background = colors[1],
                       foreground = colors[0],
                       padding = 0,
                       fontsize = 20
                       ),
              widget.TextBox(
                       text = ' ',
                       background = colors[1],
                       foreground = colors[0],
                       padding = 0,
                       fontsize = 20
                       ),
              widget.CurrentLayoutIcon(
                       custom_icon_paths = [os.path.expanduser("~/.config/qtile/icons")],
                       foreground = colors[0],
                       background = colors[0],
                       padding = 0,
                       scale = 0.7
                       ),
              widget.CurrentLayout(
                       foreground = colors[2],
                       background = colors[0],
                       padding = 5
                       ),
              widget.TextBox(
                       text = ' ',
                       background = colors[1],
                       foreground = colors[0],
                       padding = 0,
                       fontsize = 20
                       ),
              ]
    return widgets_list

def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    del widgets_screen1[7:8]               # Slicing removes unwanted widgets (systray) on Monitors 1,3
    return widgets_screen1

def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    return widgets_screen2                 # Monitor 2 will display all widgets in widgets_list

def init_screens():
    return [Screen(top=bar.Bar(widgets=init_widgets_screen1(), opacity=1.0, size=20)),
            Screen(top=bar.Bar(widgets=init_widgets_screen2(), opacity=1.0, size=20)),
            Screen(top=bar.Bar(widgets=init_widgets_screen1(), opacity=1.0, size=20))]

if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_list()
    widgets_screen1 = init_widgets_screen1()
    widgets_screen2 = init_widgets_screen2()

def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)

def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)

def window_to_previous_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i != 0:
        group = qtile.screens[i - 1].group.name
        qtile.current_window.togroup(group)

def window_to_next_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i + 1 != len(qtile.screens):
        group = qtile.screens[i + 1].group.name
        qtile.current_window.togroup(group)

def switch_screens(qtile):
    i = qtile.screens.index(qtile.current_screen)
    group = qtile.screens[i - 1].group
    qtile.current_screen.set_group(group)

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    # default_float_rules include: utility, notification, toolbar, splash, dialog,
    # file_progress, confirm, download and error.
    *layout.Floating.default_float_rules,
    Match(title='Confirmation'),  # tastyworks exit box
    Match(wm_class='pinentry-gtk-2'),  # GPG key password entry
])
auto_fullscreen = True
focus_on_window_activation = "smart"

@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
