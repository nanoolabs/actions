#!/bin/bash

if [[ -n "$DEBUG" ]]; then
  set -x
fi

set -euo pipefail

# default version (update manually on release, or set VERSION=latest to auto-fetch)
VERSION="${VERSION:-1.7.12}"

# if VERSION=latest, fetch latest release from GitHub API
if [ "$VERSION" = "latest" ]; then
  echo "Fetching latest actionlint version from GitHub API..."
  VERSION=$(curl -s "https://api.github.com/repos/rhysd/actionlint/releases/latest" | grep '"tag_name"' | cut -d'"' -f4 | sed 's/^v//')
  if [ -z "$VERSION" ]; then
    echo "ERROR: Failed to fetch latest version, using fallback 1.7.12" >&2
    VERSION="1.7.12"
  fi
  echo "Latest version: $VERSION"
fi

case "${RUNNER_OS}" in
macOS)
  OS=darwin
  EXT=tar.gz
  ;;
Windows)
  OS=windows
  EXT=zip
  ;;
*)
  OS=linux
  EXT=tar.gz
  ;;
esac

case "${RUNNER_ARCH}" in
ARM64)
  ARCH=arm64
  ;;
ARM)
  ARCH=armv6
  ;;
X86)
  ARCH=386
  ;;
*)
  ARCH=amd64
  ;;
esac

INSTALL_DIR="$RUNNER_TEMP/actionlint"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

FILE="actionlint_${VERSION}_${OS}_${ARCH}.${EXT}"
URL="https://github.com/rhysd/actionlint/releases/download/v${VERSION}/${FILE}"
CHECKSUM_URL="https://github.com/rhysd/actionlint/releases/download/v${VERSION}/actionlint_${VERSION}_checksums.txt"

echo "Downloading actionlint v${VERSION} from ${URL}"

# skip downloading if already cache, version matches, AND checksum verifies
if [[ -e "$FILE" ]] && ./actionlint -version 2>/dev/null | grep -q "v${VERSION}"; then
  # verify checksum on cache hit too
  if curl -L -s -f -o "checksums.txt" "$CHECKSUM_URL" && grep "$FILE" checksums.txt | sha256sum -c - >/dev/null 2>&1; then
    echo "Using cached actionlint binary v${VERSION} (checksum verified)"
  else
    echo "Cached binary checksum mismatch, re-downloading..."
    rm -f "$FILE"
  fi
fi

if [[ ! -e "$FILE" ]]; then
  echo "Downloading ${FILE}..."
  # download checksums first
  if ! curl -L -s -f -o "checksums.txt" "$CHECKSUM_URL"; then
    echo "WARNING: Checksums file not found at $CHECKSUM_URL, proceeding without verification" >&2
  fi

  if [[ "$OS" == "windows" ]]; then
    curl -L -o "$FILE" "$URL"
    # verify checksum
    grep "$FILE" checksums.txt | sha256sum -c -
    unzip "$FILE" actionlint.exe
    mv actionlint.exe ./actionlint
  else
    curl -L -o "$FILE" "$URL"
    # verify checksum
    grep "$FILE" checksums.txt | sha256sum -c -
    tar xzf "$FILE"
  fi
fi

chmod +x ./actionlint

echo "actionlint is ready to use! Version: $(./actionlint -version)"
