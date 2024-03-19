# raspbian-sysroot-action

GitHub Action to set up Raspbian Sysroot for cross compiling

## Key Advantages

GitHub doesn't provide ARM-based Linux runners yet. To build binaries for Raspberry Pi,
many people use Docker, QEMU-based chroot, or simply a real Pi as self-hosted runner.

While each approach has its own advantages, running whole compiling process on Pi itself,
or on ARM emulators is slow. By using this custom action, you're able to compile binaries
with compilers on your host runner, which will be much faster.

## Features

* Cache Support: Sysroot will be cached unless packages list are changed
* Easy Configuration: Provide Raspbian version and packages, and you're good to go

## Usages

```yaml
jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Prepare Sysroot
        id: pi-sysroot
        uses: mariotaku/raspbian-sysroot-action@main
        with:
          # Can be space separated, multiline list or a file
          packages: ./packages.list
          # Raspbian version, like "bullseye" or "bookworm"
          version: bullseye
          # Architecture, "armhf" or "arm64"
          arch: armhf
```