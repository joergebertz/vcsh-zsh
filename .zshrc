#
# Executes commands at the start of an interactive session.
#
# .zshrc is sourced in interactive shells. It should contain commands to set
# up aliases, functions, options, key bindings, etc.
#
# Files are read in this order:
# .zshenv. /etc/zprofile .zprofile. /etc/zshrc .zshrc /etc/zlogin .zlogin

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
