#!/usr/bin/env bash
# build git-cliff args from inputs

set -euo pipefail

VERSION="${VERSION:-}"
TAG_PATTERN="${TAG_PATTERN:-}"

ARGS=("--latest")

if [ -n "$VERSION" ]; then
  ARGS+=("--tag" "$VERSION")
fi

if [ -n "$TAG_PATTERN" ]; then
  ARGS+=("--tag-pattern" "$TAG_PATTERN")
fi

# output as space separate string for GitHub Actions
printf 'args=%s\n' "${ARGS[*]}" >> "$GITHUB_OUTPUT"
