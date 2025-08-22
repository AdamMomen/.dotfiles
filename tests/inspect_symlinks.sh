#!/usr/bin/env bash
set -euo pipefail

IMAGE="dotfiles-test:ubuntu"

docker run --rm --user root -e NO_VAULT=1 "$IMAGE" bash -s << 'EOS'
set -euo pipefail
cd /home/dev/.dotfiles
ANSIBLE_HOME=/home/dev ./bootstrap/install.sh --profile bare
su - dev -c "bash -lc 'echo ==== HOME LIST ====; ls -la ~; echo ==== ZSH DOTS ====; ls -la ~/.zshrc || true; echo ==== CONFIG LINKS ====; find -L ~/.config -maxdepth 2 -type l -printf "%p -> %l\n" 2>/dev/null || true'"
EOS


