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

$CafeVersion = '0.3.1'
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
  return $null
}

function Install-PortablePython {
  param(
    [string]$Version = '3.12.5'
  )
  try {
    $base = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "python-embed-$Version")
    if (-not (Test-Path $base)) { New-Item -ItemType Directory -Path $base | Out-Null }
    $zip = Join-Path $base "python-$Version-embed-amd64.zip"
    $url = "https://www.python.org/ftp/python/$Version/python-$Version-embed-amd64.zip"
    Write-Log "[cafe] Downloading portable Python $Version"
    Invoke-DownloadWithProgress -Uri $url -OutFile $zip -Activity "[cafe] Portable Python" -Description "Downloading $Version"
    Expand-Archive -Path $zip -DestinationPath $base -Force
    $pth = Get-ChildItem -Path $base -Filter "python*._pth" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($pth) {
      $content = Get-Content -Path $pth.FullName -Raw
      $content = $content -replace '^[#\s]*import\s+site','import site'
      Set-Content -Path $pth.FullName -Value $content -NoNewline
    }
    $script:PythonCmd = @(Join-Path $base 'python.exe')
    $script:PortablePythonBase = $base
    # Ensure portable Scripts dir exists and is on PATH before running get-pip
    $portableScripts = Join-Path $base 'Scripts'
    if (-not (Test-Path $portableScripts)) { New-Item -ItemType Directory -Path $portableScripts | Out-Null }
    if ($env:Path -notlike "*$portableScripts*") { $env:Path = "$portableScripts;$env:Path" }
    $getPip = Join-Path $base 'get-pip.py'
    Write-Log "[cafe] Installing pip for portable Python"
    Invoke-DownloadWithProgress -Uri 'https://bootstrap.pypa.io/get-pip.py' -OutFile $getPip -Activity "[cafe] get-pip.py" -Description "Downloading installer"
    $env:PIP_NO_WARN_SCRIPT_LOCATION = '1'
    $env:PIP_DISABLE_PIP_VERSION_CHECK = '1'
    & $script:PythonCmd $getPip | Out-Null
    Add-UserScriptsToPath
    return $true
  } catch {
    Write-Err "[cafe] Portable Python install failed: $($_.Exception.Message)"
    return $false
  }
}

function Ensure-Python {
  $script:PythonCmd = Resolve-PythonCommand
  if ($null -ne $script:PythonCmd) { return }
  Write-Log "[cafe] No system Python detected; attempting portable install..."
  if (Install-PortablePython) { return }
  Write-Err "[cafe] Python not found and portable install failed."
  throw "Python missing"
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
  foreach ($p in $paths) {
    if ($env:Path -notlike "*$p*") { $env:Path = "$p;$env:Path" }
  }
}

function Ensure-Pipx-Ansible {
  Add-UserScriptsToPath
  if (-not $script:PythonCmd) { $script:PythonCmd = Resolve-PythonCommand }
  # If we're using portable Python, prefer installing into its Scripts so modules are importable
  $portableScripts = $null
  if ($script:PortablePythonBase) {
    $portableScripts = Join-Path $script:PortablePythonBase 'Scripts'
    if ((Test-Path $portableScripts) -and ($env:Path -notlike "*$portableScripts*")) {
      $env:Path = "$portableScripts;$env:Path"
    }
  }
  # Prefer direct install into portable Python when available; skip pipx to reduce PATH issues
  try {
    if ($portableScripts) {
      Write-Log "[cafe] Installing ansible-core into portable Python"
      & $script:PythonCmd -m pip install --upgrade pip | Out-Null
      & $script:PythonCmd -m pip install ansible-core --target $portableScripts | Out-Null
    } else {
      Write-Log "[cafe] Installing ansible-core via pip --user"
      & $script:PythonCmd -m pip install --user ansible-core | Out-Null
    }
  } catch {}
  Add-UserScriptsToPath
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


