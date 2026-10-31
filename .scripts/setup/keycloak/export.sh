#!/usr/bin/env bash

# Exports the Keycloak realm into keycloak-webshop-export.zip next to this script.
# Keycloak must NOT be running (the export needs exclusive access to the database).

set -euo pipefail

cd "$(dirname "$(realpath "$0")")"

# ------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------
HS_USER="maowit00"

EXPORT_NAME="keycloak-webshop-export"

KC_URL="http://localhost:8080"
KC_SH="keycloak/bin/kc.sh"

# ------------------------------------------------------------------
# Derived values (resolved BEFORE changing directory)
# ------------------------------------------------------------------
REALM="${HS_USER}-organisation"
TARGET="$(pwd)/${EXPORT_NAME}.zip"

if [ ! -x "$KC_SH" ]
then
  echo "Not found/executable: $KC_SH"
  exit 1
fi

# Install zip only if it is MISSING
if ! command -v zip >/dev/null
then
  (
    set -x
    sudo apt update
    sudo apt install -y zip
  )
fi

if curl -sf "$KC_URL/realms/master" >/dev/null 2>&1
then
  echo "Keycloak is still running at $KC_URL. Stop it first, then re-run."
  exit 1
fi

# ------------------------------------------------------------------
# Export into a temp dir, then zip
# ------------------------------------------------------------------
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT
trap 'exit 130' INT TERM

echo ">> Exporting realm: $REALM"

"$KC_SH" export --dir "$TMPDIR/$EXPORT_NAME" \
  --realm "$REALM" \
  --users different_files

# Fail only if the export directory is really EMPTY
if [ -z "$(ls -A "$TMPDIR/$EXPORT_NAME" 2>/dev/null)" ]
then
  echo "Export is empty"
  exit 1
fi

echo ">> Exported files:"

ls -lA "$TMPDIR/$EXPORT_NAME"

compgen -G "$TMPDIR/$EXPORT_NAME/*-users-*.json" >/dev/null \
  || echo "WARNING: no users file exported - is the user in this realm?"

echo ">> Creating $TARGET"

rm -f "$TARGET"   # zip would otherwise update an old archive
(
  cd "$TMPDIR"
  zip -qr "$TARGET" "$EXPORT_NAME"
)

echo ">> Done:"

unzip -l "$TARGET" 2>/dev/null || ls -l "$TARGET"
