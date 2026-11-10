#!/usr/bin/env bash
# push all refs and tags to codeberg mirror
# used by .github/workflows/reusable-mirror.yml

set -euo pipefail

CODEBERG_TOKEN="${CODEBERG_TOKEN:-}"
CODEBERG_REPO_NAME="${CODEBERG_REPO_NAME:-}"

if [ -z "$CODEBERG_TOKEN" ]; then
  echo "ERROR: CODEBERG_TOKEN not set" >&2
  exit 1
fi

if [ -z "$CODEBERG_REPO_NAME" ]; then
  # default to github repo name
  CODEBERG_REPO_NAME=$(basename "$GITHUB_REPOSITORY")
fi

NAME="$CODEBERG_REPO_NAME"
git remote add codeberg "https://codeberg.org/nanoolabs/${NAME}.git"
git update-ref -d refs/remotes/origin/HEAD 2>/dev/null || true

# use git credential helper with temp file to avoid token in process table
CRED_FILE=$(mktemp)
echo "https://oauth2:${CODEBERG_TOKEN}@codeberg.org" >"$CRED_FILE"
git -c "credential.helper=store --file=${CRED_FILE}" \
  push codeberg --force --prune \
  "refs/remotes/origin/*:refs/heads/*" \
  "refs/tags/*:refs/tags/*"
rm -f "$CRED_FILE"
