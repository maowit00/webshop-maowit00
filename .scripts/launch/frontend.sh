#!/bin/sh

set -xe

cd "$(dirname "$0")/../.."

cd webshopfrontend

npm install

npm run dev
