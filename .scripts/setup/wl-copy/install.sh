#!/bin/sh

"$HOME/.scripts/install.sh" wl-clipboard

if ! command -v clip
then
    # windows habits
    (
        set -x
        sudo ln -s "$( command -v wl-copy)" /usr/local/bin/clip
        )
fi
