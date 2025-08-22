#!/usr/bin/env bash
set -euo pipefail

# Interactive, safe bootstrap for a new/wiped machine.
# - Detect OS, install prerequisites
# - Ensure pipx+ansible-core
# - Clone dotfiles (if missing)
# - Run the selected Ansible profile (bare/full)

log() { printf '%s\n' "$*"; }
err() { printf '%s\n' "$*" >&2; }

DOTFILES_DIR_DEFAULT="$HOME/.dotfiles"
DOTFILES_REPO_DEFAULT="https://github.com/adammomen/.dotfiles.git"

# Test helpers: set DRY_RUN=1 to skip running ansible
DRY_RUN="${DRY_RUN:-0}"

profile=""
use_vault="${USE_VAULT:-0}"

# parse args
if [[ "${1:-}" == "--profile" && -n "${2:-}" ]]; then
  profile="$2"; shift 2
fi
if [[ "${1:-}" == "--with-vault" ]]; then
  use_vault="1"; shift 1
fi
if [[ "${NO_VAULT:-}" == "1" ]]; then
  use_vault="0"
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "${script_dir}/.." && pwd)"
[[ -d "${DOTFILES_DIR}/.git" ]] || DOTFILES_DIR="${DOTFILES_DIR_DEFAULT}"

select_profile() {
  if [[ -n "${profile}" && ( "${profile}" == "bare" || "${profile}" == "full" ) ]]; then
    return
  fi
  log "[install] Select a profile:"
  log "  1) bare  - minimal: stow, zsh, nvim, tmux"
  log "  2) full  - full toolset (brew/apt groups)"
  read -r -p "Enter choice [1-2] (default 1): " choice || true
  case "${choice}" in
    2) profile="full" ;;
    *) profile="bare" ;;
  esac
}

detect_os() {
  uname_s=$(uname -s || true)
  case "${uname_s}" in
    Darwin) OS="macOS" ;;
    Linux)  OS="Linux" ;;
    *) err "[install] Unsupported OS: ${uname_s}"; exit 1 ;;
  esac
}

ensure_brew_on_path() {
  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    eval "$(${HOMEBREW_PREFIX:-/opt/homebrew}/bin/brew shellenv)"
  elif [[ -x "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

install_prereqs_macos() {
  log "[install] macOS prerequisites"
  if ! xcode-select -p >/dev/null 2>&1; then
    log "[install] Installing Xcode Command Line Tools (may prompt a GUI)."
    xcode-select --install || true
    log "[install] If CLT prompts appear, complete them and re-run this script if needed."
  fi
  if ! command -v brew >/dev/null 2>&1; then
    log "[install] Installing Homebrew (non-interactive)."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  ensure_brew_on_path
  brew update
  brew install git stow python pipx || true
  # Ensure pipx path
  pipx ensurepath || true
}

install_prereqs_ubuntu() {
  log "[install] Ubuntu/Debian prerequisites"
  SUDO=""
  if command -v sudo >/dev/null 2>&1; then SUDO="sudo"; fi
  ${SUDO} apt-get update -y
  ${SUDO} apt-get install -y git stow python3 python3-venv python3-pip pipx || true
  # Some distros lack pipx package
  if ! command -v pipx >/dev/null 2>&1; then
    python3 -m pip install --user pipx
  fi
  export PATH="$HOME/.local/bin:$PATH"
  pipx ensurepath || true
}

ensure_ansible() {
  export PATH="$HOME/.local/bin:$PATH"
  if ! command -v pipx >/dev/null 2>&1; then
    if command -v python3 >/dev/null 2>&1; then
      python3 -m pip install --user pipx
      pipx ensurepath || true
    else
      err "[install] python3 is required to install pipx/ansible"
      exit 1
    fi
  fi
  if ! command -v ansible-playbook >/dev/null 2>&1; then
    pipx install --include-deps ansible-core
  fi
}

clone_dotfiles_if_missing() {
  if [[ -d "${DOTFILES_DIR}/.git" ]]; then
    log "[install] Using existing dotfiles at ${DOTFILES_DIR}"
    return
  fi
  log "[install] Cloning dotfiles into ${DOTFILES_DIR}"
  git clone "${DOTFILES_REPO_DEFAULT}" "${DOTFILES_DIR}"
}

run_ansible() {
  local playbook="${DOTFILES_DIR}/ansible/playbooks/${profile}.yml"
  if [[ ! -f "${playbook}" ]]; then
    err "[install] Playbook not found: ${playbook}"
    exit 1
  fi
  if [[ "${DRY_RUN}" == "1" ]]; then
    log "[install] DRY_RUN=1 set. Skipping ansible-playbook ${playbook}"
    return 0
  fi
  local runner_home="${ANSIBLE_HOME:-$HOME}"
  log "[install] Running Ansible playbook: ${playbook}"
  log "[install] Using HOME for Ansible: ${runner_home}"
  if [[ "${use_vault}" == "1" ]]; then
    ( cd "${DOTFILES_DIR}" && HOME="${runner_home}" ansible-playbook "${playbook}" --vault-id default@prompt )
  else
    ( cd "${DOTFILES_DIR}" && HOME="${runner_home}" ansible-playbook "${playbook}" )
  fi
}

main() {
  select_profile
  detect_os
  case "${OS}" in
    macOS) install_prereqs_macos ;;
    Linux) install_prereqs_ubuntu ;;
  esac
  ensure_ansible
  clone_dotfiles_if_missing
  run_ansible
  log "[install] Done. You may need to log out/in for shell changes to apply."
}

main "$@"


