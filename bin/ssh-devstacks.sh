#!/bin/bash

# Load this up with `eval $( ssh-devstacks.sh install )`

# Set up .ssh/config like so:
#
# Devstack hosts:
#
#   host *.devstack.foo
#     Hostname foo
#
#   host *.devstack.bar
#     Hostname bar
#
# Devstack apps;
#
#   host app1.devstack.*
#     LocalForward 2001 localhost:2001
#     LocalForward 2002 localhost:2002
#
#   host app2.devstack.*
#     LocalForward 4001 localhost:4001
#     LocalForward 4002 localhost:4002
#
# Then to port forward app1 onto host bar: ssh -fNn app1.devstack.bar
#
# This lists out the apps or hosts

usage() {
    echo usage: $0 '<apps|hosts>' 1>&2
    exit 1
}

if [[ $# != 1 ]]; then
  usage
fi

install() {
  cat <<'END'
__complete-devstack() {
  if [[ ${#COMP_WORDS[@]} -gt 3 ]]; then
    return;
  fi;
  case $COMP_CWORD in
    1)
      which=hosts;
      ;;
    2)
      which=apps;
      ;;
    *)
      return;
      ;;
  esac;
  COMPREPLY=($( compgen -W "$( ssh-devstacks.sh $which )" "${COMP_WORDS[COMP_CWORD]}"));
};
complete -F __complete-devstack devstack;
devstack() { ssh -fNn "$2.devstack.$1"; };
END
}

case "$1" in
  apps)
    fgrep '.devstack.*' ~/.ssh/config | awk -F '[ .]' '{  print $2; }' | sort
    ;;

  hosts)
    fgrep '*.devstack.' ~/.ssh/config | awk -F '[ .]' '{  print $4; }' | sort
    ;;

  install)
    install
    ;;

  *)
    usage
    ;;
esac
