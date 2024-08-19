#!/bin/bash

# Load this up with `eval $( ssh-devstacks.sh install )`

# Set up .ssh/config like so:
#
# Devstack hosts:
#
#   host *.foo.devstack.internal
#     Hostname foo.domain
#
#   host *.bar.devstack.internal
#     Hostname bar.domain
#
# Devstack apps;
#
#   host app1.*.devstack.internal
#     LocalForward 2001 localhost:2001
#     LocalForward 2002 localhost:2002
#
#   host app2.*.devstack.internal
#     LocalForward 4001 localhost:4001
#     LocalForward 4002 localhost:4002
#
# Then to port forward app1 onto host bar: ssh -fNn app1.bar.devstack.internal
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
      which=apps;
      ;;
    2)
      which=hosts;
      ;;
    *)
      return;
      ;;
  esac;
  COMPREPLY=($( compgen -W "$( ssh-devstacks.sh $which )" "${COMP_WORDS[COMP_CWORD]}"));
};
complete -F __complete-devstack devstack;
devstack() { ssh -fNn "$1.$2.devstack.internal"; };
END
}

case "$1" in
  apps)
    grep '^host.*\.\*\.devstack' ~/.ssh/config \
        | awk -F '[ .]' '{ print $2 }' \
        | sort
    ;;

  hosts)
    grep '^host.*\*\..*\.devstack' ~/.ssh/config \
        | awk -F '[ .]' '{ print $3 }' \
        | sort
    ;;

  install)
    install
    ;;

  *)
    usage
    ;;
esac
