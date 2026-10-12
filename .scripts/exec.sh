#!/bin/sh

# =====================================================
# Script exec.sh
# Looks for files text files with #! and turns on execute permission
# Searches reversibly at a given directory
# Command line arguments as paths to directory in a loop
# .scripts if exists
# current working directory
# =====================================================

if [ -z "$perm" ]
then
    # un exec ;)
    # perm=-x ./exec.sh
    perm=+x
fi

set -e

SCRIPTS_DIRECTORY=.scripts

if [ "$#" -ne 0 ]
then
    if [ "$#" -gt 1 ]
    then
        for directory in "$@"
        do
            "$0" "$directory" < /dev/null
        done
        exit 0
    fi

    SCRIPTS_DIRECTORY="$1"
fi

if [ ! -d "$SCRIPTS_DIRECTORY" ]
then

    echo
    echo "INVALID PATH: $SCRIPTS_DIRECTORY"
    echo
    echo "Using current working directory instead"
    echo

    SCRIPTS_DIRECTORY="$(pwd)"

    printf 'accept (y/n) '
    read -r answer
    case $answer in
        y|Y) ;;
        *) exit 1 ;;
    esac

fi

find "$SCRIPTS_DIRECTORY" -name .git -prune -o -type f -print |
while IFS= read -r script
do
    # grep for #! at file start

    case $perm in
        +x) [ -x "$script" ] && continue ;;
        -x) [ -x "$script" ] || continue ;;
    esac

    # un readable
    [ -r "$script" ] || continue

    # not human readable
    grep -qI . "$script" || continue

    # not a script
    head -n 1 "$script" | grep -q '^#!' || continue

    (
        set -x
        chmod "$perm" "$script"
    )
done

