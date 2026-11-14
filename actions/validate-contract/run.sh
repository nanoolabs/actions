#!/bin/bash

if [[ -n "$DEBUG" ]]; then
  set -x
fi

set -euo pipefail

# avoid file expansion when passing parameters like with '*'
set -o noglob

ACTIONLINT_PATH="$RUNNER_TEMP/actionlint/actionlint"

# default inputs
PATH_INPUT="${PATH_INPUT:-.}"
CHECK_PERMISSIONS="${CHECK_PERMISSIONS:-true}"
FAIL_ON_ERROR="${FAIL_ON_ERROR:-true}"

# run actionlint
echo "Running actionlint on ${PATH_INPUT}..."
violations=$("${ACTIONLINT_PATH}" -format '{{.File}}:{{.Line}}:{{.Column}}: {{.Message}}' "${PATH_INPUT}" 2>&1 || true)

if [ -n "$violations" ]; then
  echo "::error::actionlint found violations"
  echo "$violations" | while IFS= read -r line; do
    file=$(echo "$line" | cut -d: -f1)
    line_num=$(echo "$line" | cut -d: -f2)
    col=$(echo "$line" | cut -d: -f3)
    msg=$(echo "$line" | cut -d: -f4-)
    echo "::error file=$file,line=$line_num,col=$col::$msg"
  done
fi

# output violations as JSON array for output
# convert violations to JSON array
if [ -n "$violations" ]; then
  # escape for JSON using jq for proper encoding
  if command -v jq >/dev/null 2>&1; then
    escaped=$(printf '%s' "$violations" | jq -Rs .)
  else
    # fallback: basic escaping
    escaped=$(printf '%s' "$violations" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')
  fi
  echo "violations=[${escaped}]" >>"$GITHUB_OUTPUT"
else
  echo "violations=[]" >>"$GITHUB_OUTPUT"
fi

# check permissions if enable
if [ "$CHECK_PERMISSIONS" = "true" ]; then
  passed=true
  while IFS= read -r file; do
    if [ -f "$file" ]; then
      if grep -q "permissions:" "$file"; then
        # check for overly broad permissions
        if grep -q "contents: write" "$file" && ! grep -q "pull-requests: write" "$file"; then
          echo "::warning file=$file::contents: write without pull-requests: write may be overbroad"
        fi
        if grep -q "actions: write" "$file"; then
          echo "::warning file=$file::actions: write is high privilege"
        fi
      else
        echo "::warning file=$file::No explicit permissions declared (uses default)"
        passed=false
      fi
    fi
  done < <({
    find "${PATH_INPUT}/.github/workflows" -name "*.yml" -o -name "*.yaml"
    find "${PATH_INPUT}/actions" -type f -name "action.yml"
  } 2>/dev/null || true)
  echo "passed=$passed" >>"$GITHUB_OUTPUT"
else
  echo "passed=true" >>"$GITHUB_OUTPUT"
fi

# fail if errors request
if [ "$FAIL_ON_ERROR" = "true" ]; then
  # read outputs safely using while loop
  violations_json=""
  passed_val=""
  while IFS='=' read -r key value; do
    case "$key" in
    violations) violations_json="$value" ;;
    passed) passed_val="$value" ;;
    esac
  done <"$GITHUB_OUTPUT"

  if [ "$violations_json" != "[]" ] && [ -n "$violations_json" ]; then
    echo "actionlint found violations, failing..."
    exit 1
  fi
  if [ "$passed_val" != "true" ]; then
    echo "Permission checks failed, failing..."
    exit 1
  fi
fi

echo "Validation completed successfully."
