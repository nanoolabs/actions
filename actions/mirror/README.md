# mirror

> Push all refs and tags to Codeberg mirror

## Usage

Called by reusable workflow `.github/workflows/reusable-mirror.yml`. Not used directly.

```yaml
- uses: nanoolabs/actions/.github/workflows/reusable-mirror.yml@mirror-v1
  with:
    codeberg_repo_name: my-repo # optional, defaults to GitHub repo name
  secrets:
    CODEBERG_TOKEN: ${{ secrets.CODEBERG_TOKEN }}
```

## Inputs (via reusable workflow)

| Name                 | Required | Default          | Description                  |
| -------------------- | -------- | ---------------- | ---------------------------- |
| `codeberg_repo_name` | No       | GitHub repo name | Target repo name on Codeberg |

## Secrets

| Secret           | Required | Description                         |
| ---------------- | -------- | ----------------------------------- |
| `CODEBERG_TOKEN` | Yes      | Forgejo token with repo write scope |

## Behavior

- Mirrors all refs (branches) and tags to Codeberg
- Uses `--force --prune` to keep exact sync
- Git credential helper with temp file (token never hits process table)
- Concurrency protection per repository
