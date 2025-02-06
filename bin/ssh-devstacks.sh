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
    echo usage: $0 '<apps|hosts|install|ps>' 1>&2
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
devstack() {
  case $# in
    0)
      ssh-devstacks.sh ps;
      ;;

    2)
      ssh -fNn "$1.$2.devstack.internal";
      ;;

    *)
      echo "usage: devstack <stack> <host>" 1>&2;
      return 1;
      ;;
  esac;
};
END
}

case "$1" in
  apps)
    grep -i '^host.*\.\*\.devstack' ~/.ssh/config ~/.ssh/config.d/* \
        | egrep -o '\S+\.\*\.devstack\.internal' \
        | cut -d. -f1 \
        | sort
    ;;

  hosts)
    grep -i '^host.*\*\..*\.devstack' ~/.ssh/config ~/.ssh/config.d/* \
        | egrep -o '\*\.\S+\.devstack\.internal' \
        | cut -d. -f2 \
        | sort
    ;;

  install)
    install
    ;;

  ps)
    pgrep -lf 'ssh -fNn .*.\devstack\.internal' | while read line; do
        parts=( $line )
        pid="${parts[0]}"
        host="${parts[3]}"
        ports=$(
            lsof -p $pid -P -sTCP:LISTEN 2>/dev/null \
                | grep IPv4 | awk '{ print $9 }' | cut -d: -f2 | tr '\n' ' '
        )
        echo $pid $host $ports
    done | column -t
    ;;

  *)
    usage
    ;;
esac
