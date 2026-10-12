#!/bin/sh

set -e

n=$#

for package in "$@"
do
    if [ -d "$HOME/.scripts/setup/$package" ]
    then
        # Look for dedicated installer scripts
        "$HOME/.scripts/setup/$package/install.sh"
        continue
    fi
    set -- "$@" "$package"
done

shift "$n"

# - -- - -- - -- - -- - -- - -- - -- - --

# Install ubuntu packages

if [ $# -eq 0 ]
then
    # nothing to see here
    exit 0
fi

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

set -x

apt update

apt install -y "$@"

