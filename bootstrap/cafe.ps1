# Windows PowerShell minimal bootstrap for internet cafe scenario
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -c "iwr -useb https://cafew.adammomen.com | iex"

$ErrorActionPreference = 'Stop'

function Write-Log($msg) { Write-Host $msg }
function Write-Err($msg) { Write-Error -Message ($msg | Out-String) }

function Invoke-DownloadWithProgress {
  param(
    [Parameter(Mandatory=$true)] [string] $Uri,
    [Parameter(Mandatory=$true)] [string] $OutFile,
    [string] $Activity = "[cafe] Downloading",
    [string] $Description = ""
  )
  try { Add-Type -AssemblyName System.Net.Http -ErrorAction SilentlyContinue } catch {}
  $client = New-Object System.Net.Http.HttpClient
  try {
    $request = New-Object System.Net.Http.HttpRequestMessage 'Get', $Uri
    $response = $client.SendAsync($request, [System.Net.Http.HttpCompletionOption]::ResponseHeadersRead).Result
    if (-not $response.IsSuccessStatusCode) { throw "HTTP $($response.StatusCode) for $Uri" }
    $total = $response.Content.Headers.ContentLength
    $inStream = $response.Content.ReadAsStreamAsync().Result
    $dir = [System.IO.Path]::GetDirectoryName($OutFile)
    if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
    $outStream = [System.IO.File]::Create($OutFile)
    try {
      $buffer = New-Object byte[] 8192
      $readTotal = 0L
      while (($read = $inStream.Read($buffer, 0, $buffer.Length)) -gt 0) {
        $outStream.Write($buffer, 0, $read)
        $readTotal += $read
        if ($total -and $total -gt 0) {
          $pct = [int]([double]$readTotal / $total * 100)
          Write-Progress -Activity $Activity -Status $Description -PercentComplete $pct
        } else {
          $mb = [Math]::Round($readTotal/1MB, 2)
          Write-Progress -Activity $Activity -Status "$Description ($mb MB)" -PercentComplete -1
        }
      }
    } finally {
      if ($outStream) { $outStream.Dispose() }
      if ($inStream) { $inStream.Dispose() }
      Write-Progress -Activity $Activity -Completed
    }
  } finally {
    if ($client) { $client.Dispose() }
  }
}

$CafeVersion = '0.3.8'
Write-Log "[cafe] Windows bootstrap starting... v$CafeVersion"
$DRY_RUN = $env:DRY_RUN
if (-not $DRY_RUN) { $DRY_RUN = '0' }

# New minimal flow: fetch only encrypted vault file, decrypt into ssh-agent, then connect
$VaultUrlDefault = "https://raw.githubusercontent.com/AdamMomen/.dotfiles/refs/heads/master/ansible/vault/ssh_pk.txt"
$VaultDownloaded = $false
$VaultFile = ""
$VaultPassFile = $env:VAULT_PASS_FILE

# Ensure Python (avoid WindowsApps stubs); resolve an invocable command array in $script:PythonCmd
function Resolve-PythonCommand {
  $candidates = @(
    @('python'),
    @('python3'),
    @('py','-3'),
    @('py')
  )
  foreach ($cand in $candidates) {
    try {
      $out = & $cand '-c' 'import sys; print(sys.version)' 2>$null
      if ($LASTEXITCODE -eq 0 -and $out) { return $cand }
    } catch {}
  }
  # Fallback: locate python.exe in common install paths and return an explicit path
  $found = Find-PythonExecutable
  if ($found) { return @($found) }
  return $null
}

function Find-PythonExecutable {
  $paths = @()
  if ($env:LOCALAPPDATA) {
    $pyLocal = Join-Path $env:LOCALAPPDATA 'Programs\Python'
    if (Test-Path $pyLocal) {
      Get-ChildItem -Path $pyLocal -Directory -Filter 'Python3*' -ErrorAction SilentlyContinue |
        Sort-Object -Property Name -Descending |
        ForEach-Object {
          $exe = Join-Path $_.FullName 'python.exe'
          if (Test-Path $exe) { $paths += $exe }
        }
    }
  }
  if ($env:ProgramFiles) {
    Get-ChildItem -Path $env:ProgramFiles -Directory -Filter 'Python3*' -ErrorAction SilentlyContinue |
      ForEach-Object {
        $exe = Join-Path $_.FullName 'python.exe'
        if (Test-Path $exe) { $paths += $exe }
      }
  }
  foreach ($p in $paths) {
    try {
      $out = & $p '-c' 'import sys; print(sys.version)' 2>$null
      if ($LASTEXITCODE -eq 0 -and $out) {
        # Prepend its Scripts dir to PATH for this session
        $scripts = Join-Path ([System.IO.Path]::GetDirectoryName($p)) 'Scripts'
        if (Test-Path $scripts -and $env:Path -notlike "*$scripts*") { $env:Path = "$scripts;$env:Path" }
        return $p
      }
    } catch {}
  }
  return $null
}

function Install-Python-Winget {
  try {
    $wg = Get-Command winget -ErrorAction SilentlyContinue
    if (-not $wg) { return $false }
    Write-Log "[cafe] Installing Python via winget (silent)"
    $args = @(
      'install','--id','Python.Python.3.12','-e','--source','winget',
      '--silent','--accept-package-agreements','--accept-source-agreements'
    )
    $p = Start-Process -FilePath $wg.Source -ArgumentList $args -NoNewWindow -PassThru -Wait
    # Also ensure Python Launcher is present
    try {
      $args2 = @(
        'install','--id','Python.Launcher','-e','--source','winget',
        '--silent','--accept-package-agreements','--accept-source-agreements'
      )
      Start-Process -FilePath $wg.Source -ArgumentList $args2 -NoNewWindow -PassThru -Wait | Out-Null
    } catch {}
    if ($p.ExitCode -eq 0) { return $true }
  } catch {}
  return $false
}

function Ensure-Python {
  $script:PythonCmd = Resolve-PythonCommand
  if ($null -ne $script:PythonCmd) { return }
  # Install only via winget
  if (Install-Python-Winget) { $script:PythonCmd = Resolve-PythonCommand }
  if (-not $script:PythonCmd) {
    # Try to find launcher and use it to locate python
    $pyLauncher = Get-Command py -ErrorAction SilentlyContinue
    if ($pyLauncher) {
      try {
        $out = & $pyLauncher -3 -c 'import sys; print(sys.executable)'
        if ($LASTEXITCODE -eq 0 -and $out) {
          $exe = $out.Trim()
          if (Test-Path $exe) {
            $script:PythonCmd = @($exe)
          }
        }
      } catch {}
    }
  }
  if (-not $script:PythonCmd) {
    Write-Err "[cafe] Python not found after winget install. Manual: winget install --id Python.Python.3.12 -e"
    throw "Python missing"
  }
}

function Add-UserScriptsToPath {
  $paths = @()
  $localBin = Join-Path $env:USERPROFILE ".local\bin"
  if (Test-Path $localBin) { $paths += $localBin }
  # Windows pipx shims
  $pipxBin = Join-Path $env:LOCALAPPDATA "pipx\bin"
  if ($env:LOCALAPPDATA -and (Test-Path $pipxBin)) { $paths += $pipxBin }
  $pyRoot = Join-Path $env:APPDATA "Python"
  if (Test-Path $pyRoot) {
    Get-ChildItem -Path $pyRoot -Directory -Filter "Python3*" -ErrorAction SilentlyContinue |
      ForEach-Object {
        $scripts = Join-Path $_.FullName "Scripts"
        if (Test-Path $scripts) { $paths += $scripts }
      }
  }
  # Local user-install Python (Store/winget installs) Scripts path
  if ($env:LOCALAPPDATA) {
    $pyLocal = Join-Path $env:LOCALAPPDATA "Programs\Python"
    if (Test-Path $pyLocal) {
      Get-ChildItem -Path $pyLocal -Directory -Filter "Python3*" -ErrorAction SilentlyContinue |
        ForEach-Object {
          $scripts = Join-Path $_.FullName "Scripts"
          if (Test-Path $scripts) { $paths += $scripts }
        }
    }
  }
  # If Resolve-PythonCommand found an explicit python.exe, ensure its Scripts is first
  $explicitPy = $null
  try { if ($script:PythonCmd -and ($script:PythonCmd.Count -eq 1)) { $explicitPy = $script:PythonCmd[0] } } catch {}
  if ($explicitPy -and (Test-Path $explicitPy)) {
    $pyDir = [System.IO.Path]::GetDirectoryName($explicitPy)
    $pyScripts = Join-Path $pyDir 'Scripts'
    if (Test-Path $pyScripts) { $paths = @($pyScripts) + $paths }
  }
  foreach ($p in $paths) {
    if ($env:Path -notlike "*$p*") { $env:Path = "$p;$env:Path" }
  }
}

function Ensure-Pipx-Ansible {
  if (-not $script:PythonCmd) { $script:PythonCmd = Resolve-PythonCommand }
  Add-UserScriptsToPath
  # If ansible-vault already exists, done
  $vaultCmd = Get-Command ansible-vault -ErrorAction SilentlyContinue
  if ($vaultCmd) { return }
  Write-Log "[cafe] Installing ansible-core via pip --user"
  try { & $script:PythonCmd -m pip install --disable-pip-version-check --user --upgrade pip | Out-Null } catch {}
  try { & $script:PythonCmd -m pip install --disable-pip-version-check --user ansible-core | Out-Null } catch {}
  Add-UserScriptsToPath
  $vaultCmd = Get-Command ansible-vault -ErrorAction SilentlyContinue
  if (-not $vaultCmd) {
    Write-Err "[cafe] ansible-vault not found after install. Ensure %APPDATA%\\Python\\Python3xx\\Scripts is on PATH."
    throw "ansible-vault missing"
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
  Invoke-DownloadWithProgress -Uri $VaultUrlDefault -OutFile $tmp -Activity "[cafe] Vault" -Description "Fetching ssh_pk.txt"
  $script:VaultFile = $tmp
  $script:VaultDownloaded = $true
}

function Decrypt-Into-Agent {
  if ($DRY_RUN -eq '1') { Write-Log "[cafe] DRY_RUN=1 set. Skipping vault/key."; return }
  $vaultId = $(if ($VaultPassFile -and (Test-Path $VaultPassFile)) { "default@file:$VaultPassFile" } else { "default@prompt" })
  Write-Log "[cafe] Decrypting via ansible-vault CLI"
  $ansibleVault = Get-Command ansible-vault -ErrorAction SilentlyContinue
  if (-not $ansibleVault) { throw "ansible-vault not found in PATH" }
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
      Write-Log "[cafe] DRY_RUN=1 set. Would run: ssh -tt $user@$host 'tmux new -A -s cafe'"
    } else {
      Write-Log "[cafe] Connecting to $user@$host"
      ssh -tt "$user@$host" 'tmux new -A -s cafe'
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


