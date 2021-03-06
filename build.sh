#!/bin/bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKDIR=$BASEDIR/.work
mkdir -p $WORKDIR

QEMU_VERSION=v2.8.1

if [ ! -f $WORKDIR/manifest-tool ]; then
  if [ "Darwin" == $(uname) ]; then
    echo "downloading manifest-tool for OSX ..."
    MT_URL="https://github.com/estesp/manifest-tool/releases/download/v0.4.0/manifest-tool-darwin-amd64"
  else
    echo "downloading manifest-tool for Linux ..."
    MT_URL="https://github.com/estesp/manifest-tool/releases/download/v0.4.0/manifest-tool-linux-amd64"
  fi
  wget -q -O $WORKDIR/manifest-tool $MT_URL
  chmod a+x $WORKDIR/manifest-tool
  echo "manifest-tool done"
fi

if [ ! -f $WORKDIR/minio-arm ]; then
  echo "downloading minio ..."
  wget -q -O $WORKDIR/minio-arm https://dl.minio.io/server/minio/release/linux-arm/minio
  wget -q -O $WORKDIR/minio-arm64 https://dl.minio.io/server/minio/release/linux-arm64/minio
  chmod a+x $WORKDIR/minio-*
  echo "minio done"
fi

if [ ! -f $WORKDIR/mc-arm ]; then
  echo "downloading mc ..."
  #wget -q -O $WORKDIR/mc-arm https://dl.minio.io/client/mc/release/linux-arm/archive/mc
  wget -q -O $WORKDIR/mc-arm https://dl.minio.io/client/mc/release/linux-arm/mc

  #wget -q -O $WORKDIR/mc-arm64 https://dl.minio.io/client/mc/release/linux-arm64/archive/mc
  wget -q -O $WORKDIR/mc-arm64 https://dl.minio.io/client/mc/release/linux-arm64/mc

  #wget -q -O $WORKDIR/mc-amd64 https://dl.minio.io/client/mc/release/linux-amd64/archive/mc
  wget -q -O $WORKDIR/mc-amd64 https://dl.minio.io/client/mc/release/linux-amd64/mc
  chmod a+x $WORKDIR/mc-*
  echo "mc done"
fi

echo "building minio server ..."
docker build --no-cache -t thenatureofsoftware/minio-arm:latest -f Dockerfile.minio-arm .
docker build --no-cache -t thenatureofsoftware/minio-arm64:latest -f Dockerfile.minio-arm64 .

echo "building minio client ..."
docker build --no-cache -t thenatureofsoftware/mc-arm:latest -f Dockerfile.mc-arm .
docker build --no-cache -t thenatureofsoftware/mc-arm64:latest -f Dockerfile.mc-arm64 .

echo "building volumizr ..."
docker build --no-cache -t thenatureofsoftware/volumizr-arm:latest -f Dockerfile.volumizr-arm .
docker build --no-cache -t thenatureofsoftware/volumizr-arm64:latest -f Dockerfile.volumizr-arm64 .
docker build --no-cache -t thenatureofsoftware/volumizr-amd64:latest -f Dockerfile.volumizr-amd64 .
