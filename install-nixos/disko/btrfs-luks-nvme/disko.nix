{ lib, ... }:
let
  firstDisk = "/dev/sda";

  subvolumes = {
    rootfs = "/";
    nix = "/nix";
    home = "/home";
  };

  mountOptions = [
    "noatime"
    "x-systemd.device-timeout=0"
    "discard"
    "compress=zstd:1"
  ];
in
{
  disko.devices = {
    disk = {
      ${lib.strings.removePrefix "/dev/" firstDisk} = {
        type = "disk";
        device = firstDisk;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            linux = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = lib.mapAttrs (name: mountpoint: {
                    inherit mountpoint;
                    inherit mountOptions;
                  }) subvolumes;
                };
              };
            };
          };
        };
      };
    };
  };
}
