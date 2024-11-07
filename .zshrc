# vim:foldmethod=marker
#
# Executes commands at the start of an interactive session.
#
# ‘.zshrc’ is sourced in interactive shells. It should contain commands to set
# up aliases, functions, options, key bindings, etc.
#
# Files are read in this order:
# .zshenv. /etc/zprofile .zprofile. /etc/zshrc .zshrc /etc/zlogin .zlogin

#Tmux {{{
if [ $TERM != "xterm-kitty" ] || [[ -n $SSH_CLIENT ]]; then
  if [ "$(command -v tmux)" ] && [[ -z "$TMUX" ]] ; then
      ID="`tmux ls | grep -vm1 attached | cut -d: -f1`" # get the id of a deattached session
      if [[ -z "$ID" ]] ; then
        exec tmux new-session # if not available create a new one
      else
        exec tmux attach-session -t "$ID" # if available attach to it
      fi
  fi
fi
#}}}

# Preferences {{{
#  export TERM='tmux-256color'
  export EDITOR='vim'
  export VISUAL='vim'
  export PAGER='less'
  export HIGHLIGHT_STYLE='solarized-light'
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
##export LESS='-F -g -i -M -R -S -w -X -z-4'
  export LESS='-i -R'
  export LESSOPEN='| /usr/bin/env lesspipe %s 2>&-'
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
  setopt AUTO_CD
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

# Aliases for all {{{

# Ranger

if [ "$(command -v ranger)" ]; then
  alias r='ranger'
  alias rr='source ranger'
fi

# fasd

if [ "$(command -v fasd)" ]; then
##  alias a='fasd -a'        # any
##  alias s='fasd -si'       # show / search / select
##  alias d='fasd -d'        # directory
##  alias f='fasd -f'        # file
##  alias sd='fasd -sid'     # interactive directory selection
##  alias sf='fasd -sif'     # interactive file selection
  alias z='fasd_cd -d'     # cd, same functionality as j in autojump
  alias zz='fasd_cd -di'   # cd with interactive selection

  alias v='fasd -fe vim' # quick opening files with vim
  alias vv='fasd -fie vim' # quick opening files with vim with (interactive)

##  bindkey '^X^A' fasd-complete    # C-x C-a to do fasd-complete (files and directories)
##  bindkey '^X^F' fasd-complete-f  # C-x C-f to do fasd-complete-f (only files)
##  bindkey '^X^D' fasd-complete-d  # C-x C-d to do fasd-complete-d (only directories)
fi

# exa

if [ "$(command -v exa)" ]; then
  alias ls='exa'
  alias ll='exa -gl'
  alias la='exa -gla'
  alias tree='exa -glT'
fi

# fzf + fd
if [ "$(command -v fzf)" ]; then
  if [ "$(command -v fd)" ]; then
    export FZF_DEFAULT_COMMAND="fd --type f"
  fi
  source /usr/share/doc/fzf/examples/completion.zsh
  source /usr/share/doc/fzf/examples/key-bindings.zsh
fi
# }}}

# Aliases for sudo {{{
if [ "`id -u`" -ne 0 ]; then
  alias apt-get='sudo /usr/bin/apt-get'
  alias apt-file='sudo /usr/bin/apt-file'
  alias aptitude='sudo /usr/bin/aptitude'
  alias checkrestart='sudo /usr/sbin/checkrestart'
  alias needrestart='sudo /usr/sbin/needrestart'
  alias poweroff='sudo /sbin/poweroff'
  alias reboot='sudo /sbin/reboot'
  alias halt='sudo /sbin/halt'
  alias dmesg='sudo /bin/dmesg'
  alias iotop='sudo /usr/sbin/iotop'
  alias updatedb='sudo /usr/bin/updatedb'
  if [ "$(command -v apt-dater)" ]; then
    alias apt-dater='sudo /usr/bin/apt-dater'
  fi
fi
# }}}

# Endaliases Terminal {{{
alias -s txt=nvim
alias -s md=nvim
# }}}

# Endaliases X {{{
if [[ -n $DISPLAY ]]; then
  ##alias -s txt=nvim-qt

  alias -s odt=libreoffice
  alias -s ott=libreoffice
  alias -s doc=libreoffice
  alias -s dot=libreoffice
  alias -s docx=libreoffice
  alias -s dotx=libreoffice
  alias -s rtf=libreoffice

  alias -s odp=libreoffice
  alias -s odg=libreoffice
  alias -s ppt=libreoffice
  alias -s pot=libreoffice
  alias -s pptx=libreoffice
  alias -s potx=libreoffice

  alias -s ods=libreoffice
  alias -s ots=libreoffice
  alias -s xls=libreoffice
  alias -s xlt=libreoffice
  alias -s xlsx=libreoffice
  alias -s xltx=libreoffice
  alias -s csv=libreoffice

  alias -s pdf=zatura

  alias -s jpg=feh
  alias -s png=feh
fi
# }}}

# Run programms {{{
# root usually doesn't ssh anywhere, so no key ist added
if [ "$(command -v keychain)" ]; then
##  if [ "`id -u`" -eq 0 ]; then
    export GPG_AGENT_INFO="~/.gnupg/S.gpg-agent:$(pgrep gpg-agent):1"
    eval `keychain --eval --quiet --agents gpg,ssh`
##  else
##    # eval `keychain --eval --quiet --agents gpg,ssh id_rsa`
##    eval `keychain --eval --quiet --agents gpg,ssh ~/.ssh/id_ed25519`
##    ##eval `keychain --eval --quiet --agents gpg,ssh`
##  fi
fi
# }}}

# my_zshrc {{{
if [ -s "$HOME/.my_zshrc" ] ; then
    . $HOME/.my_zshrc
fi
# }}}
