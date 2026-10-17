#!/bin/sh

FRONTEND_PATH=webshopfrontend

if [ -d "$" ]
then
    echo
    echo
    echo "$FRONTEND_PATH already exists ..."
    echo

    exit 0
fi

set -xe

npm create --yes \
    vite@8.3.0 webshopfrontend -- \
    --template vue \
    --no-rolldown --immediate
