# validate-contract

> Validate workflow/action contracts with actionlint and permission checks.

## Inputs

| Name                | Required | Default  | Description                                     |
| ------------------- | -------- | -------- | ----------------------------------------------- |
| `path`              | No       | `.`      | Path to workflow/action files                   |
| `version`           | No       | `1.7.12` | actionlint version (e.g., `1.7.12` or `latest`) |
| `check-permissions` | No       | `true`   | Check for least-privilege permissions           |
| `fail-on-error`     | No       | `true`   | Fail on validation errors                       |

## Outputs

| Name         | Description                            |
| ------------ | -------------------------------------- |
| `violations` | JSON array of actionlint violations    |
| `passed`     | Whether all checks passed (true/false) |

## Usage

```yaml
- uses: nanoolabs/actions/actions/validate-contract@v1
  with:
    path: .github/workflows
    version: "1.7.12" # or "latest"
    check-permissions: true
    fail-on-error: true
```

## Checks Performed

1. **actionlint** - Validates workflow/action YAML syntax, schema, and best practices
2. **Permissions audit** - Flags:
   - Missing explicit `permissions:` block
   - Overly broad permissions (`contents: write`, `actions: write`)
   - Missing `pull-requests: write` when `contents: write` is used
   - Recursively finds `action.yml` in `actions/` subdirectories

## Implementation

- Downloads actionlint binary from GitHub releases (no Docker required)
- Verifies SHA256 checksum on every download (including cache hits)
- Supports `VERSION=latest` to auto-fetch latest release from GitHub API
- Caches binary in `$RUNNER_TEMP/actionlint` for subsequent runs
- Works on Linux, macOS, and Windows runners
- JSON output properly escaped via `jq`

## Security

- No secrets required
- Permissions: `contents: read`

## References & Impact

| Source                 | URL                                                                                      | Impact                                  |
| ---------------------- | ---------------------------------------------------------------------------------------- | --------------------------------------- |
| actionlint             | https://github.com/rhysd/actionlint                                                      | Workflow linting binary                 |
| GitHub Actions docs    | https://docs.github.com/en/actions                                                       | Composite actions, secrets, permissions |
| jq                     | https://jqlang.github.io/jq/                                                             | JSON escaping for violations output     |
| GitHub Least Privilege | https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions | `contents: read` default                |
