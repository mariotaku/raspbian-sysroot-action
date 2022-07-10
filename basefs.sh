#!/bin/bash

if [ -z "$SYSROOT" ] || [ -z "$RELEASE" ] || [ -z "$ARCHIVE" ]; then
  echo "Following environment variables are required:"
  echo "SYSROOT: Path to Raspbian sysroot"
  echo "RELEASE: Distro version of Raspbian"
  echo "ARCHIVE: Path to .tar.gz archive of cached basefs"
  exit 1
fi

apt-get -yq install debootstrap qemu-user-static

update-binfmts --enable qemu-arm

mkdir -p "$SYSROOT"

if [ -f "$ARCHIVE" ]; then
  cd "$SYSROOT" || exit 1
  tar -xzf "$ARCHIVE"
else
  debootstrap --arch=armhf --no-check-gpg "$RELEASE" "$SYSROOT" http://raspbian.raspberrypi.org/raspbian/
  cd "$SYSROOT" || exit 1
  tar -czf "$ARCHIVE" .
fi
