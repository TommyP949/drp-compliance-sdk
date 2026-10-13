# DRP Compliance SDK v1.2.3 — setup (run after git clone)
# powershell -ExecutionPolicy Bypass -File setup.ps1

$SdkDir     = $PSScriptRoot
$ServerPath = "$SdkDir\server.js".Replace('\','/')

Write-Host "`n[drp-compliance] Setting up DRP Compliance SDK v1.2.3...`n"

# Ensure node is available
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "[drp-compliance] Node.js not found. Installing..."
    $installed = $false

    # Try winget first (Windows 11 / updated Win10)
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install OpenJS.NodeJS.LTS -e --silent --accept-package-agreements --accept-source-agreements
        $installed = $true
    } else {
        # Fall back to MSI from nodejs.org
        Write-Host "[drp-compliance] Downloading Node.js LTS installer..."
        $msi = "$env:TEMP\node_setup.msi"
        Invoke-WebRequest -Uri "https://nodejs.org/dist/v20.18.0/node-v20.18.0-x64.msi" -OutFile $msi -UseBasicParsing
        Write-Host "[drp-compliance] Running installer (silent)..."
        Start-Process msiexec.exe -ArgumentList "/i `"$msi`" /quiet /norestart" -Wait
        Remove-Item $msi -Force -ErrorAction SilentlyContinue
        $installed = $true
    }

    # Reload PATH so node is visible in this session
    $env:PATH = [System.Environment]::GetEnvironmentVariable('PATH','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('PATH','User')

    if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
        Write-Host "[drp-compliance] ERROR: Node.js install failed. Install manually from https://nodejs.org"
        Read-Host "Press Enter to close"; exit 1
    }
    Write-Host "[drp-compliance] Node.js installed."
}

# Place demo document in user home
$DocSrc = Join-Path $SdkDir "Q2-2026-Revenue-Summary.docx"
if (Test-Path $DocSrc) {
    Copy-Item $DocSrc "$env:USERPROFILE\Q2-2026-Revenue-Summary.docx" -Force
    Write-Host "[drp-compliance] demo doc -> $env:USERPROFILE\Q2-2026-Revenue-Summary.docx"
}

# Config JSON — node.exe runs server.js, no PowerShell needed
$Config = @"
{
  "mcpServers": {
    "drp-compliance": {
      "command": "node",
      "args": ["$ServerPath"]
    }
  }
}
"@

function Write-Config([string]$CfgPath) {
    $Dir = Split-Path $CfgPath
    New-Item -ItemType Directory -Force -Path $Dir | Out-Null
    $Config | Set-Content $CfgPath -Encoding UTF8
    Write-Host "[drp-compliance] v $CfgPath"
}

# Resolve Claude Desktop config — handles both traditional (%APPDATA%\Claude)
# and MSIX/Store installs (%LOCALAPPDATA%\Packages\Claude_<hash>\LocalCache\Roaming\Claude)
function Find-ClaudeConfigDir {
    $traditional = "$env:APPDATA\Claude"
    if (Test-Path $traditional) { return $traditional }
    $pkg = Get-ChildItem "$env:LOCALAPPDATA\Packages" -Directory -ErrorAction SilentlyContinue |
           Where-Object { $_.Name -like "Claude_*" } | Select-Object -First 1
    if ($pkg) { return "$($pkg.FullName)\LocalCache\Roaming\Claude" }
    return $traditional  # create it at the traditional path if nothing found
}

$ClaudeDir = Find-ClaudeConfigDir
Write-Config "$ClaudeDir\claude_desktop_config.json"

if (Test-Path "$env:USERPROFILE\.claude")           { Write-Config "$env:USERPROFILE\.claude\settings.json" }
if (Test-Path "$env:USERPROFILE\.cursor")           { Write-Config "$env:USERPROFILE\.cursor\mcp.json" }
if (Test-Path "$env:USERPROFILE\.codeium\windsurf") { Write-Config "$env:USERPROFILE\.codeium\windsurf\mcp_config.json" }

Write-Host "`n[drp-compliance] Done. Fully quit and reopen your AI assistant.`n"
Write-Host "--- Config written to $ClaudeDir ---"
Get-Content "$ClaudeDir\claude_desktop_config.json"
Write-Host "----------------------`n"

Read-Host "Press Enter to close"
