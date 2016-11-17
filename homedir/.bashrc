# .bashrc
#
# Ryan Chapman, ryan.chapman@rightnow.com
# Mon Oct 18 16:53:03 MDT 2010

umask 022

# -t 0 will return TRUE if the terminal is a pseudterminal
[[ -r ~rchapman/.setup_env && -t 0 ]] && source ~rchapman/.setup_env

[[ -r ~rchapman/.env_colors ]] && source ~rchapman/.env_colors


# User specific aliases and functions

# remove aliases for some commands
for i in {which,ls,more,sort,tail,head,ps,cd}
do
	if [[ -n `alias|grep $i=` ]]; then unalias $i; fi
done

# xterm title bar and colored prompt - added by RAC; copied from various sources
hostname | grep hmswebcu01 2>&1 >/dev/null
if [[ $? = 0 ]]; then
	SCREENRC="~rchapman/.screenrc"
else
	SCREENRC="/nfs/users/qa/rchapman/.screenrc"
fi

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

function settitle () 
{ 
    echo -ne "\033]0;${1}\007"
    echo
}
export settitle

export CVSROOT=/nfs/src/cvsroot
#export JAVA_HOME=/nfs/local/linux/jdk/1.[5|6]/current

export PYTHONPATH=/usr/local/hms/hms2/common/etc;

export OS="`cat /etc/redhat-release`"
case $OS in
"CentOS release 5* (Final)" )
  export PATH=~/bin:/nfs/local/linux/gcc-4.2.2/bin:/nfs/local/linux/bin:/home/mysql/current/bin:$PATH:/nfs/local/linux/insure/current/bin
;;
"Red Hat Linux release 7.3 (Valhalla)" )
  export PATH=~/bin:/nfs/local/linux/gcc-3.2.2/bin:/nfs/local/linux/bin:/home/mysql/current/bin:$PATH:/nfs/local/linux/insure/7.1.3_x86/bin:/usr/X11R6/bin
;;
esac


