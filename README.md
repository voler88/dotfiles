# My dotfiles

Setup work environment in Linux OS.

## Description

A collection of software developments from the author's vision for the workstation.  
All the following theses are personal opinions.

### Core software used

- **Linux OS**: Fedora Sway Atomic

> - A quick rollback feature when upgrading with package managment.
> - Up-to-date versions of most programs.
> - Beautiful and lightweight window manager with flexible settings of windows and key bindings.

- **Deployment tool**: Ansible

> - Clientless automation.
> - Already implements post-command state checking for most needs.

## Installation

### Steps

1. Install and update the OS in any way.
2. Setup network connection.
3. Clone repo and run [`install.sh`](install.sh) script:

```bash
git clone https://github.com/voler88/dotfiles.git && cd dotfiles && source install.sh
```

## Release notes

See the [changelog](CHANGELOG.md) file.

## Licensing

See the [license](LICENSE) file.

## Author information

[![voler88](https://img.shields.io/badge/voler88-black?style=social&logo=github)](https://github.com/voler88)
