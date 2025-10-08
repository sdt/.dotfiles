#!/bin/bash
set -euo pipefail

if [[ $# != 2 ]]; then
  echo usage: $0 old new 1>&2
  exit 1
fi

old="$1"
new="$2"

docker buildx imagetools create --tag "$new" "$old"
