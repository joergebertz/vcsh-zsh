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

# Set up variables{{{

# Preferences {{{
##export SHELL ='zsh'
  export EDITOR='vim'
  export VISUAL='gvim'
  export PAGER='less'
  export LESS='-i -R'
  export LESSOPEN='| /usr/bin/env lesspipe %s 2>&-'
  export TERM='tmux-256color'
# }}}

# Language {{{
# ‘en_US.UTF-8’ for root ‘de_DE.UTF-8‘ for normal users
  if [ "`id -u`" -eq 0 ]; then
    export LANG='en_US.UTF-8'
    export LANGUAGE='en_US.UTF-8'
    export LC_ALL='en_US.UTF-8'
  else
    export LANG='de_DE.UTF-8'
    export LANGUAGE='de_DE.UTF-8'
    export LC_ALL='de_DE.UTF-8'
  fi
# }}}

# $PATH {{{
#  Copied from ‘/etc/profile’
  if [ "`id -u`" -eq 0 ]; then
    PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
  else
    PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/games:/usr/games"
  fi
# Copied from ‘/etc/skel/.profile’
  if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
  fi
  export PATH
# }}}

# umask {{{
  umask 027
# }}}

# }}} 

# Set up aliases {{{

# Abreviations {{{
  alias r='ranger'
  alias rr='source ranger'
# }}}

# Aliases for sudo {{{
  if [ "`id -u`" -ne 0 ]; then
    alias apt-get='sudo /usr/bin/apt-get'
    alias apt-file='sudo /usr/bin/apt-file'
    alias aptitude='sudo /usr/bin/aptitude'
    alias poweroff='sudo /sbin/poweroff'
    alias checkrestart='sudo /usr/sbin/checkrestart'
    alias reboot='sudo /sbin/reboot'
    alias halt='sudo /sbin/halt'
  fi
# }}}

# }}}

# Set up zsh {{{

# Ensure path arrays do not contain duplicates
# Whatever that means...
  typeset -gU cdpath fpath mailpath path

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
  HISTSIZE='1000'
  SAVEHIST='1000'
  HISTFILE="$HOME/.zhistory"
  setopt histignorealldups sharehistory

# Source Prezto.
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
#
# Run programms {{{

# root usually doesn't ssh anywhere, so no key ist added
  if [ "`id -u`" -eq 0 ]; then
    eval `keychain --eval --quiet --agents ssh`
  else
    eval `keychain --eval --quiet --agents ssh id_rsa`
  fi

# }}}
