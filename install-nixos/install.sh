#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p bash disko nixos-facter jq
set -euo pipefail
trap exit SIGTERM SIGINT SIGHUP

export NIX_CONFIG="experimental-features = nix-command flakes"

workDir=$(pwd)
hostName="nixos"
userName="nixos"
diskoTmpl="btrfs"
validTmpls="btrfs btrfs-luks-nvme"

err() {
  echo "Error: $*." >&2
  exit 1
}

fin() {
  echo "Done: $*."
  exit 0
}

# Check root.
if [ $EUID -ne 0 ]; then
  err "please run as root"
fi

# Show usage.
cat <<EOF
Usage: $0 [OPTIONS]
  -H, --host, --hostname NAME   Specify the machine's hostname to be used. 
                                Default: $hostName
  -U, --user, --username NAME   Specify the user's name to be used.
                                Default: $userName
  -T, --disko-tmpl NAME         Specify the disko template name to be used.
                                Valid names are: ${validTmpls// /, }. 
                                Template saves as 'disko.nix', after end you can replace file with any
                                other from 'https://github.com/nix-community/disko/blob/master/example'.
                                Default: $diskoTmpl
  -h, --help                    Show this help message.
EOF

# Parse arguments.
while [[ $# -gt 0 ]]; do
  case $1 in
  -h | --help)
    showUsage
    exit 0
    ;;
  -H | --host | --hostname)
    hostName="$2"
    shift 2
    ;;
  -U | --user | --username)
    userName="$2"
    shift 2
    ;;
  -T | --disko-tmpl)
    if [ "$2" != "" ]; then
      if [[ " $validTmpls " =~ [[:space:]]$2[[:space:]] ]]; then
        diskoTmpl="$2"
      else
        err "unknown disko template: $2"
      fi
    fi
    shift 2
    ;;
  *)
    err "unknown option: $1"
    ;;
  esac
done

# Insall OS if configs exists.
if [ -f "$workDir/disko.nix" ] && [ -f "$workDir/facter.json" ]; then
  disko --mode destroy,format,mount --root-mountpoint /mnt "$workDir/disko.nix"
  nixos-install --root /mnt --flake "$workDir#$hostName"
  fin "installation succeeded, please remove image and reboot"
fi

# Init configs.
nix flake init -t "$workDir#$diskoTmpl"
nixos-facter -o "$workDir/facter.json"
if [ "$hostName" != "" ]; then
  sed -i "s/hostName = \".*\";/hostName = \"$hostName\";/" "$workDir/flake.nix"
fi
if [ "$userName" != "" ]; then
  sed -i "s/userName = \".*\";/userName = \"$userName\";/" "$workDir/flake.nix"
fi

# Show disks info.
echo -e "\nDisks info:"
jq -r '.hardware.disk| to_entries[] | "---
    disk-\(.key + 1)
    name: \(.value.unix_device_name)
    size: \(.value.resources[] | select(.type == "size") | .value_1 * .value_2 / 1073741824 )Gb
    model: \(.value.model)
    driver: \(.value.driver)"' "$workDir/facter.json"
echo "---"

fin "configurations initialization succeeded, please review settings in '$workDir'"
