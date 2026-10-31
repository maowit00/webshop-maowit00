#!/bin/sh

# Launch the backend.
# Usage: backend.sh            start with the port from application.properties
#        backend.sh <port>     start with SERVER_PORT=<port> (e.g. a second instance)

set -e

PORT="$1"

if [ -n "$PORT" ]; then
  case "$PORT" in
    *[!0-9]*)
      echo "Invalid port: '$PORT' (usage: $0 [port])" >&2
      exit 1
      ;;
  esac
fi

cd "$(dirname "$0")/../../webshopbackend"

if [ -n "$PORT" ]
then
  env SERVER_PORT="$PORT" mvn spring-boot:run
else
    mvn spring-boot:run
fi

