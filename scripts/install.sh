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

LATEST_VERSION=$(git ls-remote -t --sort=v:refname https://github.com/StellarTools/Stellar.git | sed -ne '$s/.*tags\/\(.*\)/\1/p')
ohai "Downloading StellarEnv..."
[ -f /tmp/StellarEnv.zip ] && rm /tmp/StellarEnv.zip
[ -f /tmp/StellarEnv ] && rm /tmp/StellarEnv
curl -LSsf --output /tmp/StellarCLI.zip https://github.com/InterstellarTools/StellarPrototype/releases/download/${LATEST_VERSION}/StellarEnv.zip
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

if [[ -f "${INSTALL_DIR}/stellar" ]]; then
  sudo_if_install_dir_not_writeable "rm ${INSTALL_DIR}/stellar"
fi

sudo_if_install_dir_not_writeable "mv /tmp/stellarenv/stellarenv \"${INSTALL_DIR}/stellar\""
sudo_if_install_dir_not_writeable "chmod +x \"${INSTALL_DIR}/stellar\""

rm -rf /tmp/StellarEnv
rm /tmp/StellarEnv.zip

ohai "StellarEnv v.$TAG installed! Try running 'stellar'."
