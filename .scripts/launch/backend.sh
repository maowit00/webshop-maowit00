#!/bin/sh

set -xe

cd "$(dirname "$0")/../.."

cd webshopbackend

mvn spring-boot:run
