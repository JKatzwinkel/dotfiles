#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

xset +fp /usr/share/fonts/local
xset fp rehash

#display power management
xset -dpms
xset s 300

# kill X
setxkbmap -option terminate:ctrl_alt_bksp

#conky -d
xbindkeys

#xmodmap ~/.Xmodmap

eval $(cat ~/.fehbg)

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
exec i3

