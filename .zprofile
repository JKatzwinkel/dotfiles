emulate sh
. ~/.profile
emulate zsh
# for webcam. needed for following command to work:
# mplayer tv:// -tv driver=v4l2:width=640:height=240:device=/dev/video0 -fps 10 
export LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so

alias ydl="youtube-dl --extract-audio --audio-format mp3 --audio-quality 0 "
alias ytp="mpv --ytdl-raw-options='cookies-from-browser=firefox,format=best[height<720]' "
export PATH="$HOME/.poetry/bin:$PATH"
