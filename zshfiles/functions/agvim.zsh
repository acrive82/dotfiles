# vim: set ft=zsh
#=#=#=
# agvim - Search files with ag, select with `$PERCOL`, and edit in vim.
#
# **Usage:**
#
# ```
# cd ~/Workspace/blog
# agvim xmonad
# ```
#
# ref) http://qiita.com/fmy/items/b92254d14049996f6ec3
#=#=

function agvim() {
  local agfilepath
  agfilepath="$(echo $(ag $@ | $PERCOL | awk -F : '{print "+" $2 " \047" $1 "\047"}'))"
  test -n "$agfilepath" && eval $(echo "vim $agfilepath")
}

