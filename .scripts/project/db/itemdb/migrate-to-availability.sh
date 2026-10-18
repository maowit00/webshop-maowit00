#!/bin/sh

set -e

cd "$(realpath "$(dirname "$0")")"

../exec.sh << 'EOF'

ALTER TABLE item ADD COLUMN availability INTEGER NOT NULL DEFAULT 10;

ALTER TABLE item ALTER COLUMN availability DROP DEFAULT;

EOF
