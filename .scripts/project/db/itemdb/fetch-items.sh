#!/bin/sh

set -e

cd "$(realpath "$(dirname "$0")")"

../exec.sh << 'EOF'

SELECT * FROM item;

EOF
