#!/bin/bash

do_install() {
    local basefile=$1
    local rccmd=$2

    [ -z $rccmd ] && rccmd="source ~/.dotfiles/$basefile"

    local sysfile=~/.${basefile}
    local dotfile="~/.dotfiles/${basefile}"

    echo -n "Installing ${dotfile} to ${sysfile} ... "
    if [ -e $sysfile ] && grep -F -q $dotfile $sysfile; then
        echo already installed.
    else
        echo ${rccmd} >> ${sysfile}
        echo ok.
    fi
}

do_install bashrc
do_install vimrc
do_install gvimrc

echo "Installing ~/.dotfiles/gitignore to ~/.gitconfig ... ok."
git config --global core.excludesfile ~/.dotfiles/gitignore
git config --global color.ui true
git config --global alias.llog 'log --date=local'
git config --global alias.ds 'diff --stat'
