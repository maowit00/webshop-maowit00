#!/bin/sh

if command -v node
then
    echo
    echo
    echo "Nodejs already installed ..."
    echo

    exit 0
fi

sudo apt update

sudo apt install -y nodejs npm
