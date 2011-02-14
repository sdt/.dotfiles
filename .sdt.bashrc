#-----------------------------------------------------------------------------
# Steve's .bashrc stuff
#
alias l='/bin/ls -F --color=auto'
alias ls='/bin/ls -lF --color=auto'
alias la='l -A'
alias lsa='ls -A'
alias m=less
alias md=mkdir
alias h=history

alias hf='history|grep -i'
alias ef='set|grep -i'
alias rm='rm -i'
alias j=jobs

alias http="plackup -MPlack::App::Directory -e 'Plack::App::Directory->new({ root => \$ENV{PWD} })->to_app;'"

#set -o vi
shopt -s dotglob

setcolor() { echo "\[\033[$1m\]"; }

BLACK=30
RED=31
GREEN=32
YELLOW=33
BLUE=34
MAGENTA=35
CYAN=36
WHITE=37

SETBLACK=$(setcolor $BLACK)
SETRED=$(setcolor $RED)
SETGREEN=$(setcolor $GREEN)
SETYELLOW=$(setcolor $YELLOW)
SETBLUE=$(setcolor $BLUE)
SETMAGENTA=$(setcolor $MAGENTA)
SETCYAN=$(setcolor $CYAN)
SETWHITE=$(setcolor $WHITE)
SETRESET=$(setcolor 0)
SETBOLD=$(setcolor 1)

HISTSIZE=2000

PS1='\[\e]0;\u@\h\a\]'
PS1+="${debian_chroot:+($debian_chroot)}"
PS1+="$SETBOLD$SETMAGENTA\$(__git_ps1 '(%s) ')"
PS1+="$SETBOLD$SETBLUE\w"
PS1+="\n"
PS1+="$SETBOLD$SETGREEN\u@\h \t"
PS1+="$SETRESET\$"
PS1+=" "

find_file_upwards()
{
    local dir=`pwd`

    until [ -f $dir/$1 ] ; do
        if [ $dir = '/' ]; then
            return 1
        fi
        dir=$(dirname $dir)
    done
    echo $dir/$1
}

is_vim_server_running()
{
    gvim --serverlist | grep -q -i `hostname`
}

can_run()
{
    which $1 > /dev/null
    return $?
}

# If gvim exists set up our gvim-in-tabs system
if canrun gvim; then
    vi()
    {
        local vimcmd="gvim --servername `hostname`"

#TODO:  cannot find a way of passing this to vim as one argument
#       keeps getting sent as qw/ '+set tags=$tagsfile' /
#    local tagsfile=$(find_file_upwards .ptags)
#    if [ -n "$tagsfile" ]; then
#        vimcmd+=" '+set tags=$tagsfile'"
#    fi

        if is_vim_server_running ; then
            if [ $# == 0 ]; then
                vimcmd+=" --remote-send :tablast<CR> --remote-send :tabnew<CR>"
            else
                vimcmd+=" --remote-tab-silent"
            fi
        else
            vimcmd+=" -p"
        fi

        #echo $vimcmd
        $vimcmd "$@"
    }
fi

mcd() { mkdir $1 && cd $1; }

alias mydebuild='debuild -uc -us -i -I -tc'

if [ -e $HOME/perl5/perlbrew/etc/bashrc ]; then
    source $HOME/perl5/perlbrew/etc/bashrc
fi

if [ -d $HOME/git/git-achievements ]; then
    PATH="$PATH:$HOME/git/git-achievements"
    alias git="git-achievements"
fi

if [ -e $HOME/.sdt.bashrc.local ]; then
    source $HOME/.sdt.bashrc.local
fi
