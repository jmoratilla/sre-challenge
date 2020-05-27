#!/bin/bash -e

IMAGE="jmoratilla/sre-challenge"
VERSION=${1:-`git rev-parse --verify HEAD --short`}

if [ ! -f Dockerfile ]
then
    echo "Dockerfile not found.  Exiting..."
    exit 1
fi

docker build . -t ${IMAGE}:${VERSION}
