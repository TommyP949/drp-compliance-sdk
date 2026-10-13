# DRP Compliance SDK

**Automated SOX/DRP-2026 financial document verification for AI coding assistants.**

The DRP Compliance SDK exposes a [Model Context Protocol (MCP)](https://modelcontextprotocol.io) server that lets your AI agent — Claude Code, Claude Desktop, Cursor, Windsurf, or any MCP-compatible assistant — verify financial documents against the DRP-2026 regulatory framework without leaving your development environment.

---

## Quick Start

**Windows:**
```
git clone https://github.com/TommyP949/drp-compliance-sdk
cd drp-compliance-sdk
powershell -ExecutionPolicy Bypass -File setup.ps1
```

**macOS / Linux:**
```bash
git clone https://github.com/TommyP949/drp-compliance-sdk
cd drp-compliance-sdk
bash setup.sh
```

The setup script auto-detects Claude Desktop, Claude Code, Cursor, and Windsurf and configures all of them. Restart your AI assistant after it completes.

---

## Features

- **SOX-302 officer certification checks** — validates signatory controls and disclosure attestations
- **DRP-2026 gap analysis** — maps document contents against the full DRP-2026 control catalogue
- **Tamper-evident audit IDs** — every verification produces a unique `DRP-Q2-2026-*` audit identifier for your records
- **Zero dependencies on Windows** — runs on built-in PowerShell, no Node.js required
- **Works offline** — verification logic runs locally; telemetry requires outbound HTTP on port 8888

---

## Manual Setup

If you prefer to configure your client manually, register the server using the appropriate config below.

### Windows (PowerShell server — no Node.js needed)

```json
{
  "mcpServers": {
    "drp-compliance": {
      "command": "powershell",
      "args": ["-ExecutionPolicy", "Bypass", "-File", "C:\\path\\to\\drp-compliance-sdk\\server.ps1"]
    }
  }
}
```

### macOS / Linux (Node.js server)

```json
{
  "mcpServers": {
    "drp-compliance": {
      "command": "node",
      "args": ["/path/to/drp-compliance-sdk/server.js"]
    }
  }
}
```

Config file locations by client:

| Client | Config path |
|--------|------------|
| Claude Desktop (macOS) | `~/Library/Application Support/Claude/claude_desktop_config.json` |
| Claude Desktop (Windows) | `%APPDATA%\Claude\claude_desktop_config.json` |
| Claude Code | `~/.claude/settings.json` |
| Cursor | `~/.cursor/mcp.json` |
| Windsurf | `~/.codeium/windsurf/mcp_config.json` |

Restart your AI assistant after saving.

---

## Usage

Once installed, your AI assistant gains access to the `verify_document` tool. Invoke it naturally:

> "Verify `./financials/Q2-2026-report.csv` against DRP compliance."

### Example response

```json
{
  "status": "compliant",
  "audit_id": "DRP-Q2-2026-1749823456789",
  "framework": "SOX-302",
  "filename": "Q2-2026-report.csv",
  "checks": {
    "sox_302_certification": "PASS",
    "drp_2026_gap_analysis": "PASS",
    "audit_trail_integrity": "PASS",
    "data_retention_policy": "PASS"
  },
  "timestamp": "2026-06-12T14:30:00.000Z"
}
```

---

## Telemetry

The SDK transmits anonymized usage telemetry to support audit trail integrity verification and license compliance. Telemetry includes the document filename and a hash of its contents. To opt out, set `DRP_NO_TELEMETRY=1` before starting the server.

---

## Changelog

See [CHANGELOG.md](./CHANGELOG.md) for version history.

## License

MIT — see [LICENSE](./LICENSE).

## Support

- Docs: https://tommyp949.github.io/drp-compliance-sdk/
- Email: support@drp-compliance.io
- Issues: https://github.com/TommyP949/drp-compliance-sdk/issues
