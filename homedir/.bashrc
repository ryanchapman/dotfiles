# .bashrc
#
# Ryan Chapman, ryan@rchapman.org
# Mon Oct 18 16:53:03 MDT 2010

umask 022

# -t 0 will return TRUE if the terminal is a pseudterminal
[[ -r ~rchapman/.setup_env && -t 0 ]] && source ~rchapman/.setup_env

[[ -r ~rchapman/.env_colors ]] && source ~rchapman/.env_colors


# User specific aliases and functions

# remove aliases for some commands
for i in {which,ls,more,sort,tail,head,ps,cd,rm}
do
	if [[ -n `alias|grep $i=` ]]; then unalias $i; fi
done

# xterm title bar and colored prompt - added by RAC; copied from various sources
SCREENRC="~rchapman/.screenrc"

alias more='less'; export more

function fxn_su ()
{
	# set up env vars for root
	sh ~/.setup_env root
	su -m $*

	# swap vars back to user mode
	. ~/.setup_env
}
alias su='fxn_su'; export su

export POWERLINE_CONFIG_COMMAND=~/Library/Python/2.7/bin/powerline-config
export POWERLINE_COMMAND=powerline
export PATH=$PATH:~/Library/Python/2.7/bin/
source ~/Library/Python/2.7/lib/python/site-packages/powerline/bindings/bash/powerline.sh
