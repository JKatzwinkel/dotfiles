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
HISTSIZE=20000
SAVEHIST=20000
# activate emacs keybindings
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
		# this has nothing to do with colors, but will show latest files in downloads dir
		alias dwn='ls --color=always -rtlh ~/Downloads | tail -n 15'
		alias tmx='tmux attach -t'
		alias txl='tmux list-sessions'
fi


[[ -e /usr/bin/highlight ]] && alias cats='highlight -O ansi'


_pwd () {
	local _wdir="$1"
	[[ "$_wdir" != "${_wdir#$HOME}" ]] && _wdir="~${_wdir#$HOME}";
	((${#_wdir}>20)) && _wdir="${_wdir:0:5}...${_wdir:$(( ${#_wdir}-12 ))}";
	echo "$_wdir"
}


# oh-my-zsh:
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="random"
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)

plugins=(
	git
	archlinux
	python
	fasd
	battery
	zsh-syntax-highlighting
	emoji
	emoji-clock
	zsh-navigation-tools
	urltools
	pipenv
	poetry
	zsh-autosuggestions
	keybase
	#gradle
)

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=96
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

source $ZSH/oh-my-zsh.sh

setopt append_history bang_hist auto_cd extended_glob notify nonomatch

unsetopt inc_append_history sharehistory

# zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(brackets)
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[default]='fg=white'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=white'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='fg=cyan,bold,bg=blue'
ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=red'
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=white'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=white'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=white'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=white'



# colors, a lot of colors!
function clicolors() {
    i=1
    for color in {000..255}; do;
        c=$c"$FG[$color]$color✔$reset_color  ";
        if [ `expr $i % 8` -eq 0 ]; then
            c=$c"\n"
        fi
        i=`expr $i + 1`
    done;
    echo $c | sed 's/%//g' | sed 's/{//g' | sed 's/}//g' | sed '$s/..$//';
    c=''
}

### PROMPTS
###########


local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}[%{$fg_bold[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%}:%{$fg[red]%}x%{$reset_color%}]"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}:%{$fg[green]%}o%{$reset_color%}]"

local battery_info='$(battery_pct)'
PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'
RPROMPT="${git_info}[%h%{$fg[yellow]%}%(?..:%?)%{$reset_color%}][${battery_info}]"
PROMPT="%{$fg[yellow]%}%(?..%{$fg[red]%})%*-\
%{$fg_bold[green]%}%n\
%{$reset_color%}@\
%{$fg[cyan]%}%M-\
%{$fg_bold[white]%}%3~\
%{$reset_color%}%(?..%{$fg[red]%})%% %{$reset_color%}"


# OH MY GIT

[[ -s "$HOME/.local/share/oh-my-git/prompt.sh" ]] && . $HOME/.local/share/oh-my-git/prompt.sh 


# set editors, pager, ...
export LESS="-R"
export PAGER=most
export SYSTEMD_PAGER=less
export EDITOR=vim
export GIT_EDITOR=vim
export GOPATH=~/tx/go
export PATH=$PATH:$GOPATH/bin
export MPD_HOST=192.168.0.8
#

# added keybindings previously being defined in .inputrc [which is not
# interpreted by zsh] as suggested at 
# https://bbs.archlinux.org/viewtopic.php?pid=428669

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
# make zle widgets from functions
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

#bindkey "^[[7~"	beginning-of-line
#bindkey "^[[8~" end-of-line

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

# custom keybindings with zle
# the zle manual is at `man zshzle`.
# zle can create widgets from functions.
# more about user defined widgets:
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#User_002dDefined-Widgets
# http://sgeb.io/articles/zsh-zle-closer-look-custom-widgets/

# define function
function prev_dir {
  popd > /dev/null
  zle reset-prompt
}

# create zle widgets
zle -N prev_dir


# To see the escape sequence for a shortcut, run `cut`, then hit keys. For instance,
# Alt+LeftArrow yields ^[[1;3D
bindkey "\e[1;3D" prev_dir

# FASD
eval "$(fasd --init auto)"

# keychain
eval $(keychain --eval --agents ssh -Q --quiet ~/.ssh/id_rsa)

# termite: open new terminal in current directory
if [[ $TERM == xterm-termite ]]; then
  . /etc/profile.d/vte.sh
  __vte_osc7
fi

# RVM
[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm"

# command not found hook brought by pkgfile
[[ -s "/usr/share/doc/pkgfile/command-not-found.zsh" ]] && . "/usr/share/doc/pkgfile/command-not-found.zsh"

# alias for largest packages
alias pacman_largest='expac -HM "%011m\t%-20n\t%10d"| sort -n | tail -20'

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.gem/ruby/2.2.0/bin" # ruby gem binaries
export PATH="$PATH:/usr/local/games"  

export DITA_HOME=/opt/dita
export ANT_HOME=/usr/share/apache-ant
export JAVA_HOME=/usr/lib/jvm/default
export PATH=${ANT_HOME}/bin:${JAVA_HOME}/bin:${DITA_HOME}:${PATH}

#export CLASSPATH=.:/usr/share/java:$CLASSPATH:$PATH
export CLASSPATH=${DITA_HOME}/lib:$DITA_HOME/lib/dost.jar:$DITA_HOME/lib/xml-resolver.jar:$CLASSPATH
export CLASSPATH=/usr/share/java/avalon-framework/avalon-framework.jar:$CLASSPATH
export CLASSPATH=/usr/share/java/batik/batik-all.jar:$CLASSPATH
export CLASSPATH=/usr/share/java/fop/fop.jar:$CLASSPATH

. ~/.zprofile

#unset GREP_OPTIONS

# PERL
PATH="${HOME}/perl5/bin${PATH:+:${PATH}}"; export PATH;
# YARN
PATH="${HOME}/.yarn/bin${PATH:+:${PATH}}"; export PATH;


PERL5LIB="/home/thor/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/thor/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/thor/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/thor/perl5"; export PERL_MM_OPT;

# ranger
export RANGER_LOAD_DEFAULT_RC=FALSE


export PATH="${HOME}/.pyenv/versions/:${HOME}/.pyenv/bin/:${HOME}/.local/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

. /usr/share/powerline/bindings/zsh/powerline.zsh

export PATH="$HOME/.poetry/bin:$PATH"
