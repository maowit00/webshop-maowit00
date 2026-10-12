#!/bin/sh

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

apt install -y postgresql

systemctl enable --now postgresql

# - -- - -- - -- - --

# Config Password for the default admin postgres user

POSTGRES_PASSWORD="postgress"

sudo runuser -u postgres -- psql -c "ALTER USER postgres WITH PASSWORD '$POSTGRES_PASSWORD';"

