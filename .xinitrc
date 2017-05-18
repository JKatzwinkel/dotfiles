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
setxkbmap us altgr-intl -option terminate:ctrl_alt_bksp -option keypad:oss -option nbsp:level3 -option shift:breaks_caps -option caps:internal

#conky -d
xbindkeys

xmodmap ~/.Xmodmap

# set 'desktop' (X root window) background color
#hsetroot -solid \#254444 
#hsetroot -solid \#503444 
hsetroot -solid \#30232a 

# start flux to dim background light
xflux -l 52.5 -g 13.4 -k 2200

# set 'desktop' background if config is available
[[ -f ~/.fehbg ]] && sh ~/.fehbg

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
exec i3
#exec herbstluftwm --locked


