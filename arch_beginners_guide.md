### establish internet conn
	iw dev
	wifi-menu wlpXXX

### mount partition
	lsblk -f
	mount /dev/sda2 /mnt

### mirror
	nano /etc/pacman.d/mirrorlist

### install base
	pacstrap -i /mnt base base-devel

Bei `invalid or corrupted package`:
	pacman-key --init
	pacman-key --populate archlinux

Bei `key could not be imported`:

	pacman -S archlinux-keyring
	pacman -Su

### fstab
	genfstab -U -p /mnt >> /mnt/etc/fstab
	nano /mnt/etc/fstab

### chroot & configure
	arch-chroot /mnt /bin/bash

### Locale anpassen: 
eintrag `en_US.UTF-8 UTF-8` in `/etc/locale.gen` uncommenten.
Locales generaten:
	locale-gen
locale.conf` erzeugen:

	echo LANG=en_US.UTF-8 > /etc/locale.conf
exportieren:

	export LANG=en_US.UTF-8

### time zone
	ln -s /usr/share/zoneinfo/<zone>/<subzone> /etc/localtime

hardware clock:

	hwclock --systohc --utc

### host name
	echo <hostname> > /etc/hostname
dann denselben hostname in `/etc/hosts` an den localhost eintrag hintenranhaengen




### password & user
	passwd # wenn wir root pw wollen
	useradd -m -G wheel -s /bin/zsh <user>
	passwd <user>
	su
	visudo # /etc/sudoers file, darin uncommenten:
		%wheel      ALL=(ALL) ALL

### bootloader
wenns denn sein musz:

	pacman -S grub
	grub-install --target=i386-pc --recheck /dev/sda
	pacman -S os-prober
	grub-mkconfig -o /boot/grub/grub.cfg 

bei BIOS-gesteuertem booten musz man natuerlich darauf achten, dasz man eine partition mit boot-flag hat:
https://bbs.archlinux.org/viewtopic.php?id=180549

### exit chroot & reboot
	exit
	reboot


### add wireless
**ERST NACH REBOOT!!!!!** sonst konfligiert wifi-menu mit dem auszerhalb der chroot-umgebung laufenden wireless profile!
	pacman -S iw wpa_supplicant dialog
	wifi-menu wlpXXX

#### known wifis: connect automatically
	pacman -S wpa_actiond
	systemctl enable netctl-auto@wlpXXX.service

Now, provided a known wifi is in range at boot time, we can connect to whatever known wifi
in range using

	netctl-auto switch-to <profile>

See netctl-auto --help for more options. 

Apparently, for `netctl-auto` to not fail starting profiles on boot,
those profiles must not be enabled by `systemctl` or `netctl` or whatever:
https://bbs.archlinux.org/viewtopic.php?id=164189
https://wiki.archlinux.org/index.php/Netctl
hence, `netctl disable <profile>` for every profile `netctl-auto` is supposed to take care of.

## yay!

### graphical user interface
	pacman -S i3
in `.xinitrc`:
	exec i3
Bei trouble mapping keys:
	xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'


### alsa:
https://bbs.archlinux.org/viewtopic.php?id=125092
https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture#Set_the_default_sound_card

default sound card in `/usr/share/alsa/alsa.conf` schreiben:

	pcm.!default {
				type hw
				card PCH
	}

	ctl.!default {
				type hw
				card PCH
	}

`PCH` ist der name der karte, den man mithilfe von `aplay -l` herausbekommt:

	**** List of PLAYBACK Hardware Devices ****
	card 0: HDMI [HDA Intel HDMI], device 3: HDMI 0 [HDMI 0]
		Subdevices: 1/1
		Subdevice #0: subdevice #0
	card 0: HDMI [HDA Intel HDMI], device 7: HDMI 1 [HDMI 1]
		Subdevices: 1/1
		Subdevice #0: subdevice #0
	card 0: HDMI [HDA Intel HDMI], device 8: HDMI 2 [HDMI 2]
		Subdevices: 1/1
		Subdevice #0: subdevice #0
	card 1: PCH [HDA Intel PCH], device 0: ALC3232 Analog [ALC3232 Analog]
		Subdevices: 0/1
		Subdevice #0: subdevice #0


#### Software-mixing in alsa aktivieren

https://bbs.archlinux.org/viewtopic.php?id=145505url
http://superuser.com/questions/461405/why-cant-i-play-audio-from-two-or-more-sources
https://bbs.archlinux.org/viewtopic.php?id=142657
https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture


### urxvt 

#### keybindings:
"a terminal has no knowledge of a Ctrl-Arrow keypress, BUT if you use a terminal emulator 
(like xterm or rxvt under X11) you can assign an X keyboard event to a string sequence like `^[[5D` that 
you then use in bindkey..."
http://zshwiki.org/home/zle/bindkeys
useful:

    xmodmap -pk

but keep in mind: `xmodmap` overwrites `setxkbmap` and is generally not recommended. To make
keybindings work in urxvt, it seems sufficient to map keys as required in `.Xresources` and
then bind the mapped input in `.xinitrc` or the shell''s rc (*e.g. `\033[1;5D` as `"\e[1;5D"`*).


### fonts
	fc-list -v # show verbose fonts info
	fc-cache  -fv # whenever new fonts have been put in /usr/share/fonts/...

#### infinality
[Infinality](https://wiki.archlinux.org/index.php/font_configuration#Infinality) is a patchset
improving `freetype2` font rendering: `freetype2-infinality-git`.  Available also, already with 
configurations via AUR is
`fontconfig-infinality-ultimate-git` (might be necessary to edit dependencies). It is also 
recommended to install and `grip-git` (AUR) for live fonts preview.

	$ fc-presets sets # select e.g. "combi"
	$ fc-presets check
	$ fc-cache -fv

Yay! Way better looking fonts in firefox and such!



### gfx

backlight: package `xorg-xbacklight`, usage: `xbacklight -inc/dec 10`.


### input devices

	xinput list

touchpad, wacom etc.


### CUPS

Arch cups is way newer than debian cups etc. So in order to talk to your debian printing server, add

   ServerName HOSTNAME-OR-IP-ADDRESS[:PORT]/version=1.1

to `/etc/cups/client.conf`. Also, in `/etc/cups/cups-files.conf`, add `printadmin` to `SystemGroup`
and then add yourself to that group (`gpasswd -a username printadmin`) and group `lp`.


### for convenience

#### keychain
package `keychain`. Add to shell profile:

    eval $(keychain --eval --agents ssh -Q --quiet ~/.ssh/id_rsa)




