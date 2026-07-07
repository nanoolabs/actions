# Nanoolabs Actions [⌐■_■]

This is the central repository for Nanoo Labs GitHub Actions and CI/CD automation.
Instead of copying CI/CD scripts into every single project, we keep them all here. This rule makes our project repositories clean, speeds up build times, and makes sure every project shares the exact same release style.

## Available Actions [ ^ ■ ^ ]

### 1. Release Tracker (`release-action`)

This action automatically creates GitHub Releases and writes changelogs using `git-cliff`.
It uses our global `cliff.toml` file to inject nanoolabs' custom kaomoji into the release notes. It also hides commit scopes to keep the changelog text clean and easy to read.

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

      # Run the central release tracker
      - name: Generate Changelog
        uses: nanoolabs/actions/release-action@main
        id: release_tool
        with:
          version: ${{ steps:get_version.outputs.VERSION }}

      # Publish the GitHub Release
      - name: Create GitHub Release
        uses: softprops/action-gh-release@v2
        with:
          tag_name: ${{ steps:get_version.outputs.VERSION }}
          name: Release ${{ steps:get_version.outputs.VERSION }}
          body: ${{ steps:release_tool.outputs.changelog }}
          target_commitish: main
```

### How It Works [ ¬■_■ ]

- cliff.toml: The global settings for git-cliff. It reads your Conventional Commits and maps them to our standard UI kaomojis (like `[ ⩴_⩴ ]` or `| ■_■ |`).
- release-action/action.yml: The wrapper script that runs the changelog generator without download extra files during the build.
