# Go cross compiler (xgo): Base cross-compilation layer
# Copyright (c) 2014 Péter Szilágyi. All rights reserved.
#
# Released under the MIT license.

FROM ubuntu:16.04

MAINTAINER Péter Szilágyi <peterke@gmail.com>

# Mark the image as xgo enabled to support xgo-in-xgo
ENV XGO_IN_XGO 1


# Configure the Go environment, since it's not going to change
ENV PATH   /usr/local/go/bin:$PATH
ENV GOPATH /go


# Inject the remote file fetcher and checksum verifier
ADD fetch.sh /fetch.sh
ENV FETCH /fetch.sh
RUN chmod +x $FETCH


# Make sure apt-get is up to date and dependent packages are installed
RUN \
  apt-get update && \
  apt-get install -y automake autogen build-essential ca-certificates                    \
    gcc-5-arm-linux-gnueabi g++-5-arm-linux-gnueabi libc6-dev-armel-cross                \
    gcc-5-arm-linux-gnueabihf g++-5-arm-linux-gnueabihf libc6-dev-armhf-cross            \
    gcc-5-aarch64-linux-gnu g++-5-aarch64-linux-gnu libc6-dev-arm64-cross                \
    gcc-5-mips-linux-gnu g++-5-mips-linux-gnu libc6-dev-mips-cross                       \
    gcc-5-mipsel-linux-gnu g++-5-mipsel-linux-gnu libc6-dev-mipsel-cross                 \
    gcc-5-mips64-linux-gnuabi64 g++-5-mips64-linux-gnuabi64 libc6-dev-mips64-cross       \
    gcc-5-mips64el-linux-gnuabi64 g++-5-mips64el-linux-gnuabi64 libc6-dev-mips64el-cross \
    gcc-5-multilib g++-5-multilib gcc-mingw-w64 g++-mingw-w64 clang llvm-dev             \
    libtool libxml2-dev uuid-dev libssl-dev swig openjdk-8-jdk pkg-config patch          \
    make xz-utils cpio wget zip unzip p7zip git mercurial bzr texinfo help2man           \
    --no-install-recommends

# Fix any stock package issues
RUN ln -s /usr/include/asm-generic /usr/include/asm

# Configure the container for OSX cross compilation
ENV OSX_SDK     MacOSX10.11.sdk
ENV OSX_NDK_X86 /usr/local/osx-ndk-x86

RUN \
  OSX_SDK_PATH=https://s3.dockerproject.org/darwin/v2/$OSX_SDK.tar.xz && \
  $FETCH $OSX_SDK_PATH dd228a335194e3392f1904ce49aff1b1da26ca62       && \
  \
  git clone https://github.com/tpoechtrager/osxcross.git && \
  mv `basename $OSX_SDK_PATH` /osxcross/tarballs/        && \
  \
  sed -i -e 's|-march=native||g' /osxcross/build_clang.sh /osxcross/wrapper/build.sh && \
  UNATTENDED=yes OSX_VERSION_MIN=10.6 /osxcross/build.sh                             && \
  mv /osxcross/target $OSX_NDK_X86                                                   && \
  \
  rm -rf /osxcross

ADD patch.tar.xz $OSX_NDK_X86/SDK/$OSX_SDK/usr/include/c++
ENV PATH $OSX_NDK_X86/bin:$PATH

# Build cross compilers for musl
ADD config_armhf.mak /config_armhf.mak 
ADD config_i386.mak /config_i386.mak
ADD config_x86_64.mak /config_x86_64.mak
ADD config_mips.mak /config_mips.mak
ADD build_musl_gcc.sh /build_musl_gcc.sh
ENV MUSL_CROSS /build_musl_gcc.sh
RUN chmod +x $MUSL_CROSS 
RUN $MUSL_CROSS
ENV PATH /opt/cross/bin:$PATH

# Check if binaries were built
RUN ls /opt/cross

# Inject the old Go package downloader and tool-chain bootstrapper
ADD bootstrap.sh /bootstrap.sh
ENV BOOTSTRAP /bootstrap.sh
RUN chmod +x $BOOTSTRAP

# Inject the new Go root distribution downloader and bootstrapper
ADD bootstrap_pure.sh /bootstrap_pure.sh
ENV BOOTSTRAP_PURE /bootstrap_pure.sh
RUN chmod +x $BOOTSTRAP_PURE

# Inject the Go source distribution downloader and bootstrapper
ADD bootstrap_repo.sh /bootstrap_repo.sh
ENV BOOTSTRAP_REPO /bootstrap_repo.sh
RUN chmod +x $BOOTSTRAP_REPO

# Inject the C dependency cross compiler
ADD build_deps.sh /build_deps.sh
ENV BUILD_DEPS /build_deps.sh
RUN chmod +x $BUILD_DEPS

# Inject the container entry point, the build script
ADD build.sh /build.sh
ENV BUILD /build.sh
RUN chmod +x $BUILD

ENTRYPOINT ["/build.sh"]
