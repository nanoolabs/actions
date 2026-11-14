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

## References & Impact

| Source                            | URL                                                                                                               | Impact                                                     |
| --------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| Codeberg mirror                   | https://codeberg.org/                                                                                             | Target registry for Codeberg mirroring                     |
| GitHub Actions reusable workflows | https://docs.github.com/en/actions/tutorials/create-actions/create-a-composite-action                             | Workflow contract structure                                |
| Git credential helper             | https://git-scm.com/docs/git-credential-store                                                                     | Token via temp file, not process table                     |
| GitHub Concurrency                | https://docs.github.com/en/actions/how-tos/write-workflows/choose-when-workflows-run/control-workflow-concurrency | Per-repository mirror serialization                        |
| Codeberg Forgejo API              | https://forgejo.org/                                                                                              | Token scope: repo write                                    |
| git mktemp                        | https://www.gnu.org/software/coreutils/manual/html_node/mktemp-invocation.html                                    | Temp file for credential storage (system utility, not git) |
