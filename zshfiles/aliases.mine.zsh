# vim: set filetype=zsh
#        _ _
#   __ _| (_) __ _ ___  ___  ___
#  / _` | | |/ _` / __|/ _ \/ __|
# | (_| | | | (_| \__ \  __/\__ \
#  \__,_|_|_|\__,_|___/\___||___/
#
# written by Shotaro Fujimoto (https://github.com/ssh0)

#-------- Alias {{{
#------------------------------------------------------

# apt update
alias apt-upd='sudo apt-get update'

# apt upgrade
alias apt-upg='sudo apt-get upgrade'

# apt install
alias apt-ins='sudo apt-get install'

# urxvt -> urxvtc
alias urxvt='urxvtc'

# git alias to "g"
alias g='git'

# mplayer alias
alias mplayer='mplayer -msgcolor'

# colordiff
if [[ -x `which colordiff` ]]; then
  alias diff='colordiff -u'
else
  alias diff='diff -u'
fi

# mkdocs
compdef _mkdocs mkdocs
function _mkdocs() {
  local -a cmds
  if (( CURRENT == 2 ));then
    cmds=('build' 'gh-deploy' 'json' 'new' 'serve')
    _describe -t commands "subcommand" cmds
  fi
}

# }}}

#-------- extract images {{{
#------------------------------------------------------
function extract() {
    case $1 in
        *.tar.gz|*.tgz) tar xzvf $1;;
        *.tar.xz) tar Jxvf $1;;
        *.zip) unzip $1;;
        *.lzh) lha e $1;;
        *.tar.bz2|*.tbz) tar xjvf $1;;
        *.tar.Z) tar zxvf $1;;
        *.gz) gzip -d $1;;
        *.bz2) bzip2 -dc $1;;
        *.Z) uncompress $1;;
        *.tar) tar xvf $1;;
        *.arj) unarj $1;;
    esac
}
alias -s {qz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract
alias -s {png,jpg,bmp,PNG,JPG,BMP}='eog'
# }}}
#-------- takenote completion {{{
#
_takenote() {
  typeset -A opt_args
  _arguments -s -S \
    "(-l -r -h)-d[set saving directory for specific directory.]: :_files -/" \
    "(-l -r -h)-o[set the text file's name.]: :( `takenote -l` )" \
    "(-l -r -h)-g[open with alternative program (default: vim).]: :(leafpad nano gedit)" \
    "(-d -o -g -r -h)-l[only do \`ls dir\`.]: :" \
    "(-d -o -g -l -h)-r[cd to TODAY dir, or it doesn't exist, to ROOT dir.]: :" \
    "(-d -o -g -l -r)-h[Show the help message.]: :" \
    && return 0
}

compdef _takenote takenote
# }}}
#-------- youtube-dl completion {{{
# generated by:
# https://github.com/rg3/youtube-dl/blob/master/devscripts/zsh-completion.in
# https://github.com/rg3/youtube-dl/blob/master/devscripts/zsh-completion.py
# and modified manually

__youtube_dl() {
  local curcontext="$curcontext" fileopts diropts cur prev
  typeset -A opt_args
  fileopts="--download-archive|-a|--batch-file|--load-info|--cookies|--ffmpeg-location"
  diropts="--cache-dir"
  ddir="/media/shotaro/STOCK/Videos"
  cur=$words[CURRENT]
  case $cur in
    :)
      _arguments '*: :(::ytfavorites ::ytrecommended ::ytsubscriptions ::ytwatchlater ::ythistory)'
    ;;
    *)
      prev=$words[CURRENT-1]
      if [[ ${prev} =~ ${fileopts} ]]; then
        _path_files
      elif [[ ${prev} =~ ${diropts} ]]; then
        _path_files -/
      elif [[ ${prev} == "--recode-video" ]]; then
        _arguments '*: :(mp4 flv ogg webm mkv)'
      elif [[ ${prev} == "--audio-format" ]]; then
        _arguments '*: :(best aac vorbis mp3 m4a opus wav)'
      elif [[ ${prev} == "--convert-subtitle" ]]; then
        _arguments '*: :(srt ass vtt)'
      elif [[ ${prev} =~ "-o|--output" ]]; then
        _arguments "*: :(\
          '${ddir}/%(title)s.%(ext)s' \
          '${ddir}/%(autonumber)s - %(title)s.%(ext)s' \
          '${ddir}/%(extractor)s/%(title)s.%(ext)s' \
          '-' \
          )"
      else
        _arguments -s -S\
          '-h[Print help]: :' \
          '-U[Update the program (run with root)]: :' \
          '-i[Continue on download errors]: :' \
          '-4[Make all connections via IPv4]: :' \
          '-6[Make all connections via IPv6]: :' \
          '-r[Maximum download rate in bytes per second (e.g. 50K or 4.2M)]: :' \
          '-R[Number of retries (default is 10), or "infinite"]: :' \
          '-a[File containg URLs to download ('-' for stdin)]: :' \
          '-o[Output filename template. (See manpage)]: :' \
          '-q[Activate quiet mode]: :' \
          '-s[Do not download the video and do not write anything to disk]: :' \
          '-g[Simulate, quiet but print URL]: :' \
          '-e[Simulate, quiet but print title]: :' \
          '-j[Simulate, quiet but print JSON information]: :' \
          '-J[Simulate, quiet but print JSON information for each command-line argument]: :' \
          '-f[Video format code, see the "FORMAT SELECTION" for all the info]: :' \
          '-F[List all available formats]: :' \
          '-u[Login with this account ID]: :' \
          '-p[Account pass word. If this option is left out, youtube-dl will ask interactively]: :' \
          '-2[Two-factor auth code]: :' \
          '-n[Use .netrc authentication data]: :' \
          '-x[Convert video files to audio-only files]: :' \
          '-k[Keep the video file on disk after the post-processing; the video is erased by default]: :' \
          '*: :(--help --version --update --ignore-errors --abort-on-error --dump-user-agent --list-extractors --extractor-descriptions --default-search --ignore-config --flat-playlist --no-color --proxy --socket-timeout --source-address --force-ipv3 --force-ipv6 --cn-verification-proxy --playlist-start --playlist-end --playlist-items --match-title --reject-title --max-downloads --min-filesize --max-filesize --date --datebefore --dateafter --min-views --max-views --match-filter --no-playlist --yes-playlist --age-limit --download-archive --include-ads --rate-limit --retries --buffer-size --no-resize-buffer --test --playlist-reverse --xattr-set-filesize --hls-prefer-native --external-downloader --external-downloader-args --batch-file --id --output --autonumber-size --restrict-filenames --no-overwrites --continue --no-continue --no-part --no-mtime --write-description --write-info-json --write-annotations --load-info --cookies --cache-dir --no-cache-dir --rm-cache-dir --write-thumbnail --write-all-thumbnails --list-thumbnails --quiet --no-warnings --simulate --skip-download --get-url --get-title --get-id --get-thumbnail --get-description --get-duration --get-filename --get-format --dump-json --dump-single-json --print-json --newline --no-progress --console-title --verbose --dump-pages --write-pages --youtube-print-sig-code --print-traffic --call-home --no-call-home --no-check-certificate --prefer-insecure --user-agent --referer --add-header --bidi-workaround --sleep-interval --format --all-formats --prefer-free-formats --list-formats --youtube-include-dash-manifest --youtube-skip-dash-manifest --merge-output-format --write-sub --write-auto-sub --all-subs --list-subs --sub-format --sub-lang --username --password --twofactor --netrc --video-password --extract-audio --audio-format --audio-quality --recode-video --keep-video --no-post-overwrites --embed-subs --embed-thumbnail --add-metadata --metadata-from-title --xattrs --fixup --prefer-avconv --prefer-ffmpeg --ffmpeg-location --exec --convert-subtitles)'
      fi
    ;;
  esac
}

compdef __youtube_dl youtube-dl

## }}}
# -------- peco-history alias {{{
#------------------------------------------------------
function peco-select-history() {
    typeset tac
    if which tac > /dev/null; then
        tac=tac
    else
        tac='tail -r'
    fi
    BUFFER=$(fc -l -n 1 | eval $tac | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N peco-select-history
# }}}
# -------- ranger-cd {{{
# Compatible with ranger 1.4.2 through 1.7.*
#
# Automatically change the directory in bash after closing ranger
#
# This is a bash function for .bashrc to automatically change the directory to
# the last visited one after ranger quits.
# To undo the effect of this function, you can type "cd -" to return to the
# original directory.

function ranger-cd {
    tempfile="$(mktemp)"
    # for manual install
    /usr/local/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    # package install
    # /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

# This binds Ctrl-O to ranger-cd:
# bind '"\C-o":"ranger-cd\C-m"'


# }}}
#-------- Start new ranger instance only if it's not running in current shell {{{
#------------------------------------------------------
# https://wiki.archlinux.org/index.php/Ranger#Start_new_ranger_instance_only_if_it.27s_not_running_in_current_shell
function r() {
    if [ -z "$RANGER_LEVEL" ]; then
        ranger-cd $@
    else
        exit
    fi
}
# }}}
#-------- zsh-bd {{{
#------------------------------------------------------
# Quickly go back to aspecific parent directory instead of typing cd ../../../
# [Tarrasch/zsh-bd](https://github.com/Tarrasch/zsh-bd)

bd () {
  (($#<1)) && {
    print -- "usage: $0 <name-of-any-parent-directory>"
    print -- "       $0 <number-of-folders>"
    return 1
  } >&2
  local num=${#${(ps:/:)${PWD} }}
  local dest="./"

  # If the user provided an integer, go up as many times as asked
  if [[ "$1" = <-> ]]
  then
    if [[ $1 -gt $num ]]
    then
      print -- "bd: Error: Can not go up $1 times (not enough parent directories)"
      return 1
    fi
    for i in {1..$1}
    do
      dest+="../"
    done
    cd $dest
    return 0
  fi

  # else, find the correct parent directory
  # Get parents (in reverse order)
  local parents
  local i
  for i in {$((num+1))..2}
  do
    parents=($parents "$(echo $PWD | cut -d'/' -f$i)")
  done
  parents=($parents "/")
  # Build dest and 'cd' to it
  local parent
  foreach parent (${parents})
  do
    if [[ $1 == $parent ]]
    then
      cd $dest
      return 0
    fi
    dest+="../"
  done
  print -- "bd: Error: No parent directory named '$1'"
  return 1
}
_bd () {
  # Get parents (in reverse order)
  local num=${#${(ps:/:)${PWD}} }
  local i
  for i in {$((num+1))..2}
  do
    reply=($reply "`echo $PWD | cut -d'/' -f$i`")
  done
  reply=($reply "/")
}
compctl -V directories -K _bd bd
# }}}

#-------- Configurations {{{
#------------------------------------------------------
cfg-aliases() { $EDITOR ~/.aliases.mine.zsh ;}
cfg-compton() { $EDITOR ~/.config/compton/compton.conf ;}
cfg-dotfiles() { $EDITOR ~/.dotfiles/setup_config_link ;}
cfg-latexmkrc() { $EDITOR ~/.latexmkrc }
cfg-mpv() { $EDITOR ~/.mpv/config ;}
cfg-mplayer() { $EDITOR ~/.mplayer/config ;}
cfg-ranger() { $EDITOR ~/.config/ranger/rc.conf ;}
cfg-ranger-rifle() { $EDITOR ~/.config/ranger/rifle.conf ;} # edit open_with extensions
cfg-ranger-commands() { $EDITOR ~/.config/ranger/commands.py ;} # scripts
cfg-tmux() { $EDITOR ~/.tmux.conf ;}
cfg-vimrc() { $EDITOR ~/.vimrc ;}
cfg-xdefaults() { $EDITOR ~/.Xdefaults ;}
# cfg-xinitrc() { $EDITOR ~/.xinitrc ;}
cfg-Xmodmap() { $EDITOR ~/.Xmodmap ;}
cfg-xmonad() { $EDITOR ~/.xmonad/xmonad.hs ;}
cfg-xresources() { $EDITOR ~/.Xresources ;}
cfg-zshrc() { $EDITOR ~/.zshrc.mine ;}
#}}}
#-------- Configurations Reload {{{
#------------------------------------------------------
rld-xdefaults() { xrdb ~/.Xdefaults ;}
rld-xmodmap() { xmodmap ~/.Xmodmap ;}
rld-xresources() { xrdb -load ~/.Xresources ;}
rld-zshrc() { source ~/.zshrc ;}
# }}}
