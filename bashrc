#-----------------------------------------------------------------------------
# Steve's .bashrc stuff
#
alias l='/bin/ls -F --color=auto'
alias ls='l -lh'
alias la='l -A'
alias df='df -h -x devtmpfs -x efivarfs -x overlay -x squashfs -x tmpfs'
alias lsa='ls -A'
m() { less -R "$@"; }
alias md='mkdir -p'
alias h=history

alias hf='history|grep -i'
alias ef='printenv|grep -i'
alias rm='rm -i'
alias j=jobs

set -o vi
shopt -s dotglob histappend

has() { type -t "$@" > /dev/null; }

echoerr() { echo $* 1>&2; }

ismacos() { [[ "$OSTYPE" =~ darwin ]]; }

# Solarized is now the default. If non-solarized is required,
# source unsolarized.sh from bashrc.local
export SOLARIZED=dark

# remove ':' from completion word breaks so man Some::Perl doesn't escape
# http://tiswww.case.edu/php/chet/bash/FAQ   /E13
export COMP_WORDBREAKS=${COMP_WORDBREAKS//:}

export NETHACKOPTIONS='color, catname:Coco, dogname:Walter the farting dog, fixinv, fruit:bum nugget, hilite_pet, runmode:walk, disclose:yi ya yv yg yc, noautopickup, nocmdassist, boulder:0'

export IGNOREEOF=1

# GNU quotes the output of ls which bugs me
export QUOTING_STYLE=literal

_make_color() {
    local code
    for i in $@; do
        eval "color=\$_$i"
        if [ -z $color ]; then
            echoerr Unknown color $i
            return 1
        fi
        code="$code;$color"
    done
    echo -n $code
}

ansicode() {

    local _black=30
    local _red=31
    local _green=32
    local _yellow=33
    local _blue=34
    local _magenta=35
    local _cyan=36
    local _white=37
    local _default=39

    local _bgblack=40
    local _bgred=41
    local _bggreen=42
    local _bgyellow=43
    local _bgblue=44
    local _bgmagenta=45
    local _bgcyan=46
    local _bgwhite=47
    local _bgdefault=49

    local _bold=1
    local _italics=3
    local _underline=4
    local _inverse=7
    local _strikeout=9

    local _nobold=22
    local _noitalics=23
    local _nounderline=24
    local _noinverse=27
    local _nostrikeout=29

    local _reset=0

    _make_color $@
}

solarized_code() {

    local _base03='1;30'
    local _base02='22;30'
    local _base01='1;32'
    local _base00='1;33'
    local _base0='1;34'
    local _base1='1;36'
    local _base2='22;37'
    local _base3='1;37'
    local _yellow='22;33'
    local _orange='1;31'
    local _red='22;31'
    local _magenta='22;35'
    local _violet='1;35'
    local _blue='22;34'
    local _cyan='22;36'
    local _green='22;32'

    local _bgbase02=40
    local _bgbase2=47
    local _bgyellow=43
    local _bgred=41
    local _bgmagenta=45
    local _bgblue=44
    local _bgcyan=46
    local _bggreen=42

    local _underline=4
    local _nounderline=24

    local _reset=0

    _make_color $@
}

ansicolor() { printf '\e[%sm' $( ansicode "$@" ); }
solacolor() { printf '\e[%sm' $( solarized_code "$@" ); }
bashcolor() { printf '\[%s\]' $( ansicolor "$@" ); }

# Use this with PROMPT_COMMAND to automatically reset the ssh auth socket.
fix_ssh_auth_sock() {
    if [[ -n "$SSH_AUTH_SOCK" && ! -S "$SSH_AUTH_SOCK" ]] \
            && tmux show-environment | grep -q SSH_AUTH_SOCK= ; then
        echo Auto-fix ssh auth sock
        eval $( tmux show-environment | grep SSH_AUTH_SOCK= )
    fi
}
PROMPT_COMMAND=( 'fix_ssh_auth_sock' )

if [[ "$HOSTNAME" =~ ^ip- ]]; then
    # "Special" hosts get a red color in the prompt
    ps1color=red
else
    ps1color=green
fi

PS1=""
PS1+="$(bashcolor reset)"
PS1+="${debian_chroot:+($debian_chroot)}"
PS1+="$(bashcolor magenta)\$(__git_ps1 '(%s) ')"
PS1+="$(bashcolor blue)\w"
PS1+="\n"
PS1+="$(bashcolor $ps1color)\u@\h \t"
PS1+="$(bashcolor reset)\$"
PS1+=" "

# Less Colors for Man Pages
if true; then
    export LESS_TERMCAP_mb=$(ansicolor red)                 # begin blinking
    export LESS_TERMCAP_md=$(ansicolor yellow)              # begin bold
    export LESS_TERMCAP_me=$(ansicolor reset)               # end mode
    export LESS_TERMCAP_se=$(ansicolor reset)               # end standout-mode
    export LESS_TERMCAP_so=$(ansicolor magenta)             # begin standout-mode – info box
    export LESS_TERMCAP_ue=$(ansicolor nounderline)         # end underline
    export LESS_TERMCAP_us=$(ansicolor underline green)     # begin underline
fi

# Handle ANSI colors in less. Quit if less than one screen.
export LESS="-FRX"

# ... but keep the git pager as it should be
#export GIT_PAGER="less -FRSX"

# ... or not, maybe
export GIT_PAGER="less -FRX"

_yes_or_no() {
    local default=$1 ; shift
    local ucdefault=$(echo $default | tr '[:lower:]' '[:upper:]')
    local yesno=yes/no
    local yn=${yesno/$default/$ucdefault}
    local prompt="$@ ($yn)? "

    while true; do
        local input; read -p "$prompt" input

        [ -z $input ] && input=$default

        case $input in
            yes|y)
                return 0
                ;;
            no|n|)
                return 1
                ;;
        esac
    done
}

YES_or_no() { _yes_or_no yes "$@"; }
yes_or_NO() { _yes_or_no no  "$@"; }
do_Yn()     { _yes_or_no yes "$@" && "$@" || echo 1>&2 Aborted ; }
do_yN()     { _yes_or_no no  "$@" && "$@" || echo 1>&2 Aborted ; }

export HISTSIZE=10000
export HISTCONTROL=erasedups:ignorespace
export EDITOR=vim

export DBIC_TRACE_PROFILE=console

UEDITOR=vi
source $HOME/.dotfiles/uselect/example.bashrc

find_file_upwards() {
    local dir="$PWD"

    until [ -f $dir/$1 ] ; do
        if [ $dir = '/' ]; then
            return 1
        fi
        dir=$(dirname $dir)
    done
    echo "$dir/$1"
}

if has mvim && ! has gvim; then
    gvim() { mvim "$@"; }
fi

if has python3; then
    alias http="python3 -m http.server"
else
    alias http="python -m SimpleHTTPServer"
fi

vs()  { find . -type f -iname '.*.sw?'; }
vsd() { find . -type f -iname '.*.sw?' -delete -exec echo Deleting {} ... \; ; }

# locate variants - only files or only dirs
flocate() {
    locate "$@" | perl -nlE 'say if -f'
}

dirlocate() {   # dlocate already exists
    locate "$@" | perl -nlE 'say if -d'
}

# Rename some commands from uselect/example.bashrc
alias fv=fe
alias gv=ge
alias lv=le

TEST=/a/test/path/../dir
EXPECTED=/a/test/dir
if GOT=$( readlink -m $TEST 2> /dev/null ) && [ "$GOT" == "$EXPECTED" ]; then
    # Use readlink if we have the gnu version
    fullpath() { readlink -m "$@"; }
elif GOT=$( greadlink -m $TEST 2> /dev/null ) && [ "$GOT" == "$EXPECTED" ]; then
    # Use greadlink if we installed that with homebrew
    fullpath() { greadlink -m "$@"; }
else
    # Fall back to python
    fullpath() { python -c \
        'import os.path; import sys; print os.path.abspath(sys.argv[1])' "$@"; }
fi
unset TEST EXPECTED GOT

strip_envvar() {
    [ $# -gt 1 ] || return;

    local pathsep=${PATHSEP:-:}

    # Add an extra pathsep to each end to avoid special cases
    local haystack=$pathsep$1$pathsep
    local needle=$pathsep$2$pathsep

    # This needs to be in a loop, multiples don't work properly if we use the
    # 'replace all' mode.
    while true; do
        local h2=${haystack/$needle/$pathsep}
        [ $h2 == $haystack ] && break
        haystack=$h2
    done
    h2=${h2#$pathsep}     # strip the initial pathsep
    echo ${h2%$pathsep}   # strip the final pathsep
}

prepend_envvar_at() {
    local sep=${PATHSEP:-:}
    local var=$1 ; shift
    local prefix=$( IFS="$sep"; echo "$*"; )
    local newpath=$( eval ~/.dotfiles/bin/cleanpath "$prefix""$sep"\$$var )
    eval "export $var=$newpath"
}

perlat()   { prepend_envvar_at PERL5LIB        "$@"; }
p6at()     { prepend_envvar_at PERL6LIB        "$@"; }
pathat()   { prepend_envvar_at PATH            "$@"; }
pythat()   { prepend_envvar_at PYTHONPATH      "$@"; }
libat()    { prepend_envvar_at LD_LIBRARY_PATH "$@"; }

export ACKRC="$HOME/.dotfiles/ackrc"
export ACK_PAGER="less"
export BUILDKIT_PROGRESS=plain
export COMPOSE_MENU=0
export INPUTRC="$HOME/.dotfiles/inputrc"
export SCREENRC="$HOME/.dotfiles/screenrc"
export TERM_ANSICOLOR_CONFIG="$HOME/.dotfiles/ansicolorrc"
export TMUX_VIM_CONFIG="$HOME/.dotfiles/tmux-vim.conf"
export TMUX_VIM_INI="$HOME/.dotfiles/tmux-vim.ini"
export USELECTRC="$HOME/.dotfiles/uselectrc"

# Screen colors (solarized)
export SCR_IW_FG=G
export SCR_IW_BG=k
export SCR_AW_FG=y
export SCR_AW_BG=.
export SCR_FG=.
export SCR_BG=.

# Leaky pipes! (with output prefix)
leak() { perl -ple "print STDERR '$*', \$_"; }

if [[ -n $TMUX ]]; then

    vi() { ~/.dotfiles/tmux-vim/tmux-vim "$@"; }

    reauth() {
        printenv SSH_AUTH_SOCK
        eval $( tmux show-environment | grep SSH_AUTH_SOCK )
        printenv SSH_AUTH_SOCK
    }

    regit() {
        reauth
        if [ $# == 0 ]; then
            local lastcmd=$( history -p '!git' )
        else
            local lastcmd="git $@"
        fi
        echo $lastcmd
        eval "$lastcmd"
    }

    # tmouse on/off
    tmouse() {
        for i in resize-pane select-pane select-window; do
            tmux set mouse-$i $1
        done
        if [[ -n "$1" ]]; then
            tmux set mode-mouse $1
        else
            local onoff=$( \
                tmux show-options | grep resize-pane | cut -d' ' -f2 )
            tmux set mode-mouse ${onoff:-off}
        fi
    }

else

    # Outside TMUX-only

    # Start up tmux in an intelligentish fashion
    gotmux() {
        new='Create new session'
        if tmux ls &> /dev/null; then
            session=$(
                cat <( tmux ls ) <( echo $new ) |
                    uselect -1 -s 'Select tmux session'
            )
        else
            session=( "$new" )
        fi

        start=$( date +%s )
        case "$session" in

        "") # Nothing selected
            echo No tmux then
            return
            ;;

        $new) # Create new session
            tmux
            ;;


        *) # Attach to an existing session
            tmux attach-session -t $( echo $session | cut -d: -f1 )
            ;;
        esac

        end=$( date +%s )

        # If we were in the tmux session for more than 10 seconds, log out
        if [[ $(( end - start )) -gt 10 ]]; then
            logout
        fi
    }

fi

mcd() { mkdir -p "$1"; cd "$1"; }

if has colordiff; then
    alias diff="colordiff -u"
elif ismacos; then
    alias diff="diff -u"
else
    alias diff="diff -u --color"
fi

# Git submodules helpers
crgit() {
    "$@"
    git submodule foreach --recursive "$@"
}

rgit() {
    crgit git "$@"
}

addgitemail() {
    local EMAILS='sdt@cpan.org sdt@dr.com stephent@logicly.com.au'
    uselect -1 -s 'select git email' $EMAILS | xargs git config user.email
}

fixgitemail() {
    addgitemail && git commit --amend --reset-author
}

do_or_dry() {
    if [[ -n $DRY ]]; then
        echo "$@"
    else
        "$@"
    fi
}

gitbranchtotag() {

    if [[ $1 = -n ]]; then
        local DRY=1
    elif [[ $1 = -f ]]; then
        local DRY=
    else
        echo "Please specify -n (dry-run) or -f (force)"
        return 1
    fi
    shift   # get rid of -n / -f

    local lbr=$1
    local rbr=origin/$1
    local tag=attic/$lbr

    git fetch origin            # get the latest version from origin
    if ! git diff --exit-code --stat $lbr $rbr; then
        echo
        echo Local branch differs from remote.
        echo Please merge remote changes and try again.
        return 1
    fi

    do_or_dry git tag $tag $lbr            # create tag from branch
    do_or_dry git branch -D $lbr           # delete branch
    do_or_dry git push origin :$lbr $tag   # update origin with new tag / deleted branch
}

# Difference between two file trees
#  difftree -q to show only the filenames
alias difftree="diff -x .git -r"

for lp in lesspipe lesspipe.sh; do
    if has $lp; then
        eval $( $lp )
    fi
done

# Dist::Zilla config lives in ~/.dotfiles/dzil
export DZIL_GLOBAL_CONFIG_ROOT=${HOME}/.dotfiles/dzil

# Handy alias for unravelling tricky perl constructs
alias perlparse='perl -MO=Deparse,-p -e'

# Reload .bashrc
rebash() {
    unalias -a
    source ~/.bashrc
}

# Update dotfiles
redot() {
    if update-git-repo ~/.dotfiles; then
        rebash
        ~/.dotfiles/install.sh
        return 0
    fi
    return 1
}

pod() {
    has perlfind || cpm.sh install App::perlfind
    perlfind "$@"
}

export SSH_ENV="$HOME/.ssh/environment"

export GOPATH="$HOME/gocode"
pathat "$GOPATH/bin"

# Don't call this directly
_start_ssh_agent() {
     echo "Initialising new SSH agent..."
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     chmod 600 "${SSH_ENV}"
     source "${SSH_ENV}"
     /usr/bin/ssh-add;
}

# This should get called by the bashrc.local of personal machines (not servers)
start_ssh_agent() {
    if [ -f "${SSH_ENV}" ]; then
         source "${SSH_ENV}" > /dev/null
         ps -ef | grep $SSH_AGENT_PID | grep -q ssh-agent$ || _start_ssh_agent
    else
         _start_ssh_agent;
    fi
}

socks_proxy() {
    local host=$1
    local port=${2:-1080}

    # ssh -f -N -p $remote-ssh-port -D [$local-address]:$local-port [$user@]$remote-host

    ssh -f -N -D 0:$port $host
}

# Local bash completion overrides
complete -f -X '!*.db' sqlite3

source_if() {
    if [[ -e $1 ]]; then
        source $1
    fi
}

# jn delimiter args - like perl join ("join" was taken)
jn() (
    IFS="$1"
    shift
    echo "$*"
)

# filter patt1 patt2 ...
# - wrapper around grep -v
# - filters out lines matching any of the given patterns
filter() {
    runv egrep -v "$( jn '|' "$@" )" ;
}

any_exists() {
    for i in "$@"; do
        [ -e "$i" ] && return 0
    done
    return 1
}

# docker-compose is too much typing
complete -F _docker_compose fig
alias fig=docker-compose

if has ag; then
    alias ack=ag
fi

pathat ~/.dotfiles/bin
pathat ~/bin

pathat ~/.rakudobrew/bin

if has ruby && has gem; then
    pathat "$(ruby -r rubygems -e 'puts Gem.user_dir')/bin"
fi

pathat ~/.cabal/bin

source_if ~/.pythonbrew/etc/bashrc
source_if ~/.pythonz/etc/bashrc
source ~/.dotfiles/tmux-colors.sh

if ismacos ; then
    source_if ~/.dotfiles/bashrc.macosx
fi

source_if ~/perl5/perlbrew/etc/bashrc
if [ -z $PERLBREW_VERSION ]; then
    # Only want these if perlbrew is not installed
    source ~/.dotfiles/bashrc.stratdat
    source ~/.dotfiles/bashrc.huni-perl
    source ~/.dotfiles/bashrc.perl-local-lib
fi

source ~/.dotfiles/bashrc.linuxbrew

for i in ~/.dotfiles/bash_completion.d/*; do
    if ! [[ $( basename "$i" ) =~ '.' ]]; then # skip files with dots
        source "$i"
    fi
done

if has platformio; then
    eval "$(_PLATFORMIO_COMPLETE=source platformio)"
fi

if any_exists ~/.dotfiles/*.local; then
    echo WARNING: these files should be transferred to ~/.dotfiles/local
    ls ~/.dotfiles/*.local
fi

# This needs to go after anything that modifies the prompt.
# Disabled this for now. direnv shits me.
if false && has direnv; then
    # eval "$(direnv hook bash)"
    # See: https://github.com/direnv/direnv/issues/627#issuecomment-634504650
    _direnv_hook() {
        local previous_exit_status=$?;
        eval "$(direnv export bash)";
        return $previous_exit_status;
    };
    if ! [[ "${PROMPT_COMMAND:-}" =~ _direnv_hook ]]; then
        PROMPT_COMMAND="_direnv_hook${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
    fi
fi

# This should override everything else
source_if ~/.dotfiles/local/bashrc
