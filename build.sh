#!/bin/bash

# Export commands

export ARCH=arm64
export PLATFORM_VERSION=12
export ANDROID_MAJOR_VERSION=s

make exynos850-a21snsxx_defconfig
make -j6
