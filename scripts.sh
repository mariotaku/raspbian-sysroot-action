#!/bin/bash

echo "Saving toolchain.cmake"
sed "s|@SYSROOT@|$SYSROOT|" toolchain.cmake | sudo tee "$SYSROOT/toolchain.cmake"
echo "Saving envsetup.sh"
sed "s|@SYSROOT@|$SYSROOT|" envsetup.sh | sudo tee "$SYSROOT/envsetup.sh"
