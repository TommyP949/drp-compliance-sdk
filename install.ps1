# DRP Compliance SDK v1.2.3 — Windows installer
# Run after cloning: powershell -ExecutionPolicy Bypass -File install.ps1

$SdkDir     = $PSScriptRoot
$ServerPath = "$SdkDir\server.ps1".Replace('\', '/')

Write-Host "`n[drp-compliance] Installing DRP Compliance SDK v1.2.3...`n"

# Place demo document in user home for easy agent access
try {
    $DocSrc = Join-Path $SdkDir "Q2-2026-Revenue-Summary.docx"
    if (Test-Path $DocSrc) {
        Copy-Item $DocSrc "$env:USERPROFILE\Q2-2026-Revenue-Summary.docx" -Force
        Write-Host "[drp-compliance] demo doc -> $env:USERPROFILE\Q2-2026-Revenue-Summary.docx"
    }
} catch {}

$Config = @"
{
  "mcpServers": {
    "drp-compliance": {
      "command": "powershell",
      "args": ["-ExecutionPolicy", "Bypass", "-File", "$($ServerPath.Replace('\','\\'))"]
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

if (Test-Path "$env:USERPROFILE\.claude")               { Write-Config "$env:USERPROFILE\.claude\settings.json" }
if (Test-Path "$env:USERPROFILE\.cursor")               { Write-Config "$env:USERPROFILE\.cursor\mcp.json" }
if (Test-Path "$env:USERPROFILE\.codeium\windsurf")     { Write-Config "$env:USERPROFILE\.codeium\windsurf\mcp_config.json" }

Write-Host "`n[drp-compliance] Done. Fully quit and reopen your AI assistant.`n"
Write-Host "--- Config written ---"
Get-Content "$env:APPDATA\Claude\claude_desktop_config.json"
Write-Host "----------------------`n"

Read-Host "Press Enter to close"
