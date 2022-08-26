#!/usr/bin/env bash
# Intended to perform all tasks that need to be executed on a first run of the
# tools

function _firstrun {

    echo ""
    echo "BLOX: Welcome!"
    echo ""
    echo "  Documentation   : https://worx.hest.io/blox/"
    echo "  Found an issue? : https://github.com/hest-io/blox/issues"

    mkdir -p ~/.awsh/config.d/
    touch ~/.awsh/config.d/.firstrun

}

# Create a tmp dir if none exists
if [[ ! -d "${AWSH_ROOT}/tmp" ]]; then
    mkdir -p "${AWSH_ROOT}/tmp"
fi

# Create a log dir if none exists
if [[ ! -d "${HOME}/.awsh/log" ]]; then
    mkdir -p "${HOME}/.awsh/log"
fi

# Create an user identities dir if none exists
if [[ ! -d ~/.awsh/identities ]]; then
    mkdir -p ~/.awsh/identities
fi

# First Run helper if no config file is found
if [[ ! -f ~/.awsh/config.d/.firstrun ]]; then
    _firstrun
fi
