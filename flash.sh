#!/usr/bin/env bash
set -e

if [[ ! $# -eq 2 ]]
then
  echo "$0: <config> <ssh address>"
  exit
fi

NIXOS_INSTALLER_VERSION=25.05

CONFIG=$1
HOST=$2

wget -c https://github.com/nix-community/nixos-images/releases/download/nixos-${NIXOS_INSTALLER_VERSION}/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz

nix run github:nix-community/nixos-anywhere -- \
  --flake .#${CONFIG} \
  --generate-hardware-config nixos-generate-config ./hw/${CONFIG}/hardware-configuration.nix \
  --kexec ./nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz \
  --target-host ${HOST}
