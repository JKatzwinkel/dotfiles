# config

## time zeit ntp

- ntp server angeben in `/etc/systemd/timesyncd.conf`.
- `timedatectl set-ntp true`
- `timedatectl set-local-rtc 0`
- `timedatectl status`


# gnome 3

um die namen von keys fuer keybindings in dconf herauszufinden kann man in gnome control center (in *gnome-control-center* unter *keyboard shortcuts*)
einfach kurz custom keybinding zufuegen und dann im terminal gucken wie dessen binding heiszt:

    gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom{X}/ binding

durchnummerierung von *`X`* beginnt mit `0`.

## workspace settings:

1. man geht in *dconf Editor* (`dconf-editor`) und bearbeitet dort die property:

        org.gnome.desktop.wm.properties.num-workspaces

2. man wechselt in `org.gnome.desktop.wm.keybindings` und customized dort zb keybinding namens:

        org.gnome.desktop.wm.keybindings.switch-to-workspace-8

    und setzt als keybinding

        ['<Super>8']

3. fuer den entsprechenden shortcut `org.gnome.desktop.wm.keybindings.move-to-workspace-8` wendet man den `gsettings get`
   trick von oben an um den namen der taste `*` rauszufinden..

        ['<Shift><Super>asterisk']

   oder halt hier gucken: https://www.tldp.org/HOWTO/Intkeyb/x476.html


# sound

fuer equalizer `pulseeffects` installieren.


# editors

## vim

`vim-plug`: https://github.com/junegunn/vim-plug

    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

in `.vimrc`:

    call plug#begin()
    Plug 'preservim/NERDTree'
    call plug#end()

Dann: 

    :PlugInstall

seit vim 8 gibt es native plugin management was quasi dasselbe macht wie frueher pathogen:
- https://shapeshed.com/vim-packages/
- https://opensource.com/article/20/2/how-install-vim-plugins

damit man den ganzen stresz mit git submodules im `.vim/pack/bla` verzeichnis nicht hat, nimmt man `vim-plug`.


## spacevim

spacevim installieren mit 

    curl -sLf https://spacevim.org/install.sh | bash

es benennt dann `.vimrc` in `.vimrc_back` um. Die config datei ist dann `.SpaceVim.d/init.toml`.
Hilfe mit `:h SpaceVim`

vim settings muessen in `.SpaceVim.d/autoload/myspacevim.vim` in `function! myspacevim#before() abort` 
oder `function! myspacevim#after() abort` und dann in der config file unter `bootstrap_after = "myspacevim#after"` 
musz die function angegeben werden.

autocomplete config:

- automatische klammern: `autocomplete_parens = false`
- autocomplete popup: `auto_completion_delay = 500`
  - das funktioniert aber nur bei bestimmten engines, also zb. `autocomplete_method = "completor"`
    - wenn man schon `completor` hat, kann man auch einstellen dasz completions erst ab 3 characters aufpoppen, indem man in seiner `myspacevim.vim` sagt:
      - `let g:completor_min_chars=3`

deinstallieren mit:

    curl -sLf https://spacevim.org/install.sh | bash -s -- --uninstall


# gnome shell

damit man sieht in welchem fenster man gerade ist sollte man evtl window bar css anpaszen:
- `.config/gtk-3.0/gtk.css`:
```css
.titlebar {
    background: #3089FF;
    color:white;
}

.titlebar:backdrop  {
    background: #777777;
    color:white;
}
```


# pacman 

option `Color` in `/etc/pacman.conf` anschalten. Auszerdem `VerbosePkgLists`.

Alle explizit installierten pakete:

    pacman -Qqe

Auf jeden fall `pkgfile` installieren.


## AUR

package manager fuer AUR: `yay`. Man kann ohne `sudo` verwenden.


# python

## poetry

    curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python
    poetry self:update --preview

completions:

    mkdir $ZSH/plugins/poetry
    poetry completions zsh > $ZSH/plugins/poetry/_poetry

dann plugin `poetry` in `.zshrc` zufuegen.

## pyenv

keine ahnung wie man serioes shell completions aktiviert also kopiere ich einfach
den inhalt von https://raw.githubusercontent.com/pyenv/pyenv/master/completions/pyenv.zsh
in `.oh-my-zsh/plugins/pyenv/pyenv.plugin.zsh` rein.


# swap

wegen dualboot hat man nur 1 physische partition fuer linux also keine swap.
stattdessen swapfile machen:

    fallocate -l 8G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile

in `/etc/fstab`:

    /swapfile swap swap defaults 0 0


# netzlaufwerke:

kein auto mount sondern automount per systemd weil sonst wird versucht zu mounten bevor netzwerk da ist.

    UUID=A6FEBE6BFEBE3401                     /mnt/win       ntfs-3g uid=1000,gid=1000,fmask=133,dmask=022,windows_names                                0 0
    //192.168.4.15/{USER}                    /mnt/home      cifs    user,cred=/home/{USER}/.smbcredentials,uid=1000,gid=1000,iocharset=utf8,file_mode=0644,dir_mode=0755,vers=1.0,noauto,x-systemd.automount,x-systemd.mount-timeout=10,_netdev 0 0
    //192.168.4.15/pom/                       /mnt/pom       cifs    user,cred=/home/{USER}/.smbcredentials,uid=1000,gid=1000,iocharset=utf8,file_mode=0644,dir_mode=0755,vers=1.0,noauto,x-systemd.automount,x-systemd.mount-timeout=10,_netdev 0 0
    //192.168.4.15/aaew/                      /mnt/aaew      cifs    user,cred=/home/{USER}/.smbcredentials,uid=1000,gid=1000,iocharset=utf8,file_mode=0644,dir_mode=0755,vers=1.0,noauto,x-systemd.automount,x-systemd.mount-timeout=10,_netdev 0 0
    //192.168.4.15/software/                  /mnt/software  cifs    user,cred=/home/{USER}/.smbcredentials,uid=1000,gid=1000,iocharset=utf8,file_mode=0644,dir_mode=0755,vers=1.0,noauto,x-systemd.automount,x-systemd.mount-timeout=10,_netdev 0 0
    //192.168.4.15/akademie/                  /mnt/akademie  cifs    user,cred=/home/{USER}/.smbcredentials,uid=1000,gid=1000,iocharset=utf8,file_mode=0644,dir_mode=0755,vers=1.0,noauto,x-systemd.automount,x-systemd.mount-timeout=10,_netdev 0 0


# ruby

paket `ruby`.
in `.profile`:

    PATH="$PATH:$(ruby -e 'puts Gem.user_dir')/bin"  


# termite

fuer ssh sollte man auf dem remote host die terminfo installieren:

    wget https://raw.githubusercontent.com/thestinger/termite/master/termite.terminfo
    tic -x termite.terminfo

wenn man monokai theme in termite.config macht, sollte man color16 etwas abdunkeln weil
ipython die als fg fuer `prompt_toolkit` autocompletion widgets nimmt und man das sonst schwer lesen kann.


# ranger

tips und tricks: https://github.com/ranger/ranger/wiki/Keybindings

## devicons:

man clont repo `https://github.com/alexanderjeurissen/ranger_devicons` in `.config/ranger/plugins/` und dann added man
`default_linemode devicons` in seiner `rc.conf`.

Man braucht nerdfonts...

    yay -S nerd-fonts-complete

wenn man date of latest modification angezeigt bekommen will einfach eingeben `:linemode sizemtime`.

## syntax highlighting:

einfach package `highlight` installieren.


# powerline

systemweit installieren mit `pip`:

    sudo pip install powerline-status

Dann config verzeichnisse anlegen (zb fuer extension `tmux`):

    mkdir -p .config/powerline/themes/tmux

dort die default configs als templates reinkopieren:

    cp /usr/lib/python3.7/site-packages/powerline/config_files/themes/tmux/default.json ~/.config/powerline/themes/tmux/

dort drin ein segment fuer den kultigen music plater `cmus` zufuegen:

    {
      "function": "powerline.segments.common.players.cmus"
    }

auszerdem nicht vergessen in `.zshrc` ganz unten:

    powerline-daemon -q
    . /usr/lib/python3.7/site-packages/powerline/bindings/zsh/powerline.zsh


# tmux

Sehr nuetzliche aliases fuer in die `.zshrc`:

    alias tmx="tmux attach -t"
    alias txl="tmux list-sessions"

## powerline aktivieren:

in `.tmux.conf` unten dranhaengen:

    source "/usr/lib/python3.7/site-packages/powerline/bindings/tmux/powerline.conf"

## plugins

Erstens mal braucht man tmux plugin manager [`tpm`](https://github.com/tmux-plugins/tpm):

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

ganz unten in die `.tmux.conf` musz rein:

    run -b '~/.tmux/plugins/tpm/tpm'

Dann config neu laden:

    tmux source ~/.tmux.conf    

Ab jetzt immer wenn man was in der `.tmux.conf` aendert also zum beispiel ein plugin zufuegt,
kann man in tmux `<Ctrl-B> + <I>` druecken und die wird neu geladen.


### tmux-open

wenn man `tmux-open` plugin verwendet, musz man komischerweise das editor command
ueberschreiben, weil er sonst immer `nano` nimmt obwohl `$EDITOR` auf `vim` gesetzt ist:
in `.tmux.conf`:

    set -g @plugin 'tmux-plugins/tmux-open'
    set -g @open-editor-command '/usr/bin/vim'

### tmux-fpp, tmux-copycat

paket `fpp` aus AUR installieren

in `.tmux.conf`:

    # open facebook path picker (fpp) with prefix + f
    set -g @plugin 'jbnicolai/tmux-fpp'
    
    # regex and predefined searches
    # prefix + ctrl-f - simple file search
    # prefix + ctrl-g - jumping over git status files (best used after git status command)
    # prefix + alt-h - jumping over SHA-1/SHA-256 hashes (best used after git log command)
    # prefix + ctrl-u - url search (http, ftp and git urls)
    # prefix + ctrl-d - number search (mnemonic d, as digit)
    # prefix + alt-i - ip address search
    set -g @plugin 'tmux-plugins/tmux-copycat'

Am geilsten ist `Ctrl-F` (filenames), `Ctrl-G` (git files) und `Ctrl-u` (URLs`).


# soundscrape

mit `pip install --user`




