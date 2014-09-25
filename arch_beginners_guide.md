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


## yay!

### graphical user interface
	pacman -S i3
in `.xinitrc`:
	exec i3
Bei trouble mapping keys:
	xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'



