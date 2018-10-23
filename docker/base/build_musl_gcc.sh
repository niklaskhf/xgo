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


cd musl-cross-make 

# Install the i386-linux-musl to /opt/cross
cp ../config_i386.mak ./config.mak
make install
rm ./config.mak

# Install the x86_64-linux-musl to /opt/cross
cp ../config_x86_64.mak ./config.mak
make install 
rm ./config.mak

# Install the arm-linux-musleabihf
cp ../config_armhf.mak ./config.mak
make install
rm ./config.mak

# Install mips-linux-musl
cp ../config_mips.mak ./config.mak
make install 
rm ./config.mak 


# Add binaries to path
export PATH="$PATH:/opt/cross/bin"

# List cross-compilers
ls /opt/cross
ls /opt/cross/bin