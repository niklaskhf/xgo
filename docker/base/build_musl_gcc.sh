#!/bin/bash
#
# Contains the a dependency builder to iterate over all installed dependencies
# and cross compile them to the requested target platform.
#
# Usage: build_deps.sh <dependency folder> <configure arguments>
#
# Needed environment variables:
#   CC      - C cross compiler to use for the build
#   HOST    - Target platform to build (used to find the needed tool-chains)
#   PREFIX  - File-system path where to install the built binaries


# Clone the repo
git clone https://github.com/richfelker/musl-cross-make.git

# Get the config
mv config.mak ./musl-cross-make/config.mak

cd musl-cross-make 

# Install the toolchain to /usr/share and /opt/cross (TODO: Figure out which one we need)
make install

# List the available musl cross compilers
ls /opt/cross

# Echo PATH for debugging
echo $PATH