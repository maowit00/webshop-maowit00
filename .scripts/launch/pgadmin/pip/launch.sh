#!/bin/sh

set -e

. "$HOME/.scripts/launch/.env"

(
    set -x

    . "$PGADMIN_TARGET_TARGET/bin/activate"

    export PYTHONPATH="$PGADMIN_TARGET_TARGET/.config/pgadmin${PYTHONPATH:+:$PYTHONPATH}"

    export PGADMIN_SETUP_EMAIL="$PGADMIN_DEFAULT_EMAIL"
    export PGADMIN_SETUP_PASSWORD="$PGADMIN_DEFAULT_PASSWORD"

    pgadmin4
    )

