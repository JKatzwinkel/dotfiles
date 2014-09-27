# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _expand _list _ignored _correct _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 2 numeric
zstyle ':completion:*' menu select=1
zstyle ':completion:*' prompt 'errors: %e'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-compctl true
zstyle :compinstall filename '/home/thor/.zshrc'

autoload -Uz compinit
compinit
autoload -U promptinit
promptinit
autoload -U colors
colors
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=15000
SAVEHIST=15000
setopt appendhistory autocd extendedglob notify
bindkey -e
# End of lines configured by zsh-newuser-install

# taken from .bashrc:
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


_pwd () {
	local _wdir="$1"
	[[ "$_wdir" != "${_wdir#$HOME}" ]] && _wdir="~${_wdir#$HOME}";
	((${#_wdir}>20)) && _wdir="${_wdir:0:5}...${_wdir:$(( ${#_wdir}-12 ))}";
	echo "$_wdir"
}


PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'
#PROMPT='\[\033[0;33m\]\t\342\200\224\[\033[1;32m\]\u\[\033[0m\]@\[\033[36m\]\h\342\200\224\[\033[32m\]$(_pwd "$PWD") \[\033[0m\]'
PROMPT="%{$fg[yellow]%}%*-%{$fg[green]%}%n%{$reset_color%}@%{$fg[cyan]%}%M-%{$fg_no_bold[green]%}%3~ %{$reset_color%}% "
RPROMPT="[%h%{$fg[yellow]%}:%?%{$reset_color%}]"


# oh-my-zsh:
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="random"
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git nyan archlinux thor python fasd battery zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

#PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'
#PROMPT='\[\033[0;33m\]\t\342\200\224\[\033[1;32m\]\u\[\033[0m\]@\[\033[36m\]\h\342\200\224\[\033[32m\]$(_pwd "$PWD") \[\033[0m\]'
#PROMPT="%{$fg[yellow]%}%*-%{$fg[green]%}%n%{$reset_color%}@%{$fg[cyan]%}%M-%{$fg_no_bold[green]%}%3~ %{$reset_color%}% "
#RPROMPT="[%h%{$fg[yellow]%}:%?%{$reset_color%}]"


# set editors, pager, ...
export PAGER=most
export EDITOR=vim
export GIT_EDITOR=vim
export GOPATH=~/tx/go
export PATH=$PATH:$GOPATH/bin
#

# added keybindings previously being defined in .inputrc [which is not
# interpreted by zsh] as suggested at 
# https://bbs.archlinux.org/viewtopic.php?pid=428669

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
#bindkey "^[[A" up-line-or-beginning-search # Up
#bindkey "^[[B" down-line-or-beginning-search # Down

typeset -g -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-beginning-search
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-beginning-search
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init () {
    printf '%s' "${terminfo[smkx]}"
  }
  function zle-line-finish () {
    printf '%s' "${terminfo[rmkx]}"
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

#autoload zkbd
#[[ ! -f ${ZDOTDIR:-$HOME}/.zkbd/$TERM-$VENDOR-$OSTYPE ]] && zkbd
#source ${ZDOTDIR:-$HOME}/.zkbd/$TERM-$VENDOR-$OSTYPE

#[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
#[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
#[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
#[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" up-line-or-history
#[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
#[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
#[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" down-line-or-history
#[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
#[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
#[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search
#[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char

# hard-coded keybindings, which is not best practice, but binds Ctrl+arrow
# for wordwise movement
bindkey "\e[1;5C" emacs-forward-word
bindkey "\e[1;5D" emacs-backward-word
#bindkey "\e[0C" emacs-forward-word
#bindkey "\e[0D" emacs-backward-word 
#bindkey "^H" backward-delete-word

# alias for running skype as separate skype user
alias skype='xhost +local: && su skype -c skype'

eval "$(fasd --init auto)"


# RVM
[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm"


export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

