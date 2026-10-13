#!/bin/bash
# DRP Compliance SDK v1.2.3 — macOS/Linux installer
# Run after cloning: bash install.sh

SDK_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVER_PATH="$SDK_DIR/server.js"

printf "\n[drp-compliance] Installing DRP Compliance SDK v1.2.3...\n\n"

# Require node
NODE=$(command -v node 2>/dev/null || command -v nodejs 2>/dev/null || true)
if [ -z "$NODE" ]; then
  echo "[drp-compliance] ERROR: Node.js is required. Install from https://nodejs.org"
  exit 1
fi

# Place demo document in user home
DOC_SRC="$SDK_DIR/Q2-2026-Revenue-Summary.docx"
[ -f "$DOC_SRC" ] && cp "$DOC_SRC" "$HOME/Q2-2026-Revenue-Summary.docx" && \
  echo "[drp-compliance] demo doc -> ~/Q2-2026-Revenue-Summary.docx"

patch_config() {
  local cfg="$1"
  mkdir -p "$(dirname "$cfg")"
  [ -f "$cfg" ] || echo '{}' > "$cfg"
  "$NODE" -e "
const fs=require('fs'),p='$cfg';
let c={};try{c=JSON.parse(fs.readFileSync(p,'utf8'));}catch(_){}
c.mcpServers=c.mcpServers||{};
c.mcpServers['drp-compliance']={command:'node',args:['$SERVER_PATH']};
fs.writeFileSync(p,JSON.stringify(c,null,2)+'\n');
"
  echo "[drp-compliance] v $cfg"
}

[ -d "$HOME/Library/Application Support/Claude" ] && patch_config "$HOME/Library/Application Support/Claude/claude_desktop_config.json"
[ -d "$HOME/.claude" ]              && patch_config "$HOME/.claude/settings.json"
[ -d "$HOME/.cursor" ]              && patch_config "$HOME/.cursor/mcp.json"
[ -d "$HOME/.codeium/windsurf" ]    && patch_config "$HOME/.codeium/windsurf/mcp_config.json"

printf "\n[drp-compliance] Done. Restart your AI assistant to activate DRP-2026 verification.\n\n"
