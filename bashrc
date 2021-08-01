# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ls='ls -v --color=auto --group-directories-first'
alias grepl='grep --color -n'
alias sshr='ssh -l root'

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history.
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# colors
RED='\[\e[31m\]'
GREEN='\[\e[32m\]'
YELLOW='\[\e[33m\]'
BLUE='\[\e[34m\]'
CYAN='\[\e[36m\]'
BRIGHT='\[\e[01m\]'
NORMAL='\[\e[00m\]'
WHITE='\[\e[37m\]'
ORANGE='\[\e[38;5;214m\]'
SAND='\[\e[38;5;216m\]'

gitBranch() {
    if git branch > /dev/null 2>&1; then
        echo "  $(git symbolic-ref --short HEAD)";
    fi
}

PS1="$BRIGHT$WHITE[$NORMAL\u$BRIGHT$ORANGEॐ $BLUE\h $NORMAL$GREEN\w$SAND\$(gitBranch)$BRIGHT$WHITE]$ $NORMAL"
PS1="\n$BRIGHT$RED┌─[$NORMAL\u$BRIGHT$ORANGEॐ $CYAN\h $NORMAL$GREEN\w$SAND\$(gitBranch)$BRIGHT$RED]\n$BRIGHT$RED└──╼$YELLOW$ $NORMAL"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export AWS_PROFILE=openshift-dev
export AWS_PROFILE=ODF_Devel_User

export OC_EDITOR="vim"
export KUBE_EDITOR="vim"
export KUBECONFIG=~/code/cluster/auth/kubeconfig
export KUBECONFIG=~/Downloads/kubeconfig

export GOPATH=~/code/go
export PATH=$PATH:$GOPATH/bin

export IMAGE_BUILD_CMD=docker
export REGISTRY_NAMESPACE=nigoyal

odf=$GOPATH/src/github.com/red-hat-storage/odf-operator
ocs=$GOPATH/src/github.com/red-hat-storage/ocs-operator
csi=$GOPATH/src/github.com/ceph/ceph-csi-operator
