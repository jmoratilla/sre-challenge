#!/bin/bash

OPENSSL=`which openssl`

if [ "$OPENSSL" == "" ]
then
  echo "openssl command not found.  Exitting..."
  exit 1
fi

$OPENSSL req -x509 -subj '/CN=localhost' -newkey rsa:4096 -keyout ./ca-key.pem -out ./ca-cert.pem -nodes -days 365
