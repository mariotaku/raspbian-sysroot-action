#!/bin/bash

case $ARCH in
  armhf)
    TARGET_TRIPLE="arm-linux-gnueabihf"
    ;;
  arm64)
    TARGET_TRIPLE="aarch64-linux-gnu"
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

echo "Saving toolchain.cmake"
sed -e "s|@SYSROOT@|$SYSROOT|" -e "s|@TARGET_TRIPLE@|$TARGET_TRIPLE|" toolchain.cmake | sudo tee "$SYSROOT/toolchain.cmake"
echo "Saving envsetup.sh"
sed -e "s|@SYSROOT@|$SYSROOT|" -e "s|@TARGET_TRIPLE@|$TARGET_TRIPLE|" envsetup.sh | sudo tee "$SYSROOT/envsetup.sh"
