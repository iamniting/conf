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

alias mkv-merge='mkvmerge -d 0 -a 1,2 -s 3,4 -M -B -T \
    --no-global-tags --no-chapters --title "" \
    --language 0:und --track-name 0:"" --default-track 0:true \
    --language 1:und --track-name 1:"" --default-track 1:true \
    --language 2:und --track-name 2:"" --default-track 2:true \
    --language 3:und --track-name 3:"" --default-track 3:true \
    --language 4:und --track-name 4:"" --default-track 4:true'

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

export AWS_PROFILE=`cat ~/code/private/AWS_PROFILE 2> /dev/null`

export OC_EDITOR="vim"
export KUBE_EDITOR="vim"
export KUBECONFIG=~/code/cluster/auth/kubeconfig

export GOPATH=~/code/go
export PATH=$PATH:$GOPATH/bin

export IMAGE_BUILD_CMD=docker
export REGISTRY_NAMESPACE=nigoyal

ocs=$GOPATH/src/github.com/red-hat-storage/ocs-operator
odf=$GOPATH/src/github.com/red-hat-storage/odf-operator
release=~/code/release

removeImg() {
    for i in `docker images | grep none | awk '{print $3}'`; do
        docker rmi $i
    done
}

removeImgAll() {
    for i in `docker images -a | grep none | awk '{print $3}'`; do
        docker rmi $i
    done
}

k8s() {
    if [ -n "$1" ]; then
        curl "$1" > ~/Downloads/kubeconfig
    fi

    export KUBECONFIG=~/Downloads/kubeconfig
}
