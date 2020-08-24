# vim:foldmethod=marker
#
# Executes commands at the start of an interactive session.
#
# ‘.zshrc’ is sourced in interactive shells. It should contain commands to set
# up aliases, functions, options, key bindings, etc.
#
# Files are read in this order:
# .zshenv. /etc/zprofile .zprofile. /etc/zshrc .zshrc /etc/zlogin .zlogin

# Tmux {{{
  if [[ -z "$TMUX" ]] ; then
    ID="`tmux ls | grep -vm1 attached | cut -d: -f1`" # get the id of a deattached session
    if [[ -z "$ID" ]] ; then
      exec tmux new-session # if not available create a new one
    else
      exec tmux attach-session -t "$ID" # if available attach to it
    fi
  fi
# }}}

# Preferences {{{
  export TERM='tmux-256color'
  export EDITOR='vim'
  export VISUAL='gvim'
  export PAGER='less'
  export HIGHLIGHT_STYLE='solarized-light'
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
##export LESS='-F -g -i -M -R -S -w -X -z-4'
  export LESS='-i -R'
  export LESSOPEN='| /usr/bin/env lesspipe %s 2>&-'
# }}}

# Aliases for all {{{
  alias r='ranger'
  alias rr='source ranger'
# }}}

# Aliases for sudo {{{
  if [ "`id -u`" -ne 0 ]; then
    alias apt-get='sudo /usr/bin/apt-get'
    alias apt-file='sudo /usr/bin/apt-file'
    alias aptitude='sudo /usr/bin/aptitude'
    alias checkrestart='sudo /usr/sbin/checkrestart'
    alias poweroff='sudo /sbin/poweroff'
    alias reboot='sudo /sbin/reboot'
    alias halt='sudo /sbin/halt'
    alias dmesg='sudo /bin/dmesg'
    alias iotop='sudo /usr/sbin/iotop'
    alias updatedb='sudo /usr/bin/updatedb'
  fi
# }}}

# Set up zsh {{{
# Ensure path arrays do not contain duplicates.
# Whatever that means...
  typeset -gU cdpath fpath mailpath path
# Set the list of directories that cd searches.
# cdpath=($cdpath)
# Set the list of directories that Zsh searches for programs.
# $PATH is set in .zshenv
  path=($path)
# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
  HISTSIZE='1000'
  SAVEHIST='1000'
  HISTFILE="$HOME/.zhistory"
  setopt histignorealldups sharehistory
# }}}

# Source Prezto {{{
  if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
    source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
  fi
# Execute code that does not affect the current session in the background.
{
# Compile the completion dump to increase startup speed.
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
    if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
    fi
} &!
# }}}

# Run programms {{{
# root usually doesn't ssh anywhere, so no key ist added
  if [ "`id -u`" -eq 0 ]; then
    eval `keychain --eval --quiet --agents gpg,ssh`
  else
    eval `keychain --eval --quiet --agents gpg,ssh id_rsa`
  fi
# }}}
