#!/bin/bash

export      PATH="${HOME}/.cargo/bin:${PATH}" 
export      ANDROID_HOME=${HOME}/Android/Sdk 
export      NDK_HOME=/e/eda5101/src/android-studio-ide-193.6514223-linux/ANDROID_SDK_ROOT/Android/Sdk/ndk/21.2.6472646 
export      ANDROID_NDK=/e/eda5101/src/android-studio-ide-193.6514223-linux/ANDROID_SDK_ROOT/Android/Sdk/ndk/21.2.6472646 

${NDK_HOME}/build/tools/make_standalone_toolchain.py --api 26 --arch arm64 --install-dir NDK/arm64
${NDK_HOME}/build/tools/make_standalone_toolchain.py --api 26 --arch arm --install-dir NDK/arm
${NDK_HOME}/build/tools/make_standalone_toolchain.py --api 26 --arch x86 --install-dir NDK/x86

