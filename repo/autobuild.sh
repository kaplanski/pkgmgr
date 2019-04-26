#!/usr/bin/env bash
echo
./build-index-db.sh i386
echo
./build-index-db.sh amd64
echo
./build-index-db.sh python2
echo
./build-index-db.sh python3
echo
./build-index-db.sh noarch
echo
