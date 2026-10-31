#!/usr/bin/env bash

set -Eeuo pipefail

cd "$(dirname "$(realpath "$0")")"

# ------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------
FRONTEND_PORT=8145

HS_USER="maowit00"
USER_PASSWORD="changeme"         # password of the realm user

KC_ADMIN="admin"                 # master-realm admin (created on first start)
KC_ADMIN_PASSWORD="admin"

KC_HOME="keycloak"               # unzipped Keycloak folder (contains bin/)
KC_URL="http://localhost:8080"
STOP_KC_AFTERWARDS=true          # false = leave the server running afterwards

# ------------------------------------------------------------------
# Derived values
# ------------------------------------------------------------------
KCADM="$KC_HOME/bin/kcadm.sh"
KC_SH="$KC_HOME/bin/kc.sh"
REALM="${HS_USER}-organisation"
CLIENT="webshop-${HS_USER}"
FRONTEND="http://localhost:${FRONTEND_PORT}"

if [ ! -x "$KCADM" ]
then
  echo "Not found/executable: $KCADM (check KC_HOME)"
  exit 1
fi

if ! command -v curl >/dev/null
then
  sudo apt update
  sudo apt install -y curl
fi

# ------------------------------------------------------------------
# Start Keycloak if needed
# ------------------------------------------------------------------
KC_PID=""

cleanup() {
  if [[ -n "$KC_PID" && "$STOP_KC_AFTERWARDS" == true ]]
  then
    echo ">> Stopping Keycloak (pid $KC_PID)"
    pkill -P "$KC_PID" 2>/dev/null || true   # child processes (java), if any
    kill "$KC_PID" 2>/dev/null || true
    wait "$KC_PID" 2>/dev/null || true
  fi
}

trap cleanup EXIT
trap 'exit 130' INT TERM

kc_up() {
  curl -sf "$KC_URL/realms/master" >/dev/null
}

if kc_up
then
  echo ">> Keycloak already running, using it"
else

  echo ">> Starting Keycloak (log: keycloak.log)"

  KC_BOOTSTRAP_ADMIN_USERNAME="$KC_ADMIN" \
  KC_BOOTSTRAP_ADMIN_PASSWORD="$KC_ADMIN_PASSWORD" \
  KEYCLOAK_ADMIN="$KC_ADMIN" \
  KEYCLOAK_ADMIN_PASSWORD="$KC_ADMIN_PASSWORD" \
    "$KC_SH" start-dev > keycloak.log 2>&1 &

  KC_PID=$!

  echo ">> Waiting for Keycloak"

  for _ in $(seq 1 90)
  do

    kc_up && break

    if ! kill -0 "$KC_PID" 2>/dev/null
    then
      echo "Keycloak exited early, see keycloak.log"
      exit 1
    fi

    sleep 2

  done

  if ! kc_up
  then
    echo "Timeout waiting for Keycloak, see keycloak.log"
    exit 1
  fi
fi

# ------------------------------------------------------------------
# Configure Keycloak
# ------------------------------------------------------------------
echo ">> Login"

"$KCADM" config credentials \
  --server "$KC_URL" --realm master \
  --user "$KC_ADMIN" --password "$KC_ADMIN_PASSWORD"

echo ">> Realm: $REALM (recreating if it exists)"

"$KCADM" delete "realms/$REALM" 2>/dev/null || true

"$KCADM" create realms -s realm="$REALM" -s enabled=true

echo ">> User: $HS_USER"
# email/first/last name avoid "Account is not fully set up" on login
"$KCADM" create users -r "$REALM" \
  -s username="$HS_USER" \
  -s enabled=true \
  -s email="${HS_USER}@hs-esslingen.de" \
  -s emailVerified=true \
  -s firstName="$HS_USER" \
  -s lastName="$HS_USER"

"$KCADM" set-password \
  -r "$REALM" --username "$HS_USER" \
  --new-password "$USER_PASSWORD"

echo ">> Client: $CLIENT"

CID=$("$KCADM" create clients -r "$REALM" -i \
  -s clientId="$CLIENT" \
  -s enabled=true \
  -s publicClient=true \
  -s standardFlowEnabled=true \
  -s rootUrl="$FRONTEND" \
  -s "redirectUris=[\"${FRONTEND}/*\"]" \
  -s 'webOrigins=["*"]')

echo ">> Client role 'admin'"

"$KCADM" create "clients/$CID/roles" \
  -r "$REALM" -s name=admin

echo ">> Assign role to user"

"$KCADM" add-roles -r "$REALM" --uusername "$HS_USER" --cclientid "$CLIENT" --rolename admin

echo ">> Mapper: client roles -> ID token"

"$KCADM" create "clients/$CID/protocol-mappers/models" -r "$REALM" \
  -s name=client-roles \
  -s protocol=openid-connect \
  -s protocolMapper=oidc-usermodel-client-role-mapper \
  -s consentRequired=false \
  -s 'config."multivalued"=true' \
  -s 'config."id.token.claim"=true' \
  -s 'config."access.token.claim"=true' \
  -s 'config."userinfo.token.claim"=true' \
  -s 'config."jsonType.label"=String' \
  -s 'config."claim.name"=resource_access.${client_id}.roles' \
  -s "config.\"usermodel.clientRole.clientId\"=${CLIENT}"

echo ">> Verify: roles of $HS_USER on $CLIENT"

"$KCADM" get-roles \
  -r "$REALM" \
  --uusername "$HS_USER" \
  --cclientid "$CLIENT" \
  --fields name

echo ">> Done. Realm: $REALM | Client: $CLIENT | User: $HS_USER"

if [[ -n "$KC_PID" && "$STOP_KC_AFTERWARDS" == true ]]
then
  echo "   (Keycloak will be stopped now; data persists in $KC_HOME/data)"
fi
