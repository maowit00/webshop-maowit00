#!/bin/sh

set -e

if [ -d "$HOME/.oh-my-zsh" ]
then
    echo
    echo "oh-my-zsh already installed ..."
    echo
    echo

    exit 0
fi

set -x

"$HOME/.scripts/install.sh" git zsh wget


sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended

sudo chsh -s "$(command -v zsh)" "$USER"

exec zsh
