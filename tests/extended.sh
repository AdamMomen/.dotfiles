#!/usr/bin/env bash
set -euo pipefail

IMAGE="dotfiles-test:ubuntu"

log() { printf '%s\n' "$*"; }

# 1) Full flow: install bare + stow, then cafe dry-run
log "[tests] Full flow: install bare + stow, then cafe"
docker run --rm --user root -e DRY_RUN=1 -e NO_VAULT=1 "$IMAGE" bash -s << 'EOS'
set -euo pipefail
cd /home/dev/.dotfiles
su - dev -c "bash -lc './bootstrap/install.sh --profile bare'"
su - dev -c "bash -lc './bootstrap/cafe.sh'"
EOS

# 2) cafe.sh fails fast when python3 is missing
log "[tests] cafe.sh fails with clear message when python3 missing"
docker run --rm --user root "$IMAGE" bash -s << 'EOS'
set -euo pipefail
mv /usr/bin/python3 /usr/bin/python3.bak
set +e
su - dev -c "bash -lc './bootstrap/cafe.sh'" >/tmp/out 2>/tmp/err
code=$?
set -e
grep -q "python3 not found" /tmp/err
test $code -ne 0
EOS

# 3) install.sh default selection chooses bare when input is empty
log "[tests] install.sh defaults to bare profile when no input provided"
docker run --rm --user root -e DRY_RUN=1 "$IMAGE" bash -s << 'EOS'
set -euo pipefail
out=$(su - dev -c "bash -lc 'printf "\n" | ./bootstrap/install.sh'" 2>&1)
echo "$out" | grep -q "/ansible/playbooks/bare.yml"
EOS

log "[tests] Extended tests OK"


