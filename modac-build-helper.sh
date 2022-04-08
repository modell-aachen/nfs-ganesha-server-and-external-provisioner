#!/bin/bash

set -e

buildTag="20220408"

# Build and push linux/amd64
GOOS=linux GOARCH=amd64 go build -o deploy/docker/nfs-provisioner ./cmd/nfs-provisioner

pushd deploy/docker
docker buildx build \
    --push \
    --tag harbor.modac.cloud/public/nfs-ganesha-provisioner:$buildTag-amd64 \
    --platform linux/amd64 .
rm nfs-provisioner
popd


# Build and push darwin/arm64
GOOS=darwin GOARCH=arm64 go build -o deploy/docker/nfs-provisioner ./cmd/nfs-provisioner

pushd deploy/docker
docker buildx build \
    --push \
    --tag harbor.modac.cloud/public/nfs-ganesha-provisioner:$buildTag-arm64 \
    --platform linux/arm64 .
rm nfs-provisioner
popd


docker manifest create \
    harbor.modac.cloud/public/nfs-ganesha-provisioner:$buildTag \
    --amend harbor.modac.cloud/public/nfs-ganesha-provisioner:$buildTag-amd64 \
    --amend harbor.modac.cloud/public/nfs-ganesha-provisioner:$buildTag-arm64

docker manifest push harbor.modac.cloud/public/nfs-ganesha-provisioner:$buildTag