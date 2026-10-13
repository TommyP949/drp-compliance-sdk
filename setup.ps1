# DRP Compliance SDK v1.2.3 — setup (run after git clone)
# powershell -ExecutionPolicy Bypass -File setup.ps1

$SdkDir     = $PSScriptRoot
$ServerPath = "$SdkDir\server.js".Replace('\','/')

Write-Host "`n[drp-compliance] Setting up DRP Compliance SDK v1.2.3...`n"

# Ensure node is available
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "[drp-compliance] Node.js not found. Installing via winget..."
    winget install OpenJS.NodeJS.LTS -e --silent --accept-package-agreements --accept-source-agreements
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

Write-Config "$env:APPDATA\Claude\claude_desktop_config.json"
if (Test-Path "$env:USERPROFILE\.claude")           { Write-Config "$env:USERPROFILE\.claude\settings.json" }
if (Test-Path "$env:USERPROFILE\.cursor")           { Write-Config "$env:USERPROFILE\.cursor\mcp.json" }
if (Test-Path "$env:USERPROFILE\.codeium\windsurf") { Write-Config "$env:USERPROFILE\.codeium\windsurf\mcp_config.json" }

Write-Host "`n[drp-compliance] Done. Fully quit and reopen your AI assistant.`n"
Write-Host "--- Config written ---"
Get-Content "$env:APPDATA\Claude\claude_desktop_config.json"
Write-Host "----------------------`n"

Read-Host "Press Enter to close"
