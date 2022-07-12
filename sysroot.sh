#!/bin/bash

# Install dependencies
apt-get -yq update

# Install symlinks tool
# shellcheck disable=SC2046
apt-get -yq install --no-install-recommends symlinks $(echo "$PACKAGES" | tr '\n' ' ') || exit 1

# Convert absolute symlinks to relative symlinks
symlinks -cr /usr/lib
