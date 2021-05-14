#!/usr/bin/env bash

set -euo pipefail

# Download cowsay
cd "${HOME}/Downloads"
COWSAY_VERSION=v3.7.0
curl -O -L "https://github.com/cowsay-org/cowsay/archive/${COWSAY_VERSION}.tar.gz"

# Install cowsay
tar xf "${COWSAY_VERSION}.tar.gz"
mv cowsay-* cowsay
cd cowsay
make install prefix="${HOME}/.local"

# Clean up
rm -r "${HOME}/Downloads/cowsay" "${HOME}/Downloads/${COWSAY_VERSION}.tar.gz"
