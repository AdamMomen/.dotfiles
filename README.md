## Dotfiles Recovery and Bootstrap

This repository enables fast, secure recovery of your development environment using Ansible, Ansible Vault, and GNU Stow.

### Scenarios

- **Internet cafe (minimal, no admin):**
  - Entry point: `curl -fsSL https://adammomen.com/cafe | sh`
  - Goal: Get your VPS shell (and tmux/nvim on the VPS) within minutes. Local machine remains mostly untouched.
- **New or wiped machine (full install):**
  - Entry point: `curl -fsSL https://adammomen.com/install | bash -s -- --profile bare` (or `--profile full`)
  - Goal: Rebuild macOS or Ubuntu with packages, dotfiles via Stow, and optional window manager.

### Components

- **Bootstrap scripts**
  - `bootstrap/cafe.sh`: Minimal, user-space bootstrap for unprivileged machines. Gets Ansible, fetches repo, decrypts only required secrets, and connects to VPS.
  - `bootstrap/install.sh`: Prereqs + full setup on macOS/Ubuntu. Installs packages and applies roles/playbooks.
- **Ansible**
  - Playbooks for `bare` and `full` profiles, and OS-specific tasks.
  - Roles: `stow`, `zsh`, `nvim`, `tmux`, `brew`, `apt`, `yabai`, `skhd`.
- **Secrets**
  - Managed with Ansible Vault. Store only must-have items (e.g., `vps_ssh_private_key`).
  - Avoid putting complete password manager exports in the repo.

### Quick start

- Internet cafe:
  1) Run: `curl -fsSL https://adammomen.com/cafe | sh`
  2) Enter Vault password when prompted. Script fetches repo and prepares SSH to `matrix.eveva.ai`.

- New machine:
  1) Run: `curl -fsSL https://adammomen.com/install | bash -s -- --profile bare`
  2) Follow prompts for Vault and optional features (e.g., yabai on macOS).

### Structure

- `bootstrap/`: Entry-point scripts served over HTTPS.
- `ansible/playbooks/`: `bare.yml`, `full.yml`, `mac.yml`, `ubuntu.yml`.
- `ansible/roles/`: Implementation for each logical area.
- `ansible/group_vars/`: Shared and OS-specific variables, categories, and package groups.
- `zsh/`, `nvim/`, `tmux/`, `bin/`: Stow packages for dotfiles.

### Security

- Serve scripts only over HTTPS. Consider signature or SHA256 verification of fetched scripts.
- Use `ansible-vault` with a strong but memorable password.
- Decrypt only what is required for the scenario (e.g., only VPS key for cafe).

### Next steps

This repo currently contains scaffolding. Implement roles incrementally and populate package lists:

- macOS: generate a Brewfile with `brew bundle dump --describe --force --file ansible/Brewfile`.
- Ubuntu: define `apt` package groups in `ansible/group_vars/ubuntu.yml`.
- Add dotfiles under `zsh/`, `nvim/.config/nvim/`, `tmux/` and use Stow.


Brews Installs
- Karabiner-element & Karabiner-EventPreviewer
- Docker 
- Mongo
- Postiqo
- Raycast


