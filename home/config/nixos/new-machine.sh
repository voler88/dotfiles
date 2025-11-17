#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p bash
set -euo pipefail
trap exit SIGTERM SIGINT SIGHUP

hostName=$(hostname)
baseDir=$(realpath "$(dirname "$0")")
machineDir=$baseDir/machines/$hostName

err() {
  echo "Error: $*." >&2
  exit 1
}

# Init configs.
if [ -d "$machineDir" ]; then
  err "machine already exists: $machineDir"
fi
mkdir -p "$machineDir"
# shellcheck disable=SC2024
sudo nixos-generate-config --show-hardware-config >"$machineDir/hardware-configuration.nix"
sed "s/example-hostname/$hostName/g;
  s/example-username/$USER/g" "$baseDir/configuration-example.nix" >"$machineDir/configuration.nix"

# Link configs.
sudo ln -s "$machineDir/hardware-configuration.nix" "/etc/nixos/hardware-configuration.nix"
sudo ln -s "$machineDir/configuration.nix" "/etc/nixos/configuration.nix"

echo "Machine configurations successfully created."
