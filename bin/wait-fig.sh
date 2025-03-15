#!/bin/bash
set -euo pipefail

if [[ $# != 1 ]]; then
    echo "usage $0: service-name" 1>&2
    exit 1
fi

SECONDS=0

while true; do
    health=$( docker-compose ps --format json "$1" | jq -r .Health )

    case "$health" in

    starting)
        echo $health ... $SECONDS sec
        sleep 1
        ;;

    healthy)
        echo $health
        exit 0
        ;;

    *)
        echo $health
        exit 1
        ;;

    esac
done
