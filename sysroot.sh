#!/bin/bash

if [ -z "$RELEASE" ] || [ -z "$PACKAGES" ]; then
  echo "Following environment variables are required:"
  echo "RELEASE: Distro version of Raspbian"
  echo "PACKAGES: Packages list needs to be installed"
  exit 1
fi

# Install dependencies
apt-get -yq update

# Install symlinks tool
# shellcheck disable=SC2046
apt-get -yq install symlinks $(echo "$PACKAGES" | tr '\n' ' ')

# Convert absolute symlinks to relative symlinks
symlinks -cr /usr/lib
