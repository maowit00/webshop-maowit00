#!/bin/sh

set -xe

. "$HOME/.scripts/launch/.env"

docker run \
  --network="host" \
  -e PGADMIN_DEFAULT_EMAIL="$PGADMIN_DEFAULT_EMAIL" \
  -e PGADMIN_DEFAULT_PASSWORD="$PGADMIN_DEFAULT_PASSWORD" \
  -e PGADMIN_LISTEN_PORT='5050' \
  dpage/pgadmin4:latest
