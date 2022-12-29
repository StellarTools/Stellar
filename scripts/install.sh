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

LATEST_VERSION=$(git ls-remote -t --sort=v:refname https://github.com/InterstellarTools/StellarPrototype.git | sed -ne '$s/.*tags\/\(.*\)/\1/p')
ohai "Downloading StellarCLI..."
[ -f /tmp/StellarCLI.zip ] && rm /tmp/StellarCLI.zip
[ -f /tmp/StellarCLI ] && rm /tmp/StellarCLI
curl -LSsf --output /tmp/StellarCLI.zip https://github.com/InterstellarTools/StellarPrototype/releases/download/${LATEST_VERSION}/StellarCLI.zip
ohai "Unzipping StellarCLI..."
unzip -o /tmp/StellarCLI.zip -d /tmp/StellarCLI > /dev/null
ohai "Installing StellarCLI..."

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

if [[ -f "${INSTALL_DIR}/StellarCLI" ]]; then
  sudo_if_install_dir_not_writeable "rm ${INSTALL_DIR}/StellarCLI"
fi

sudo_if_install_dir_not_writeable "mv /tmp/StellarCLI/StellarCLI \"${INSTALL_DIR}/StellarCLI\""
sudo_if_install_dir_not_writeable "chmod +x \"${INSTALL_DIR}/StellarCLI\""

rm -rf /tmp/StellarCLI
rm /tmp/StellarCLI.zip

ohai "StellarCLI installed. Try running 'StellarCLI'"
