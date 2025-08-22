#!/usr/bin/env bash
set -euo pipefail

IMAGE="dotfiles-test:ubuntu"

log() { printf '%s\n' "$*"; }

log "[tests] Running install.sh dry-run (as root to allow apt)"
docker run --rm --user root -e DRY_RUN=1 "$IMAGE" bash -lc 'cd /home/dev/.dotfiles && ./bootstrap/install.sh --profile bare'

log "[tests] Running cafe.sh dry-run"
docker run --rm -e DRY_RUN=1 "$IMAGE" bash -lc 'cd ~/.dotfiles && ./bootstrap/cafe.sh'

log "[tests] OK"


