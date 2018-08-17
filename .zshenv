#
# Defines environment variables.
#
# .zshenv is sourced on all invocations of the shell, unless the -f option is
# set. It should contain commands to set the command search path, plus other
# important environment variables. .zshenv should not contain commands that
# produce output or assume the shell is attached to a tty. 
#
# Files are read in this order:
# .zshenv. /etc/zprofile .zprofile. /etc/zshrc .zshrc /etc/zlogin .zlogin

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi
