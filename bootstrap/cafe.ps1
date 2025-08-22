# Windows PowerShell minimal bootstrap for internet cafe scenario
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -c "iwr -useb https://adammomen.com/cafe.ps1 | iex"

$ErrorActionPreference = 'Stop'

function Write-Log($msg) { Write-Host $msg }
function Write-Err($msg) { Write-Error $msg }

Write-Log "[cafe] Windows bootstrap starting..."
$DRY_RUN = $env:DRY_RUN
if (-not $DRY_RUN) { $DRY_RUN = '0' }

# Ensure Python (portable if possible)
function Ensure-Python {
  if (Get-Command python -ErrorAction SilentlyContinue) { return }
  if (Get-Command python3 -ErrorAction SilentlyContinue) { return }
  Write-Err "[cafe] Python not found. On kiosks, installing is blocked."
  Write-Err "[cafe] Use your VPS from another host, or install a portable Python if allowed."
  throw "Python missing"
}

function Ensure-Pipx-Ansible {
  $env:Path = "$env:USERPROFILE\.local\bin;$env:Path"
  $pipx = Get-Command pipx -ErrorAction SilentlyContinue
  if (-not $pipx) {
    python -m pip install --user pipx | Out-Null
  }
  $pipx = Get-Command pipx -ErrorAction SilentlyContinue
  if ($pipx) {
    if (-not (Get-Command ansible-playbook -ErrorAction SilentlyContinue)) {
      pipx install --include-deps ansible-core | Out-Null
    }
  } else {
    python -m pip install --user ansible-core | Out-Null
  }
}

$Dotfiles = Join-Path $env:USERPROFILE ".dotfiles"
$RepoZip = Join-Path $env:TEMP "dotfiles.zip"

function Fetch-Dotfiles {
  if (Test-Path $Dotfiles) { Write-Log "[cafe] Using existing $Dotfiles"; return }
  New-Item -ItemType Directory -Force -Path $Dotfiles | Out-Null
  try {
    # Download zip if git absent
    $hasGit = (Get-Command git -ErrorAction SilentlyContinue) -ne $null
    if ($hasGit) {
      git clone --depth 1 https://github.com/adammomen/.dotfiles.git $Dotfiles | Out-Null
    } else {
      Invoke-WebRequest -UseBasicParsing -Uri https://api.github.com/repos/adammomen/.dotfiles/zipball -OutFile $RepoZip
      $tmp = New-Item -ItemType Directory -Path (Join-Path $env:TEMP (New-Guid))
      Expand-Archive -LiteralPath $RepoZip -DestinationPath $tmp -Force
      $top = Get-ChildItem $tmp | Where-Object { $_.PSIsContainer } | Select-Object -First 1
      Get-ChildItem $top.FullName -Force | ForEach-Object { Move-Item -Force $_.FullName $Dotfiles }
    }
  } catch {
    Write-Err "[cafe] Failed to fetch dotfiles: $_"
    throw
  }
}

function Write-SSH-Key-With-Ansible {
  if ($DRY_RUN -eq '1') { Write-Log "[cafe] DRY_RUN=1 set. Skipping vault/key."; return }
  $play = @"
- hosts: localhost
  connection: local
  gather_facts: false
  vars_files:
    - ansible/vault.yml
  tasks:
    - name: Ensure .ssh exists
      file:
        path: "{{ lookup('env','USERPROFILE') }}\\.ssh"
        state: directory
        mode: '0700'
    - name: Write SSH private key from vault
      copy:
        dest: "{{ lookup('env','USERPROFILE') }}\\.ssh\\id_ed25519"
        content: "{{ vps_ssh_private_key }}"
        mode: '0600'
"@
  $playPath = Join-Path $env:TEMP "cafe-play.yml"
  Set-Content -LiteralPath $playPath -Value $play -NoNewline
  Push-Location $Dotfiles
  try {
    ansible-playbook $playPath --vault-id default@prompt
  } finally {
    Pop-Location
  }
}

function Connect-VPS {
  $host = "matrix.eveva.ai"
  $user = "root"
  if (Get-Command ssh -ErrorAction SilentlyContinue) {
    if ($DRY_RUN -eq '1') {
      Write-Log "[cafe] DRY_RUN=1 set. Would run: ssh -t $user@$host 'tmux new -A -s work'"
    } else {
      Write-Log "[cafe] Connecting to $user@$host"
      ssh -t "$user@$host" 'tmux new -A -s work'
    }
  } else {
    Write-Err "[cafe] ssh not found. Install OpenSSH client from Windows Optional Features or use another host."
  }
}

try {
  Ensure-Python
  Ensure-Pipx-Ansible
  Fetch-Dotfiles
  Write-SSH-Key-With-Ansible
  Connect-VPS
} catch {
  Write-Err $_
  exit 1
}


