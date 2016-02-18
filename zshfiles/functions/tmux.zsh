#=#=#=
# set tmux aliases and start up behavior
#
# > [Start a new session from within tmux with ZSH_TMUX_AUTOSTART=true - Super User](http://superuser.com/questions/821339/start-a-new-session-from-within-tmux-with-zsh-tmux-autostart-true)
#
# Auto start tmux when the terminal launched.
#=#=

tmux-new-session() {
  if [[ -n $TMUX ]]; then
    tmux switch-client -t "$(TMUX= tmux -S "${TMUX%,*,*}" new-session -dP "$@")"
  else
    tmux new-session "$@"
  fi
}

# Aliases
if [[ -n $TMUX ]]; then
  alias ta='tmux switch-client -t'
else
  alias ta='tmux attach-session -t'
fi
alias ts='tmux-new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'

# Autostart if not already in tmux.
if [[ ! -n $TMUX ]]; then
  # get the IDs
  ID="`tmux list-sessions`"
  if [[ -z "$ID" ]]; then
    tmux new-session && exit
  fi
  create_new_session="Create New Session"
  ID="${create_new_session}:\n$ID"
  ID="`echo $ID | $PERCOL | cut -d: -f1`"
  if [[ "$ID" = "${create_new_session}" ]]; then
    tmux new-session && exit
  elif [[ -n "$ID" ]]; then
    tmux attach-session -t "$ID" && exit
  else
    :  # Start terminal normally
  fi
fi

