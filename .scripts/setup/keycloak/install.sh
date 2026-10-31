#!/usr/bin/env bash

# KeyCloak Install and Link Script

set -euo pipefail

cd "$(dirname "$(realpath "$0")")"

# - -- - -- - -- - -- -

KEYCLOAK_INSTALL_LOCATION="."

KEYCLOAK_VERSION="26.7.0"

KEYCLOAK_URL="https://github.com/keycloak/keycloak/releases/download/$KEYCLOAK_VERSION/keycloak-$KEYCLOAK_VERSION.zip"

KEYCLOAK_ZIP="keycloak-$KEYCLOAK_VERSION.zip"

KEYCLOAK_BIN_DIR="keycloak-$KEYCLOAK_VERSION"

EXECUTABLE_LINK="/usr/local/bin/keycloak"

# - -- - -- - -- - -- - -- - -- - -- - -- - -- - --

### Fetch Keycloak ZIP

mkdir -p "$KEYCLOAK_INSTALL_LOCATION"

if [ ! -d "$KEYCLOAK_INSTALL_LOCATION/keycloak" ]
then

	(

	### Install Deps
	sudo apt install unzip wget -y

	cd "$KEYCLOAK_INSTALL_LOCATION"

	[ -f "$KEYCLOAK_ZIP" ] || wget -O "$KEYCLOAK_ZIP" "$KEYCLOAK_URL"

	unzip -q "$KEYCLOAK_ZIP"

	mv "$KEYCLOAK_BIN_DIR" keycloak

	)

fi

# - -- - -- - -- - -- - -- - -- - -- - -- - -- - --

if [ ! -L "$EXECUTABLE_LINK" ]
then

	(
		set -x

		sudo ln -s $(realpath "$KEYCLOAK_INSTALL_LOCATION/keycloak/bin/kc.sh") "$EXECUTABLE_LINK"
	)

fi
