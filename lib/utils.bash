#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/ogham/exa"
TOOL_NAME="exa"
TOOL_TEST="exa --version"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//'
}

list_all_versions() {
  list_github_tags
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  local platform
  case "$OSTYPE" in
    darwin*) platform="macos" ;;
    linux*) platform="linux" ;;
    *) fail "Unsupported platform" ;;
  esac

  local architecture
  case "$(uname -m)" in
    x86_64) architecture="x86_64" ;;
    arm64) architecture="armv7" ;;
    *) fail "Unsupported architecture" ;;
  esac

  # Per issue #1, there is not currently a macos/Apple Silicon build of exa, so
  # we overwrite the architecture
  if [ $platform = "macos" -a $architecture = "armv7" ]; then
    echo "Exa does not have Apple Silicon releases yet. See https://github.com/nyrst/asdf-exa/issues/1"
    architecture="x86_64"
  fi

  url="$GH_REPO/releases/download/v${version}/exa-${platform}-${architecture}-v${version}.zip"

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  local release_file="$install_path/$TOOL_NAME-$version.zip"
  (
    mkdir -p "$install_path"
    download_release "$version" "$release_file"
    unzip -qq "$release_file" -d "$install_path" || fail "Could not extract $release_file"
    rm "$release_file"

    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}
