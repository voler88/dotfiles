# My dotfiles

Declarative setup environment in Linux OS.

## Description

A collection of software developments for setup environment from scratch.
All the following theses are personal opinions.

This dotfiles repository does not store sensitive information and
does not exempt from the use of backups.

### Core software used

- **Linux OS**: NixOS

> - Modern.
> - Declarative, reproducible and reliable system
    configuration and package management.

- **Filesystem**: Btrfs

> - Modern.
> - Compression features.
> - Snapshots management.

## Installation

> Note:
> If you planed to use this dotfiles, fork this repo to use it as your own.

### Steps

1. [Download](https://nixos.org/download) and run NixOS minimal image.

2. Init basic configs and run `install.sh` as privileged user for configs setup:
   > Note: See template names in [`nixos/disko`](nixos/disko).
   > If not use disko templates from this repo, just get proper
   > [disko examples](https://github.com/nix-community/disko/blob/master/example)
   > and save as `disko.nix` after run.

   ```bash
   nix --extra-experimental-features 'nix-command flakes' flake init -t github:voler88/dotfiles
   chmod +x ./install.sh
   sudo ./install.sh -H <hostname> -U <username> -T <template>
   # defaults: nixos, nixos, btrfs.
   ```

3. Review configs and make changes (if needed) and run `install.sh` again
   to initialize filesystem and install NixOS:

   ```bash
   sudo ./install.sh -H <hostname>
   ```

4. Remove image, reboot, login, clone this repo:

   ```bash
   git clone https://github.com/voler88/dotfiles.git
   ```

5. Run `new-machine.sh` to create new machine configuration and link it
   to system directory `/etc/nixos/`:

   ```bash
   cd dotfiles/home/config/nixos
   chmod u+x ./new-machine.sh
   ./new-machine.sh
   ```

6. Add needed modules from `~/.config/nixos/modules` to `configuration.nix`
   like `../../module/<module>.nix`.

7. Apply new configuration:

   > Note: This `-I nixos-config=/etc/nixos/configuration.nix` needed only
   > on first run for new machine.

   ```bash
   sudo nixos-rebuild -I nixos-config=/etc/nixos/configuration.nix switch
   ```

8. (Optional) Initialize git repository on machine configuration to track changes:

   ```bash
   cd ~/.config/nixos/machines/$(hostname)
   git init
   git add -A
   git commit -m "Initial commit"
   ```

### Related documentation

- [Nix](https://nix.dev/manual/nix/stable/)
- [NixOS](https://nixos.org/manual/nixos/stable)
- [Disko](https://github.com/nix-community/disko)
- [NixOS Facter](https://github.com/nix-community/nixos-facter)

## Release notes

See the [changelog](CHANGELOG.md) file.

## Licensing

See the [license](LICENSE) file.

## Author information

[![voler88](https://img.shields.io/badge/voler88-black?style=social&logo=github)](https://github.com/voler88)
