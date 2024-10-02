
SOURCES += main.cpp

PROJECT_BASENAME = stdio

RC_LEGALCOPYRIGHT ?= Copyright (C) 2011-2014 Go Watanabe; Copyright (C) 2019-2020 Julian Uy; See details of license at license.txt, or the source code location.

include external/ncbind/Rules.lib.make

ifeq (xdisabled,x)
ifeq ($(VCPKG_ROOT),)
$(error Variables VCPKG_ROOT not set correctly.)
endif

ifeq ($(shell type cygpath > /dev/null && echo true),true)
FIXPATH = cygpath -ma
else
FIXPATH = realpath
endif

VCPKG=$(shell $(FIXPATH) "$(VCPKG_ROOT)/vcpkg")

ifeq ($(VCPKG_TARGET_TRIPLET),)
VCPKG_TARGET_TRIPLET=x86-windows-static
endif

ifeq ($(BUILD_TYPE),)
BUILD_TYPE=Debug
endif

export VCPKG_TARGET_TRIPLET
export BUILD_TYPE

BUILD_PATH=build/$(VCPKG_TARGET_TRIPLET)/$(BUILD_TYPE)

all: build

.PHONY: prebuild build run clean

# ビルド実行
# 現状 msys 環境だと MSVCコンパイラとリンカの探索に失敗する
# CC=cl と定義して開始すると大丈夫
# CMAKEOPT で引数定義追加
prebuild:
	cmake -G Ninja -DVCPKG_TARGET_TRIPLET=$(VCPKG_TARGET_TRIPLET) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) ${CMAKEOPT} -B $(BUILD_PATH)

build:
	cmake --build $(BUILD_PATH)

clean:
	cmake --build $(BUILD_PATH) --target clean

run:
	./krkr.exe data
endif
