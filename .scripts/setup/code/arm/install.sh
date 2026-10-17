#!/bin/sh

if command -v code
then
    echo
    echo
    echo "vscode already installed ..."
    echo

    exit 0
fi

# - -- - -- - -- - -- - -- - -- - --

tmpdir=$(mktemp -d) || exit 1

trap 'rm -rf "$tmpdir"' EXIT
trap 'exit 1' INT TERM HUP

cd "$tmpdir"

# - -- - -- - -- - -- - -- - -- - --

wget -O code_arm64.deb \
    "https://update.code.visualstudio.com/latest/linux-deb-arm64/stable"

sudo apt install -y ./code_arm64.deb
