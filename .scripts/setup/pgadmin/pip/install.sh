#!/bin/sh

set -e

. "$HOME/.scripts/launch/.env"

if [ -d "$PGADMIN_TARGET_TARGET" ]
then
    echo
    echo "pgadmin from python pip already installed at $PGADMIN_TARGET_TARGET"
    echo
    echo

    exit 1
fi

"$HOME/.scripts/install.sh" python3 python3-venv python3-dev libpq-dev

mkdir -p "$PGADMIN_TARGET_TARGET"

mkdir -p "$PGADMIN_TARGET_TARGET/.config/pgadmin"

cat > "$PGADMIN_TARGET_TARGET/.config/pgadmin/config_local.py" << 'EOF'
import os

DATA_DIR = os.path.expanduser('~/.pgadmin')
LOG_FILE = os.path.join(DATA_DIR, 'pgadmin4.log')
SQLITE_PATH = os.path.join(DATA_DIR, 'pgadmin4.db')
SESSION_DB_PATH = os.path.join(DATA_DIR, 'sessions')
STORAGE_DIR = os.path.join(DATA_DIR, 'storage')
AZURE_CREDENTIAL_CACHE_DIR = os.path.join(DATA_DIR, 'azurecredentialcache')
KERBEROS_CCACHE_DIR = os.path.join(DATA_DIR, 'krbccache')
EOF

python3 -m venv "$PGADMIN_TARGET_TARGET"

(
    . "$PGADMIN_TARGET_TARGET/bin/activate"

    pip install pgadmin4
)
