# [⌐■_■] Nanoolabs Actions

This is the central repository for Nanoo Labs GitHub Actions and CI/CD automation.
Instead of copying CI/CD scripts into every single project, we keep them all here. This rule makes our project repositories clean, speeds up build times, and makes sure every project shares the exact same release style.

## Available Actions

### 1. Release Tracker (`release-action`)

This action automatically creates GitHub Releases and writes changelogs using `git-cliff`.
It uses our global `cliff.toml` file to inject nanoolabs custom kaomoji to the release notes. Commit lines are terse; a `**scope:**` prefix only render when the commit actually has one.

#### How to Use

Add this to any Nanoo Labs project workflow (for example, in `.github/workflows/release.yml`):

```yaml
jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      # Get the version from your project
      - name: Get Version
        id: get_version
        run: echo "VERSION=v$(node -p "require('./package.json').version")" >> $GITHUB_OUTPUT

      # Save tag before running git cliff
      - name: Create Tag
        if: ${{ !startsWith(github.ref, 'refs/tags/') }}
        run: |
          git tag ${{ steps.get_version.outputs.VERSION }}
          git push origin ${{ steps.get_version.outputs.VERSION }}

      # Run the central release tracker
      - name: Generate Changelog
        uses: nanoolabs/actions/release-action@v2
        id: release_tool

      # Publish the GitHub release (version is already the title,`v2.2.6`)
      - name: Create GitHub Release
        uses: softprops/action-gh-release@v2
        with:
          tag_name: ${{ steps.get_version.outputs.VERSION }}
          name: ${{ steps.get_version.outputs.VERSION }}
          body: ${{ steps.release_tool.outputs.changelog }}
          target_commitish: main
```

> Pin by the bare major tag (`@v2`) this repo hold a single action, so the tag doesn't repeat the action name (contrast `@release-action-v2`)

### How It Works

- `cliff.toml`: the global git-cliff settings. It reads Conventional Commits and maps them to Nanoo kaomojis copy from `nanoolabs/kaomoji` (e.g. `[ ^■^ ] Features`, `[ ;■_■ ] Bug Fixes`). Header is plain `## Changelog. no version, no footer. Commit lines are terse; scope only render for commits that have one. One`[Full diff]` compare link sits at the top.
- `release-action/action.yml`: the wrapper that runs the generator without download extra files during the build.

#### Per-repo config override

The action `config` input (default: empty) chooses its `cliff.toml` in this order: explicit `config` input → a repo-local `cliff.toml` at the consumer repo root → the bundle default. Drop a `cliff.toml` in a consumer repo to customize its changelog (custom commit types, custom kaomoji, monorepo scopes) without touching the share one.
