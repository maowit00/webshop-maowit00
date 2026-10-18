#!/bin/sh

## Pipe/Read into STDIN

set -e

DB_NAME=itemdb
DB_USERNAME=webshop-maowit00
DB_PASSWORD=not-hs-password

if ! $(sudo runuser -u postgres -- psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='$DB_USERNAME'" | grep -q 1)
then
	sudo runuser -u postgres -- psql -c "CREATE ROLE \"$DB_USERNAME\" WITH LOGIN PASSWORD '$DB_PASSWORD' CREATEDB;"
fi

if ! $(sudo runuser -u postgres -- psql -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'" | grep -q 1)
then
	sudo runuser -u postgres -- psql -c "CREATE DATABASE \"$DB_NAME\" WITH OWNER \"$DB_USERNAME\";"
fi

# - -- - -- - -

set -x

sudo runuser -u postgres -- psql "postgresql://$DB_USERNAME:$DB_PASSWORD@localhost/$DB_NAME" -f -
