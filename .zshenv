# vim:foldmethod=marker
#
# .zshenv is sourced on all invocations of the shell, unless the -f option is
# set. It should contain commands to set the command search path, plus other
# important environment variables. .zshenv should not contain commands that
# produce output or assume the shell is attached to a tty. 
#
# Files are read in this order:
# .zshenv. /etc/zprofile .zprofile. /etc/zshrc .zshrc /etc/zlogin .zlogin

# .zshenv is sourced by .profile

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
#
# Copied from ‘/etc/skel/.profile’
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
# }}}

# umask {{{
  umask 027
# }}}
