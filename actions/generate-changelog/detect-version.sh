#!/usr/bin/env bash
# detect version tag from git describe (git-cliff not available in composite action)

set -euo pipefail

# try git describe first (works without git-cliff binary)
tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "")

# fallback: parse git-cliff output if git-cliff happens to be available
if [ -z "$tag" ] && command -v git-cliff >/dev/null 2>&1; then
  CONFIG="${CONFIG:-${GITHUB_ACTION_PATH}/../../cliff.toml}"
  tag=$(git cliff --latest --config "$CONFIG" 2>/dev/null | head -1 | sed -n 's/^## \[\(.*\)\].*/\1/p')
fi

echo "version=$tag" >>"$GITHUB_OUTPUT"
