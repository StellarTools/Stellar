#!/bin/bash

set -e

shell_join() {
  local arg
  printf "%s" "$1"
  shift
  for arg in "$@"; do
    printf " "
    printf "%s" "${arg// /\ }"
  done
}

ohai() {
  printf "${tty_blue}==>${tty_bold} %s${tty_reset}\n" "$(shell_join "$@")"
}

warn() {
  printf "${tty_red}Warning${tty_reset}: %s\n" "$(chomp "$1")"
}

# Check the existence of the GITHUB-TOKEN file.
# This is necessary until the repo becomes public.
GITHUB_TOKEN_FILE=~/.stellar/.GITHUB-TOKEN
if [ ! -f "$GITHUB_TOKEN_FILE" ]; then
    ohai "Create a .GITHUB-TOKEN in your ~/.stellar directory before using this script"
    exit
fi

# Prepare headers for GitHub autentication.
GITHUB_TOKEN=`cat ${GITHUB_TOKEN_FILE}`
declare -a GITHUB_HEADERS=('-H' "X-GitHub-Api-Version: 2022-11-28" '-H' "Accept: application/json" '-H' "Authorization: Bearer ${GITHUB_TOKEN}")

JSON=$(curl --silent -L -s "${GITHUB_HEADERS[@]}" https://api.github.com/repos/StellarTools/Stellar/releases/latest)
TAG=$(echo "${JSON}" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

#TAG=$(get_latest_release)
ohai "Latest release of stellar is $TAG"

# This is not available for private repos.
# ARTIFACT_URL="https://github.com/StellarTools/Stellar/releases/download/$TAG/StellarEnv.zip"
# curl --verbose -LSsf "${GITHUB_BIN_HEADERS[@]}" --output /tmp/StellarEnv.zip "${ARTIFACT_URL}"

# Fix for authenticated request. We need to get the assets URL which is private. Public URL does not work, of course.
ASSET_URL=$(ruby ./asset_url.rb "${JSON}")
ohai $ASSET_URL
ohai "Downloading stellarenv [$ASSET_URL]"
declare -a GITHUB_BIN_HEADERS=('-H' "Accept: application/octet-stream" '-H' "Authorization: Bearer ${GITHUB_TOKEN}")
curl -LSsf "${GITHUB_BIN_HEADERS[@]}" --output /tmp/StellarEnv.zip "${ASSET_URL}"

ohai "Unzipping StellarEnv..."
unzip -o /tmp/StellarEnv.zip -d /tmp/StellarEnv > /dev/null
ohai "Installing StellarEnv..."

INSTALL_DIR="/usr/local/bin"

sudo_if_install_dir_not_writeable() {
  local command="$1"
  if [ -w $INSTALL_DIR ]; then
    bash -c "${command}"
  else
    bash -c "sudo ${command}"
  fi
}

if [[ ! -d $INSTALL_DIR ]]; then
  sudo_if_install_dir_not_writeable "mkdir -p ${INSTALL_DIR}"
fi

if [[ -f "${INSTALL_DIR}/StellarEnv" ]]; then
  sudo_if_install_dir_not_writeable "rm ${INSTALL_DIR}/StellarEnv"
fi

sudo_if_install_dir_not_writeable "mv /tmp/StellarEnv/StellarEnv \"${INSTALL_DIR}/StellarEnv\""
sudo_if_install_dir_not_writeable "chmod +x \"${INSTALL_DIR}/StellarEnv\""

rm -rf /tmp/StellarEnv
rm /tmp/StellarEnv.zip

# Also install the CLI environment for this version.
ohai "Installing latest version of CLI..."
stellarenv install

ohai "StellarEnv v.$TAG installed! Try running 'stellarenv'"
