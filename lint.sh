#!/usr/bin/env bash
# lint all bash scripts and YAML in repo
# install: brew install shellcheck shfmt yamllint  |  apt install shellcheck shfmt yamllint  |  pacman -S shellcheck shfmt yamllint
#
# usage: lint.sh          # check only (exit 1 on issues)
#        lint.sh --write  # auto-fix formatting

set -euo pipefail

WRITE_MODE=false
if [[ "${1:-}" == "--write" || "${1:-}" == "-w" ]]; then
  WRITE_MODE=true
fi

SCRIPTS=(
  actions/setup-runtime/resolve-version.sh
  actions/validate-contract/install.sh
  actions/validate-contract/run.sh
  actions/generate-changelog/build-args.sh
  actions/generate-changelog/detect-version.sh
  actions/mirror/push.sh
  actions/release-preview/detect-version.sh
  actions/release-preview/create-summary.sh
  actions/release-apply/move-major-tag.sh
  actions/release-apply/publish.sh
  actions/release-apply/verify-tag.sh
  release-action/resolve-config.sh
)

YAML_FILES=(
  actions/**/action.yml
  .github/workflows/*.yml
)

if [ "$WRITE_MODE" = true ]; then
  echo "==> Auto-fixing formatting with shfmt -w..."
  shfmt -w "${SCRIPTS[@]}"
else
  echo "==> Checking formatting with shfmt..."
  shfmt -d "${SCRIPTS[@]}"
fi

echo "==> Linting with shellcheck..."
shellcheck -x "${SCRIPTS[@]}"

echo "==> Linting YAML with yamllint..."
yamllint -c .yamllint.yml "${YAML_FILES[@]}"

echo "All checks passed!"
