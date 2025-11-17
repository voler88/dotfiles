# Disko configuration notes

## LUKS

- `allowDiscards = true`: allow TRIM discards for SSD safety

## Btrfs

- `-f`: argument for forcibly overwrite an existing filesystem

## Mount options

- `noatime`: don't change file access time for performance
- `discard`: discard unused blocks for SSD safety
- `compress=zstd:1`: reduce disk space usage in Btrfs
- `x-systemd.device-timeout=0`: always wait secret for LUKS
