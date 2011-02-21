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

eval $(lesspipe)

# remove ':' from completion word breaks so man Some::Perl doesn't escape
# http://tiswww.case.edu/php/chet/bash/FAQ   /E13
export COMP_WORDBREAKS=${COMP_WORDBREAKS//:}

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
export EDITOR=vim

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
if can_run gvim; then
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

yamldump() {
    perl -MData::Dumper::Concise -MYAML -e \
        'print qq("$_" =>\n), Dumper(YAML::LoadFile($_)) for @ARGV' $@
}

if can_run iselect; then
    fv() {
        local query=$1;
        [ -n "$query" ] || return;
        found=`find . -type f \( -iname "*$query*" -! -iname '.*.sw?' \)`
        [ -z "$found" ] && return ;

        # reading array http://tinyurl.com/la6juc
        # allows -m option to work
        local OIFS="$IFS"
        IFS=$'\n';
        set -f ;
        trap 'echo Or maybe not...' INT
        local edit=( $(iselect -f -a -m "$found" -t "$query" -n "vi" ) ) ;
        trap INT
        set +f ;
        IFS="$OIFS"

        [ -n "$edit" ] && vi ${edit[@]};
    }

    f() {
        local query=${!#};
        local cmdargs=$(($#-1));
        local cmd="${@:1:$cmdargs}";

        [ -n "$query" ] || return;
        found=`find . -type f \( -iname "*$query*" -! -iname '.*.sw?' \)`
        [ -z "$found" ] && return ;

        # reading array http://tinyurl.com/la6juc
        # allows -m option to work
        local OIFS="$IFS"
        IFS=$'\n';
        set -f ;
        trap 'echo Or maybe not...' INT
        local selected=( $(iselect -f -a -m "$found" -t "$query" -n "vi" ) ) ;
        trap INT
        set +f ;
        IFS="$OIFS"

        [ -n "$selected" ] && echo $cmd ${selected[@]} && $cmd ${selected[@]};
    }
else
    function fv {
        echo iselect not installed
    };

    function f {
        echo iselect not installed
    };
fi

append_envvar() {
    local envvar=$1
    eval "local envval=\$$envvar"
    if test -z $envval; then
        eval "$envvar=\"$2\""
    else
        eval "$envvar=\"$envval:$2\""
    fi
    eval "echo \$envvar=\$$envvar"
}

mcd() { mkdir $1 && cd $1; }

alias mydebuild='debuild -uc -us -i -I -tc'

if [ -e $HOME/perl5/perlbrew/etc/bashrc ]; then
    source $HOME/perl5/perlbrew/etc/bashrc
fi

if [ -d $HOME/git/git-achievements ]; then
    PATH="$PATH:$HOME/git/git-achievements"
    alias git="git-achievements"
fi

if [ -e ~/.dotfiles/bashrc.local ]; then
    source ~/.dotfiles/bashrc.local
fi

alias rebash='source ~/.bashrc'
