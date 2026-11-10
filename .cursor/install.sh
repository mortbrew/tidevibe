#!/usr/bin/env bash
set -euo pipefail

if command -v sudo >/dev/null 2>&1 && [ "$(id -u)" -ne 0 ]; then
  SUDO="sudo"
else
  SUDO=""
fi

$SUDO apt-get update
$SUDO apt-get install -y --no-install-recommends \
  build-essential ca-certificates curl pkg-config \
  protobuf-compiler libprotobuf-dev

if ! command -v cargo >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs \
    | sh -s -- -y --default-toolchain 1.92.0 --profile minimal
fi

if [ -x "$HOME/.cargo/bin/cargo" ]; then
  $SUDO ln -sfn "$HOME/.cargo/bin/cargo" /usr/local/bin/cargo
  $SUDO ln -sfn "$HOME/.cargo/bin/rustc" /usr/local/bin/rustc
  $SUDO ln -sfn "$HOME/.cargo/bin/rustup" /usr/local/bin/rustup
fi

rustup show
cargo build
