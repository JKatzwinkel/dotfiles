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

#### eduroam:

password hash:

    echo -n password_here | iconv -t utf16le | openssl md4

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


##### keycodes misc:

read [XKB](https://wiki.archlinux.org/index.php/X_KeyBoard_extension) and [xmodmap](https://wiki.archlinux.org/index.php/Xmodmap)
wiki articles, install `xorg-xev`, `xorg-xkbutils`.



### fonts

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

Here is some devs writing about urxvt: http://pod.tst.eu/http://cvs.schmorp.de/rxvt-unicode/doc/rxvt.7.pod#Rendering_Font_amp_Look_and_Feel_Iss

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


### cron

implementation `fcron`: `systemctl enable/start fcron.service`. `fcrontab -e`

### ACPI etc.

	upower -e
		/org/freedesktop/UPower/devices/line_power_ADP1
		/org/freedesktop/UPower/devices/battery_BAT0
		/org/freedesktop/UPower/devices/DisplayDevice
	upower -i /org/freedesktop/UPower/devices/battery_BAT0



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

Then, plug and play..


#### keychain
package `keychain`. Add to shell profile:

    eval $(keychain --eval --agents ssh -Q --quiet ~/.ssh/id_rsa)



#### pacman tips

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
		pacman -D --asexp	# Mark one or more installed packages as explicitly installed 
		pacman -D --asdep	# Mark one or more installed packages as non explicitly installed

(from [arch wiki](https://wiki.archlinux.org/index.php/Pacman_tips))

##### expac (databasae extraction utility)

largest packages:

		 expac -HM "%011m\t%-20n\t%10d" | sort -n

most recently installed/updated packages:

		expac --timefmt=%s '%l\t%n' | sort -n | tail -20

show versions of installed packages:

		expac -s "%-30n %v"
		pacman -Qm
		pacman -Qe


#### Must-have applications

##### Command line

	* `archey`

##### Desktop Applications

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

