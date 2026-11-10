# generate-changelog

> Generate changelog from conventional commits using git-cliff

## Inputs

| Name          | Required | Default     | Description                   |
| ------------- | -------- | ----------- | ----------------------------- |
| `config-path` | No       | bundled     | Path to git-cliff config file |
| `version`     | No       | auto-detect | Explicit version tag          |
| `tag-pattern` | No       | bundled     | Custom tag pattern regex      |

## Outputs

| Name        | Description                  |
| ----------- | ---------------------------- |
| `changelog` | Generated markdown changelog |
| `version`   | Detected or provided version |

## Usage

```yaml
- uses: actions/checkout@v4
  with:
    fetch-depth: 0

- uses: nanoolabs/actions/actions/generate-changelog@v1
  id: changelog
  with:
    config-path: "" # optional
    version: "" # optional
    tag-pattern: "" # optional

- uses: softprops/action-gh-release@v2
  with:
    tag_name: ${{ steps.changelog.outputs.version }}
    name: ${{ steps.changelog.outputs.version }}
    body: ${{ steps.changelog.outputs.changelog }}
```

## Behavior

1. **Detect version:** from git tags (`git tag --sort=-v:refname`) or explicit input
2. **Build `git-cliff` args:** via `build-args.sh` (testable, no inline expressions)
3. **Run `git-cliff`:** using bundled `cliff.toml` with kaomoji groups

## What you need

- `actions/checkout@v4` with `fetch-depth: 0`

## Security

- No secrets required
- Uses `GITHUB_TOKEN` via git-cliff-action (read repo history)
- Permissions: `contents: read`
