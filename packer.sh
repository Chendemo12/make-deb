#!/bin/bash

# shellcheck disable=SC2002
PACKAGE_CONTROL=$(cat ../project/DEBIAN/control | sed ':jix;N;s/\n/ /g;b jix')
PACKAGE_VERSION=${PACKAGE_CONTROL#*Version: }
PACKAGE_VERSION=${PACKAGE_VERSION%% *}

PACKAGE_NAME=${PACKAGE_CONTROL#*Package: }
PACKAGE_NAME=${PACKAGE_NAME%% *}

PACKAGE_ARCH=${PACKAGE_CONTROL#*Architecture: }
PACKAGE_ARCH=${PACKAGE_ARCH%% *}

echo "**********************************************"
echo "*"
echo "* Package Name: ${PACKAGE_NAME}"
echo "* Version: ${PACKAGE_VERSION}"
echo "* Arch: ${PACKAGE_ARCH}"
echo "*"
echo ""

if [ -e './tmp' ]; then
  rm -rf ./tmp
fi

mkdir ./tmp

if [ -e './bin' ]; then
  rm -rf ./bin
fi

mkdir ./bin

# 检测当前运行目录下是否存在 build.sh 文件
if [ -f "build.sh" ]; then
  echo "Building binary package..."
  # 执行 build.sh 文件
  ./build.sh

  # 检查 build.sh 是否返回错误
  if [ $? -ne 0 ]; then
    echo "执行 build.sh 时发生错误，程序终止"
    exit 1
  else
    echo "Build done."
  fi
fi


rsync -av ./project ./tmp/ --exclude=.idea --exclude=logs
mkdir -p ./tmp/project/opt/apps/bin
mv ./bin/* ./tmp/project/opt/apps/bin

# 确保拥有可执行权限
chmod -R 775 ./tmp/project/DEBIAN/*
chmod -R 775 ./tmp/project/opt/apps/bin*

mkdir -p ./deb

# 强制使用gzip打包deb
# Ubuntu >= 21.04 Supported
dpkg-deb -Zxz --build --root-owner-group tmp/project deb/"${PACKAGE_NAME}"_"${PACKAGE_VERSION}"_"${PACKAGE_ARCH}".deb

rm -rf ./tmp

exit 0
