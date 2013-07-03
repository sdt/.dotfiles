#!/bin/bash

do_install() {
    local basefile="$1"
    local rccmd="$2"

    [ -z "$rccmd" ] && rccmd="source ~/.dotfiles/$basefile"

    local sysfile=~/.${basefile}
    local dotfile="~/.dotfiles/${basefile}"

    echo -n "Installing ${dotfile} to ${sysfile} ... "
    if [ -e $sysfile ] && grep -F -q "$rccmd" $sysfile; then
        echo already installed.
    else
        echo ${rccmd} >> ${sysfile}
        echo ok.
    fi
}

install_link() {
    local src="$1"
    local dest="$2"

    if [ -L "$dest" ]; then
        ln -f -v -s "$src" "$dest"
    elif [ ! -e "$dest" ]; then
        ln -v -s "$src" "$dest"
    else
        echo $dest already exists, but is not a symbolic link
    fi
}

do_install bashrc
do_install vimrc
do_install gvimrc
do_install tmux.conf
do_install sqliterc ".read $HOME/.dotfiles/sqliterc"
install_link ~/.dotfiles/colordiffrc ~/.colordiffrc

echo -n "Updating git config ... "
git config --global core.excludesfile ~/.dotfiles/gitignore
git config --global color.ui true
git config --global alias.llog 'log --date=local'
git config --global alias.ds 'diff --stat'
git config --global alias.dc 'diff --cached'
git config --global alias.dsc 'diff --stat --cached'
git config --global alias.steve 'tag -f steve-was-here'
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
git config --global alias.wu 'log --stat origin..@{0}'
git config --global alias.wup 'log -p origin..@{0} --'
git config --global alias.w 'whatchanged -M -C -B'
git config --global alias.cv 'commit -v'
git config --global alias.co 'checkout'
git config --global alias.unstage 'reset HEAD'
git config --global alias.st 'status'
echo ok.
