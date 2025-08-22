#!/usr/bin/env bash
set -euo pipefail

log() { printf '%s\n' "$*"; }
err() { printf '%s\n' "$*" >&2; }

usage() {
  echo "Usage: curl -fsSL https://adammomen.com/cafe | sh" >&2
}

# Test helpers: set DRY_RUN=1 to skip ansible + ssh steps
DRY_RUN="${DRY_RUN:-0}"

log "[cafe] Minimal bootstrap starting..."

uname_s=$(uname -s || true)
case "${uname_s}" in
  Linux|Darwin) : ;;
  MINGW*|MSYS*|CYGWIN*)
    err "[cafe] Detected Windows shell. Use PowerShell:"
    err "  powershell -NoProfile -ExecutionPolicy Bypass -c \"iwr -useb https://adammomen.com/cafe.ps1 | iex\""
    exit 1
    ;;
  *) err "[cafe] Unsupported OS: ${uname_s}"; exit 1 ;;
esac

ensure_python() {
  if command -v python3 >/dev/null 2>&1; then return; fi
  err "[cafe] python3 not found. On this kiosk, installing system packages is typically blocked."
  err "[cafe] Options: 1) Use a machine with python3. 2) Connect to your VPS from another host."
  exit 1
}

ensure_ansible() {
  export PATH="$HOME/.local/bin:$PATH"
  if ! command -v pipx >/dev/null 2>&1; then
    if command -v python3 >/dev/null 2>&1; then
      python3 -m pip install --user pipx >/dev/null 2>&1 || true
      command -v pipx >/dev/null 2>&1 || python3 -m pip install --user --upgrade pip >/dev/null 2>&1
    fi
  fi
  if command -v pipx >/dev/null 2>&1; then
    command -v ansible-playbook >/dev/null 2>&1 || pipx install --include-deps ansible-core
  else
    python3 -m pip install --user ansible-core
  fi
}

DOTFILES_DIR="${HOME}/.dotfiles"
REPO_URL="https://github.com/adammomen/.dotfiles.git"

fetch_dotfiles() {
  if [[ -d "${DOTFILES_DIR}/.git" || -d "${DOTFILES_DIR}" ]]; then
    log "[cafe] Using existing ${DOTFILES_DIR}"
    return
  fi
  mkdir -p "${DOTFILES_DIR}"
  if command -v git >/dev/null 2>&1; then
    log "[cafe] Cloning dotfiles"
    git clone --depth 1 "${REPO_URL}" "${DOTFILES_DIR}"
  else
    log "[cafe] Downloading dotfiles zip (no git)"
    tmpzip="$(mktemp -t dotfiles.XXXXXX.zip)"
    curl -fsSL "https://api.github.com/repos/adammomen/.dotfiles/zipball" -o "${tmpzip}"
    tmpdir="$(mktemp -d)"
    unzip -q "${tmpzip}" -d "${tmpdir}"
    topdir=$(find "${tmpdir}" -mindepth 1 -maxdepth 1 -type d | head -n1)
    shopt -s dotglob
    mv "${topdir}"/* "${DOTFILES_DIR}" || true
    shopt -u dotglob
  fi
}

write_ssh_key_with_ansible() {
  if [[ "${DRY_RUN}" == "1" ]]; then
    log "[cafe] DRY_RUN=1 set. Skipping vault decryption and key write."
    return 0
  fi
  local play_tmp
  play_tmp="$(mktemp -t cafe-play.XXXXXX.yml)"
  cat >"${play_tmp}" <<'YAML'
- hosts: localhost
  connection: local
  gather_facts: false
  vars_files:
    - ansible/vault.yml
  tasks:
    - name: Ensure .ssh exists
      file:
        path: "{{ lookup('env','HOME') }}/.ssh"
        state: directory
        mode: '0700'
    - name: Write SSH private key from vault
      copy:
        dest: "{{ lookup('env','HOME') }}/.ssh/id_ed25519"
        content: "{{ vps_ssh_private_key }}"
        mode: '0600'
YAML
  ( cd "${DOTFILES_DIR}" && ansible-playbook "${play_tmp}" --vault-id default@prompt )
}

connect_vps() {
  local host="matrix.eveva.ai"
  local user="root"
  if command -v ssh >/dev/null 2>&1; then
    if [[ "${DRY_RUN}" == "1" ]]; then
      log "[cafe] DRY_RUN=1 set. Would run: ssh -t ${user}@${host} 'tmux new -A -s work'"
    else
      log "[cafe] Connecting to ${user}@${host} (tmux attach/create)"
      ssh -t "${user}@${host}" 'tmux new -A -s work'
    fi
  else
    err "[cafe] ssh client not available. Download a portable SSH client or use another host."
  fi
}

ensure_python
ensure_ansible
fetch_dotfiles
write_ssh_key_with_ansible
connect_vps

exit 0


