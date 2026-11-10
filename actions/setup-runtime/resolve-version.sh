#!/usr/bin/env bash
# resolve deno version from input, .tool-versions, or .dvmrc

set -euo pipefail

version=""
if [ -n "${VERSION:-}" ]; then
  version="${VERSION}"
elif [ -f ".tool-versions" ]; then
  # strip inline comments, handle leading whitespace
  version=$(awk '/^[[:space:]]*deno[[:space:]]+/ {gsub(/#.*/, "", $2); print $2; exit}' .tool-versions)
elif [ -f ".dvmrc" ]; then
  # pick first line starting with digit (skip comments/empty lines)
  version=$(awk '/^[0-9]/ {print; exit}' .dvmrc)
fi
version=$(echo "$version" | xargs)
[ -z "$version" ] && version="2"
echo "version=$version" >>"$GITHUB_OUTPUT"
