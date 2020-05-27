#!/bin/bash -e

for i in etcd*
do
  rm -rf $i/data/*
done
