#!/bin/bash

if [ -z "$SYSROOT" ] || [ -z "$RELEASE" ]; then
  echo "Following environment variables are required:"
  echo "SYSROOT: Path to Raspbian sysroot"
  echo "RELEASE: Distro version of Raspbian"
  exit 1
fi

apt-get -yq install qemu-user-static

case "$ARCH" in
armhf)
  update-binfmts --enable qemu-arm || exit 1
  DEBIAN_PUBKEY="https://archive.raspbian.org/raspbian.public.key"
  DEBIAN_KEYRING="/tmp/raspbian_keyring.gpg"

  wget "$DEBIAN_PUBKEY" -qO- | gpg --import --no-default-keyring --keyring "$DEBIAN_KEYRING" || exit 1
  KEYRING_OPT="--keyring=$DEBIAN_KEYRING"
  MIRROR="http://raspbian.raspberrypi.org/raspbian/"
  ;;
arm64)
  update-binfmts --enable qemu-aarch64 || exit 1
  MIRROR="http://deb.debian.org/debian/"
  ;;
*)
  echo "Unsupported architecture: $ARCH"
  exit 1
  ;;
esac

mkdir -p "$SYSROOT"

if [ -n "$ARCHIVE" ] && [ -f "$ARCHIVE" ]; then
  cd "$SYSROOT" || exit 1
  tar -xzf "$ARCHIVE"
  exit 0
fi

apt-get -yq install debootstrap || exit 1

debootstrap --arch="$ARCH" $KEYRING_OPT "$RELEASE" "$SYSROOT" "$MIRROR" || exit 1
cd "$SYSROOT" || exit 1

mkdir -p ./etc/apt/sources.list.d/ || exit 1

# Add archive.raspberrypi.org to APT sources
echo "deb http://archive.raspberrypi.org/debian/ $RELEASE main" >./etc/apt/sources.list.d/raspi.list

# Trust archive.raspberrypi.org
RASPI_PUBKEY="https://archive.raspberrypi.org/debian/raspberrypi.gpg.key"
RASPI_KEYRING="./etc/apt/trusted.gpg.d/raspberrypi-archive-keyring.gpg"

wget "$RASPI_PUBKEY" -qO- | gpg --import --no-default-keyring --keyring gnupg-ring:"$RASPI_KEYRING"
chmod 644 "$RASPI_KEYRING"

# Use Google DNS for a consistent name resolution
cat <<DNS >/etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
DNS

if [ -n "$ARCHIVE" ]; then
  tar --exclude='./var/cache/apt' --exclude='./var/lib/apt' -czf "$ARCHIVE" .
fi
