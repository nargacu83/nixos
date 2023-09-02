#!/usr/bin/env python3

# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

mod = "mod4"

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "shift"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "shift"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    # Key(
    #     [mod, "shift"],
    #     "Return",
    #     lazy.layout.toggle_split(),
    #     desc="Toggle between split and unsplit sides of stack",
    # ),
    Key([mod], "Return", lazy.spawn("alacritty"), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "f", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
]

group_names = [("1", {'layout': 'monadtall'}),
               ("2", {'layout': 'monadtall'}),
               ("3", {'layout': 'monadtall', 'matches': [Match(wm_class=["discord", "element"])]}),
               ("4", {'layout': 'monadtall'})]

group_keys = ["ampersand",
              "eacute",
              "quotedbl",
              "apostrophe"]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

for i, (name, kwargs) in enumerate(group_names, 0):
    # Switch to another group
    keys.append(Key([mod], group_keys[i], lazy.group[name].toscreen()))
    # Send current window to another group
    keys.append(Key([mod, "shift"], group_keys[i], lazy.window.togroup(name)))

theme_colors = {
    "fg_normal": "#f8f8f2",
    "fg_focus": "#ffffff",
    "bg_normal": "#282a36BF",
    "bg_focus": "#bd93f9ee",
    "bg_urgent": "#f8f8f2",
}

layouts = [
    layout.MonadTall(
        new_client_position = "top",
        border_width = 2,
        margin = 2,
        border_normal = theme_colors["bg_normal"],
        border_focus = theme_colors["bg_focus"],
    ),
    layout.Max(
        only_focused = False,
        border_width = 0,
        margin = 0,
        border_normal = theme_colors["bg_normal"],
        border_focus = theme_colors["bg_focus"],
    ),
]

widget_defaults = dict(
    font = "Cantarell Bold",
    fontsize = 11,
    padding = 5,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Clock(format="%a %d %b %Y"),
                widget.Sep(
                    linewidth = 0,
                    padding = 4
                ),
                widget.Clock(format="%H:%M"),
                widget.Spacer(),

                widget.GroupBox(),
                widget.Spacer(),

                widget.GenPollCommand(
                    cmd = "cpu-usage",
                    update_interval = 2
                ),
                widget.GenPollCommand(
                    cmd = "gpu-usage",
                    update_interval = 2
                ),
                widget.GenPollCommand(
                    cmd = "mem-usage",
                    update_interval = 2
                ),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                widget.Systray(
                    padding = 5
                ),
            ],
            30,
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = False
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry

        Match(wm_type='utility'),
        Match(wm_type='notification'),
        Match(wm_type='toolbar'),
        Match(wm_type='splash'),
        Match(wm_type='dialog'),
        Match(wm_class='file_progress'),
        Match(wm_class='confirm'),
        Match(wm_class='dialog'),
        Match(wm_class='download'),
        Match(wm_class='error'),
        Match(wm_class='notification'),
        Match(wm_class='splash'),
        Match(wm_class='toolbar'),
        Match(func=lambda c: c.has_fixed_size()),

        Match(wm_class='Arandr'),
        Match(wm_class='Blueman-manager'),
        Match(wm_class='Gpick'),
        Match(wm_class='Kruler'),
        Match(wm_class='MessageWin'), # kalarm.
        Match(wm_class='Sxiv'),
        Match(wm_class='Tor Browser'), # Needs a fixed window size to avoid fingerprinting by screen size.
        Match(wm_class='Wpa_gui'),
        Match(wm_class='veromix'),
        Match(wm_class='xtightvncviewer'),
        Match(wm_class='pavucontrol'),
        Match(wm_class='kdenlive'),
        Match(wm_class='pinentry-gtk-2'), # GPG key password entry
        Match(wm_class='Tor Browser'),
        Match(wm_class='origin.exe'),
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = False

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

@hook.subscribe.startup_once
def startup_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/autostart.sh'])
