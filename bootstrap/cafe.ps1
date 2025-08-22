# Windows PowerShell minimal bootstrap for internet cafe scenario
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -c "iwr -useb https://cafew.adammomen.com| iex"

$ErrorActionPreference = 'Stop'

function Write-Log($msg) { Write-Host $msg }
function Write-Err($msg) { Write-Error $msg }

Write-Log "[cafe] Windows bootstrap starting..."
$DRY_RUN = $env:DRY_RUN
if (-not $DRY_RUN) { $DRY_RUN = '0' }

# New minimal flow: fetch only encrypted vault file, decrypt into ssh-agent, then connect
$VaultUrlDefault = "https://raw.githubusercontent.com/AdamMomen/.dotfiles/refs/heads/master/ansible/vault/ssh_pk.txt"
$VaultDownloaded = $false
$VaultFile = ""
$VaultPassFile = $env:VAULT_PASS_FILE

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

function Fetch-Vault {
  $localVault = Join-Path $env:USERPROFILE ".dotfiles/ansible/vault/ssh_pk.txt"
  if (Test-Path $localVault) {
    $script:VaultFile = $localVault
    Write-Log "[cafe] Using local vault at $VaultFile"
    return
  }
  $tmp = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), (New-Guid).ToString() + ".txt")
  Write-Log "[cafe] Downloading encrypted vault"
  Invoke-WebRequest -UseBasicParsing -Uri $VaultUrlDefault -OutFile $tmp
  $script:VaultFile = $tmp
  $script:VaultDownloaded = $true
}

function Decrypt-Into-Agent {
  if ($DRY_RUN -eq '1') { Write-Log "[cafe] DRY_RUN=1 set. Skipping vault/key."; return }
  $vaultId = $(if ($VaultPassFile -and (Test-Path $VaultPassFile)) { "default@file:$VaultPassFile" } else { "default@prompt" })
  # Decrypt the vault file to a string
  $key = ansible-vault view --vault-id $vaultId --% "$VaultFile"
  if (-not $key) { throw "Vault decryption failed" }
  # Ensure ssh-agent service is running
  try { Start-Service ssh-agent -ErrorAction SilentlyContinue } catch {}
  # Try piping to ssh-add -; if it fails, fall back to a temp file with LF newlines
  $piped = $true
  try {
    $proc = Start-Process -FilePath "ssh-add" -ArgumentList "-" -NoNewWindow -PassThru -RedirectStandardInput "Pipe"
    $proc.StandardInput.Write($key)
    $proc.StandardInput.Close()
    $proc.WaitForExit()
    if ($proc.ExitCode -ne 0) { $piped = $false }
  } catch { $piped = $false }
  if (-not $piped) {
    $lfKey = ($key -replace "`r`n","`n").TrimEnd() + "`n"
    $tmp = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), (New-Guid).ToString() + ".pem")
    [System.IO.File]::WriteAllText($tmp, $lfKey, (New-Object System.Text.UTF8Encoding($false)))
    try { icacls $tmp /inheritance:r /grant "$env:USERNAME:(R)" | Out-Null } catch {}
    & ssh-add $tmp | Out-Null
    Remove-Item -Force $tmp
  }
}

function Connect-VPS {
  $host = "matrix.eveva.ai"
  $user = "root"
  if (Get-Command ssh -ErrorAction SilentlyContinue) {
    if ($DRY_RUN -eq '1') {
      Write-Log "[cafe] DRY_RUN=1 set. Would run: ssh -t $user@$host 'tmux new -A -s cafe'"
    } else {
      Write-Log "[cafe] Connecting to $user@$host"
      ssh -t "$user@$host" 'tmux new -A -s cafe'
    }
  } else {
    Write-Err "[cafe] ssh not found. Install OpenSSH client from Windows Optional Features or use another host."
  }
}

try {
  Ensure-Python
  Ensure-Pipx-Ansible
  Fetch-Vault
  Decrypt-Into-Agent
  Connect-VPS

  if ($VaultDownloaded -and (Test-Path $VaultFile)) { Remove-Item -Force $VaultFile }
} catch {
  Write-Err $_
  exit 1
}


