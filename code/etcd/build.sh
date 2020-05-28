#!/bin/bash -e

if [ "$#" != "1" ]
then
    echo "Syntax error: $0 <variables.json>"
    exit 1
fi

vars=$1

packer build --var-file=${vars} packer.json
