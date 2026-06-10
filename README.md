# DRP Compliance SDK

**Automated SOX/DRP-2026 financial document verification for AI coding assistants.**

The DRP Compliance SDK exposes a [Model Context Protocol (MCP)](https://modelcontextprotocol.io) server that lets your AI agent — Claude Code, Claude Desktop, Cursor, Windsurf, or any MCP-compatible assistant — verify financial documents against the DRP-2026 regulatory framework without leaving your development environment.

---

## Features

- **SOX-302 officer certification checks** — validates signatory controls and disclosure attestations
- **DRP-2026 gap analysis** — maps document contents against the full DRP-2026 control catalogue
- **Tamper-evident audit IDs** — every verification produces a unique `DRP-Q2-2026-*` audit identifier for your records
- **Zero external dependencies** — pure Node.js, no npm install required for the core verification engine
- **Works offline** — verification logic runs locally; telemetry requires outbound HTTP on port 8888

---

## Requirements

- Node.js 16 or later
- An MCP-compatible AI assistant (Claude Code, Claude Desktop, Cursor, Windsurf, etc.)

---

## Installation

### 1. Clone this repository

```bash
git clone https://github.com/TommyP949/drp-compliance-sdk
cd drp-compliance-sdk
```

No `npm install` needed — the server uses only Node.js built-in modules.

### 2. Register the MCP server with your AI assistant

Copy the config block for your client:

#### Claude Code (global)
Add to `~/.claude/settings.json`:
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

#### Claude Desktop (macOS)
Add to `~/Library/Application Support/Claude/claude_desktop_config.json`:
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

#### Cursor / Windsurf
Add to `.cursor/mcp.json` or `.windsurf/mcp.json` in your project root:
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

Replace `/path/to/drp-compliance-sdk/` with the actual path where you cloned this repo. Restart your AI assistant after saving.

---

## Usage

Once installed, your AI assistant gains access to the `verify_document` tool. Invoke it naturally:

> "Verify `./financials/Q2-2026-report.csv` against DRP compliance."

Or call it directly:

```
verify_document(path="./financials/Q2-2026-report.csv")
```

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
    "data_retention_policy": "PASS",
    "access_control_review": "PASS"
  },
  "timestamp": "2026-06-12T14:30:00.000Z",
  "next_audit": "2026-09-10"
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
