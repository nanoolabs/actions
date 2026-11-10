#!/usr/bin/env bash
# detect version tag from git tags (git-cliff not available in composite action)

set -euo pipefail

# use git tag --sort=-v:refname for reliable latest semantic version
# git describe --tags --abbrev=0 behavior varies by Git version
# https://git-scm.com/docs/git-tag/2.12.5#Documentation/git-tag.txt---sortkey
tag=$(git tag --sort=-v:refname 2>/dev/null | head -1 || echo "")

# fallback: parse git-cliff output if git-cliff happens to be available
if [ -z "$tag" ] && command -v git-cliff >/dev/null 2>&1; then
  CONFIG="${CONFIG:-${GITHUB_ACTION_PATH}/../../cliff.toml}"
  tag=$(git cliff --latest --config "$CONFIG" 2>/dev/null | head -1 | sed -n 's/^## \[\(.*\)\].*/\1/p')
fi

echo "version=$tag" >>"$GITHUB_OUTPUT"
