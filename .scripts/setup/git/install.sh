#!/bin/sh

if command -v git
then
    echo
    echo "git already installed ..."
    echo
    echo

    exit 0
fi

set -e

if [ "$(id -u)" -ne 0 ]
then

    if [ -z "$(command -v sudo)" ]
    then
        echo "ERROR: Not possible to become root ..."
        exit 1
    fi

    echo
    echo "Elevating to root ..."
    echo
    echo

    exec sudo -- "$0" "$@"
fi

apt update

apt install -y git git-lfs

