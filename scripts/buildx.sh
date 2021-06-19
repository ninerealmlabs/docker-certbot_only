#!/bin/bash

# To tag images, run with `sudo bash ./scripts/buildx.sh --tag {REGISTRY}/{IMAGE}:{TAG}`

# REGISTRY="ninerealmlabs"
# TAG=${1:-"test"}

# define build context
# assumes run from project folder root
DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# buildx
docker buildx create --name "${BUILDX_NAME:-certbot_only}" || echo
docker buildx use "${BUILDX_NAME:-certbot_only}"

docker buildx build \
	--no-cache \
	--platform linux/amd64,linux/arm64 \
	--file Dockerfile \
	--build-arg BUILD_DATE=$(date +'%Y-%m-%d')
	--push \
	$@ \
	.

# cleanup
docker buildx rm "${BUILDX_NAME:-certbot_only}"
cd ${DIR} \
	&& rm -rf ./tmp