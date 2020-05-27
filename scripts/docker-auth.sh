#!/bin/bash -e

if [ "$#" != "2" ]
then
    echo "Syntax: $0 <container_id> <root password>"
    exit 1
fi

container=$1
password=$2

docker exec ${container} "/opt/etcd/etcdctl member add root:${password} \
  && /opt/etcd/etcdctl auth enable"
