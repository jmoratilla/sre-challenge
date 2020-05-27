#!/bin/bash -e

if [ "$#" != "1" ]
then
    echo "Syntax error: $0 <servername>"
    exit 1
fi

name=$1

# generate server key
openssl genrsa -out server-${name}-key.pem 4096

# generate CSR
openssl req -new -key server-${name}-key.pem -out server-${name}-csr.pem -subj "/CN=${name}"

# sign
openssl x509 -req -days 365 -in server-${name}-csr.pem -signkey ca-key.pem -out server-${name}-cert.pem

