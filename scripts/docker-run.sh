#!/bin/bash -e

if [ "$#" != "2" ]
then
  echo "Syntax error: $0 discovery_uri cluster_id"
  exit 1
fi

discovery=$1
id=$2

docker run -d --rm \
  --env-file=$PWD/etcd${id}/env \
  -e ETCD_NAME=etcd${id} -e ETCD_DISCOVERY=${discovery} \
  -p 2379${id}:2379 -p 2380${id}:2380 \
  -v $PWD/etcd${id}/config:/config -v $PWD/etcd${id}/data:/data \
  jmoratilla/sre-challenge:0.3.0

