#!/usr/bin/env sh
# Install starship into ~/.local/bin unless it is already available.
set -eu
command -v starship >/dev/null 2>&1 && exit 0
mkdir -p "${HOME}/.local/bin"
curl -fsSL https://starship.rs/install.sh | sh -s -- --yes --bin-dir "${HOME}/.local/bin"
