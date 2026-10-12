#!/bin/sh

set -e

LINK_AT="$HOME/.scripts"

if [ -L "$LINK_AT" ]
then
    echo
    echo "Unable to create a link at $LINK_AT"
    echo
    echo "Something already exists there ..."
    echo

    exit 1
fi

ANCHOR="$(realpath "$(dirname "$0")")"

set -x

ln -s "$ANCHOR" "$LINK_AT"

