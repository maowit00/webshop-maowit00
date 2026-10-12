#!/bin/sh

if command -v brew
then
    echo
    echo "brew already installed ..."
    echo
    echo

    exit 0
fi

# - -- - -- - -- - -- - -- - -- - --

## Dependencies

sudo apt update

sudo apt install -y \
    build-essential procps curl file git

# - -- - -- - -- - -- - -- - -- - --

set -e

(
    set -x

    NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    )

# - -- - -- - -- - -- - -- - -- - --

## Config Shell env

cat << 'EOF' | tee -a $HOME/.zshrc $HOME/.bashrc

# - -- - -- - -- - -- - -- - --

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

EOF
