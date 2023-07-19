#!/usr/bin/env bash
# Do not edit by hand; please use build scripts/templates to make changes
set -eo pipefail

docker context create cimg
docker buildx create --use cimg
docker buildx build --platform=linux/amd64,linux/arm64 --file 20.0/Dockerfile -t cimg/openjdk:20.0.1 -t cimg/openjdk:20.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 20.0/node/Dockerfile -t cimg/openjdk:20.0.1-node -t cimg/openjdk:20.0-node --push .
docker buildx build --platform=linux/amd64 --file 20.0/browsers/Dockerfile -t cimg/openjdk:20.0.1-browsers -t cimg/openjdk:20.0-browsers --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 17.0/Dockerfile -t cimg/openjdk:17.0.7 -t cimg/openjdk:17.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 17.0/node/Dockerfile -t cimg/openjdk:17.0.7-node -t cimg/openjdk:17.0-node --push .
docker buildx build --platform=linux/amd64 --file 17.0/browsers/Dockerfile -t cimg/openjdk:17.0.7-browsers -t cimg/openjdk:17.0-browsers --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 11.0/Dockerfile -t cimg/openjdk:11.0.19 -t cimg/openjdk:11.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 11.0/node/Dockerfile -t cimg/openjdk:11.0.19-node -t cimg/openjdk:11.0-node --push .
docker buildx build --platform=linux/amd64 --file 11.0/browsers/Dockerfile -t cimg/openjdk:11.0.19-browsers -t cimg/openjdk:11.0-browsers --push .
