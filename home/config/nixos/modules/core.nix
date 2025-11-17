{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Use the limine EFI boot loader (see docs to enable SecureBoot).
  boot.loader.limine.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use in-memory compressed swap (can use 50% of RAM by default).
  zramSwap.enable = true;

  # Set time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties and keybooard layouts.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [ "ru_RU.UTF-8/UTF-8" ];
  services.xserver.xkb = {
    layout = "us,ru";
    options = "grp:alt_shift_toggle";
  };

  # Use xkb keymaps in tty.
  console.useXkbConfig = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = lib.mkDefault true;

  # Enable experimental nix commands and flakes.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
