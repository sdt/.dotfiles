#!/bin/bash
set -euo pipefail

if [[ $# != 1 ]]; then
    echo "usage $0: service-name" 1>&2
    exit 1
fi

while true; do
    health=$( docker-compose ps --format json "$1" | jq -r .Health | tee /dev/stderr )

    case "$health" in

    starting)
        sleep 1
        ;;

    healthy)
        exit 0
        ;;

    *)
        exit 1
        ;;

    esac
done
