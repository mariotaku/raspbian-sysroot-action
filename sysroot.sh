#!/bin/bash

if [ -z "$PACKAGES" ]; then
  echo "Following environment variables are required:"
  echo "PACKAGES: Packages list needs to be installed"
  exit 1
elif [ -f "$PACKAGES" ]; then
  PACKAGES=$(cat "$PACKAGES")
fi

# Install dependencies
apt-get -yq update

# Install symlinks tool
# shellcheck disable=SC2046
apt-get -yq install --no-install-recommends symlinks $(echo "$PACKAGES" | tr '\n' ' ')

# Convert absolute symlinks to relative symlinks
symlinks -cr /usr/lib
