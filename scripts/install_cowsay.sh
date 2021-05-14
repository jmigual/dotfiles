#!/usr/bin/env bash

set -euo pipefail

# Download cowsay
COWSAY_VERSION=v3.7.0
wget https://github.com/cowsay-org/cowsay/archive/${COWSAY_VERSION}.tar.gz
tar xf ${COWSAY_VERSION}.tar.gz
mv cowsay-* cowsay
cd cowsay
make install prefix=$HOME/.local
cd $HOME
rm -r $HOME/Downloads/cowsay $HOME/Downloads/${COWSAY_VERSION}.tar.gz
