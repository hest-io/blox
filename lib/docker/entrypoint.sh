#!/bin/bash

# Defaults
: ${DEFAULT_TERRAFORM_VERSION:="0.11.3"}

# Link the default TF version
ln -s "/usr/local/bin/terraform-${DEFAULT_TERRAFORM_VERSION}" "${HOME}/bin/terraform"

# UID/GID (may) map to unknown user/group, $HOME=/ (the default when no home directory is defined)
eval $( fixuid -q )
# UID/GID now match user/group, $HOME has been set to user's home directory

# On with the show
$@
