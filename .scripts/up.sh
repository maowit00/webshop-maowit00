#!/bin/bash

set -e

cd "$(realpath "$(dirname "$0")")/.."

COMMANDS=(
  ".scripts/launch/keycloak.sh"
  ".scripts/launch/backend.sh"
  ".scripts/launch/backend.sh 8290"
  ".scripts/launch/frontend.sh"
)

COMMANDS+=("$@")

trap 'trap "" INT TERM EXIT; kill 0' EXIT INT TERM

for cmd in "${COMMANDS[@]}"; do
  echo "starting: $cmd"
  bash -c "$cmd" &
done

wait -n
