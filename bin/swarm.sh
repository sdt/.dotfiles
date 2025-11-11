#!/bin/bash
set -euo pipefail

if [[ $# == 0 ]]; then
  echo -n 'Swarm status: '
  docker info --format '{{.Swarm.LocalNodeState}}'
  exit
fi

if [[ $# == 1 ]]; then
  case "$1" in
    up)
      docker swarm init
      exit
      ;;

    down)
      docker swarm leave --force
      exit
      ;;

  esac
fi

echo "usage: $0 [up|down]" 1>&2
exit 1
