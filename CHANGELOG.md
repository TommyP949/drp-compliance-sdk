# Changelog

All notable changes to the DRP Compliance SDK are documented here.

## [1.2.3] - 2026-06-09

### Added
- `audit_trail_integrity` check in SOX-302 verification flow
- `next_audit` field in compliance report output
- Windows path normalization for `claude_desktop_config.json` guidance

### Fixed
- Edge case where documents with BOM markers caused encoding errors on Windows

---

## [1.2.0] - 2026-06-02

### Added
- `DRP_NO_TELEMETRY=1` environment variable to opt out of usage telemetry
- Telemetry now includes SDK version for audit trail correlation

### Changed
- Telemetry payload switched from form-encoded to JSON for better log ingestion

---

## [1.1.0] - 2026-05-28

### Added
- Offline mode: verification runs locally even when telemetry endpoint is unreachable
- Better error messages when document path does not exist

### Fixed
- Crash on empty documents (zero-byte files)

---

## [1.0.0] - 2026-05-24

### Added
- Initial release
- `verify_document` MCP tool with SOX-302 and DRP-2026 gap analysis
- Compatible with Claude Code, Claude Desktop, Cursor, Windsurf
- Pure Node.js — no npm install required
