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
git config --global alias.blog '!sh -c "git lg $( git merge-base $1 master )^..$1" -'
git config --global alias.cf 'commit -m FIXME'
git config --global alias.branch-name 'rev-parse --abbrev-ref HEAD'
git config --global alias.chp 'cherry-pick -n -x'
git config --global alias.ca 'commit -v --amend'
git config --global alias.co 'checkout'
git config --global alias.cv 'commit -v'
git config --global alias.dc 'diff --cached'
git config --global alias.ds 'diff --stat'
git config --global alias.dsc 'diff --stat --cached'
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cd) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
git config --global alias.llog 'log --date=local'
git config --global alias.mff 'merge --ff-only'
git config --global alias.recent-branches "for-each-ref --sort=-committerdate refs/heads/ --format='%(committerdate:short) %(authorname) %(refname:short)'"
git config --global alias.st 'status -s'
git config --global alias.stashed "stash list --pretty=format:'%gd: %Cred%h%Creset %Cgreen[%ar]%Creset %s'"
git config --global alias.steve 'tag -f steve-was-here'
git config --global alias.w 'whatchanged -M -C -B'
git config --global alias.wu 'log --stat origin..@{0}'
git config --global alias.wup 'log -p origin..@{0} --'
git config --global color.ui true
git config --global core.excludesfile ~/.dotfiles/gitignore
git config --global diff.renames true
git config --global diff.tool console
git config --global difftool.console.cmd 'colordiff -y -W $( tput cols ) $LOCAL $REMOTE'
git config --global init.defaultBranch main
git config --global user.name 'Stephen Thirlwall'
echo ok.
