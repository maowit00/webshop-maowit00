#!/bin/bash

set -e

"$HOME/.scripts/install.sh" brew

brew install neovim

(
	set +e

	mv "$HOME/.config/nvim{,.bak}"

	mv "$HOME/.local/share/nvim{,.bak}"
	mv "$HOME/.local/state/nvim{,.bak}"
	mv "$HOME/.cache/nvim{,.bak}"

	) || true

set -x

git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"

rm -rf "$HOME/.config/nvim/.git"
