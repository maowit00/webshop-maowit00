#!/bin/sh

cd "$(dirname "$0")/../.."

KEYCLOAK_LAUNCH_SCRIPT=.scripts/setup/keycloak/keycloak/bin/kc.sh

set -xe

"$KEYCLOAK_LAUNCH_SCRIPT" start-dev
