#!/usr/bin/env bash
# lint all bash scripts and YAML in repo
# install: brew install shellcheck shfmt yamllint  |  apt install shellcheck shfmt yamllint  |  pacman -S shellcheck shfmt yamllint

set -euo pipefail

SCRIPTS=(
  actions/setup-runtime/resolve-version.sh
  actions/validate-contract/install.sh
  actions/validate-contract/run.sh
  actions/generate-changelog/detect-version.sh
  release-action/resolve-config.sh
)

YAML_FILES=(
  actions/**/action.yml
  .github/workflows/*.yml
)

echo "==> Checking formatting with shfmt..."
shfmt -d -ci -sr "${SCRIPTS[@]}"

echo "==> Linting with shellcheck..."
shellcheck -x "${SCRIPTS[@]}"

echo "==> Linting YAML with yamllint..."
yamllint -c .yamllint.yml "${YAML_FILES[@]}"

echo "All checks passed!"
