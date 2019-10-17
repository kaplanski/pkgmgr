#!/usr/bin/env bash
echo
./build-index-db.sh stable
echo
./build-index-db.sh lnx-bin
echo
./build-index-db.sh rpi-bin
echo
./build-index-db.sh freebsd11-bin
echo
