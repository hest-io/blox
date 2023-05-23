#!/bin/bash

# Defaults
: ${DEFAULT_TERRAFORM_VERSION:="0.12.20"}

# UID/GID (may) map to unknown user/group, $HOME=/ (the default when no home directory is defined)
eval $( fixuid -q )
# UID/GID now match user/group, $HOME has been set to user's home directory

# Starship setup
[ -d "${HOME}/.config" ] || mkdir -p "${HOME}/.config"
[ -f "${HOME}/.config/starship.toml" ] || ln -s /opt/awsh/lib/starship/starship.toml "${HOME}/.config/starship.toml"

# Link the default TF version. Remove existing file/link if exists as a workaround
# to GitLab CICD issue where entrypoint is run for each stage when using container based builds
${HOME}/.tfenv/bin/tfenv use ${DEFAULT_TERRAFORM_VERSION}

# On with the show
exec "$@"
