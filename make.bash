#!/bin/bash -

TRUE=0
FALSE=1

BOLD="$(tput bold)"
CLR="$(tput sgr0)"
RED="$(tput setaf 1 0)"
GREEN="$(tput setaf 10 0)"
CYAN="$(tput setaf 14 0)"

function logit
{
    if [[ "${1}" == "FATAL" ]]; then
        fatal="FATAL"
        shift
    fi
    echo -n "$(date '+%b %d %H:%M:%S.%N %Z') $(basename -- $0)[$$]: "
    if [[ "${fatal}" == "FATAL" ]]; then echo -n "${RED}${fatal} "; fi
    echo "$*"
    if [[ "${fatal}" == "FATAL" ]]; then echo -n "${CLR}"; exit 1; fi
}

function run_ignerr
{
    _run warn $*
}

function run
{
    _run fatal $*
}

function _run
{
    if [[ $1 == fatal ]]; then
        errors_fatal=$TRUE
    else
        errors_fatal=$FALSE
    fi
    shift
    logit "${BOLD}$*${CLR}"
    eval "$*"
    rc=$?
    if [[ $rc != 0 ]]; then
        msg="${BOLD}${RED}$*${CLR}${RED} returned $rc${CLR}"
    else
        msg="${BOLD}${GREEN}$*${CLR}${GREEN} returned $rc${CLR}"
    fi
    logit "${BOLD}$msg${CLR}"
    # fail hard and fast
    if [[ $rc != 0 && $errors_fatal == $TRUE ]]; then
        pwd
        exit 1
    fi
    return $rc
}

function all
{
    local homedir=""
    
    logit "Looking for your home directory"
    if [[ -d ~ ]]; then
        homedir=~
    elif [[ -d $HOME ]]; then
        homedir=$HOME
    else
        logit FATAL "Cannot figure out where your home directory is (checked ~ and \$HOME)"
    fi
    logit "homedir=$homedir"
    logit "Looking for your home directory: done"
     
    logit "Copying dotfiles into $homedir"
    run "rsync -avxW homedir/ $homedir"
    logit "Copying dotfiles into $homedir: done"

    logit "Making sure \"source ~/.bashrc\" is in ~/.bash_profile"
    if ! grep 'source ~/.bashrc' ~/.bash_profile; then
        run "echo 'source ~/.bashrc' >> ~/.bash_profile"
    fi
    logit "Making sure \"source ~/.bashrc\" is in ~/.bash_profile: done"

    logit "Checking if we need to install pip"
    if ! which pip &>/dev/null; then
        logit "Checking if we need to install pip: yes"
        logit "Installing pip"
        run "brew install pip"
        logit "Installing pip: done"
    else
        logit "Checking if we need to install pip: no"
    fi

    logit "Checking if we need to install powerline"
    if ! which powerline &>/dev/null; then
        logit "Checking if we need to install powerline: yes"
        logit "Installing powerline"
        run "pip install --user git+git://github.com/powerline/powerline"
        logit "Installing powerline: done"

        logit "Installing powerline fonts"
        local tmpdir=$(mkdir /tmp/XXXXX)
        run "(cd ${tmpdir} && git clone https://github.com/powerline/fonts.git && cd fonts && ./install.sh)"
        logit "Installing powerline fonts: done"
    else
        logit "Checking if we need to install powerline: no"
    fi

}

#################################
# main
#################################

function main () {
    func_to_exec=${1:-all}
    type ${func_to_exec} 2>&1 | grep -q 'function' >&/dev/null || {
        logit "$(basename $0): ERROR: function '${func_to_exec}' not found."
        exit 1
    }

    shift
    ${func_to_exec} $*
    echo
}

main $*
