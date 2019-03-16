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

`locale.conf` erzeugen:

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
    
		visudo 
		
		# oeffnet /etc/sudoers file, 
		# darin uncommenten:

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



## Post-Installation

Good moves are also documented in [this](http://tutos.readthedocs.org/en/latest/source/Arch.html).

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

#### eduroam:

password hash:

    echo -n password_here | iconv -t utf16le | openssl md4

working config file for standard eduroam (`/etc/netctl/eduroam`, working at campus, adw academy, ...):

	Description='Eduroam-profile'
	Interface=wlp2s0
	Connection=wireless
	Security=wpa-configsection
	IP=dhcp
	WPAConfigSection=(
	 'ssid="eduroam"'
	 'proto=RSN WPA'
	 'key_mgmt=WPA-EAP'
	 'auth_alg=OPEN'
	 'eap=PEAP'
	 'anonymous_identity="anonymous@zedat.fu-berlin.de"'
	 'identity="username@zedat.fu-berlin.de"'
	 'ca_path="/etc/ssl/certs"'
	 'ca_path2="/etc/ssl/certs"'
	 'phase1="peaplevel=0"'
	 'phase2="auth=MSCHAPV2"'
	 'password=hash:********'
	 'priority=2'
	)

*yay!*

### filesystems

  * vfat: `dosfstools`

## X

### i3 

	  pacman -S i3

in `.xinitrc`:

  	exec i3
	
Bei trouble mapping keys:

    xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'

#### stuff for i3


##### i3-gaps:

[i3-gaps](https://github.com/Airblader/i3): fork with additional features, like gaps between windows.

build like [this](https://github.com/Airblader/i3/wiki/Compiling-&-Installing):

		# compile & install
		autoreconf --force --install
		rm -rf build/
		mkdir -p build && cd build/

		# Disabling sanitizers is important for non-release versions!
		# The prefix and sysconfdir are, obviously, dependent on the distribution.
		#../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
		../configure
		make
		sudo make install

Sanitizers ausschalten wirklich voll wichtig sonst startet i3 nur noch bei angabe von `LD_PRELOAD=<libasan.so path>` und braucht
utopische mengen arbeitsspeicher.

##### rofi

[rofi](https://github.com/DaveDavenport/rofi) (`rofi-git`). Better than `dmenu`. Settings go into `.Xresources`.
Rofi-based mpd client??? [clerk](https://github.com/carnager/clerk). Interesting. Run `rofi -show run`.

###### random resources

look, [config files](https://github.com/akrasic/i3-config)!


##### jazz up i3 status bar

Show title of focused window in i3bar [1](https://faq.i3wm.org/question/1537/show-title-of-focused-window-in-status-bar/).

###### i3blocks
Show custom script output in i3 status bar.
[i3blocks](https://github.com/vivien/i3blocks) overvides the `i3status`
configuration and defines widget-like blocks that invoke specified commands
and can be configured seperately so that some get updated more frequently than
others, for example. There is also a
[wiki](https://github.com/vivien/i3blocks/wiki/Blocklets) and there are many
examples. Sits on GTK+3.
Special bonus: supplies its font configurations (multiple fallback fonts can be
listed) to other X applications like the terminal exmulator via `pango`. This
way it can be possible to have fancy unicode glyphs be rendered in the shell
that were not shown before. Yay!


#### Compton

[Compton](https://wiki.archlinux.org/index.php/Compton) might be able to manage stuff like graying out windows without
focus (which URxvt can by itself, but termite can not) and getting rid of
tearing / vsync issues. 

Discussion and samples config [here](https://faq.i3wm.org/question/3279/do-i-need-a-composite-manager-compton/)

Compton can totally improve rendering. There is a [performance guide](https://github.com/chjj/compton/wiki/perf-guide),
and even a [vsync guide](https://github.com/chjj/compton/wiki/vsync-guide). 



## sound

### alsa:
 - [forum](https://bbs.archlinux.org/viewtopic.php?id=125092)
 - [wiki](https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture#Set_the_default_sound_card)

default sound card in `/usr/share/alsa/alsa.conf` schreiben:

	pcm.!default {
				type hw
				card PCH
	}

	ctl.!default {
				type hw
				card PCH
	}

oder sowas wie

	pcm.!default {
			type plug
			slave.pcm {
					@func getenv
					vars [ ALSAPCM ]
					default "hw:PCH"
			}
	}

`defaults.pcm.card` musz auch `1` sein:

	defaults.ctl.card 1
	defaults.pcm.card 1
	defaults.pcm.device 0
	defaults.pcm.subdevice -1
	defaults.pcm.nonblock 1
	defaults.pcm.compat 0

`PCH` ist der name der karte, den man mithilfe von `aplay -l` herausbekommt (capture device analog mit `arecord -l`):

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


#### pulseaudio emulieren

Manche applications brauchen pulseaudio um sound abzuspielen, z.b. firefox (ab version 52).
Um kein pulseaudio installieren zu muessen, kann man [emulator](https://github.com/i-rinat/apulse)
benutzen (installieren aus AUR). Zum diesen nutzt man dann zum starten des fragliche programms, 
z.b. `apulse firefox`, `apulse skype` etc.

Man musz aber auch folgendes zu seiner alsa-conf (z.b. `/usr/share/alsa/alsa.conf`) hinzufuegen:

		pcm.!default {
				type plug
				slave.pcm "asymed"
		}


		pcm.asymed {
				type asym
				playback.pcm {
						@func getenv
						vars [ ALSAPCM ]
						default "dmix"
				}
				capture.pcm "dsnoop"
		}

Edit: ok offenbar nicht wirklich, jedenfalls wird das bei update rausgeloescht und sound in firefox und sogar externes mikro
in telegram geht trotzdem.


#### Software-mixing in alsa aktivieren

https://bbs.archlinux.org/viewtopic.php?id=145505url
http://superuser.com/questions/461405/why-cant-i-play-audio-from-two-or-more-sources
https://bbs.archlinux.org/viewtopic.php?id=142657
https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture


### having fun hearing sound

`mocp`, `cmus`, `mpd`, `ncmpc`, `mpv`, `mps`, `mps-youtube`, ...

##### cmus

there is a standalone last.fm scrobbler compatible with their new API which can
be connected to cmus:
[cmusfm](https://github.com/Arkq/cmusfm).

It is put in usage by cmus with `set
status_display_program=/usr/local/bin/cmusfm`. `libnotify`-popups can be  activated
in `.config/cmus/cmusfm.conf`.






## Terminal

### urxvt 

I.e. `urxvt-unicode-patched` from AUR.

#### Perl

when upgrading perl, warnings might show that there is data in perl directories that will no longer be used by interpreter. Those directories are:

    /usr/lib/perl5/core_perl
    /usr/lib/perl5/site_perl
    /usr/lib/perl5/vendor_perl

to find those packages who stored data in there that won't be used by interpreter, we run.

    pacman -Qqo /usr/lib/perl5/{core,site,vendor}_perl

find all include directories perl uses:

    perl -E 'map {say $_} @INC'




#### keybindings:

"a terminal has no knowledge of a Ctrl-Arrow keypress, BUT if you use a terminal emulator 
(like xterm or rxvt under X11) you can assign an X keyboard event to a string sequence like `^[[5D` that 
you then use in bindkey..."
http://zshwiki.org/home/zle/bindkeys
useful:

    xmodmap -pk

but keep in mind: `xmodmap` overwrites `setxkbmap` and is generally not recommended. To make
keybindings work in urxvt, it seems sufficient to map keys as required in `.Xresources` and
then bind the mapped input in `.xinitrc` or the shell''s rc *(e.g. `\033[1;5D` as `"\e[1;5D"`)*.

For more information on keycodes, keysyms and `xmodmap`, read arch wiki entry on [xmodmap](https://wiki.archlinux.org/index.php/xmodmap).

##### `xbindkeys`

Assign commands to certain *keysym* s in `xbindkeys` config file `.xbindkeysrc` like this (command first, keysym in next line):

		# adjust backlight using package xorg-xbacklight
		"xbacklight -inc 10"
			XF86MonBrightnessUp
		"xbacklight -dec 10"
			XF86MonBrightnessDown

		# make screenshot (requires gnome-screenshot tool)
		"gnome-screenshot"
			Shift + Menu

`xbindkeys` must be called in `.xinitrc`, obviously. Find a list of all assigneable keysyms [here](http://wiki.linuxquestions.org/wiki/List_of_Keysyms_Recognised_by_Xmodmap).
To find out the correct keysyms to assign a command to, run `xbindkeys -k` and press key(s) in question.


##### keycodes misc:

read [XKB](https://wiki.archlinux.org/index.php/X_KeyBoard_extension) and [xmodmap](https://wiki.archlinux.org/index.php/Xmodmap)
wiki articles, install `xorg-xev`, `xorg-xkbutils`.

We choose keyboard layout, variant and options with `setxkbmap`. Read `man xkeyboard-config` for details.
When using layout `us`, one might consider to use variant `altgr-intl` in order to access 3rd level characters like 
umlauts or €-sign with AltGr-key. Check current settings with `setxkbmap -query` oder `setxkbmap -print -verbose 10`.

 
### Termite

[Termite](https://wiki.archlinux.org/index.php/Talk:Termite) has a vim-like command mode and a hint overlay like
`dwb` etc. and some more interesting [features](https://github.com/thestinger/termite/blob/master/README.rst).
It also supports [Fontconfig](https://wiki.archlinux.org/index.php/Font_configuration), where URxvt only
supports [Xft](http://en.wikipedia.org/wiki/Xft).
It has no built-in dimming function for inactive windows, but for that, we can use `compton`.
There are also issues with `dircolors` required for colored `ls` output, which might disable 
`ls` colors in ssh-shells entirely. In local shells, this can be worked around, as described
at [arch wiki](https://wiki.archlinux.org/index.php/Termite#Colored_ls_output):


> For colored `ls` output it is necessary to use a custom `LS_COLORS` environment variable, which can be set with a dircolors file. Generate one with:

	$ dircolors -p > ~/.dircolors

> Then edit `~/.dircolors` file, and append

	TERM xterm-termite

Termite config file itself is at `.config/termite/config`. 


### fonts

Random references: [1](http://www.jaysonrowe.com/2013/04/font-configuration-in-arch-linux.html)

Fontconfig:

		fc-list -v # show verbose fonts info
		fc-cache  -fv # whenever new fonts have been put in /usr/share/fonts/...

		fc-list :spacing=mono family style # show monospace font family names and styles [?]


in `.Xresources`: `URxvt*font: xft:Font Family Name:size=11:antialias=true:hinting=true, xft:Fallback Font:...`

view font characters: use `xfd` (`xorg-xfd`):
	
		xfd -fa "font name"

to test font settings outcome in terminal, this script can be useful (from [arch wiki](https://bbs.archlinux.org/viewtopic.php?id=169810)):


		#!/bin/bash
		x=(0 1 2 3 4 5 6 7 8 9 A B C D E F)
		for a in {0..15}; do for b in {0..15}; do for c in {0..15}; do
			[[ $a -eq 0 && $b -eq 0 && $c -lt 2 ]] && continue
			echo -en "\n${x[$a]}${x[$b]}${x[$c]}X: "
			for d in {0..15}; do
				echo -en "\u${x[$a]}${x[$b]}${x[$c]}${x[$d]}"
			done
		done; done; done

(*pipe this through pager, otherweise terminal font rendering might be fucked up.*)
However, some fonts lie about their glyph size, so that even though they include a certain character,
rather than itself, only a little frame is shown because the terminal thinks the glyph is too large
or whatever. It can be made to render those characters, but only by setting `URxvt*letterSpace: 4`
or something the like, which looks as butt-ugly as expected.

doesnt hurt: `adobe-source-han-sans-jp-fonts` (contains source han sans jp)
and something like suggested [here](https://bbs.archlinux.org/viewtopic.php?id=172811).
Test with [this](http://www.cl.cam.ac.uk/~mgk25/ucs/examples/UTF-8-demo.txt).
[Here](https://www.reddit.com/r/archlinux/comments/2diqx8/what_font_packages_do_you_usually_install/)
is a fonts diskussion on reddit.

update X server: `xrdb -merge .Xresources`

Here is some devs writing [about urxvt](http://pod.tst.eu/http://cvs.schmorp.de/rxvt-unicode/doc/rxvt.7.pod#Rendering_Font_amp_Look_and_Feel_Iss)

#### infinality

[Infinality](https://wiki.archlinux.org/index.php/font_configuration#Infinality) is a patchset
improving `freetype2` font rendering: `freetype2-infinality-git`.  Available also, already with 
configurations via AUR is
`fontconfig-infinality-ultimate-git` (might be necessary to edit dependencies).

Its also available via
`pacman` when the repo is added to `pacman.conf`:

	[infinality-bundle]
	Server = http://bohoomil.com/repo/$arch

The developers key is also required. Get it with `pacman-key -r 962DDE58`. It should arrive us follows:

	$ gpg --fingerprint 962DDE58
	pub   rsa2048/962DDE58 2013-04-22
				Key fingerprint = A924 4FB5 E93F 11F0 E975  337F AE68 66C7 962D DE58
	uid       [ unknown] bohoomil (dev key) <bohoomil@zoho.com>
	sub   rsa2048/C83B4AD8 2013-04-22

Now we can install the meta package `infinality-bundle`.

##### grip

It is also 
recommended to install and `grip-git` (AUR) for live fonts preview.

	$ fc-presets sets # select e.g. "combi"
	$ fc-presets check
	$ fc-cache -fv

Yay! Way better looking fonts in firefox and such!

#### freetype 

Because infinality maintainer bohoomil disappeared in january 2017, it cannot be used alongside harfbuzz anymore.
We need to switch to freetype2.
[Here](https://gist.github.com/cryzed/e002e7057435f02cc7894b9e748c5671) is how.

    ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
		ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
		ln -s /etc/fonts/conf.avail/10-hinting-slight.conf /etc/fonts/conf.d # if necessary!

install `fonts-meta-extended-lt`.
find optional deps of `pacman -Qi fonts-meta-base fonts-meta-extended-lt`
and install them with `--asdeps` flag.


add to `/etc/profile.d/jre.sh`:

		# https://wiki.archlinux.org/index.php/java#Better_font_rendering
		export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'


### Termite

heiszer tip von niels: [termite](https://wiki.archlinux.org/index.php/Termite)
kann so sachen wie follow links overlay (wie dwb, vimperator, qutie...)




### gfx

backlight: package `xorg-xbacklight`, usage: `xbacklight -inc/dec 10`.

webcam:

    mplayer tv:// -tv driver=v4l2:width=1071:height=600:device=/dev/video0 -fps 10 -vf screenshot

### input devices

	xinput list

touchpad, wacom etc.


### CUPS

Arch cups is way newer than debian cups etc. So in order to talk to your debian printing server, add

   ServerName HOSTNAME-OR-IP-ADDRESS[:PORT]/version=1.1

to `/etc/cups/client.conf`. Also, in `/etc/cups/cups-files.conf`, add `printadmin` to `SystemGroup`
and then add yourself to that group (`gpasswd -a username printadmin`) and group `lp`.

damit bei `lpstat` und `lpinfo` kein `bad file descriptor` kommt, macht man in `/etc/cups/client.conf` auszerdem rein:

    ServerName /var/run/cups/cups.sock


### cron

implementation `fcron`: `systemctl enable/start fcron.service`. `fcrontab -e`

### ACPI etc.

	upower -e
		/org/freedesktop/UPower/devices/line_power_ADP1
		/org/freedesktop/UPower/devices/battery_BAT0
		/org/freedesktop/UPower/devices/DisplayDevice
	upower -i /org/freedesktop/UPower/devices/battery_BAT0


Change default behaviour of power button, closed lid etc:

  /etc/systemd/logind.conf


#### thinkpad

kernel modules: `thinkpad_acpi`, 

packages: `tlp`, `tpacpi-bat`, 


#### udev

[writing udev rules](http://reactivated.net/writing_udev_rules.html)
[how to write udev rules](http://hackaday.com/2009/09/18/how-to-write-udev-rules/)

		# query path of battery device
		udevadm info -q path --path=/sys/class/power_supply/BAT0
		# use the query result device path with udevadm test
		udevadm test $(udevadm info -q path --path=/sys/class/power_supply/BAT0)

`/etc/udev/rules.d/98-discharge.rules`:

		# log battery capacities on discharge
		SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", RUN+="/usr/bin/bash /home/thor/projects/battery/batlog.sh"

https://wiki.archlinux.org/index.php/udev#Writing_udev_rules


### for convenience

#### auto mount devices with udisks/udisks2/udevil or whatever

install `udisks2` and [`udevil`](https://github.com/IgnorantGuru/udevil/blob/master/README). 
[The latter](http://ignorantguru.github.io/udevil/#post) includes `devmon`, which needs to be run as a systemd service:

	systemctl enable devmon@<user>.service
	systemctl start devmon@<user>

Then, plug and play... Umount with `devmon -c`.


#### keychain
package `keychain`. Add to shell profile:

    eval $(keychain --eval --agents ssh -Q --quiet ~/.ssh/id_rsa)



#### package management

##### pkgfile
package `pkgfile`: search files in repo packages. `pkgfile -u` syncs database,
`pkgfile <file>` finds package shipping file:

		pkgfile ss
	
##### pacman commands:

		sudo pacman -Syu		# Synchronize with repositories and then upgrade packages that are out of date on the local system.
		pacman -Sw		# Download specified package(s) as .tar.xz ball
		sudo pacman -S		# Install specific package(s) from the repositories
		sudo pacman -U		# Install specific package not from the repositories but from a file 
		sudo pacman -R		# Remove the specified package(s), retaining its configuration(s) and required dependencies
		sudo pacman -Rns		# Remove the specified package(s), its configuration(s) and unneeded dependencies
		pacman -Rc 		# remove package and all packages dependent on it (useful for haskell and other dump-fuck garbage)
		pacman -Si		# Display information about a given package in the repositories
		pacman -Ss		# Search for package(s) in the repositories
		pacman -Qi		# Display information about a given package in the local database
		pacman -Qs		# Search for package(s) in the local database
		pacman -Qdt		# List all packages which are orphaned
		sudo pacman -Scc		# Clean cache - delete all the package files in the cache
		pacman -Ql		# List all files installed by a given package
		pacman -Qo		# Show package(s) owning the specified file(s)
		pacman -Qqo		# same but with more concise output
		pacman -D --asexp	# Mark one or more installed packages as explicitly installed 
		pacman -D --asdep	# Mark one or more installed packages as non explicitly installed
		pacman -Qqettm # package list without version numbers, only explicitly installed not required directly by other package and from AUR
		pacman -Qqettn # same but native instead foreign (AUR)
		pacman -Rns $(pacman -Qtdq) # remove orphans and their configuration files


(from [arch wiki](https://wiki.archlinux.org/index.php/Pacman_tips))

    pactree --reverse <package>

##### expac (databasae extraction utility)

largest packages:

		 expac -HM "%011m\t%-20n\t%10d" | sort -n

most recently installed/updated packages:

		expac --timefmt=%s '%l\t%n' | sort -n | tail -20

show versions of installed packages:

		expac -s "%-30n %v"
		pacman -Qm
		pacman -Qe

##### aura

AUR package manager. Install package `aura-bin` (AUR), e.g. using `yaourt`. 


#### Must-have applications

##### Command line

 - `ranger` plus [`git-annex`](https://git-annex.branchable.com/tips/git-annex_extensions_for_ranger__44___the_file_manager/)

###### System/Hardware Info

	* `archey` (AUR)
	* `hwinfo`
	* `dmidecode` (z.b. `-t processor`)
	* `lscpu`
	* `lshw` (z.b. `-class processor`)
	* `tig` (for git)
	* `iotop` (hdd I/O)


##### VIM

##### Plugin Managers

[NeoBundle](https://github.com/Shougo/neobundle.vim).
[Pathogen](https://github.com/tpope/vim-pathogen) (clone plugins from git into `.vim/bundle`).


##### Plugins

[Unite](https://github.com/Shougo/unite.vim)
[VOom](https://github.com/vim-scripts/VOoM): for markup/programming language structure viewing etc.

[fugitive](https://github.com/tpope/vim-fugitive): Git wrapper.
For status panel, type `:Gstatus`, while in there, use arrow keys oder `<C-n>/<C-p>` to stage/unstage files by hitting `-`. Type `cc` to commit.
For blame interactive vertical split, use `:Gblame`. Hit `o` to open commit to blame for a certain line!
For split-view of unstaged changes, enter `:Gdiff`.



##### Desktop Applications

##### Default Applications

The settings for default applications associated to known mimetypes seem to be defined in
`.config/mimeapps.list` (and apparently formerly in `.local/share/applications/mimeapps.list`.

On the other hand, it is recommended to use `xdg-utils` to take care of that stuff.

    xdg-mime default nautilus.desktop inode/directory



###### DWB

*D*ynamic *W*ebkit *M*anager [official site](http://portix.bitbucket.org/dwb/) ::
[arch wiki page](https://wiki.archlinux.org/index.php/Dwb) ::
Nice, usable and fast, but *keep in mind that very resource-hungry* (memory)!

Important default key bindings:

	open settings page (dwb:settings):        Ss
	spawn hints in new background tab:        ;b
	follow multiple background links rapidly: ;r

This [here](https://glamorousgnulinux.wordpress.com/2014/03/27/dwb-the-slim-vim-browser/) is a 
userful blog post about `dwb`, how to set up and use. Good suggestion: override default keybindings
in `~/.config/dwb/default/custom_keys`, e.g.:

	Control @Page_Up@ :focus_prev
	Control @Page_Down@ :focus_next
	@Home@ :scroll_top
	@End@ :scroll_bottom

Problem: unsigned certificates. To trust an SSL connection, we can download the certificate and append it to 
`/etc/ssl/certs/ca-certificates.crt`:

	gnutls-cli --print-cert [-p port] domain.name | vim -

Then isolate certificate block and copy it into `ca-certificates.crt`.

######### Extensions

Show available extensions:

	dwbem -a
	==> Syncing with https://bitbucket.org/portix/dwb_extensions
	==> Available extensions:
  	- adblock_subscriptions
		[...]
	
Commented list of extensions (use `dwbem -i` to install, `dwbem -r` to remove, `dwbem -I` for detailed description):

   Available extensions:      Mainstream equivalent:
   - adblock_subscriptions    Adblock
   - autoquvi                 Video DownloadHelper
   - contenthandler           (Handle requests based on MIME type, filename extension or URI scheme)
   - downloadhandler          (Handle downloads based on mimetype or filename extension, useful if 'download-no-confirm' is set)
   - formfiller               LastPass, Lazarus (Save form data and fill forms with previously saved data, also with gpg-support)
   - googlebookmarks          GBookmarks, GMarks (Add bookmarks to google bookmarks with a shortcut)
   - googledocs               Open with Google Docs, Google Docs Viewer
   - grabscrolling            (Adobe Acrobat style grab and drag mouse scrolling)
   - multimarks               (Bookmark multiple urls to a single quickmark)
   - navtools                 Opera Fast Forward, IE 10 Flip Ahead
   - perdomainsettings        (Change webkit-settings automatically on domain or url basis)
   - pwdhash                  PwdHash
   - requestpolicy            RequestPolicy, Disconnect, Ghostery
   - simplyread               Readability, Clearly
   - speeddial                Speed Dial
   - supergenpass             (Generate domain-based passwords; compatible with the bookmarklet supergenpass but with additional options)
   - unique_tabs              (Remove duplicate tabs or avoid duplicate tabs by autoswitching to tabs with same url)
   - userscripts              GreaseMonkey/Stylish
   - whitelistshortcuts       (Whitelist webkit settings for certain domains with a shortcut)
	
Install extension `adblock_subscriptions`, restart `dwb`, enable adblocker with `:set adblocker true`, execute `:adblock_subscribe:, 
choose blacklist hit Enter and load list by calling `:adblock_update`.




#### very useful tools

 - `inotifywait`: monitor file and run command on specific modifications

    # compile latex file every time it is written to disk
    while inotifywait -e modify cv.tex; do pdflatex cv.tex; done


## Latex

es gibt `pdflatex` in `texlive-bin` ist klar.

commands: 

- `mktexlsr`: make ls-R databases
- `kpsewhich`: zeigt an wo sich lokal bestimmtes paket aufhaelt
- `kpsewhich -var-value TEXINPUTS`
- `kpsewhich -var-value TEXMFLOCAL`
- `tlmgr` kram installieren halt
- `tlmgr init-usertree`

 
<!--- vim: set ts=2 sw=2 tw=0 noet ft=markdown : -->
