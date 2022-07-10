#!/bin/bash

if [ -z "$RELEASE" ] || [ -z "$PACKAGES" ]; then
  echo "Following environment variables are required:"
  echo "RELEASE: Distro version of Raspbian"
  echo "PACKAGES: Packages list needs to be installed"
  exit 1
fi

# Use Google DNS for a consistent name resolution
cat <<DNS >/etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
DNS

# Add archive.raspberrypi.org to APT sources
echo "deb http://raspbian.raspberrypi.org/raspbian/ ${RELEASE} main" >/etc/apt/sources.list
echo "deb http://archive.raspberrypi.org/debian/ ${RELEASE} main" >/etc/apt/sources.list.d/raspi.list

# Trust source from above repositories
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 82B129927FA3303E

# Install dependencies
apt-get -yq update

# Install symlinks tool
# shellcheck disable=SC2046
apt-get -yq install symlinks $(echo "$PACKAGES" | tr '\n' ' ')

# Convert absolute symlinks to relative symlinks
symlinks -cr /usr/lib
