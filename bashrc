#-----------------------------------------------------------------------------
# Steve's .bashrc stuff
#
alias l='/bin/ls -F --color=auto'
alias ls='/bin/ls -lF --color=auto'
alias la='l -A'
alias lsa='ls -A'
m() { less -R $*; }
alias md=mkdir
alias h=history

alias hf='history|grep -i'
alias ef='printenv|grep -i'
alias rm='rm -i'
alias j=jobs

alias http="plackup -MPlack::App::Directory -e 'Plack::App::Directory->new({ root => \$ENV{PWD} })->to_app;'"

#set -o vi
shopt -s dotglob

setcolor() { echo "\[\033[$1m\]"; }


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

PS1="${debian_chroot:+($debian_chroot)}"
PS1+="$SETBOLD$SETMAGENTA\$(__git_ps1 '(%s) ')"
PS1+="$SETBOLD$SETBLUE\w"
PS1+="\n"
PS1+="$SETBOLD$SETGREEN\u@\h \t"
PS1+="$SETRESET\$"
PS1+=" "

# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

export DBIC_TRACE_PROFILE=console

find_file_upwards() {
    local dir=`pwd`

    until [ -f $dir/$1 ] ; do
        if [ $dir = '/' ]; then
            return 1
        fi
        dir=$(dirname $dir)
    done
    echo $dir/$1
}

is_vim_server_running() {
    gvim --serverlist | grep -q -i `hostname`
}

can_run() {
    which $1 > /dev/null
    return $?
}

# If gvim exists set up our gvim-in-tabs system
if can_run gvim; then
    vi() {
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

vs()  { find . -type f -iname '.*.sw?'; }
vsd() { find . -type f -iname '.*.sw?' -print -delete; }


yamldump() {
    perl -MData::Dumper::Concise -MYAML -e \
        'print qq("$_" =>\n), Dumper(YAML::LoadFile($_)) for @ARGV' $@
}

if can_run iselect; then
    iselect_and_run() {
        # iselect_and_run [grepargs] cmd [cmdargs] filespec

        # Grab the all the args that start with -
        local grep_args=""
        while [ $# -gt 0 ] && [ ${1:0:1} == '-' ] && [ $1 != '--' ]; do
            grep_args+=" $1"
            shift
        done

        if [ $# -lt 2 ]; then
            # TODO: see if we can get the caller function name in here
            echo "usage: iselect_and_run [grepargs] cmd [cmdargs] filespec"
            return
        fi

        local filespec=${!#};
        local num_cmdargs=$(($#-1));
        local cmd="${@:1:$num_cmdargs}";

        [ -n "$filespec" ] || return;
        local found=$(find . \( -name .git -prune \) -o -type f -! -iname '.*.sw?' \
                | /bin/grep $grep_args $filespec)
        [ -z "$found" ] && return ;

        # reading array http://tinyurl.com/la6juc
        # allows -m option to work
        local OIFS="$IFS"
        IFS=$'\n';
        set -f ;
        trap 'echo Or maybe not...' INT
        local selected=( $(iselect -f -a -m "$found" -t "$filespec" -n "$cmd" ) ) ;
        trap INT
        set +f ;
        IFS="$OIFS"

        [ -n "$selected" ] && echo $cmd ${selected[@]} && $cmd ${selected[@]};
    }
else
    no_iselect() {
        echo iselect not installed
    }

    iselect_and_run()     { no_iselect; }
fi

alias fv='iselect_and_run -i vi'
alias fvc='iselect_and_run vi'

envvar_contains() {
    local pathsep=${PATHSEP:-:}
    eval "echo \$$1" | egrep -q "(^|$pathsep)$2($pathsep|\$)";
}

strip_envvar() {
    [ $# -gt 1 ] || return;

    local pathsep=${PATHSEP:-:}
    local haystack=$1
    local needle=$2
    echo $haystack | sed -e "s%^${needle}\$%%"  \
                   | sed -e "s%^${needle}${pathsep}%%"   \
                   | sed -e "s%${pathsep}${needle}\$%%"  \
                   | sed -e "s%${pathsep}${needle}${pathsep}%${pathsep}%"
}

prepend_envvar() {
    local envvar=$1
    local pathsep=${PATHSEP:-:}
    eval "local envval=\$(strip_envvar \$$envvar $2)"
    if test -z $envval; then
        eval "export $envvar=\"$2\""
    else
        eval "export $envvar=\"$2$pathsep$envval\""
    fi
    #eval "echo \$envvar=\$$envvar"
}

prepend_envvar_here()    { prepend_envvar $1 $(pwd); }
prepend_envvar_at()      {
    local dir=$(readlink -e $2)
    [ -z "$dir" ] && echo Can\'t find $2 && return
    prepend_envvar $1 $dir
}

perlhere() { PATHSEP=: prepend_envvar_here PERL5LIB; }
perlat()   { for i in $@; do PATHSEP=: prepend_envvar_at PERL5LIB $i; done; }
pathat()   { for i in $@; do PATHSEP=: prepend_envvar_at PATH $i; done; }

mcd() { mkdir -p $1; cd $1; }

if can_run colordiff; then
    alias diff="colordiff -u"
else
    alias diff="diff -u"
fi

if can_run lesspipe; then
    eval $(lesspipe)
fi

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
