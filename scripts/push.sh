#!/bin/bash -e

IMAGE="jmoratilla/sre-challenge"
VERSION=${1:-`git rev-parse --verify HEAD --short`}

docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}

docker push ${IMAGE}:${VERSION}