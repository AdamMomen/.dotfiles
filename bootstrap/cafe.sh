#!/usr/bin/env bash
set -euo pipefail

log() { printf '%s\n' "$*"; }
err() { printf '%s\n' "$*" >&2; }

usage() {
  echo "Usage: curl -fsSL https://cafe.adammomen.com | sh" >&2
}

# Test helpers: set DRY_RUN=1 to skip ansible + ssh steps
DRY_RUN="${DRY_RUN:-0}"

log "[cafe] Minimal bootstrap starting..."

uname_s=$(uname -s || true)
case "${uname_s}" in
  Linux|Darwin) : ;;
  MINGW*|MSYS*|CYGWIN*)
    err "[cafe] Detected Windows shell. Use PowerShell:"
    err "  powershell -NoProfile -ExecutionPolicy Bypass -c \"iwr -useb https://cafew.adammomen.com | iex\""
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
VAULT_PASS_FILE="${VAULT_PASS_FILE:-}"
VAULT_URL_DEFAULT="https://raw.githubusercontent.com/AdamMomen/.dotfiles/refs/heads/master/ansible/vault/ssh_pk.txt"
VAULT_DOWNLOADED=0

# Fetch (or locate) only the encrypted vault file
fetch_vault() {
  # Prefer local vault if present
  if [[ -f "${DOTFILES_DIR}/ansible/vault/ssh_pk.txt" ]]; then
    VAULT_FILE="${DOTFILES_DIR}/ansible/vault/ssh_pk.txt"
    log "[cafe] Using local vault at ${VAULT_FILE}"
    return
  fi
  # Otherwise download the encrypted vault from GitHub
  VAULT_FILE="$(mktemp -t vault.XXXXXX.txt)"
  log "[cafe] Downloading encrypted vault"
  curl -fsSL "${VAULT_URL_DEFAULT}" -o "${VAULT_FILE}"
  VAULT_DOWNLOADED=1
}

decrypt_key_into_agent() {
  if [[ "${DRY_RUN}" == "1" ]]; then
    log "[cafe] DRY_RUN=1 set. Skipping vault decrypt and ssh-agent."
    return 0
  fi
  # Choose vault mode: passfile if provided; otherwise interactive prompt
  local vault_id
  if [[ -n "${VAULT_PASS_FILE}" && -f "${VAULT_PASS_FILE}" ]]; then
    vault_id="default@file:${VAULT_PASS_FILE}"
  else
    vault_id="default@prompt"
  fi
  # Start a temporary ssh-agent and load key directly from vault output
  eval "$(ssh-agent -s)" >/dev/null
  trap 'ssh-agent -k >/dev/null 2>&1 || true' EXIT
  if ! ansible-vault view --vault-id "${vault_id}" "${VAULT_FILE}" | ssh-add - >/dev/null; then
    err "[cafe] Failed to decrypt and load SSH key"
    exit 1
  fi
}

connect_vps() {
  local host="matrix.eveva.ai"
  local user="root"
  if command -v ssh >/dev/null 2>&1; then
    if [[ "${DRY_RUN}" == "1" ]]; then
      log "[cafe] DRY_RUN=1 set. Would run: ssh -t ${user}@${host} 'tmux new -A -s cafe'"
    else
      log "[cafe] Connecting to ${user}@${host} (tmux attach/create)"
      ssh -o IdentitiesOnly=yes -t "${user}@${host}" 'tmux new -A -s cafe'
    fi
  else
    err "[cafe] ssh client not available. Download a portable SSH client or use another host."
  fi
}

ensure_python
ensure_ansible
fetch_vault
decrypt_key_into_agent
connect_vps

# Cleanup any downloaded vault file
if [[ "${VAULT_DOWNLOADED}" == "1" && -n "${VAULT_FILE:-}" && -f "${VAULT_FILE}" ]]; then
  rm -f "${VAULT_FILE}"
fi

exit 0


