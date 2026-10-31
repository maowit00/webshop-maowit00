#!/usr/bin/env bash

# Imports a realm export zip (made by export-keycloak.sh) into Keycloak.
# Usage: bash import-keycloak.sh [path/to/export.zip]
# Keycloak must NOT be running (the import needs exclusive access to the database).

set -Eeuo pipefail

cd "$(dirname "$(realpath "$0")")"

# ------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------
EXPORT_NAME="keycloak-webshop-export"
KC_URL="http://localhost:8080"
KC_SH="keycloak/bin/kc.sh"
OVERRIDE=true                    # true = replace realm/users that already exist

on_error() {
  echo "" >&2
  echo "FAILED (exit $1) at line $2: $3" >&2
}

trap 'on_error $? $LINENO "$BASH_COMMAND"' ERR

# ------------------------------------------------------------------
# Find the zip: argument > <EXPORT_NAME>.zip > newest keycloak*export*.zip
# ------------------------------------------------------------------
if [ $# -ge 1 ]
then
  ZIP="$1"
elif [ -f "${EXPORT_NAME}.zip" ]
then
  ZIP="${EXPORT_NAME}.zip"
else
  ZIP="$(ls -t keycloak*export*.zip 2>/dev/null | head -n 1 || true)"
fi

if [ -z "${ZIP:-}" ] || [ ! -f "$ZIP" ]
then
  echo "No export zip found. Pass one as argument or put ${EXPORT_NAME}.zip next to this script."
  exit 1
fi

ZIP="$(realpath "$ZIP")"

# ------------------------------------------------------------------
# Checks
# ------------------------------------------------------------------
if [ ! -x "$KC_SH" ]
then
  echo "Not found/executable: $KC_SH"
  exit 1
fi

# Install unzip only if it is MISSING
if ! command -v unzip >/dev/null
then
  (
    set -x
    sudo apt update
    sudo apt install -y unzip
  )
fi

if curl -sf "$KC_URL/realms/master" >/dev/null 2>&1
then
  echo "Keycloak is still running at $KC_URL. Stop it first, then re-run."
  exit 1
fi

# ------------------------------------------------------------------
# Unzip into a temp dir and locate the realm files
# ------------------------------------------------------------------
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT
trap 'exit 130' INT TERM

echo ">> Unzipping $ZIP"
unzip -q "$ZIP" -d "$TMPDIR"

REALM_FILE="$(find "$TMPDIR" -name '*-realm.json' | head -n 1)"
if [ -z "$REALM_FILE" ]
then
  echo "No *-realm.json found in $ZIP - is this a Keycloak export?"
  exit 1
fi

IMPORT_DIR="$(dirname "$REALM_FILE")"

echo ">> Files to import:"

ls -1 "$IMPORT_DIR"

compgen -G "$IMPORT_DIR/*-users-*.json" >/dev/null \
  || echo "WARNING: zip contains no users file - only the realm will be imported"

# ------------------------------------------------------------------
# Import
# ------------------------------------------------------------------
echo ">> Importing (override=$OVERRIDE)"

"$KC_SH" import --dir "$IMPORT_DIR" --override "$OVERRIDE"

echo ">> Done. Start Keycloak with:  $KC_SH start-dev"
