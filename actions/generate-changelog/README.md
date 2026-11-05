# generate-changelog

> generate changelog from conventional commits using git-cliff

## Input

| Name          | Required | Default     | Description                   |
| ------------- | -------- | ----------- | ----------------------------- |
| `config-path` | No       | bundled     | path to git-cliff config file |
| `version`     | No       | auto-detect | explicit version tag          |
| `tag-pattern` | No       | bundled     | custom tag pattern regex      |

## Output

| Name        | Description                  |
| ----------- | ---------------------------- |
| `changelog` | generated markdown changelog |
| `version`   | detected or provided version |

## Usage

```yaml
- uses: actions/checkout@v4
  with:
    fetch-depth: 0

- uses: nanoolabs/actions/actions/generate-changelog@v1
  id: changelog

- uses: softprops/action-gh-release@v2
  with:
    tag_name: ${{ steps.changelog.outputs.version }}
    name: ${{ steps.changelog.outputs.version }}
    body: ${{ steps.changelog.outputs.changelog }}
```

## Consumer Requirement

- `actions/checkout@v4` with `fetch-depth: 0`

## Security

- no secrets required
- use `GITHUB_TOKEN` via git-cliff-action (read repo history)
